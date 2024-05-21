require_relative 'quiz'

QuizSelin::Quiz::config do |par|
  par[:yaml_dir] = "quiz/yml"
  par[:in_ext] = "yml"
  par[:answers_dir] = "quiz/answers"
end