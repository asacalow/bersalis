require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bersalis'

class Test::Unit::TestCase
  def self.should_be_recognised_as(xml_string)
    test_class = constantize(Shoulda.current_context.name)
    
    should 'be recognised' do
      connection = mock('Connection')
      client = Bersalis::Client.new(connection)
      document = Nokogiri::XML::Document.parse(xml_string)
      assert_equal test_class, client.send(:stanza_class_for, document.root)
    end
  end
  
  # borrowed from Rails::ActiveSupport
  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
end