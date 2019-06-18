class CreateBooking
  def call(restaurant_id:, table_numbers:, user_id:, time_from:, time_to:)
    tables = Table.where(number: table_numbers, restaurant_id: restaurant_id) 
    booking = Booking.new(user_id: user_id, tables: tables, time_from: time_from, time_to: time_to, restaurant_id: restaurant_id)
    booking_valid = ValidateBooking.new.call(booking)

    if booking_valid
      booking.save!
    else
      raise RestaurantBookingErrors::BookingCreationFailed
    end
  end
end
