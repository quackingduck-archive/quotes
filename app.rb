require 'rubygems'
require 'sinatra'

class Quote
  
  def self.all
    Dir[Sinatra::Application.root+'/quotes/*'].
    map do |path|
      id, updated = File.basename(path), File.mtime(path)
      body, props = File.read(path).match(/(.+?)---\n(.+)/m).captures
      new(id, body, updated, YAML.load(props))
    end.
    sort_by { |q| q.updated }.reverse
  end
  
  def initialize(*args)
    @id, @body, @updated, @props = args
  end
  
  attr_reader :id, :updated
  
  def to_s; @body end
  
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
  # haml "#{options.root}/view.haml".to_sym
  haml :view
end