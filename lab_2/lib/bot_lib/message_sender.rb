require_relative 'reply_markup_formatter'
require_relative 'app_configurator'

class MessageSender
  attr_reader :bot
  attr_reader :text
  attr_reader :chat
  attr_reader :answers
  attr_reader :logger

  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
    @answers = options[:answers]
    @remove_keyboard = options[:remove_keyboard]
    @logger = AppConfigurator.new.get_logger
  end

  def send
    if @remove_keyboard
      kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: kb)
    elsif reply_markup
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: reply_markup)
    else
      bot.api.send_message(chat_id: chat.id, text: text)
    end

    logger.debug "sending '#{text}' to #{chat.username}"
  end

  private

  def reply_markup
    if answers
      ReplyMarkupFormatter.new(answers).get_markup
    end
  end
end