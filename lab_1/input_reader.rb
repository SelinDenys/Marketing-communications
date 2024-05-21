module QuizSelin
  class InputReader
    def initialize(welcome_message, validator, error_message, process)
      @welcome_message = welcome_message
      @validator = validator
      @error_message = error_message
      @process = process
    end
    def read
      InputReader::read(@welcome_message, @validator, @error_message, @process)
    end

    class << self
      def read(welcome_message, validator, error_message, process)
        is_ok = false
        while !is_ok
          puts welcome_message
          data = gets.chomp
          is_ok = validator.call(data)
          if !is_ok
            puts error_message
          end
        end
        return process.call(data)
    end
  end
  end
end