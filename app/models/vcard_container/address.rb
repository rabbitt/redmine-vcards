class VcardContainer::Address < VcardContainer
  def parameters
    [ :street, :city, :state, :postalcode ]
  end
  alias :required_parameters :parameters
  
  def generate vcard, user
    street  = user.vcard_parameter(:street, self.location)
    city    = user.vcard_parameter(:city, self.location)
    state   = user.vcard_parameter(:state, self.location)
    zipcode = user.vcard_parameter(:postalcode, self.location)

    unless street.blank? or city.blank? or state.blank?
      vcard.add_addr do |address|
        address.location = self.location
        address.delivery = [ 'postal', 'dom' ]
        address.street = street 
        address.locality = city 
        address.region = state 
        address.postalcode = zipcode unless zipcode.blank?
        address.preferred = true
      end
    end
  end
end

