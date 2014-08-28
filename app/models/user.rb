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

  def full_name
  	first_name + ' ' + last_name
  end

  def to_param
    profile_name
  end
end
