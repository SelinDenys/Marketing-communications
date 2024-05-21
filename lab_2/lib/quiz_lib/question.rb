require 'json'
require 'yaml'

module QuizSelin
  class Question
    def initialize(raw_text, raw_answers)
      @question_body = raw_text
      @question_correct_answer = raw_answers[0]
      @question_answers = load_answers(raw_answers)
    end

    attr_accessor :question_body, :question_correct_answer, :question_answers

    def display_answers
      result = []
      @question_answers.each do |key, value|
        result << "#{key}.#{value}"
      end
      return result
    end

    def to_s
      return @question_body
    end

    def to_h
      result = {}
      result[:question_body] = @question_body
      result[:question_correct_answer] = @question_correct_answer
      result[:question_answers] = @question_answers
      return result
    end

    def to_json
      return JSON.pretty_generate(to_h)
    end

    def to_yaml
      return to_h.to_yaml
    end

    def load_answers(raw_answers)
      result = {}
      letter = 'A'
      raw_answers.shuffle!
      raw_answers.each do |answer|
        result[:"#{letter}"] = answer
        letter.next!
      end

      return result
    end

    def find_answer_by_char(char)
      return @question_answers[char.to_sym]
    end
  end
end