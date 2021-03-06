require 'test_helper'

class DummyStanza < Bersalis::Stanza; NODE_NAME='foo'; end

class TestStanza < Test::Unit::TestCase
  context 'self.create' do
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