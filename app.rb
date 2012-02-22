require 'rubygems'
require 'sinatra'

# the server handles logging
disable :logging

get '/' do
  if settings.production?
    File.read settings.root + '/build/index.html'
  else
    require 'compile'
    Compile()
  end
end
