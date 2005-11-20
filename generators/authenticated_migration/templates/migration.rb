class <%= class_name %> < ActiveRecord::Migration
  # modify the table name for now, until I can figure out how to set it w/ the generator
  def self.up
    create_table "users", :force => true do |t|
      t.column "login",            :string, :limit => 40
      t.column "email",            :string, :limit => 100
      t.column "crypted_password", :string, :limit => 40
      t.column "salt",             :string, :limit => 40
      t.column "activation_code",  :string, :limit => 40
      t.column "active",           :boolean, :default => false # only if you want user activation
      t.column "created_at",       :datetime
      t.column "updated_at",       :datetime
    end
  end

  def self.down
    drop_table "users"
  end
end
