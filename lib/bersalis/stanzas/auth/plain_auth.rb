module Bersalis
  class PlainAuth < AuthMechanism
    register '/auth:auth[@mechanism="PLAIN"]', 'auth' => 'urn:ietf:params:xml:ns:xmpp-sasl'
    MECHANISM = 'PLAIN'
  
    def set_credentials(opts)
      self.node.content = b64("#{opts[:jid]}\x00#{opts[:username]}\x00#{opts[:password]}")
    end
  
    private
  
    def b64(str)
      [str].pack('m').gsub(/\s/,'')
    end
  end
end