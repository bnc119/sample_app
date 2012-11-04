require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  describe "GET 'home'" do
    describe "when not signed in" do
      before :each do
        get :home
      end
      
      it "should be successful" do
        response.should be_success
      end
      
      it "the home page should have the right title" do
        response.should have_selector("title", :content => @base_title + " | Home")
      end
    end
    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user=Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end
      
      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href=>following_user_path(@user), :content => "0 following")
        response.should have_selector("a", :href=>followers_user_path(@user), :content => "1 follower")
      end
    end
    
  end
  
  describe "GET 'contact'" do
    it "the contact page returns http success" do
      get 'contact'
      response.should be_success
    end
    
    it "the contact page should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => @base_title + " | Contact")
                        
    end
  end
  
  
  describe "GET 'about'" do
    it "the about page returns http success" do
      get 'about'
      response.should be_success
    end
    
    it "the about page should have the right title" do
      get 'about'
      response.should have_selector("title", :content => @base_title + " | About")
                        
    end
  end
  
  
  describe "GET 'help'" do
    it "the help page returns http success" do
      get 'help'
      response.should be_success
    end
    
     it "the help page should have the right title" do
      get 'help'
      response.should have_selector("title", :content => @base_title + " | Help")
                        
    end
        
  end
  
  
   


end
