require 'minitest/autorun'
require File.expand_path(File.join(File.dirname(__FILE__), '/../lib/rnvivo'))
require 'minitest/reporters'
MiniTest::Reporters.use!
require 'mocha/setup'

FAKE_API_KEY = 'wadus'