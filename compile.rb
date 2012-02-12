require 'rubygems'
require 'rdiscount'
require 'haml'
require 'yaml'

# A complex method of compiling a html document containing all the quotes
def Compile
  Haml::Engine.new(
    File.read(Quote.root+'/view.haml'),
    :format => :html5
  ).render()
end

# `Quote` is really just a namespace
class Quote

  def self.all
    Dir[root+'/quotes/*'].
    collect { |path| load(path) }.
    compact. # ignore the ones that fail to load
    group_by { |q| q.date }.
    sort_by { |date, g| date }.reverse.
    map { |date, group| group.sort_by(&:author) }.
    flatten
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

  def self.root
    File.dirname(__FILE__)
  end

  ## --

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
