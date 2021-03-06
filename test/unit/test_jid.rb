require 'test_helper'
include Bersalis

class TestJID < Test::Unit::TestCase
  context 'new' do
    should 'separate out the username, host and resource correctly' do
      j = JID.new('bob@example.com/trousers')
      assert_equal j.username, 'bob'
      assert_equal j.host, 'example.com'
      assert_equal j.resource, 'trousers'
    end
    
    should 'handle just being given a bare jid' do
      j = JID.new('bob@example.com')
      assert_equal  j.username, 'bob'
      assert_equal  j.host, 'example.com'
      assert_nil    j.resource
    end
    
    should 'handle just being given a hostname' do
      j = JID.new('example.com')
      assert_nil    j.username
      assert_equal  j.host, 'example.com'
      assert_nil    j.resource
    end
  end
  
  context 'to_s' do
    should 'just return the hostname if no username and resource given' do
      j = Bersalis::JID.new
      j.host = 'example.com'
      assert_equal j.to_s, 'example.com'
    end
    
    should 'just return the bare jid if no resource given' do
      j = JID.new
      j.username = 'bob'
      j.host = 'example.com'
      assert_equal j.to_s, 'bob@example.com'
    end
    
    should 'return the full jid if username, host and resource is given' do
      j = JID.new
      j.username = 'bob'
      j.host = 'example.com'
      j.resource = 'trousers'
      assert_equal j.to_s, 'bob@example.com/trousers'
    end
  end
  
  context 'bare_jid' do
    should 'return just the bare jid' do
      j = JID.new('bob@example.com/trousers')
      assert_equal j.bare_jid, 'bob@example.com'
    end
  end
end