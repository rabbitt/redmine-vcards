require 'vpim/dirinfo'
require 'vpim/vcard'

class Vpim::Vcard::Maker
  APPLE_PROTOCOL_MAPS = {
    :aim    => 'AIM',
    :jabber => 'JABBER',
    :msn    => 'MSN',
    :yim    => 'YAHOO',
    :icq    => 'ICQ',
    :skype  => 'SKYPE'
  }

  def add_x_im(proto, account) # :yield: xaim
    params = {}
       
    if block_given?
      x = Struct.new( :location, :preferred ).new
      yield x
      x[:preferred] = 'PREF' if x[:preferred]
      types = x.to_a.flatten.compact.map { |s| s.downcase }.uniq
      params['TYPE'] = types if types.first
    end

    @card << Vpim::DirectoryInfo::Field.create( "X-#{APPLE_PROTOCOL_MAPS[(proto.downcase.to_sym rescue proto)] || 'IM'}", account, params) 
    self
  end  
end


class VcardContainer::Im < VcardContainer
  STANDARD_PROTOCOL_MAPS = {
    :aim    => 'aim',
    :jabber => 'xmpp',
    :gchat  => 'xmpp',
    :yim    => 'ymsgr',
    :msn    => 'msn',
    :icq    => 'icq',
    :skype  => 'skype',
    :im     => 'im'
  }
  
  def parameters
    [ :protocol, :account ]
  end
  alias :required_parameters :parameters

  def generate vcard, user
    protocol = user.vcard_parameter(:im_protocol, location)
    protocol = (protocol.blank? ? 'im' : protocol).downcase.to_sym
    username = user.vcard_parameter(:im_account, location)
  
    return if protocol.blank? or username.blank?

    vcard.add_impp("#{(STANDARD_PROTOCOL_MAPS[protocol].downcase rescue '')}:#{username}") do |e|
      e.location = location
    end unless username.blank?
    
    vcard.add_x_im(protocol, username) do |xim|
      xim.location = location
    end
  end
end

