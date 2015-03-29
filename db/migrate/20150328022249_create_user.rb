class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :email,                :default => '' , :unique => true
      t.string   :name,                 :default => ''
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :users, :email,                :unique => true
  end
end
