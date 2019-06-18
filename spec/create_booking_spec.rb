require "rails_helper"
require 'pry'

RSpec.describe CreateBooking do

  let(:restaurant) { Restaurant.create(working_from: "10:00", working_to: "23:00") }
  let(:user) { User.create }

  before do
    Timecop.freeze(DateTime.now)
  end

  after do
    Timecop.return
  end

  it "creates booking" do
    table = Table.create(number: 1, restaurant_id: restaurant.id)

    CreateBooking.new.call(
      restaurant_id: restaurant.id,
      table_numbers:[table.number],
      user_id: user.id,
      time_from: Time.now.utc.change({ hour: 18, min: 0}),
      time_to: Time.now.utc.change({ hour: 19, min: 0})
    )

    expect(Booking.count).to eql(1)
  end

  context "When there is another intersecting booking" do
    it "doesn't creates booking" do
      table1 = Table.create(number: 1, restaurant_id: restaurant.id)
      Booking.create!(user_id: user.id, restaurant_id: restaurant.id, tables: [table1], time_from: Time.now.utc.change({ hour: 18, min: 0}), time_to: Time.now.utc.change({ hour: 21, min: 0}))
      expect do
        CreateBooking.new.call(
          restaurant_id: restaurant.id,
          table_numbers:[table1.number],
          user_id: user.id,
          time_from: Time.now.utc.change({ hour: 18, min: 0}),
          time_to: Time.now.utc.change({ hour: 20, min: 0})
        )
      end.to raise_error
    end
  end

  context "When booking hours exceed restaurant working hours" do
    it "doesn't creates booking" do
      table1 = Table.create(number: 1, restaurant_id: restaurant.id)
      expect do
        CreateBooking.new.call(
          restaurant_id: restaurant.id,
          table_numbers:[table1.number],
          user_id: user.id,
          time_from: Time.now.utc.change({ hour: 9, min: 30}),
          time_to: Time.now.utc.change({ hour: 10, min: 0})
        )
      end.to raise_error
    end
  end

  context "When booking time_from equal to time_to of other booking" do
    it "creates booking" do
      table1 = Table.create(number: 1, restaurant_id: restaurant.id)
      Booking.create!(user_id: user.id, restaurant_id: restaurant.id, tables: [table1], time_from: Time.now.utc.change({ hour: 18, min: 0}), time_to: Time.now.utc.change({ hour: 19, min: 0}))

      CreateBooking.new.call(
        restaurant_id: restaurant.id,
        table_numbers:[table1.number],
        user_id: user.id,
        time_from: Time.now.utc.change({ hour: 19, min: 00}),
        time_to: Time.now.utc.change({ hour: 19, min: 30})
      )

      expect(Booking.count).to eql(2)
    end
  end

  context "When exists intersecting booking for other table" do
    it "creates booking" do
      table1 = Table.create(number: 1, restaurant_id: restaurant.id)
      table2 = Table.create(number: 2, restaurant_id: restaurant.id)
      time_from = Time.now.utc.change({ hour: 18, min: 0})
      time_to = Time.now.utc.change({ hour: 18, min: 30})
      Booking.create!(user_id: user.id, restaurant_id: restaurant.id, tables: [table1], time_from: time_from, time_to: time_to)

      CreateBooking.new.call(
        restaurant_id: restaurant.id,
        table_numbers:[table2.number],
        user_id: user.id,
        time_from: time_from,
        time_to: time_to
      )

      expect(Booking.count).to eql(2)
    end
  end

  context "When booking ends on next day after restaurant working hours" do
    it "doesn't creates booking" do
      table1 = Table.create(number: 1, restaurant_id: restaurant.id)
      Booking.create!(user_id: user.id, restaurant_id: restaurant.id, tables: [table1], time_from: Time.now.utc.change({ hour: 18, min: 0}), time_to: 1.day.from_now.change({ hour: 2, min: 0}))
      expect do
        CreateBooking.new.call(
          restaurant_id: restaurant.id,
          table_numbers:[table1.number],
          user_id: user.id,
          time_from: 1.hours.from_now,
          time_to: 2.hours.from_now
        )
      end.to raise_error
    end
  end

end
