# the abstract Stanza classes
# a Stanza is basically a wrapper around a Nokogiri node

KNOWN_STANZAS = {}

class ReadOnlyStanza
  attr_accessor :node
  
  def initialize(node)
    self.node = node
  end

  def to_xml
    self.node.to_xml
  end
  
  def self.register(path, namespaces={})
    KNOWN_STANZAS[self] = {:path => path, :namespaces => namespaces}
  end
end

class Stanza < ReadOnlyStanza
  def self.create
    node = Nokogiri::XML::Node.new(self::NODE_NAME, Nokogiri::XML::Document.new)
    node.document.root = node # we do this to make the whole node searchable via xpath
    self.setup(node)
    return self.new(node)
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
end

class AnonymousAuth < Stanza
  NODE_NAME = 'auth'
  SASL_NS = 'urn:ietf:params:xml:ns:xmpp-sasl'

  def self.setup(node)
    node = super(node)
    node.add_namespace(nil, SASL_NS)
    node['mechanism'] = 'ANONYMOUS'
    node
  end

  private

  def b64(str)
    [str].pack('m').gsub(/\s/,'')
  end
end

class Presence < Stanza
  NODE_NAME = 'presence'
end