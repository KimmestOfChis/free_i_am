class ErrorSerializer < ActiveModel::Serializer
  attribute :errors

  def errors
    object.errors.full_messages
  end
end
