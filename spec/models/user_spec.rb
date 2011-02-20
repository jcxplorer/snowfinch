require 'spec_helper'

describe User do

  describe "on create" do
    context "no password specified" do
      it "generates a random password" do
        user = Factory :user, :password => nil
        user.password.should_not be_nil
        user.password.should_not be_empty
      end
    end

    context "password specified" do
      it "uses the specified password" do
        user = Factory :user, :password => "monkey"
        user.password.should == "monkey"
      end
    end

    it "sends an email with the password to the user" do
      Factory :user, :email => "lucy@snowfinch.net", :password => "passw0rd"
      email = last_email_sent

      email.should deliver_to("lucy@snowfinch.net")
      email.should have_subject("Account for snowfinch.rails.fi:3000")
      email.should have_body_text(/lucy@snowfinch.net/)
      email.should have_body_text(/passw0rd/)
    end
  end

end
