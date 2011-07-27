# Class used to hold user information logic
require 'rubygems'
require 'mongoid'
require 'digest'

class User 
  include Mongoid::Document

  store_in :user
	
  field :name, :type => String
  field :password, :type => String

  before_save :encrypt_password

  def to_json
    super(:except => :password)
  end

  def encrypt_password
   self.password = Digest::SHA2.hexdigest(password).to_s
  end
end
