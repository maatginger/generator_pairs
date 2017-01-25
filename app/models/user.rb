class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name , presence: true, uniqueness: { scope: :first_name}

  def self.random_pairs!
    users = all.to_a.shuffle
    raise ArgumentError.new('Oops error..') unless users.size % 2 == 0
    return users
  end
end
