require File.join(File.dirname(__FILE__), 'test_helper')

class ReadOnlyStanzaTest < Test::Unit::TestCase
  should 'register a stanza type in the appropriate format'
  
  context 'to_xml' do
    should 'return the xml representation'
  end
  
  context 'at' do
    should 'return the node found at the given path'
  end
  
  context 'self.attribute' do
    should 'create a getter that points to the right place'
    should 'create a setter that points to the right place'
  end
  
  context 'self.content' do
    should 'create a getter that points to the right place'
    should 'create a setter that points to the right place'
  end
end

class StanzaTest < Test::Unit::TestCase
  context 'self.create' do
    should 'instantiate and set up a nokogiri node'
  end
end