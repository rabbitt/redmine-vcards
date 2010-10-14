class VcardContainer::Name < VcardContainer
  def parameters
    [ :first, :middle, :last ]
  end
  def required_parameters
    [ :first, :last ]
  end

  def generate vcard, user
  end
end

