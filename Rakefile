task :default => :run

port = 5143 

task :run do
  sh "ruby app.rb -p #{port} & open http://localhost:#{port}"
end

task :deploy do
  sh 'git push origin master'
  sh 'git push heroku master'
end