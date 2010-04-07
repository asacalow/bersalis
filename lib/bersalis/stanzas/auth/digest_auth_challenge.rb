module Bersalis
  class DigestAuthChallenge < Auth
    register '/auth:challenge', 'auth' => 'urn:ietf:params:xml:ns:xmpp-sasl'
    
    attr_accessor :realm, :nonce
    
    def decode_challenge
      text = @node.content.unpack('m').first
      res = {}

      text.split(',').each do |statement|
        key, value = statement.split('=')
        res[key] = value.delete('"') unless key.empty?
      end
      self.nonce = res['nonce']
      self.realm = res['realm']
    end
  end
end