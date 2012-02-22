require 'rubygems'
require 'sinatra'
require 'compile'

# the server handles logging
disable :logging

get '/' do
  if settings.production?
    File.read settings.root + '/build/index.html'
  else
    Compile()
  end
end
