require_relative 'question_data'
require_relative 'quiz'
require_relative 'input_reader'

module QuizSelin
  class Engine
    def initialize
      @question_collection = QuestionData.new(Quiz::yaml_dir, Quiz::in_ext)
      @input_reader = InputReader.new("Choose correct answer", 
                                    ->(str) { !str.empty?},
                                    "Answer too small",
                                    ->(str) { return str[0].upcase})
      @user_name = InputReader::read("Write your name", 
                                    ->(str) {str.size() > 2},
                                    "Name must be grater than 2",
                                    ->(str) { return str})
      @current_time = Time.now.strftime("%Y%m%d%H%M%S")
      @writer = FileWriter.new("a", Quiz::answers_dir, @user_name + '_' + @current_time + ".txt")
      @statistics = Statistics.new(@writer)
    end

    def run
      @question_collection.collection.each do |question|
        puts question
        @writer.write(question)
        answers =  question.display_answers
        puts answers
        @writer.write(answers)
        get_answer_by_char(question)
      end
      puts "Result"
      @writer.write("Result")
      @statistics.print_report
    end

    def get_answer_by_char(question)
      answer = @input_reader.read()
      @writer.write("Answer: " + answer)
      check(question.find_answer_by_char(answer), question.question_correct_answer)
    end

    def check(user_answer, correct_answer)
      if user_answer == correct_answer
        @statistics.correct_answer += 1
        puts "Correct!\n\n"
        @writer.write("Correct!\n\n")
      else
        @statistics.incorrect_answer += 1
        puts "Incorrect!\n\n"
        @writer.write("Incorrect!\n\n")
      end
    end
  end
end