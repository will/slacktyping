require 'dotenv/load'
require 'slack-ruby-client'

raise 'Missing ENV[SLACK_API_TOKENS]!' unless ENV.key?('SLACK_API_TOKENS')

$stdout.sync = true
logger = Logger.new($stdout)
logger.level = Logger::DEBUG

ENV['SLACK_API_TOKENS'].split.each do |token|
  logger.info "Starting #{token[0..12]} ..."

  client = Slack::RealTime::Client.new(token: token)

  client.on :hello do
    logger.info "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
  end

  client.on(:user_typing) do |data|
    logger.info data
    client.typing channel: data.channel
    #client.message channel: data.channel, text: "What are you typing <@#{data.user}>?"
  end

  client.start_async
end

loop do
  Thread.pass
end
