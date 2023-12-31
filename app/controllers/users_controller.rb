# frozen string literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    @user.save!
    render json: @user, status: :created, serializer: UserSerializer
  end

  def update
    @user = User.find(params[:id])

    @user.update!(user_params)
    render json: @user, status: :ok, serializer: UserSerializer
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!

    render json: { status: 200, message: "User deleted successfully" }
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
