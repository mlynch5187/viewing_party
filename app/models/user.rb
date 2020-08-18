class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :profile, presence: true
  validates :openid, presence: true
  validates :google_token, uniqueness: true, presence: true
  validates :google_refresh_token, uniqueness: true, presence: true

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.email = auth.info.email
    end
  end
end