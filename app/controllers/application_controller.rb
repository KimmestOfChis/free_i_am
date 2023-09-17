# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique
  rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
  rescue_from StandardError, with: :internal_server_error

  private

  def not_found(exception)
    render_error(404, exception)
  end

  def parameter_missing(exception)
    render_error(422, exception)
  end

  def record_invalid(exception)
    render_error(422, exception.record)
  end

  def record_not_unique(exception)
    render_error(409, exception)
  end

  def record_not_destroyed(exception)
    render_error(409, exception)
  end

  def invalid_foreign_key(exception)
    render_error(409, exception)
  end

  def internal_server_error(exception)
    Rails.logger.error(exception)
    render_error(500, "Internal server error")
  end

  def render_error(status, resource)
    render json: resource, status:, serializer: ErrorSerializer, adapter: :json
  end
end
