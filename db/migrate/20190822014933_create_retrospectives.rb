class CreateRetrospectives < ActiveRecord::Migration[5.2]
  def change
    create_table :retrospectives do |t|
      t.integer :member_id
      t.date :date
      t.string :objective
      t.string :y
      t.string :w
      t.string :t

      t.timestamps
    end
  end
end
