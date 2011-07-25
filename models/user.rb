# Class used to hold user information logic
require 'rubygems'
require 'mongoid'

class User 
	include Mongoid::Document

	store_in :user
	
	field :name, :type => String
	field :password, :type => String

	def to_json
		super(:except => :password)
	end

	#def get_id
	#	self._id.to_s
	#end
end
