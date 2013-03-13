class AddRolesToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :role, :hash, default: :author
  end
end
