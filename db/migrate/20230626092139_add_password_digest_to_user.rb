class AddPasswordDigestToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :pasword_digest, :string
    remove_column :users, :password
  end
end
