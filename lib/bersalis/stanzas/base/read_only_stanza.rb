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
end