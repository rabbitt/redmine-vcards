class VcardContainer::Email < VcardContainer
  def parameters
    [ :email ]
  end
    alias :required_parameters :parameters

  def generate vcard, user
    unless (email = user.vcard_parameter(:email, location)).blank?
      vcard.add_email(email) do |e|
        e.location = location
      end
    end
  end
end

