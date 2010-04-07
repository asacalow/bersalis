module Bersalis
  class DigestAuthChallengeResponse < Stanza
    NODE_NAME = 'response'

    def self.setup(node)
      node = super(node)
      node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-sasl')
      node
    end

    def set_credentials(opts)
      password = opts.delete(:password)
      response = {
        :nonce        => opts[:nonce],
        :charset      => 'utf-8',
        :username     => opts[:username],
        :realm        => opts[:realm] || opts[:domain],
        :cnonce       => h(Time.new.to_f.to_s),
        :nc           => '00000001',
        :qop          => 'auth',
        :'digest-uri' => "xmpp/#{opts[:domain]}"
      }
      response[:response] = generate_response(password, response)

      string_response = response.map{|k,v| "#{k}=#{v}"}.join(',')
      self.node.content = b64(string_response)
    end

    def generate_response(pass, response)
      a1 = "#{d("#{response[:username]}:#{response[:realm]}:#{pass}")}:#{response[:nonce]}:#{response[:cnonce]}"
      a2 = "AUTHENTICATE:#{response[:'digest-uri']}"
      h("#{h(a1)}:#{response[:nonce]}:#{response[:nc]}:#{response[:cnonce]}:#{response[:qop]}:#{h(a2)}")
    end

    def d(s); Digest::MD5.digest(s);    end
    def h(s); Digest::MD5.hexdigest(s); end
    def b64(str)
      [str].pack('m').gsub(/\s/,'')
    end
  end
end