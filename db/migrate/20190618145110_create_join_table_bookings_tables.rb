class CreateJoinTableBookingsTables < ActiveRecord::Migration[5.2]
  def change
    create_join_table :bookings, :tables do |t|
      t.references :booking, foreign_key: true
      t.references :table, foreign_key: true
    end
  end
end
