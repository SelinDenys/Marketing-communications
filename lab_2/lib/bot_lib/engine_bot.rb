require 'telegram/bot'

require_relative 'message_responder'
require_relative 'app_configurator'
module QuizSelin
  class EngineBot
    def initialize
      @engine = QuizSelin::Engine.new
    end

    def run
      config = AppConfigurator.new
      config.configure

      token = config.get_token
      logger = config.get_logger

      logger.debug 'Starting telegram bot'

      Telegram::Bot::Client.run(token) do |bot|
        bot.listen do |message|
          options = {bot: bot, message: message, engine: @engine}

          logger.debug "@#{message.from.username}: #{message.text}" 
          MessageResponder.new(options).respond
        end
      end
    end
  end
end