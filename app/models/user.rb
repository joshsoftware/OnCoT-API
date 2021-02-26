class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  belongs_to :organization
  belongs_to :role
  has_many :problems
  has_many :drives
  has_many :test_cases
end

