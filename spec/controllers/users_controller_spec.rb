require 'spec_helper'

describe UsersController do
  render_views


  describe "GET 'show'" do
  
    # use the factories.rb file to create a factory user  
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do 
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the correct user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the correct title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    
    it "should include the users's name" do
      get :show, :id =>@user
      response.should have_selector("h1", :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
      
  end
  

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    
    it "returns the correct title" do
      get :new
      response.should have_selector('title', :content=>"Sign up")
    end
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    
    it "should have a password confirmation field" do 
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
    
  end
  
  describe "POST 'create' " do
    describe "failure" do
      before(:each) do
        @attr = { :name=> "", :email=> "",:password => "", :password_confirmation=> "" }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user=> @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content=> "Sign up")
      end
      
      it "should render the 'new' page again" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name=> "New User", :email=> "user@example.com",
                                      :password => "foobar", 
                                      :password_confirmation=> "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user=> @attr
        end.should change(User, :count).by(1)
      end
      
          
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      it "should sign the user in" do
        post :create, :user =>@attr
        controller.should be_signed_in
      end
    end
  end
  
  describe "GET 'edit'" do
    before (:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end
    
    it "should have a link to Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url, :content => "change")
    end
  
  end
  
  describe "PUT 'update' " do
    
     before (:each) do
       @user = Factory(:user)
       test_sign_in(@user)
     end
     
     describe "failure" do
       before(:each) do
        @attr = { :name=> "", :email=> "",:password => "", :password_confirmation=> "" }
       end
       
       it "should render the edit page" do
         put :update, :id => @user, :user => @attr
         response.should render_template('edit')
       end
       
       it "should have the right title" do
         put :update, :id => @user, :user => @attr
         response.should have_selector("title", :content => "Edit User")
       end
     end
     
     describe "success" do
       before(:each) do
         @attr = { :name=> "New Name", :email=> "user@example.org",
         :password => "foobar", :password_confirmation=> "foobar" }
       end
       
       it "should change the user's attributes" do
         put :update, :id => @user, :user => @attr
         @user.reload
         @user.name.should == @attr[:name]
         @user.email.should == @attr[:email]
       end
       
       it "should redirect to the show users page" do
         put :update, :id => @user, :user => @attr
         response.should redirect_to(user_path(@user))
       end
       
       it "should have a flash message" do
         put :update, :id => @user, :user => @attr
         flash[:success].should =~ /updated/
       end
       
     end
   end
   
   describe "authentication of edit/update pages" do
     before(:each) do
       @user = Factory(:user)
     end
     
     describe "for non-signed in users" do
       it "should deny access to 'edit'" do
         get :edit, :id => @user
         response.should redirect_to(signin_path)
       end
       
       it "should deny access to 'update'" do
         put :update, :id => @user, :user => {}
         response.should redirect_to(signin_path)
       end
     end
     
     describe "for signed-in users" do
       before(:each) do
         wrong_user = Factory(:user, :email => "user@example.net")
         test_sign_in(wrong_user)
       end
       
       it "should require matching users for 'edit'" do
         get :edit, :id => @user
         response.should redirect_to(root_path)
       end
       
       it "should require matching users for 'update'" do
         put :update, :id => @user, :user => {}
         response.should redirect_to(root_path)
       end
     end
       
   end
   
  
end
