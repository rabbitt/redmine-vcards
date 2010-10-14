require 'redcloth3'
require 'redmine'
begin
  require 'config/initializers/session_store.rb'
rescue LoadError
end

Dir::foreach(File.join(File.dirname(__FILE__), 'lib')) do |file|
  next unless /\.rb$/ =~ file
  require file
end

require 'dispatcher'

Dispatcher.to_prepare do
  require 'user_vcard_user_patch'
  require 'user_vcard_custom_field_patch'

  CustomField.send(:include, UserVcardsPlugin::CustomFieldPatch)
  User.send(:include, UserVcardsPlugin::UserPatch)
end

Redmine::Plugin.register :redmine_vcards do
  name 'Redmine User vCard plugin'
  author 'Carl P. Corliss'
  description 'Provides the ability for users to export their data in vCard format - which requires certain custom fields have been created for users.'
  url "http://www.nytimes.com/" if respond_to? :url
  version '0.0.1'
  requires_redmine :version_or_higher => '0.9.0'

  project_module :vcards do
    # permission :add_vcards_data, {:user_vcards => [:add_vcard_container, :add_vcard_field ]}
    # permission :delete_vcards_data, {:user_vcards => [:destroy_vcard_container, :destroy_vcard_field]}
    # permission :user_vcards_settings, {:user_vcards_settings => [:show, :update]}
    permission :download_vcards_data, { :vcards => [ :download ] }
  end

  menu :account_menu, :vcards, { :controller => 'vcards', :action => 'download' },
       :caption => 'Download Contacts', :before => :logout,
       :if => Proc.new{ |project| !User.current.anonymous? }
end

# This plugin should be reloaded in development mode.
if RAILS_ENV == 'development'
  ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end