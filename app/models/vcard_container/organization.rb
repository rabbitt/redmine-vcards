class VcardContainer::Organization < VcardContainer
  def parameters
    [ :department, :group ]
  end
  alias :required_parameters :parameters
  
  def generate vcard, user
    dept = user.vcard_parameter(:department)
    group = user.vcard_parameter(:group)
    return if dept.blank? and group.blank?
    
    vcard.org = [ dept, group ]
  end
end

