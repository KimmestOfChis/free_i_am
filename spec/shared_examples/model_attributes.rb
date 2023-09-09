# frozen_string_literal: true

RSpec.shared_examples "a valid attribute" do |attribute, value|
  let(:attributes) { attributes_for(:user, attribute => value) }
  let(:model_instance) { described_class.new(attributes) }

  before { model_instance.valid? }

  it { expect(model_instance).to be_valid }
end

RSpec.shared_examples "an invalid attribute" do |attribute, value, message|
  let(:attributes) { attributes_for(described_class.name.downcase.to_sym, attribute => value) }
  let(:model_instance) { described_class.new(attributes) }

  before { model_instance.valid? }

  attribute = :password if attribute == :password_confirmation

  it { expect(model_instance).not_to be_valid }
  it { expect(model_instance.errors[attribute]).to include(message) }
end
