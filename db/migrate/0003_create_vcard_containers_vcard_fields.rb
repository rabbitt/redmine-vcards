class CreateVcardContainersVcardFields < ActiveRecord::Migration
  def self.up
    create_table :vcard_containers_vcard_fields, :id => false do |t|
      t.column :vcard_container_id, :integer
      t.column :vcard_field_id, :integer
    end
  end

  def self.down
    drop_table :vcard_containers_vcard_fields
  end
end  