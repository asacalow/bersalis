require 'test_helper'

class TestNode < Test::Unit::TestCase
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