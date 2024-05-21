module QuizSelin
  class Quiz
    class << self
      def config
        return unless block_given?

        params = {yaml_dir: "./", in_ext: "yaml", answers_dir: "./"}
        yield params

        @@yaml_dir = params[:yaml_dir]
        @@in_ext = params[:in_ext]
        @@answers_dir = params[:answers_dir]
      end

      def yaml_dir
        @@yaml_dir
      end
      def in_ext
        @@in_ext
      end
      def answers_dir
        @@answers_dir
      end
    end
  end
end