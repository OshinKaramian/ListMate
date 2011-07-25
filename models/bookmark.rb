# Class used to hold bookmarking logic
require 'rubygems'
require 'mongoid'

class Bookmark
	include Mongoid::Document
	
	store_in :bookmarks

	field :user_id, :type => String
	field :name, :type => String
	field :url, :type => String
end
