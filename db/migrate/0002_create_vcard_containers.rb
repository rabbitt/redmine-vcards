class CreateVcardContainers < ActiveRecord::Migration
  def self.up
    create_table :vcard_containers do |t|
      t.column :id, :integer
      t.column :type, :string
      t.column :location, :string, :default => 'default'
      t.column :description, :text
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :vcard_containers
  end
end  
