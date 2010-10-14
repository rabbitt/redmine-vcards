class VcardContainer::Title < VcardContainer
  def parameters
    [ :title ]
  end
  alias :required_parameters :parameters

  def generate vcard, user
    vcard.title = user.vcard_parameter(:title)
  end
end

