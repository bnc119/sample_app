require 'spec_helper'

describe "LayoutLinks" do
  
  it "should have a home page @ '/' " do
    get '/'
    response.should have_selector('title', :content=> "Home")
  end
  
  it "should have a contact page @ '/contact' " do
    get '/contact'
    response.should have_selector('title', :content=>"Contact")
  end
  
  it "should have an about page @ '/about' " do
    get '/about'
    response.should have_selector('title', :content=>"About")
  end
  
  it "should have a help page @ '/help' " do
    get '/help'
    response.should have_selector('title', :content=>"Help")
  end
  
  it "should have a signup @ '/help' " do
    get '/signup'
    response.should have_selector('title', :content=>"Sign up")
  end
  
  describe "when not signed in" do
    
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href =>signin_path, :content => "Sign in")
    end
    
  end
  
  describe "when signed in" do
    
    before (:each) do 
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end


    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href =>signout_path, :content => "Sign out")
    end
    
    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user), :content => "Profile")
    end
    
  end

end
