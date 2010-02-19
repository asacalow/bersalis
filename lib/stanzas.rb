# the abstract Stanza classes
# a Stanza is basically a wrapper around a Nokogiri node

KNOWN_STANZAS = {}

module Bersalis
  class ReadOnlyStanza
    attr_accessor :node
  
    def initialize(node, attributes={})
      self.node = node
    
      # set some attribute values
      attributes.each_pair do |attribute, value|
        self.send("#{attribute}=", value)
      end
    end
    
    def at(path, namespaces={})
      self.node.document.at(path, namespaces)
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
        return self.at(path, namespaces)[attribute_name]
      end
    
      define_method("#{name}=") do |value|
        path = opts[:path]
        namespaces = opts[:namespaces] || {}
        attribute_name = (opts[:attribute_name] || name).to_s
        self.at(path, namespaces)[attribute_name] = value
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
end