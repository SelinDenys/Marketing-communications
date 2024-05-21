require_relative '../../models/user'
require_relative 'message_sender'
require_relative '../quiz_lib/engine'
require_relative 'reply_markup_formatter'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
    @engine = options[:engine]
  end

  def respond
    on /^\/start/ do
      answer_with_greeting_message
      return
    end

    on /^\/stop/ do 
      answer_with_farewell_message
      return
    end

    on /^\/c (\d*)/ do |n|
      answer_with_question(n)
      return
    end

    on /^(.)\..*/ do |a|
      answer_with_answer_result(a)
      return
    end

    on /.*/ do
      answer_with_error_message
    end
  end

  private

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end
  end

  def answer_with_greeting_message
    answer_with_message I18n.t('greeting_message')
  end

  def answer_with_farewell_message
    answer_with_message I18n.t('farewell_message')
  end

  def answer_with_error_message
    answer_with_message I18n.t('error_message')
  end

  def answer_with_answer_result(msg)
    result = @engine.get_answer_by_char(msg)
    if result
      answer_with_result result
    end
  end

  def answer_with_question(number)
    result = @engine.get_question_by_number(number)
    answers = []
    result[1].each do |a|
      answers += [[{text: a}]]
    end
    answer_with_markup result[0], answers
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def answer_with_markup(text, answer)
    MessageSender.new(bot: bot, chat: message.chat, text: text, answers: answer).send
  end
  def answer_with_result(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text, remove_keyboard: true).send
  end
end