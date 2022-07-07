class SessionsController < ApplicationController

  def new
  end
  
  def create
    byebug
    @session = Session.new(params[:session])
    if @session.save
      flash[:success] = "Session successfully created"
      redirect_to @session
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def destroy
    @session = Session.find(params[:id])
    if @session.destroy
      flash[:success] = 'Session was successfully deleted.'
      redirect_to sessions_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to sessions_url
    end
  end
end