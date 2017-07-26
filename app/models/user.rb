class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_AGENT_ID_REGEX = /(^(0|[1-9][0-9]*)$|^((0|[1-9][0-9]*)\.)+(0|[1-9][0-9]*)$)/
  VALID_NAME_REGEX = /\A\w+$\z/

  validates :first_name,
    presence: true,
    format: { with: VALID_NAME_REGEX }
  validates :last_name,
    presence: true,
    format: { with: VALID_NAME_REGEX }
  validates :email,
    presence: true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password,
    presence: true,
    length: { minimum: 7 }
  validates :agent_id,
    presence: true,
    length: { minimum: 1 },
    format: { with: VALID_AGENT_ID_REGEX },
    uniqueness: true

  has_many :orders,
    primary_key: :agent_id,
    foreign_key: :agent_id

  attr_accessor :password_reset_token, :remember_me_token, :activation_token

  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def create_password_reset_digest
    self.password_reset_token = User.new_token
    update_attribute(:password_reset_digest, User.digest(password_reset_token))
    update_attribute(:password_reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def remember
    self.remember_me_token = User.new_token
    update_attribute(:remember_me_token, User.digest(remember_me_token))
  end

  def verify
    update_attribute(:verified_agent, true) && update_attribute(:verified_at, Time.zone.now)
  end

  def forget
    self.remember_me_token = nil
    update_attribute(:remember_me_token, nil)
  end

  def authenticate_token(token_type, token_value)
    digest = send("#{token_type.to_s.remove("_token")}_digest")
    return nil unless digest
    BCrypt::Password.new(digest).is_password?(token_value)
  end

  def send_activation_email
    self.activation_token = User.new_token
    update_attribute(:activation_digest, User.digest(activation_token))
    UserMailer.account_activation(self).deliver_now
  end

  private
end
