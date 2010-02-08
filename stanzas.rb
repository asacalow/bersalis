# the abstract Stanza classes
# a Stanza is basically a wrapper around a Nokogiri node

KNOWN_STANZAS = {}

class ReadOnlyStanza
  attr_accessor :node
  
  def initialize(node, attributes={})
    self.node = node
    
    # set some attribute values
    attributes.each_pair do |attribute, value|
      self.send("#{attribute}=", value)
    end
  end

  def to_xml
    self.node.to_xml
  end
  
  def self.register(path, namespaces={})
    KNOWN_STANZAS[self] = {:path => path, :namespaces => namespaces}
  end
  
  def self.attribute(name, opts={})
    define_method("#{name}") do
      path = opts[:path], opts[:namespaces]
      namespaces = opts[:namespaces] || {}
      attribute_name = (opts[:attribute_name] || name).to_s
      return self.node.document.at(path, namespaces)[attribute_name]
    end
    
    define_method("#{name}=") do |value|
      path = opts[:path]
      namespaces = opts[:namespaces] || {}
      attribute_name = (opts[:attribute_name] || name).to_s
      self.node.document.at(path, namespaces)[attribute_name] = value
    end
  end
  
  def self.content(name, opts={})
    define_method("#{name}") do
      path = opts[:path]
      namespaces = opts[:namespaces] || {}
      return self.node.document.at(path, namespaces).content
    end
    
    define_method("#{name}=") do |value|
      path = opts[:path]
      namespaces = opts[:namespaces] || {}
      self.node.document.at(path, namespaces).content = value
    end
  end
  
  attribute :to,    :path => '/*'
  attribute :from,  :path => '/*'
end

class Stanza < ReadOnlyStanza
  def self.create(attributes={})
    node = Nokogiri::XML::Node.new(self::NODE_NAME, Nokogiri::XML::Document.new)
    node.document.root = node # we do this to make the whole node searchable via xpath
    self.setup(node)
    return self.new(node, attributes)
  end

  # override this method and build your stanza here like so:
  # def self.setup(node)
  #     node = super(node)
  #     Nokogiri::XML::Builder.with(node) do |xml|
  #       # do cool stuff
  #     end
  #     # and now return the node from which child classes of this stanza build
  #   end
  def self.setup(node)
    node
  end
end

class Features < ReadOnlyStanza
  register '/features'
  # register '/stream:features', 'stream' => 'http://etherx.jabber.org/streams'
end

class AuthenticationSuccessful < ReadOnlyStanza
  register '/auth:success', 'auth' => 'urn:ietf:params:xml:ns:xmpp-sasl'
end

class Auth < Stanza
  NODE_NAME = 'auth'
end

class AnonymousAuth < Auth
  def self.setup(node)
    node = super(node)
    node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-sasl')
    node['mechanism'] = 'ANONYMOUS'
    node
  end
end

class PlainAuth < Auth
  def self.setup(node)
    node = super(node)
    node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-sasl')
    node['mechanism'] = 'PLAIN'
    node.content = b64("jimjam@alakazam.local\x00jimjam\x00password")
    node
  end
  
  private
  
  def self.b64(str)
    [str].pack('m').gsub(/\s/,'')
  end
end

class Presence < Stanza
  NODE_NAME = 'presence'
  
  register '/presence'
end

class Iq < Stanza
  NODE_NAME = 'iq'
  
  attribute :type,  :path => '/iq'
  attribute :id,    :path => '/iq'
end

class Bind < Iq
  register '/iq/bind:bind', 'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'
  content :jid,       :path => '//bind:jid',      :namespaces => {'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'}
  content :resource,  :path => '//bind:resource', :namespaces => {'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'}
  
  def self.setup(node)
    node = super(node)
    bind = node << Nokogiri::XML::Node.new('bind', node.document)
    bind.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-bind')
    bind << Nokogiri::XML::Node.new('jid', node.document)
    bind << Nokogiri::XML::Node.new('resource', node.document)
    node
  end
end

class Session < Iq
  register '/iq/session:session', 'session' => 'urn:ietf:params:xml:ns:xmpp-session'
  
  def self.setup(node)
    node = super(node)
    session = node << Nokogiri::XML::Node.new('session', node.document)
    session.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-session')
    node
  end
end

class RosterGet < Iq
  def self.setup(node)
    node = super(node)
    query = node << Nokogiri::XML::Node.new('query', node.document)
    query.add_namespace(nil, 'jabber:iq:get')
    query
  end
end