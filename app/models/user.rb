class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :photos
  has_one :pairuserofuser, class_name: "User",
                              foreign_key: "pairuser_id"
  belongs_to :pairuser , class_name: "User" , foreign_key: "pairuser_id"

  #has_many :pairphotos, through: :pairuserofuser, source: 'user'  うまく動かない

end
