# the abstract Stanza classes
# a Stanza is basically a wrapper around a Nokogiri node

module Bersalis
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
    
    def at(path, namespaces={})
      self.node.at(path, namespaces)
    end

    def self.register(path, namespaces={})
      KNOWN_STANZAS[self] = {:path => path, :namespaces => namespaces}
    end
  
    def self.attribute(name, opts={})
      define_method("#{name}") do
        path = opts[:path]
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
        return self.at(path, namespaces).content
      end
    
      define_method("#{name}=") do |value|
        path = opts[:path]
        namespaces = opts[:namespaces] || {}
        self.at(path, namespaces).content = value
      end
    end
  
    attribute :to,    :path => '/*'
    attribute :from,  :path => '/*'
  end

  class Stanza < ReadOnlyStanza
    def self.create(attributes={})
      node = Node.new(self::NODE_NAME)
      node.finish_up
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
    
    def to_xml(*args)
      self.node.to_xml(*args)
    end
    
    def reply!
      self.to, self.from = self.from, self.to
    end
  end
  
  class Node < Nokogiri::XML::Node
    def self.new(name, doc=Nokogiri::XML::Document.new)
      super(name, doc)
    end
    
    # we do this so we can use the at method below to search the entire node
    def finish_up
      self.document.root = self
    end
    
    def at(*args)
      self.document.at(*args)
    end
  end
end