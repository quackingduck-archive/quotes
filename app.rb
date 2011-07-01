require 'rubygems'
require 'sinatra'
require 'rdiscount'
require 'haml'
require 'yaml'

set :views, Sinatra::Application.root
set :haml, :format => :html5
# the server handles logging
disable :logging

get '/' do
  haml :view
end

class Quote

  def self.all
    Dir[Sinatra::Application.root+'/quotes/*'].
    collect { |path| load(path) }.
    compact. # ignore the ones that fail to load
    sort_by { |q| q.date }.reverse
  end

  class ParseError < StandardError ; end

  def self.load(path)
    id = File.basename(path)
    begin
      body, props = self.parse(File.read(path))
      new(id, body, YAML.load(props))
    rescue ParseError
      $stderr.puts "can't parse quote at: #{path}"
    end
  end

  def self.parse(str)
    match = str.match(/(.+?)---\n(.+)/m)
    raise ParseError unless match
    match.captures
  end

  def initialize(*args)
    @id, @body, @props = args
  end

  attr_reader :id, :updated

  def to_s; RDiscount.new(@body).to_html end

  def method_missing(*args)
    return super unless args.size == 1
    name = args.first.to_s[/(.+?)\??$/,1]
    @props[name]
  end

end

helpers do

  def quotes ; Quote.all end

end