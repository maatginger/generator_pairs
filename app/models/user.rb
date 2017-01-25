class User < ApplicationRecord
  validates :firstName, presence: true
  validates :secondName , presence: true, uniqueness: { scope: :firstName}

  def self.random_pairs!
    users = all.to_a.shuffle
    raise ArgumentError.new('Oops error..') unless users.size % 2 == 0
    return users
  end
end
