class User < ApplicationRecord

  validates :firstName, presence: true
  validates :secondName , presence: true, uniqueness: true
end
