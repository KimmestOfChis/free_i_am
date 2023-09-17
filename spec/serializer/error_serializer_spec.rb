# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorSerializer, type: :serializer do
  subject(:serialized_errors) { JSON.parse(serialization.to_json) }

  let(:user) { User.new } # Assuming User is an ActiveRecord model
  let(:serializer) { described_class.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  before { user.valid? }

  it "serializes error messages correctly" do
    user.errors.full_messages.each do |error_message|
      expect(serialized_errors["errors"]).to include(error_message)
    end
  end
end
