class Api::V1::BookingsController < ApplicationController

  before_action :sanitize_params, only: [:create]

  def create
    CreateBooking.new.call(
      restaurant_id: bookings_params[:restaurant_id],
      table_numbers: bookings_params[:table_numbers],
      user_id: bookings_params[:user_id],
      time_from: bookings_params[:time_from],
      time_to: bookings_params[:time_to]
    )
    head 201
  rescue RestaurantBookingErrors::BookingCreationFailed
    head 422
  end

  private

  def bookings_params
    params.permit(:restaurant_id, :user_id, :time_from, :time_to, table_numbers: [])
  end

  def sanitize_params
    params[:restaurant_id] = params[:restaurant_id].to_i
    params[:table_numbers] = params[:table_numbers].map(&:to_i)
    params[:time_from] = DateTime.parse(params[:time_from])
    params[:time_to] = DateTime.parse(params[:time_to])
    params[:user_id] = params[:user_id].to_i
  end

end
