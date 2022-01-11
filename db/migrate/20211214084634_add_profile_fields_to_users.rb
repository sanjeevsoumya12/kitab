class AddProfileFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :user_name, :string
    add_index :users, :user_name, unique: true
    add_column :users, :phn_number, :string
    add_column :users, :date_of_birth, :date
  end
end
