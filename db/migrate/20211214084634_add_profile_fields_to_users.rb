class AddProfileFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :phn_number, :bigint
    add_column :users, :date_of_birth, :text
  end
end
