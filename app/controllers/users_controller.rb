class UsersController < ApplicationController
  before_action :find_user, only: [:edit, :update, :show, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:alert] = t('users.created')
      redirect_to users_path
    else
      render :new
    end
  end

  def index
    @users = User.all
  end

  def update
    if @user.update(user_params)
      flash[:alert] = t('users.updated')
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:alert] = t('users.destroyed')
      redirect_to users_path
    else
      redirect_to users_path, error: 'User no delete'
    end
  end

  def generate_pairs
    @users = User.random_pairs!
    rescue ArgumentError
      flash[:alert] = t('users.cant_generate')
      redirect_to root_path
  end

  private
    def user_params
      params[:user].permit(:first_name, :last_name)
    end

    def find_user
      @user = User.find(params[:id])
    end
end
