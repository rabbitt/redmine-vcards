class VcardField < ActiveRecord::Base
  unloadable
  
  belongs_to :custom_field
  has_and_belongs_to_many :vcard_containers

  validates_presence_of :param, :custom_field_id
  validates_uniqueness_of :custom_field_id, :scope => :param
  
  def self.find_or_create(fields)
    field = VcardField.find_by_custom_field_id_and_param(fields[:custom_field_id], fields[:param])
    field ||= VcardField.create(fields)
    field.save!
    field
  end  
end
