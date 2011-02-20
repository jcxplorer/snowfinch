class UserMailer < ActionMailer::Base
  default :from => Snowfinch.configuration[:mailer_sender]

  def account_information(user)
    @user = user
    @host = Snowfinch.configuration[:host]

    mail :to => @user.email, :subject => "Account for #{@host}"
  end
end
