class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate( params[:session][:email],
                              params[:session][:password])
    if user.nil?
      # create an error message to display
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      # sign the user in and redirect to the users show page
      sign_in user
      redirect_to user
      
    end

  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
