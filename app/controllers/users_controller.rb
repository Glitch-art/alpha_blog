class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
  
    respond_to do |wants|
      if @user.save
        flash[:notice] = "Welcome to the Alpha Blog #{@user.username}, you have successfully signed up."
        wants.html { redirect_to(articles_path) }
        wants.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end