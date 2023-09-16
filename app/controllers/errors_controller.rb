# frozen string literal: true

class ErrorsController < ApplicationController
  def not_found
    render json: { error: 'not_found' }, status: :not_found
  end

  def handle_bad_request
    errors = error_params[:errors]
    render json: { errors: errors.full_messages }, status: :bad_request
  end

  private

  def error_params
    params.require(:error).permit(errors: [])
  end
end
