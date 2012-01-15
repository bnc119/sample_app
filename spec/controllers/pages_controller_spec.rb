require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'home'" do
    it "the home page returns http success" do
      get 'home'
      response.should be_success
    end
  end
  
  describe "GET 'home'" do
    it "the home page should have the right title" do
      get 'home'
      response.should have_selector("title", 
                       :content => "Ruby on Rails Tutorial Sample App | Home")
                        
    end
  end

  describe "GET 'contact'" do
    it "the contact page returns http success" do
      get 'contact'
      response.should be_success
    end
  end
  
  describe "GET 'contact'" do
    it "the contact page should have the right title" do
      get 'contact'
      response.should have_selector("title", 
                       :content => "Ruby on Rails Tutorial Sample App | Contact")
                        
    end
  end
  
  describe "GET 'about'" do
    it "the about page returns http success" do
      get 'about'
      response.should be_success
    end
  end
  
  describe "GET 'about'" do
    it "the about page should have the right title" do
      get 'about'
      response.should have_selector("title", 
                       :content => "Ruby on Rails Tutorial Sample App | About")
                        
    end
  end

end
