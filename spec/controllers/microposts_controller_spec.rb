require 'spec_helper' 

describe MicropostsController do
  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do 
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id=>1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :content => "" }
      end
      
      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end
      it "should render the homepage" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
        
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :content => "Lore Ipsum" }
      end
      
      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
          end.should change(Micropost, :count).by(1)
      end
      
      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end
      
      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end
    end
      
  end
  
  describe "DELETE 'destroy'" do
    describe "for unauthorized users" do
      
      before (:each) do
        @user = Factory(:user)
        wrong_user= Factory(:user, :email=>Factory.next(:email))
        # signin with a different user
        test_sign_in(wrong_user)
        # have the valid user create the post
        @micropost = Factory(:micropost, :user => @user)
      end
        
      it "should deny access" do
        #wrong user tries to delete the micropost
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end
    
    describe "for an authorized user" do
      before (:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end
      
      it "it should destroy the micropost" do
        lambda do
          delete :destroy, :id =>@micropost
        end.should change(Micropost, :count).by(-1)
      end      
    end
    
  end
  
end

