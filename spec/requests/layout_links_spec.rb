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

end
