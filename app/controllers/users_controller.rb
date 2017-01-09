class UsersController < ApplicationController

  before_filter :find_user, only: [:edit, :update, :show, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    if @user.destroy
      redirect_to users_path
    else
      redirect_to users_path, error: 'User no delete'
    end
  end

  private
    def user_params
      params[:user].permit(:firstName, :secondName)
    end

    def find_user
      @user = User.find(params[:id])
    end
end
