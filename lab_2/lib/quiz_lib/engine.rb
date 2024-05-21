require_relative 'question_data'
require_relative 'quiz'
require_relative 'input_reader'

module QuizSelin
  class Engine
    def initialize
      @question_collection = QuestionData.new(Quiz::yaml_dir, Quiz::in_ext)
      @current_question = nil
    end

    def get_question_by_number(number)
      if @question_collection.collection.size > number.to_i
        @current_question = @question_collection.collection[number.to_i]
        return [@current_question, @current_question.display_answers]
      end

      @current_question = nil
      return ["There is no such question", []]
    end

    def get_answer_by_char(answer)
      if @current_question
        return check(@current_question.find_answer_by_char(answer), @current_question.question_correct_answer)
      end
    end

    def check(user_answer, correct_answer)
      if user_answer == correct_answer
        return "Correct!"
      else
        return "Incorrect!"
      end
    end
  end
end