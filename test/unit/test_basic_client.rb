require 'test_helper'
include Bersalis

class TestBasicClient < Test::Unit::TestCase
  testing BasicClient
  
  should_handle stanza_fixture(:auth_features),           :choose_auth_mechanism
  should_handle stanza_fixture(:auth_features_with_tls),  :choose_auth_mechanism
  should_handle stanza_fixture(:tls_proceed),             :proceed_with_tls
  should_handle stanza_fixture(:md5_challenge),           :auth_challenge
  should_handle stanza_fixture(:auth_success),            :authentication_successful
  
  context 'new' do
    should 'set the password, jid and host from the given options' do
      jid = 'bob@example.com'
      password = 'unguess4ble'
      host = 'xmpp.example.com'
      client = BasicClient.new(:jid => jid, :password => password, :host => host)
      assert_equal client.jid.to_s, jid
      assert_equal client.password, password
      assert_equal client.host,     host
    end
    
    should 'set the host from the jid if none given' do
      jid = 'bob@example.com'
      client = BasicClient.new(:jid => jid)
      assert_equal 'example.com', client.host
    end
  end
  
  context 'handlers' do
    setup do
      @client = BasicClient.new(:jid => 'bob@example.com/test', :password => 'password')
      @client.stubs(:write)
      @connection = mock('Connection')
      @connection.stubs(:send_data)
      @connection.stubs(:start)
      @connection.stubs(:start_tls)
      @client.connection = @connection
    end
    
    context 'choose_auth_mechanism' do
      should 'pick the most appropriate authentication mechanism' do
        features = Features.new(nil)
        features.stubs(:tls_required?).returns(false)
        @client.stubs(:write) do |stanza|
          assert_kind_of DigestAuth, stanza
        end
      
        @client.choose_auth_mechanism(features)
      end
    
      should 'start tls if available' do
        features = Features.new(nil)
        features.stubs(:tls_required?).returns(true)
        @client.stubs(:write) do |stanza|
          assert_kind_of Starttls, stanza
        end
      
        @client.choose_auth_mechanism(features)
      end
    end
  
    context 'proceed_with_tls' do
      should 'start tls on the connection' do
        @client.expects(:start_tls)
        proceed = StartTLSProceed.new(nil)
        @client.proceed_with_tls(proceed)
      end
    
      should 'restart the stream' do
        @client.expects(:restart)
        proceed = StartTLSProceed.new(nil)
        @client.proceed_with_tls(proceed)
      end
    end
  
    context 'auth_challenge' do
      setup do
        @challenge = DigestAuthChallenge.new(nil)
        @challenge.stubs(:decode_challenge)
        @response = DigestAuthChallengeResponse.new(nil)
        @response.stubs(:set_credentials)
        DigestAuthChallengeResponse.stubs(:create).returns(@response)
      end
      
      should 'decode the challenge' do
        @challenge.expects(:decode_challenge)
        @client.auth_challenge(@challenge)
      end
      
      should 'create an auth challenge response' do
        DigestAuthChallengeResponse.expects(:create).returns(@response)
        @client.auth_challenge(@challenge)
      end
      
      should 'set the credentials on the response using the decoded challenge and our username/password'  do
        @challenge.stubs(:nonce).returns('abcd1234')
        @challenge.stubs(:realm).returns('realm.example.com')
        
        @response.expects(:set_credentials).with(
          :username => 'bob',
          :password => 'password',
          :nonce => 'abcd1234',
          :realm => 'realm.example.com',
          :domain => 'example.com'
        )
        
        @client.auth_challenge(@challenge)
      end
      
      should 'send a DigestAuthChallengeReponse' do
        @client.stubs(:write) do |stanza|
          assert_kind_of DigestAuthChallengeResponse, stanza
        end
      
        @client.auth_challenge(@challenge)
      end
    end
  
    context 'authentication_successful' do
      should 'restart the stream' do
        @success = AuthenticationSuccessful.new(nil)
        @client.expects(:restart).returns(nil)
        @client.authentication_successful(@success)
      end
    end
  
    context 'ready_to_bind' do
      setup do
        @bind = Bind.new(nil)
        Bind.stubs(:create).returns(@bind)
      end
      
      should 'bind using our jid' do
        Bind.expects(:create).with(
          :type => 'get',
          :jid => 'bob@example.com',
          :resource => 'test'
        ).returns(@bind)
        @client.ready_to_bind(@bind)
      end
      
      should 'send the bind stanza' do
        @client.expects(:write).with(@bind)
        @client.ready_to_bind(@bind)
      end
    end
  
    context 'bound' do
      should 'start a session' do
        bind = Bind.new(nil)
        @client.stubs(:write) do |stanza|
          assert_kind_of Session, stanza
          assert_equal stanza.type, 'set'
        end
        @client.bound(bind)
      end
    end
  
    context 'session_started' do
      should 'notify the server of our presence' do
        session = Session.new(nil)
        @client.stubs(:write) do |stanza|
          assert_kind_of Presence, stanza
        end
        @client.session_started(session)
      end
    end
  end
end