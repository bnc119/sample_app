
class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :restrict, :only => [:create, :new]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  # respond to GET users/new
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  # respond to get calls
  def show
    
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
    
  end
  
  # respond to POST /users
  def create
    @user = User.new (params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
    
  end
  
  # respond to GET /users/1/edit
  def edit
    @title="Edit user"
    
  end
  
  #respond to PUT /users/1
  def update
    
    if @user.update_attributes(params[:user])
      flash[:success] ="Profile updated."
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
      
  end
  
  def following
    @title="Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title="Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  private 
        
    def restrict 
      redirect_to(root_path) if signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin? 
    end
  
  

end
