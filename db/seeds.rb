# clean db
Table.destroy_all
Booking.destroy_all
Restaurant.destroy_all
User.destroy_all

#seed db
Restaurant.create!(working_from: "10:00", working_to: "23:00")
User.create!(first_name: "test", last_name: "user")
[1,2,3,4,5].map do |number|
  Table.create(number: number, restaurant: Restaurant.last)
end
