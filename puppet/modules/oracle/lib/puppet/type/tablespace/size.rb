newproperty(:size) do
  include EasyType
  include EasyType::Mungers::Size

  desc "The size of the tablespace"
  defaultto "500M"

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('BYTES').to_i
  end

  on_modify do | command_builder|
    "resize #{resource[:size]}"
  end

  on_create do | command_builder|
    if resource[:datafile].nil?
      "datafile size #{resource[:size]}"
    else
      "datafile '#{resource[:datafile]}' size #{resource[:size]}"
    end
  end

end
