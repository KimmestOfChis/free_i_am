# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject { build(:user) }

  password = "Password123!@#"

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to validate_confirmation_of(:password) }
  end

  RSpec.shared_examples "a valid attribute" do |attribute, value|
    let(:attributes) { attributes_for(:user, attribute => value) }
    let(:user) { described_class.new(attributes) }

    before { user.valid? }

    it { expect(user).to be_valid }
  end

  RSpec.shared_examples "an invalid attribute" do |attribute, value, message|
    let(:attributes) { attributes_for(described_class.name.downcase.to_sym, attribute => value) }
    let(:model_instance) { described_class.new(attributes) }

    before { model_instance.valid? }

    attribute = :password if attribute == :password_confirmation

    it { expect(model_instance).not_to be_valid }
    it { expect(model_instance.errors[attribute]).to include(message) }
  end

  RSpec.shared_examples "password complexity validation" do |password_param|
    let(:password_comlexity_error) do
      "Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
    end
    let(:params) { attributes_for(:user, password: password_param, password_confirmation: password_param) }
    let(:user) { described_class.new(params) }
    before { user.valid? }

    it { expect(user).not_to be_valid }
    it { expect(user.errors[:password]).to include(password_comlexity_error) }
  end

  describe "email validation" do
    it_behaves_like "a valid attribute", :email, Faker::Internet.email

    it_behaves_like "an invalid attribute", :email, "", "can't be blank"
    it_behaves_like "an invalid attribute", :email, nil, "can't be blank"

    it_behaves_like "an invalid attribute", :email, "not_an_email", "is invalid"
    it_behaves_like "an invalid attribute", :email, "not_an_email@", "is invalid"
    it_behaves_like "an invalid attribute", :email, "not_an_email.com", "is invalid"
    it_behaves_like "an invalid attribute", :email, "not_an_email@.com", "is invalid"
  end

  describe "password encryption" do
    it "does not store the password in plaintext" do
      user = build(:user, password:, password_confirmation: password)
      user.save!
      expect(user.password_digest).not_to eq password
    end
  end

  describe "password validation" do
    context "when password and password confirmation match" do
      let(:password) { "Password123!@#" }
      let(:user) { described_class.new(attributes_for(:user, password:, password_confirmation: password)) }

      before { user.valid? }

      it { expect(user).to be_valid }
    end

    context "when password and password confirmation do not match" do
      let(:password) { "Password123!@#" }
      let(:user) { described_class.new(attributes_for(:user, password:, password_confirmation: "not_the_same")) }

      before { user.valid? }

      it { expect(user).not_to be_valid }
      it { expect(user.errors[:password_confirmation]).to include("doesn't match Password") }
    end

    context "when passwords lack complexity" do
      it_behaves_like "password complexity validation", "lower123!@#"
      it_behaves_like "password complexity validation", "UPPER123!@#"
      it_behaves_like "password complexity validation", "UpperLower!@#"
      it_behaves_like "password complexity validation", "UpperLower123"
    end
  end
end
