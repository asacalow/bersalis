module Bersalis
  class Handshake < Stanza
    NODE_NAME = 'handshake'
    
    register '/handshake'
    
    content :auth_hash, :path => '/handshake'
    
    def set_credentials(opts)
      self.auth_hash = Digest::SHA1.hexdigest(opts[:id] + opts[:secret])
    end
  end
end