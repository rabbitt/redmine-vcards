class SetupUserCustomFields < ActiveRecord::Migration
  
  VALID_PARAMETERS = [ :title, :department, :group, :street, :city, :state, :postalcode, :email, :phone, :im_protocol, :im_account ]
  
  CUSTOM_USER_DATA = [
    {:name=>"Alternate E-Mail",:field_format=>"string",:regexp=>"^[a-z0-9_.-]+@[\\w\\d.]+$"},
    {
      :name=>"Home Phone",
      :field_format=>"string",
      :regexp=>"^\\d{3,3}[.-]{0,1}\\d{3,3}[.-]{0,1}\\d{4,4}$",
      :max_length=>12,
      :min_length=>10,
      :is_required=>true
    },
    {
      :name=>"Work Phone",
      :field_format=>"string",
      :regexp=>"^\\d{3,3}[.-]{0,1}\\d{3,3}[.-]{0,1}\\d{4,4}$",
      :max_length=>12,
      :min_length=>10,
      :is_required=>true
    },
    {
      :name=>"Mobile Phone",
      :field_format=>"string",
      :regexp=>"^(\\+{0,1}\\d\\s*){0,1}\\d{3,3}[.-]{0,1}\\d{3,3}[.-]{0,1}\\d{4,4}$",
      :max_length=>12,
      :min_length=>10,
      :is_required=>true
    },
    {:name=>"Title",:field_format=>"string",:is_required=>true},
    {:name=>"Department",:field_format=>"string",:is_required=>true},
    {:name=>"Group", :field_format=>"string"},
    {:name=>"Street",:field_format=>"string",:is_required=>true},
    {:name=>"City",:field_format=>"string",:is_required=>true},
    {:name=>"State",:field_format=>"string",:regexp=>"^[a-zA-Z]{2}$",:max_length=>2,:min_length=>2,:is_required=>true},
    {
      :name=>"Postal Code",
      :field_format=>"string",
      :regexp=>"^\\d{5}(-{0,1}\\d{4}){0,1}$",
      :max_length=>10,
      :min_length=>5,
      :is_required=>true
    },
    {
      :name=>"IM Type",
      :field_format=>"list",
      :possible_values=>["AIM", "YIM", "MSN", "ICQ", "Jabber", "Skype"],
      :default_value=>"AIM",
      :is_required=>true
    },
    {:name=>"IM Username",:field_format=>"string",:is_required=>true}
  ]
  
  CONTAINER_MAP = {
    'Title' => :Title,
    'Department' => :Organization,
    'Group' => :Organization,
    'Street' => :Address,
    'City'   => :Address,
    'State'  => :Address,
    'Postal Code'    => :Address,
    'Home Phone' => :Phone,
    'Work Phone' => :Phone,
    'Mobile Phone' => :Phone,
    'Alternate E-Mail' => :Email,
    'IM Type' => :IM,
    'IM Username' => :IM,
  }
  
  CONTAINERS = {
    :Title => { :default => [ "Title" ] },
    :Organization => { :default => [ "Department", "Group" ] },
    :Address => { :home => [ "Street", "City", "State", "Postal Code" ] },
    :Phone => {
      :home => [ "Home Phone" ],
      :work => [ "Work Phone" ],
      :mobile => [ "Mobile Phone" ]
    },
    :Email => { :home => [ "Alternate E-Mail" ] },
    :IM => { :home => [ "IM Type", "IM Username" ] }
  }
  
  FIELDS = {
    'Title' => { :param => :title},
    'Department' => { :param => :department},
    'Group' => { :param => :group},
    'Street' => { :param => :street, :location => :home },
    'City'   => { :param => :city, :location => :home },
    'State'  => { :param => :state, :location => :home },
    'Postal Code' => { :param => :postalcode, :location => :home },
    'Home Phone' => { :param => :phone, :location => :home },
    'Work Phone' => { :param => :phone, :location => :work },
    'Mobile Phone' => { :param => :phone, :location => :mobile },
    'Alternate E-Mail' => { :param => :email, :location => :home },
    'IM Type' => { :param => :im_protocol, :location => :home },
    'IM Username' => { :param => :im_account, :location => :home },
  }

  def self.up

    CUSTOM_USER_DATA.each do |data|
      field_name = data[:name]
      field = UserCustomField.find_by_name(data[:name]) || UserCustomField.create(data.merge(:searchable => true))
      puts "Field: #{field_name}"; pp field
      
      field_data = FIELDS[field_name].merge(:custom_field_id => field[:id])
      vfield = VcardField.find_or_create(Hash[field_data.reject{|k,v| k == :location}.collect{|k,v| [ k, v.to_s ]}])
      puts "vCard Field: "; pp vfield      

      container_type     = CONTAINER_MAP[field_name].to_s.capitalize
      container_location = field_data[:location].to_s
    
      vcontainer = VcardContainer.find_or_create({ :type => container_type, :location => container_location })
      puts "vCard Container: "; pp vcontainer
      
      vcontainer.vcard_fields << vfield
    end
  end
  
  def self.down
  end
end