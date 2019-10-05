class ChangeDataPublishToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :publish, 'integer USING CAST(publish AS integer)'
  end
end
