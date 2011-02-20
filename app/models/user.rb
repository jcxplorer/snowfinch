class User < ActiveRecord::Base

  devise  :database_authenticatable, :lockable, :recoverable, :rememberable,
          :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  before_validation :generate_password_if_unset, :on => :create
  after_create :send_account_information_email

  private

  def generate_password_if_unset
    self.password ||= SecureRandom.hex(6)
  end

  def send_account_information_email
    UserMailer.account_information(self).deliver
  end

end
