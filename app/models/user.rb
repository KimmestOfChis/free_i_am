# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }
  validate :password_complexity

  def password_complexity
    return if password&.match?(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[[:^alnum:]])/x)

    errors.add :password,
               "Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end
end
