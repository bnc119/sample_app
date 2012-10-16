class UsersController < ApplicationController
  
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
    @user = User.find(params[:id])
    
  end
  
  #respond to PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] ="Profile updated."
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
      
  end
  

end
