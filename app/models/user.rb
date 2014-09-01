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

  has_many :user_friendships
  has_many :friends, -> { where(user_friendships: { state: "accepted"}) }, through: :user_friendships

  has_many :pending_user_friendships, -> { where user_friendships: { state: 'pending'} }, 
                                        class_name: 'UserFriendship', foreign_key: :user_id

  has_many :pending_friends, 
              -> { where user_friendships: { state: "pending" } }, 
                 through: :user_friendships,
                 source: :friend                                 

  def full_name
  	first_name + ' ' + last_name
  end

  def to_param
    profile_name
  end
end
