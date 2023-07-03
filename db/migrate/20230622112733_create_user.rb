class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email ,unique: true
      t.string :password
      t.string :name
      t.timestamps
    end
  end
end
