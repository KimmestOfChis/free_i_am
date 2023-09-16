# frozen string literal: true

class UsersController < ApplicationController
  def create 
    @user = User.new(user_params)
    
    render json: @user, status: :created
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
