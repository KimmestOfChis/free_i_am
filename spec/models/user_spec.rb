require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }  
    
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'email validation' do
    it 'rejects invalid email addresses' do
      user = build(:user, email: 'invalid-email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'accepts valid email addresses' do
      user = build(:user, email: 'valid@example.com')
      expect(user).to be_valid
    end
  end

  describe 'password encryption' do
    it 'does not store the password in plaintext' do
      user = create(:user, password: 'password')  # Creates a user instance and saves it to the database
      expect(user.password_digest).not_to eq 'password'
    end
  end
end

