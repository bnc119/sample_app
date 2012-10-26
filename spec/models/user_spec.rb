require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar"}
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
  
  describe "password validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid  
    end
    
    it "should reject short passwords" do
      User.new(@attr.merge(:password => "abc")).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = 'a'*60
      User.new(@attr.merge(:password => long, :password_confirmation => long)).should_not be_valid
    end  
  end
  
  describe "password encryption" do
     before(:each) do
       @user = User.create!(@attr)
     end
     
     it "should have an encrypted password attribute" do
       @user.should respond_to(:encrypted_password)
     end
     
     it "should create an encrypted password" do
       @user.encrypted_password.should_not be_blank
     end
     
    it "should return true if the passwords match" do
      @user.has_password?(@attr[:password].should be_true)
    
    end
    
    it "should return false if the passwords do not match" do
      @user.has_password?(@attr["invalid"].should be_false)
    
    end
    
    it "should return nil on email/password mismatch" do
      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_password_user.should be_nil
    end  
    
    it "should return for an email address with no user" do
      non_existent_user = User.authenticate("bar@foo.com", @attr[:password])
      non_existent_user.should be_nil
    end
    
    it "should return the actual user object for a correct username and password" do
      matching_user = User.authenticate(@attr[:email], @attr[:password])
      matching_user.should == @user
    end
    
  end
  
  describe "admin attribute" do
    before (:each) do 
      @user= User.create!(@attr)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)

    end
    it "should not be admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end
  
  describe "micropost associations" do
    before (:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user=>@user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user=>@user, :created_at => 1.hour.ago)
    end
    
    it "should have a micropost attribute" do
      @user.should respond_to(:microposts)
    end
    
    it "should have the right microposts in the right order" do
      @user.microposts.should == [ @mp2, @mp1]
    end
    
    it "should destroy associated microposts" do
      @user.destroy
      [@mp1,@mp2].each do |m|
        Micropost.find_by_id(m.id).should be_nil
      end
    end
  end
  
end
