# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :handle_bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :handle_bad_request
  rescue_from ActiveRecord::RecordNotUnique, with: :handle_bad_request
  rescue_from ActiveRecord::RecordNotDestroyed, with: :handle_bad_request
  rescue_from ActiveRecord::InvalidForeignKey, with: :handle_bad_request
end
