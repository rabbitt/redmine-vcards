class VcardsController < ApplicationController
  unloadable
  
#  before_filter :authorize, :only => :download
  before_filter :only => :download
  
  def download
    data = User.find_all_by_status(1).collect { |u| u.vcard.to_s }.to_s 
    send_data data, :filename => 'vcards.vcf', :type => 'text/x-vcard', :disposition => 'attachment'
  end
end
