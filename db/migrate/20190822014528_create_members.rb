class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :account
      t.string :name
      t.integer :team_id

      t.timestamps
    end
  end
end
