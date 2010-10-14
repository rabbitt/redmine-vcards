class VcardContainer::Phone < VcardContainer
  def parameters
    [ :phone ]
  end
  alias :required_parameters :parameters
  
  def generate vcard, user
    return if (phone = user.vcard_parameter(:phone, location)).blank?
    
    vcard.add_tel(user.vcard_parameter(:phone, location)) do |e|
      e.location = location
      e.preferred = true if location.to_s.downcase == 'work'
    end
  end
end

