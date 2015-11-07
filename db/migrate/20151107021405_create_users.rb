class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps
      t.string :address
      t.string :ip, null: false
      t.decimal :lat
      t.decimal :lng
    end
  end
end
