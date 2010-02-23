require File.join(File.dirname(__FILE__), 'test_helper')

class ReadOnlyStanzaTest < Test::Unit::TestCase
  should 'register a stanza type in the appropriate format' do
    class DummyStanza < Bersalis::ReadOnlyStanza; end
    path = '/some/identifying/foo:path'
    namespaces = {:foo => 'http://foo.com'}
    DummyStanza.register(path, namespaces)
    registration = Bersalis::KNOWN_STANZAS[DummyStanza]
    
    assert_equal registration[:path], path
    assert_equal registration[:namespaces], namespaces
  end
  
  context 'to_xml' do
    should 'return the xml representation' do
      node = Bersalis::Node.new('foo')
      bar = node << Bersalis::Node.new('bar', node.document)
      stanza = Bersalis::ReadOnlyStanza.new(node)
      assert_equal(node.to_xml, stanza.to_xml)
    end
  end
  
  context 'at' do
    should 'return the node found at the given path' do
      node = Bersalis::Node.new('foo')
      bar = node << Bersalis::Node.new('bar', node.document)
      node.finish_up
      stanza = Bersalis::ReadOnlyStanza.new(node)
      assert_equal stanza.at('//bar'), bar
    end
  end
  
  context 'self.attribute' do
    setup do
      @node = Bersalis::Node.new('foo')
      @node.finish_up
      @bar = @node << Bersalis::Node.new('bar', @node.document)
    end
    
    should 'create a setter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.attribute('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      stanza.bar = 'baz'
      assert_equal @bar[:bar], stanza.bar
    end
    
    should 'create a getter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.attribute('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      @bar['bar'] = 'bazzzz'
      assert_equal @bar[:bar], stanza.bar
    end
  end
  
  context 'self.content' do
    setup do
      @node = Bersalis::Node.new('foo')
      @node.finish_up
      @bar = @node << Bersalis::Node.new('bar', @node.document)
    end
    
    should 'create a setter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.content('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      stanza.bar = 'baz'
      assert_equal @bar.content, stanza.bar
    end
    
    should 'create a getter that points to the right place' do
      class DummyStanza < Bersalis::ReadOnlyStanza; end
      DummyStanza.content('bar', :path => '//bar')
      stanza = DummyStanza.new(@node)
      @bar.content = 'bazzzz'
      assert_equal @bar.content, stanza.bar
    end
  end
end

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
end

class NodeTest < Test::Unit::TestCase
  context 'Node' do
    context 'finish_up' do
      should 'set itself as the root node for its document' do
        node = Bersalis::Node.new('foo')
        node.document.expects(:root=).with(node)
        node.finish_up
      end
    end
    
    context 'at' do
      should 'hand off to the node document' do
        node = Bersalis::Node.new('foo')
        path = '/this/is/a/path'
        node.document.expects(:at).with(path)
        node.at(path)
      end
    end
  end
end