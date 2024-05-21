module QuizSelin
  class FileWriter
    def initialize(mode, *args)
      @mode = mode
      @answers_dir = args[0]
      @filename = prepare_filename(args[1])
    end

    def write(message)
      File.open(@filename, @mode) do |f|
        f.puts message
      end
    end

    def prepare_filename(filename)
      return File.expand_path(@answers_dir + '/' + filename, __dir__)
    end
  end
end