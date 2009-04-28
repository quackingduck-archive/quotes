task :run do
  sh 'ruby app.rb'
end

task :deploy do
  sh 'git push origin master'
  sh 'git push heroku master'
end