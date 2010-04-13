require 'test_helper'
include Bersalis

class BasicClientTest < Test::Unit::TestCase
  testing BasicClient
  
  should_handle stanza_fixture(:auth_features),           :choose_auth_mechanism
  should_handle stanza_fixture(:auth_features_with_tls),  :choose_auth_mechanism
  should_handle stanza_fixture(:tls_proceed),             :proceed_with_tls
  should_handle stanza_fixture(:md5_challenge),           :auth_challenge
  should_handle stanza_fixture(:auth_success),            :authentication_successful
  
  context 'new' do
    # TODO
  end
  
  context 'choose_auth_mechanism' do
    should 'pick the most appropriate authentication mechanism'
    should 'start tls if available'
    should 'send an auth stanza'
  end
  
  context 'proceed_with_tls' do
    should 'start tls on the connection'
    should 'restart the stream'
  end
  
  context 'auth_challenge' do
    should 'decode the challenge'
    should 'create an auth challenge response'
    should 'set the credentials on the response using the decoded challenge and our username/password'
    should 'send the response stanza'
  end
  
  context 'authentication_successful' do
    should 'restart the stream'
  end
  
  context 'ready_to_bind' do
    should 'bind using our jid'
    should 'send the bind stanza'
  end
  
  context 'bound' do
    should 'start a session'
  end
  
  context 'session_started' do
    should 'notify the server of our presence'
  end
end