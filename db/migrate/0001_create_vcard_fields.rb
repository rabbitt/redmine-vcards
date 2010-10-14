class CreateVcardFields < ActiveRecord::Migration
  def self.up
    create_table :vcard_fields do |t|
      t.column :id, :integer
      t.column :custom_field_id, :integer
      t.column :param, :string
      t.column :description, :text
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :vcard_fields
  end
end  
