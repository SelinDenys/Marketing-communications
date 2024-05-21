require_relative 'question'
require 'yaml'
require 'thread'

module QuizSelin
  class QuestionData
    def initialize (dir, ext)
      @collection = []
      @yaml_dir = dir
      @in_ext = ext
      @threads = []
      load_data()
      @collection.shuffle!
    end

    attr_accessor :collection

    def to_yaml
      hash = @collection.map{|item| item.to_h}
      return hash.to_yaml
    end

    def to_json
      hash = @collection.map{|item| item.to_h}
      return JSON.pretty_generate(hash)
    end

    def save_to_yaml(file_name)
      File.open(file_name, 'w') do |f|
        f.write to_yaml
      end
    end

    def save_to_json(file_name)
      File.open(file_name, 'w') do |f|
        f.write to_json
      end
    end

    def prepare_filename(filename)
      return File.expand_path(@yaml_dir + '/' + filename)
    end

    def each_file
      return unless block_given?
      files = Dir.glob("*.#{@in_ext}", base: @yaml_dir)

      files.each do |file|
          yield file
      end
    end

    def in_thread(&block)
      return unless block_given?
      @threads << Thread.new do
        yield
      end
    end
    
    def load_from(filename)
      data = YAML.load_file(prepare_filename(filename))
      @collection += data.map do |question|
        Question.new(question["question"], question["answers"])
      end
    end

    def load_data
      each_file do |file|
        in_thread do
          load_from(file)
        end
      end

      @threads.each do |thread|
        thread.join()
      end
    end
  end
end