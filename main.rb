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

# Log user in and passes back a user object with a token that can be used at a later time
get '/user' do
	username = params[:username]
	password = Digest::SHA2.hexdigest(params[:password])
	
	user = User.where({ :name => username, 
						:password => password })

	if user
		user.to_json
	else
		error 404, {:error => "user not found"}.to_json 
	end
end

# Create a new user
post '/user' do
	begin
		username = params[:username]
		password = params[:password]

		user = User.new(:name => username, 
						:password => password )
		if user.save
		  user.to_json 
		else
		  error 400, user.errors.to_json
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
delete '/bookmark/:url' do
	begin
		bookmark_url = params[:url]
		token = params[:user_id]
		bookmark = Bookmark.where({:url => bookmark_url, :user_id => token })
		if bookmark.delete
			{ :status => "success" }.to_json
		else
			bookmark.errors.to_json
		end
	rescue => e
		error 400, e.message.to_json
	end
end
