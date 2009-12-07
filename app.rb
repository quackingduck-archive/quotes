require 'rubygems'
require 'sinatra'
require 'rdiscount'
require 'haml'

class Quote
  
  def self.all
    Dir[Sinatra::Application.root+'/quotes/*'].
    map do |path|
      id = File.basename(path)
      body, props = File.read(path).match(/(.+?)---\n(.+)/m).captures
      new(id, body, YAML.load(props))
    end.
    sort_by { |q| q.date }.reverse
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

set :views, Sinatra::Application.root

get '/' do
  haml :view
end