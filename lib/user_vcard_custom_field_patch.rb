require 'custom_field'

module UserVcardsPlugin
  module CustomFieldPatch
    def self.included(base)
      base.class_eval do
        unloadable
        has_one :vcard_field
      end
      super
    end
  end
end
