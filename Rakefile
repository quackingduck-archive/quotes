task :default => :run

task :run do
  sh 'ruby app.rb & open http://localhost:4567'
end

task :deploy do
  sh 'git push origin master'
  sh 'git push heroku master'
end