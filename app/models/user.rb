class User < ApplicationRecord

  validates :firstName, :secondName, presence: true
end
