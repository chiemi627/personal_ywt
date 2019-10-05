class ChangeDataCategoryToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :category, 'integer USING CAST(category AS integer)'
    change_column :mentors, :category, 'integer USING CAST(category AS integer)'
  end
end
