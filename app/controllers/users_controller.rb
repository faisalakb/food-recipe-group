class UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]
  before_action :authenticate_user!

  def login
    @user = User.new
  end

  def index
    @users = User.includes(:posts).all
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  def show
    @posts = @user.posts
  end

  private

  def set_user
    @user = User.includes(:posts).find_by_id(params[:id])
  end
end
