class UsersController < ApplicationController
  http_basic_authenticate_with name: Figaro.env.ADM_LOG, password: Figaro.env.ADM_PASS

  before_action :find_user, only: [:edit, :update, :show, :destroy]

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

  def generate_pairs
    @users = User.all.shuffle
    if @users.count % 2 != 0
      flash.alert = "Users count is odd"
      redirect_to root_path
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
