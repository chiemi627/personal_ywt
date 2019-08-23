class CreateMentors < ActiveRecord::Migration[5.2]
  def change
    create_table :mentors do |t|
      t.string :email
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
