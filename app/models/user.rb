class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 7 }
  attr_accessor :password_reset_token, :remember_me_token
  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def create_password_reset_digest
    self.password_reset_token = User.new_token
    update_attribute(:password_reset_digest,
      User.digest(password_reset_token))
    update_attribute(:password_reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def remember
    self.remember_me_token = User.new_token
    update_attribute(:remember_me_token, User.digest(remember_me_token))
  end

  def forget
    self.remember_me_token = nil
    update_attribute(:remember_me_token, nil)
  end

  def authenticate_token?(token_type, token_value)
    digest = send("#{token_type.to_s.remove("_token")}_digest")
    return nil unless digest
    BCrypt::Password.new(digest).is_password?(token_value)
  end
end
