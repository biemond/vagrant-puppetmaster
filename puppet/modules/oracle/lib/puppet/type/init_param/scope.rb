newparam(:scope) do
  include EasyType

  desc "The scope of the change."

  newvalues(:spfile, :memory, :both)

  defaultto 'spfile'

end
