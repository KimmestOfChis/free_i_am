# frozen string literal: true

require "rails_helper"

RSpec.describe UserSerializer, type: :serializer do
  subject(:serialized_user) { JSON.parse(serialization.to_json) }

  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  it "has an id that matches" do
    expect(serialized_user).to include("id" => user.id,
                                       "email" => user.email)
  end
end
