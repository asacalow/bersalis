require 'rubygems'
require 'eventmachine'
require 'nokogiri'

require 'stanzas'

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

class Document < Nokogiri::XML::SAX::Document
  attr_accessor :receiver
  
  def initialize(receiver)
    self.receiver = receiver
    @doc = Nokogiri::XML::Document.new
  end
  
  def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
    return if name == 'stream' # this tag only gets closed when the connection is closed so we want to ignore this for now
    # TODO: Create a Stream object which captures some of this stuff.
    
    # create a Nokogiri node from what we know…
    node = Nokogiri::XML::Node.new(name, @doc)
    attrs.each {|a| node[a.localname] = a.value}
    ns.each do |ns|
      prefix, uri = ns
      node.add_namespace(prefix,uri)
    end
    @current << node if @current # down the tree
    @current = node
  end
  
  def end_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
    return if name == 'stream' # TODO: Handle this (see above!)
    process(@current) unless (@current.parent) # if there's a parent node we're not done parsing here
    @current = @current.parent # and back up the tree
  end
  
  def characters(chars = '')
    @current << Nokogiri::XML::Text.new(chars, @current.document) if @current
  end
  
  private
  
  def process(node)
    self.receiver.process(node)
  end
end

class Connection < EventMachine::Connection
  attr_accessor :client
  
  def initialize(client)
    self.client = client
  end
  
  def post_init
    # send an 'open stream' tag
    @parser = Nokogiri::XML::SAX::PushParser.new(Document.new(self))
    send "<stream:stream xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">"
  end
  
  def receive_data(data)
    @parser << data
  end
  
  def unbind
    # close the stream
    send_data "</stream:stream>"
  end
  
  # this gets called back from the parser when we've got a Nokogiri Node to work with
  def process(node)
    stanza = Stanza.new(node)
    puts stanza.to_xml
  end
  
  def send(data)
    send_data(data)
  end
end

class Client
  HANDLERS = {}
  
  def self.run
    EM.connect '127.0.0.1', 5222, Connection, Client.new
  end
end

EM.run do
  Client.run
end