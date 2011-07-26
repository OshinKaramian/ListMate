require 'main'
require 'test/unit'
require 'rack/test'

set :environment, :test

class HelloWorldTest < Test::Unit::TestCase

  def test_create_user
    browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    browser.post '/user', :username => "test", :password => "test_password"
    assert browser.last_response.ok?
    assert browser.last_response.body.include?('_id')
    assert browser.last_response.body.include?('test')
    assert !browser.last_response.body.include?('test_password')
  end

end

