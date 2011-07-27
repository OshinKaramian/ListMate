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

class ListMateBookmarkRouteTest < Test::Unit::TestCase
  def setup
    User.delete_all
    Bookmark.delete_all
    
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    @browser.post '/user', :username => "test", :password => "test_password"
    @user_info = JSON.parse(@browser.last_response.body)

    @browser.post '/bookmark', :name => "Google", :url => "http://www.google.com", :user_id => @user_info["_id"]
    @bookmark_info = JSON.parse(@browser.last_response.body)
  end

  def tear_down
    User.delete_all
    Bookmark.delete_all
  end

  def test_create_bookmark
    assert @browser.last_response.ok?
    assert @bookmark_info["status"] == "success"
  end

  def test_get_all_bookmarks
    @browser.get '/bookmark', :user_id => @user_info["_id"]

    get_data = JSON.parse(@browser.last_response.body)
    assert @browser.last_response.ok?
    assert get_data[0]["name"] == "Google"
    assert get_data[0]["url"] == "http://www.google.com"
    assert get_data[0]["user_id"] == @user_info["_id"]
  end

  def test_delete_bookmark
    @browser.delete '/bookmark', :user_id => @user_info["_id"], :id => @bookmark_info["_id"]
    delete_data = JSON.parse(@browser.last_response.body)
    assert delete_data["status"] == "success"
  end
end

