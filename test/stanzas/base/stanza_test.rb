require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class StanzaTest < Test::Unit::TestCase
  context 'self.create' do
    setup do
      class DummyStanza < Bersalis::Stanza; NODE_NAME='foo'; end
    end
    
    should 'instantiate a node' do
      stanza = DummyStanza.create
      assert_kind_of Bersalis::Node, stanza.node
    end
    
    should 'set up the instance' do
      DummyStanza.expects(:setup)
      DummyStanza.create
    end
  end
  
  context 'to_xml' do
    should 'return the xml representation' do
      node = Bersalis::Node.new('foo')
      bar = node << Bersalis::Node.new('bar', node.document)
      stanza = Bersalis::Stanza.new(node)
      assert_equal(node.to_xml, stanza.to_xml)
    end
  end
  
  context 'reply!' do
    should 'swap the to and the from' do
      node = Bersalis::Node.new('foo')
      node.finish_up
      stanza = Bersalis::Stanza.new(node)
      to = stanza.to = 'bob@example.com'
      from = stanza.from = 'jim@example.com'
      stanza.reply!
      assert_equal stanza.from, to
      assert_equal stanza.to, from
    end
  end
end