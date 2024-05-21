require_relative 'quiz'

QuizSelin::Quiz::config do |par|
  par[:yaml_dir] = "config/quiz_yml"
  par[:in_ext] = "yml"
  par[:answers_dir] = "quiz/answers"
end