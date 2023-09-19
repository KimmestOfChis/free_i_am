# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :not_found

  def record_invalid(exception)
    error = ApiError.new(
      status: 422,
      message: "Validation Failed",
      details: exception.record.errors.full_messages
    )
    render json: error, status: error.status
  end

  def record_not_found(exception)
    render json: { error: "Record not found: #{exception.message}" }, status: :not_found
  end

  def record_not_unique(exception)
    render json: { error: "Record not unique: #{exception.message}" }, status: :unprocessable_entity
  end

  def invalid_foreign_key(exception)
    render json: { error: "Invalid foreign key: #{exception.message}" }, status: :unprocessable_entity
  end

  def not_found(exception)
    error = ApiError.new(
      status: 404,
      message: "Not Found",
      details: exception.message
    )
    render json: error, status: error.status
  end
end
