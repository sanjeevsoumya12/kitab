class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.decimal :price, null: false, default: 0
      t.date :publishing_date, null: false

      t.timestamps
    end
  end
end
