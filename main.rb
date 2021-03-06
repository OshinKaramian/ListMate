require 'rubygems'
require 'sinatra'
require 'mongoid'
require 'digest'
Dir["models/*.rb"].each {|file| require file }

# Include as init
configure do
   Mongoid.configure do |config|
    name = "bookmark_app"
    host = "localhost"
    config.master = Mongo::Connection.new.db(name)
  end
end

get '/' do
  send_file File.join('public', 'index.html')
end

# Log user in and passes back a user object with a token that can be used at a later time
get '/user' do
  content_type :json
  token = params[:token]
  user = nil

  if !token.nil?
    user = User.find(token)
  else
    username = params[:username]
    password = params[:password]
    password = Digest::SHA2.hexdigest(params[:password])

    user = User.first(:conditions => {:name => username, :password => password})
  end

  if user
    return user.to_json
  else
    error 404, {:error => "User Does Not Exist Or Password is Incorrect"}.to_json 
  end
end

# Create a new user
post '/user' do
  begin
    content_type :json
    username = params[:username]
    password = params[:password]

    user = User.new(:name => username, 
                    :password => password )
    if user.save
      return user.to_json 
    else
      error 400, user.errors.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

delete '/user' do
  begin
    token = params[:user_id]
    user = User.first(:conditions => { :_id => token })

    if user.delete
      { :status => "success" }.to_json
    else
      user.errors.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# Create a new user Bookmark
post '/bookmark' do
  begin
    bookmark_name = params[:name]
    bookmark_url = params[:url]
    token = params[:user_id]

    bookmark = Bookmark.new(:user_id => token, 
                            :name => bookmark_name, 
                            :url => bookmark_url )
    if bookmark.save
       { :status => "success" }.to_json
    else
      bookmark.errors.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# Get all user bookmarks
get '/bookmark' do
  begin
    token = params[:user_id]
    bookmarks = Bookmark.where({ :user_id => token })
    bookmarks.to_json
  rescue => e
    error 400, e.message.to_json
  end
end

# Delete this user bookmark
delete '/bookmark' do
  begin
    bookmark_id = params[:id]
    token = params[:user_id]
    bookmark = Bookmark.where({:_id => bookmark_id, :user_id => token })
    if bookmark.delete
      { :status => "success" }.to_json
    else
      bookmark.errors.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end
