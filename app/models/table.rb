class Table < ApplicationRecord

  belongs_to :restaurant
  has_and_belongs_to_many :bookings

end
