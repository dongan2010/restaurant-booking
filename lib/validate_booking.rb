class ValidateBooking

  def call(booking)
    return false unless validate_tables_presence(booking)
    return false unless validate_booking_duration(booking)
    return false unless validate_with_restaurant_working_hours(booking)
    return false unless validate_with_other_bookings(booking)
    return true
  end

  private

  def validate_tables_presence(booking)
    return booking.tables.present?
  end

  def validate_with_restaurant_working_hours(booking)
    restaurant = booking.restaurant

    working_from = DateTime.parse(booking.time_from.strftime("%Y-%m-%dT#{restaurant.working_from}%z"))
    working_to = DateTime.parse(booking.time_to.strftime("%Y-%m-%dT#{restaurant.working_to}%z"))

    return false if booking.time_from < working_from
    return false if booking.time_to > working_to
    return true
  end

  def validate_with_other_bookings(booking)
    restaurant = booking.restaurant
    intersect_bookings = Booking.joins(:tables)
                                .where("time_from >= :time_from AND time_from < :time_to OR (time_to > :time_from AND time_to <= :time_to)", time_from: booking.time_from, time_to: booking.time_to)
                                .where("tables.id IN (?)", booking.table_ids)

    return intersect_bookings.empty?
  end

  def validate_booking_duration(booking)
    return (booking.time_to.change(sec: 0) - booking.time_from.change(sec: 0)) % 1800 == 0
  end

end
