require 'user_vcard'
require 'principal'
require 'user'

module UserVcardsPlugin
  module UserPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
   
      # Same as typing in the class
      base.class_eval do
        unloadable # Send unloadable so it can be unloaded in development
        attr_reader :vcard_parameters
      end
      
      super
    end
    
    module InstanceMethods
      def vcard
        UserVcard.create self
      end
  
      def after_initialize
        @vcard_parameters = {}
        
        VcardContainer.all.each do |container|
          location = (container.location.blank? ? 'default' : container.location).to_sym
          container.vcard_fields.each do |field|
            param_name = field.param.to_sym
            (@vcard_parameters[param_name]||={})[location] = self.custom_values.select { |cv| field.custom_field == cv.custom_field }.first
          end
        end
      end
      
      def vcard_parameter name, location = :default
        name = name.to_s.to_sym
      
        return '' unless @vcard_parameters.include? name
        
        data = if @vcard_parameters[name].size == 1
          @vcard_parameters[name].values.first
        elsif @vcard_parameters[name].size > 1
          @vcard_parameters[name][location.to_s.to_sym]
        else
          CustomValue.new(:value => '')
        end

        (data.value rescue '') || ''
      end
    end  
  end
end
