task :default => :dev

port = 4567

task :dev do
  sh "shotgun -p #{port} -s thin -O"
end

task :build do
  sh "ruby -r compile.rb -e 'puts Compile()' > build/index.html"
end

task :deploy do
  sh 'git push origin master'
  sh 'git push heroku master'
end