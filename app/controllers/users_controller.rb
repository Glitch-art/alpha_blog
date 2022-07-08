class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def update
    respond_to do |wants|
      if @user.update(user_params)
        flash[:notice] = 'Your account information was successfully updated.'
        wants.html { redirect_to(@user) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def create
    @user = User.new(user_params)
  
    respond_to do |wants|
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Welcome to the Alpha Blog #{@user.username}, you have successfully signed up."
        wants.html { redirect_to(articles_path) }
        wants.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      flash[:success] = 'Account and all associated articles was successfully deleted.'
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong'
      redirect_to root_path
    end
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if current_user != @user
      flash[:alert] = "You can only edit your own account"
      redirect_to current_user
    end
  end
end