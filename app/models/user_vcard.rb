require 'vpim/vcard'

class UserVcard
  unloadable
  
  def self.create user
      Vpim::Vcard::Maker.make2 do |generator|
        generator.add_name do |name|
          name.given = user.firstname
          name.family = user.lastname
        end
        
        unless not user.respond_to? :mail
          generator.add_email(user.mail) do |email|
            email.location = 'work'
            email.preferred = true
          end
        end
        
        VcardContainer.all.map { |c| c.generate generator, user }
      end
  end
end
