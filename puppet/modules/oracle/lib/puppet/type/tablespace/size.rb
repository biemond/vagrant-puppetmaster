newproperty(:size) do
  include EasyType
  include EasyType::Mungers::Size

  desc "The size of the tablespace"
  defaultto "500M"

  on_apply do
    if provider.property_hash[:datafile]
      "size #{resource[:size]}"
    else
      "datafile size #{resource[:size]}"
    end
  end

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('BYTES').to_i
  end

end
