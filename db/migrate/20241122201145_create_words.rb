class CreateWords < ActiveRecord::Migration[8.0]
  def change
    create_table :words do |t|
      t.string :title
      t.references :week, null: false, foreign_key: true

      t.timestamps
    end
  end
end
