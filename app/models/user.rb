class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :profile_name, presence: true, 
                           uniqueness: true,
                           format: {
                             with: /\A[a-z0-9_-]{6,16}+\Z/,
                             message: "Must be formatted correctly."
                           }

  validates :country, presence: true

  validates :about_me, presence: true

  validates :hobbies, presence: true

  validates :gender, presence: true

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  def full_name
  	first_name + ' ' + last_name
  end

  def to_param
    profile_name
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
end
