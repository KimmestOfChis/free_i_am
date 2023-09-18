# frozen string literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    @user.save!
    render json: @user, status: :created, serializer: UserSerializer
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
