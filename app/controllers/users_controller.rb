class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  
  # respond to GET users/new
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  # respond to get calls
  def show
    
    @user = User.find(params[:id])
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
  
  private 
    def authenticate 
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
  

end
