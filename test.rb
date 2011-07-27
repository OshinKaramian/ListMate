require 'main'
require 'test/unit'
require 'rack/test'
require 'json'

set :environment, :test

class ListMateUserRouteTest < Test::Unit::TestCase
  def setup
    User.delete_all
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    @browser.post '/user', :username => "test", :password => "test_password"
    @user_info = JSON.parse(@browser.last_response.body)
  end

  def tear_down
    User.delete_all
  end

  def test_create_user
    assert @browser.last_response.ok?
    assert @user_info["name"] == "test"
  end

  def test_get_user
    @browser.get '/user', :username => "test", :password => "test_password"
    data_from_get = JSON.parse(@browser.last_response.body)

    assert @browser.last_response.ok?
    assert @user_info["_id"] == data_from_get["_id"]
  end

  def test_get_user_not_in_database
    @browser.get '/user', :username => "test_negative", :password => "test_password"
    data_from_get = JSON.parse(@browser.last_response.body)

    assert !@browser.last_response.ok?
    assert data_from_get["error"].to_s == "User Does Not Exist Or Password is Incorrect"
  end

  def test_delete_user
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    @browser.delete '/user', :user_id => @user_info["_id"] 
    
    delete_response = JSON.parse(@browser.last_response.body)

    assert @browser.last_response.ok?
    assert delete_response["status"] == "success"
  end
end

