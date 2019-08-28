class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :member_id, :integer
    add_column :users, :publish, :string
  end
end
