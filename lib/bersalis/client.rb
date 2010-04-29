module Bersalis
  class Client
    attr_accessor :connection, :iq_callbacks
    
    HANDLERS = []
  
    def self.handle(klass, method, options={})
      options[:method] = method
      options[:class] = klass
      self::HANDLERS << options
    end
    
    def connect
      EM.connect '127.0.0.1', self.class::PORT_NUMBER, Connection, self
    end
  
    def initialize
      self.iq_callbacks = {}
    end
  
    def start
      self.connection.start
      self.write self.class::START_STREAM
    end
    
    def start_tls
      self.connection.start_tls
    end
    
    # after we've authenticated we need to renegotiate the stream
    def restart
      start
    end
  
    # this gets called back from the parser when we've got a Nokogiri Node to work with
    def process(node)
      return if callback_for(node)
      
      klasses = stanza_classes_for(node)
      return if klasses.empty? # return if the stanza hasn't been recognised
      
      for klass in klasses
        # now, if we know of a handler for the class, we can do something with it
        handler = handler_for(klass, node)
        next if handler.nil? # no handler matched
      
        send(handler[:method], klass.new(node))
      end
    end
  
    def write(stanza)
      xml = stanza.respond_to?(:to_xml) ? stanza.to_xml : stanza
      Bersalis.debug("OUT: #{xml}")
      self.connection.send_data(xml)
    end
    
    def write_iq(stanza, &block)
      self.iq_callbacks[stanza.id] = stanza
      write stanza
    end
    
    private
    
    def stanza_classes_for(node)
      klasses = []
      KNOWN_STANZAS.each_pair do |kls, nns|
        # if we get a hit for the registered path/namespace pairing then we have a recognisable class
        klasses << kls if !node.at(nns[:path], nns[:namespaces]).nil?
      end
      klasses
    end
    
    def handler_for(klass, node)
      possibles = self.class::HANDLERS.select{|h| klass == h[:class]}
      # now filter 'em
      opts = nil
      possibles.each do |options|
        next if options[:filter] && !node.at(options[:filter], options[:filter_ns] || {})
        opts = options
      end
      opts
    end
    
    def callback_for(node)
      iq = node.at('/iq[@type="result"]')
      return unless iq # not an iq result
      iq_id = iq['id']
      outgoing_iq = self.iq_callbacks[iq_id]
      return unless outgoing_iq # no outgoing iq matches
      outgoing_iq.succeed outgoing_iq.class.new(node) # assumption is that incoming stanza is of the same class as outgoing!
    end
  end
end