class User < ActiveRecord::Base

	validates_presence_of :nick_name, :avatar => "can't be blank~"
		
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:weibo,:qq_connect]


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nick_name, :avatar
  # attr_accessible :title, :body
end
