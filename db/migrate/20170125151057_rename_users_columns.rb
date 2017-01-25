class RenameUsersColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :firstName, :first_name
    rename_column :users, :secondName, :last_name
  end

end
