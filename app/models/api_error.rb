# frozen string literal: true

class ApiError
  include ActiveModel::Model
  attr_accessor :status, :message, :details

  def initialize(status:, message:, details: [])
    @status = status
    @message = message
    @details = details
  end
end
