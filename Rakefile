task :default => :run

port = 4567 

task :dev do
  sh "shotgun -p #{port} -O"
end

task :deploy do
  sh 'git push origin master'
  sh 'git push heroku master'
end