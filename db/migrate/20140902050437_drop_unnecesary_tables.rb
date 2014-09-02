class DropUnnecesaryTables < ActiveRecord::Migration
  def change
  	drop_table :relationships
  	drop_table :user_friendships
  end
end
