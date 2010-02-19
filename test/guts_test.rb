require File.join(File.dirname(__FILE__), 'test_helper')

class ConnectionTest < Test::Unit::TestCase
  context 'initialising' do
    should 'instantiate a client'
    should 'instantiate a parser'
  end
  
  context 'receiving data' do
    should 'hand it off to the parser'
  end
end

class ClientTest < Test::Unit::TestCase
  context 'starting' do
    should 'set up the connection'
    should 'send a stream start message'
  end
  
  should 'restarting should start again'
  
  context 'creating a handler' do
    should 'add a handler in the appropriate format'
  end
  
  context 'processing a parsed node' do
    should 'not do anything with an unrecognised stanza'
    
    context 'of a recognised stanza type' do
      should 'look for a handler'
      should 'apply the stanza filter for a recognised handler'
    end
  end
  
  context 'sending data' do
    should 'convert the stanza to xml'
    should 'write data to the connection'
  end
end

class DocumentTest < Test::Unit::TestCase
  should 'process a complete stanza'
  should 'not process an incomplete stanza'
end