module Bersalis
  class IQ < Stanza
    include EventMachine::Deferrable
    
    NODE_NAME = 'iq'
    
    register '/iq'
  
    attribute :type,  :path => '/iq'
    attribute :id,    :path => '/iq'
    
    def self.setup(node)
      super(node)
      node['id'] = IQ.increment_id!.to_s
      node
    end
    
    def self.increment_id!
      @iq_id ||= 0
      @iq_id += 1
    end
  end
  
  class Presence < Stanza
    NODE_NAME = 'presence'
  
    register '/presence'
  end
  
  class Message < Stanza
    NODE_NAME = 'message'
    
    register '/message'
    
    attribute :type, :path => '/message'
    content   :body, :path => '/message'
  end
end