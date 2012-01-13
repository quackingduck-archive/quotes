require 'rubygems'
require 'sinatra'
require 'compile'

# the server handles logging
disable :logging

get '/' do
  Compile()
end
