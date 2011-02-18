class User < ActiveRecord::Base

  devise  :database_authenticatable, :lockable, :recoverable, :rememberable,
          :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

end
