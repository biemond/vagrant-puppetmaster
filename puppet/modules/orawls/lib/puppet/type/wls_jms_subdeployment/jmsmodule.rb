newparam(:jmsmodule) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The JMS module name"

end
