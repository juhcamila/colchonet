class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  has_many :reviews, dependent:  :destroy
  has_many :rooms, dependent: :destroy

  validates_presence_of :full_name, :email, :location
  validates_length_of :bio, minimum: 30, allow_blank: false
  validates_uniqueness_of :email, with: EMAIL_REGEXP

  has_secure_password

  before_create do |user|
    user.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
    return if confirmed?
    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end
  def confirmed?
    confirmed_at.present?
  end

  scope :confirmed, -> { where.not(confirmed_at: nil)}

  def self.authenticate(email, password)
    user = confirmed.find_by(email: email)

    if user.present?
      user.authenticate(password)
    end
  end

end
