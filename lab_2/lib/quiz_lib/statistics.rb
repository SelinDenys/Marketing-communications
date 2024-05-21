require_relative 'file_writer'

module QuizSelin
  class Statistics
    def initialize(writer)
      @writer = writer
      @correct_answer = 0
      @incorrect_answer = 0
    end

    attr_accessor :correct_answer, :incorrect_answer

    def print_report
      correctness = (incorrect_answer + correct_answer > 0) ? ((correct_answer * 100) / (incorrect_answer + correct_answer)) : 0
      str = "Correct: #{correct_answer}\nIncorrect: #{incorrect_answer}\nCorrectness: #{correctness}%"
      @writer.write(str)
      puts str
    end
  end
end