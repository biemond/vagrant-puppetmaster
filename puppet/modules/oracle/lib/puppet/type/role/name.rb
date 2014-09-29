newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  desc "The role name "

  isnamevar

  to_translate_to_resource do | raw_resource|
    sid = raw_resource.column_data('SID')
    role_name = raw_resource.column_data('ROLE').upcase 
    "#{sid}/#{role_name}"
	end

end
