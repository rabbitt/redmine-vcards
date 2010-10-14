class VcardContainer < ActiveRecord::Base
  unloadable
  
  has_and_belongs_to_many :vcard_fields

  validates_presence_of :type
  validates_uniqueness_of :type, :scope => :location
  
  def self.find_or_create(fields)
    container = VcardContainer.find_by_type_and_location(fields[:type], fields[:location])
    container ||= VcardContainer.const_get(fields[:type].to_s).create(fields.reject{|k| k == :type})
    container.save!
    container
  end
  
  def generate vcard, user
  end
end