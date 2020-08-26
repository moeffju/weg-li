class CreateCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :charges do |t|
      t.string :tbnr
      t.string :description
      t.string :description_long
      t.string :bkat_short
      t.string :bkat_long
      t.string :points_type
      t.integer :points
      t.decimal :fine
      t.string :table_group
      t.string :table_long
      t.integer :table_short
      t.date :from
      t.date :to
      t.string :ban
      t.integer :asterisk
      t.integer :category
      t.string :overload_from
      t.string :overload_to

      t.timestamps
    end
  end
end
