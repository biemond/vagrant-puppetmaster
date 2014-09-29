newparam(:parameter_name) do
  include EasyType
  include EasyType::Validators::Name
  desc "The parameter name"

  isnamevar

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('NAME')
  end

end

