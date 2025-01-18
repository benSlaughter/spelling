class CreateWeeks < ActiveRecord::Migration[8.0]
  def change
    create_table :weeks do |t|
      t.text :note
      t.date :date, null: false

      t.timestamps
    end
  end
end
