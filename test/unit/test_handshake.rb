require 'test_helper'

class TestHandshake < Test::Unit::TestCase
  context 'Bersalis::Handshake' do
    test_stanza '<handshake>1234abcd</handshake>'
    should_have 'auth_hash', '1234abcd'
    
    should 'set the credentials as a hash of the given id and secret' do
      id = 'test1234'
      secret = 'unguess4ble'
      hs = Bersalis::Handshake.create
      hs.set_credentials(:id => id, :secret => secret)
      
      assert_equal hs.auth_hash, Digest::SHA1.hexdigest(id + secret)
    end
  end
end