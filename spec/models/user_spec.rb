require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr);
  end
  
  it "should require a name" do
    no_name_user=User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user=User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject user names that are too long" do
    long_name = 'a'*51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@example.com THE_USER@r.com first.last@some.example.com]
    addresses.each do |a|
      user = User.new(@attr.merge(:email => a))
      user.should be_valid
    end
       
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[userexample.com THE_USER@ @some.com example.user@foo]
    addresses.each do |a|
      user = User.new(@attr.merge(:email => a))
      user.should_not be_valid
    end
       
  end
  
  it "should only accept unique email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
    
  end  
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr)
    upcased_email = User.new(@attr.merge(:email => upcased_email))
    upcased_email.should_not be_valid
  end
  
end
