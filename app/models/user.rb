class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  field :authentication_token, :type => String

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token, :type => String
  field :confirmed_at, :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email, :type => String

  field :firstname, type: String
  field :lastname, type: String
  field :username, type: String
  field :admin, type: Boolean, default: false
  field :url, type: String


  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  has_many :comments
  has_many :organizer_comments
  has_many :events, inverse_of: :user
  has_many :events, inverse_of: :owner
  has_many :notifications
  has_many :auth_providers
  has_and_belongs_to_many :organizes, class_name: "Event", inverse_of: :organizers

  index({ authentication_token: 1 }, { unique: true, name: "authentication_token_index" })
  index({ confirmation_token: 1}, {unique: true, name: "confirmation_token_index"})
  index({ email: 1 }, { name: "email_index" })

  # validates :email, :presence => true

  def name
    [firstname, lastname].compact.join(" ")
  end

  def gravatarID
    if self.email
      Digest::MD5::hexdigest(self.email).downcase
    else
      nil
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def valid_authentication_token?(token)
    authentication_token === token
  end

  def confirmed
    confirmed_at.blank? ? false : true
  end
  
  def email_required?
    if self.auth_providers? || self.email?
      false
    else
      true
    end
  end
 
 
  private
 
  def generate_authentication_token
    loop do
      token = Devise.friendly_token[0,32]
      break token unless User.where(authentication_token: token).first
    end
  end

end