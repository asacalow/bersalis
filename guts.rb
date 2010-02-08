require 'nokogiri'
require 'logger'

class Document < Nokogiri::XML::SAX::Document
  attr_accessor :receiver
  
  def initialize(receiver)
    self.receiver = receiver
  end
  
  def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
    return if name == 'stream' # this tag only gets closed when the connection is closed so we want to ignore this for now
    # TODO: Create a Stream object which captures some of this stuff.
    
    doc = stanza_building_in_progress? ? @current.document : Nokogiri::XML::Document.new
    # create a Nokogiri node from what we know…
    node = Nokogiri::XML::Node.new(name, doc)
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
    
    # if there's a parent node we're not done parsing here so return
    if @current.parent
      @current = @current.parent
      return
    end
    process(@current)
  end
  
  def characters(chars = '')
    @current << Nokogiri::XML::Text.new(chars, @current.document) if @current
  end
  
  private
  
  def process(node)
    # we set this so we can use xpath across the whole node.
    # just using the node's xpath function doesn't give us the node itself!
    node.document.root = node
    @current = nil # reset 
    
    self.receiver.process(node)
  end
  
  def stanza_building_in_progress?
    !!@current
  end
end

class Connection < EventMachine::Connection
  attr_accessor :client
  
  def initialize(client)
    self.client = client.new(self)
  end
  
  def post_init
    start
  end
  
  def start
    # send an 'open stream' tag
    @parser = Nokogiri::XML::SAX::PushParser.new(Document.new(self.client))
    send_data Client::START_STREAM
  end
  
  def receive_data(data)
    Client.debug("IN: #{data}")
    @parser << data
  end
  
  def unbind
    # close the stream
    send_data "</stream:stream>"
  end
end

class Client
  HANDLERS = []
  @@logger = nil
  
  START_STREAM = "<stream:stream xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">"
  
  attr_accessor :connection
  
  def self.run
    @@logger = Logger.new($stdout)
    @@logger.level = Logger::DEBUG
    
    self.connect
  end
  
  def self.connect
    EM.connect '127.0.0.1', 5222, Connection, self
  end
  
  def self.handle(klass, method, options={})
    options[:method] = method
    options[:class] = klass
    HANDLERS << options
  end
  
  def self.info(msg)
    @@logger.log(Logger::INFO, msg)
  end
  
  def self.debug(msg)
    @@logger.log(Logger::DEBUG, msg)
  end
  
  def initialize(connection)
    self.connection = connection
  end
  
  def start
    self.connection.start
  end
  
  # this gets called back from the parser when we've got a Nokogiri Node to work with
  def process(node)
    klass = nil
    # search through the dictionary of known stanzas for a handler
    KNOWN_STANZAS.each_pair do |kls, nns|
      # if we get a hit for the registered path/namespace pairing then we have a recognisable class
      klass = kls if !node.document.at(nns[:path], nns[:namespaces]).nil?
    end
    return if klass.nil? # return if the stanza hasn't been recognised
    
    # now, if we know of a handler for the class, we can do something with it
    possibles = HANDLERS.select{|h| klass == h[:class]}
    return if possibles.empty? # no handler
    opts = nil
    possibles.each do |options| 
      next if options[:filter] && !node.document.at(options[:filter], options[:filter_ns] || {}) # pass over if we have a filter but the node doesn't match it
      opts = options
    end
    return if opts.nil? # no filter matched
    send(opts[:method], klass.new(node))
  end
  
  def write(stanza)
    Client.debug("OUT: #{stanza.to_xml}")
    self.connection.send_data(stanza.to_xml)
  end
end