require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'ora_utils/oracle_access'
require 'ora_utils/title_parser'

module Puppet
  newtype(:init_param) do
    include EasyType
    include ::OraUtils::OracleAccess
    extend ::OraUtils::TitleParser

    desc "This resource allows you to manage Oracle parameters."

    set_command(:sql)

    ensurable

    def apply(command_builder)
      statement = "alter system set \"#{parameter_name}\" = #{self[:value]} scope=#{scope} sid='#{instance}'"
      command_builder.add(statement, :sid => sid)
    end


    on_create do | command_builder |
      apply(command_builder)
    end

    on_modify do | command_builder |
      apply(command_builder)
    end

    on_destroy do | command_builder |
      statement = "alter system reset \"#{parameter_name}\" scope=#{scope} sid='#{instance}'"
      command_builder.add(statement, :sid => sid)
    end

    to_get_raw_resources do
      specfied_parameters
    end


    def self.parse_instance_title
      @@instance_parser ||= lambda { |instance_name| instance_name.nil? ? '*' : instance_name[0..-2]}
    end


    map_title_to_sid([:instance, parse_instance_title], :parameter_name) { /^((.*?\/)?(.*?\/)?(.*)?)$/}

    parameter :name
    parameter :parameter_name
    parameter :sid
    parameter :instance

    property  :value
    parameter :scope


    private

    def self.specfied_parameters
      all_parameters.select{|p| p['DISPLAY_VALUE'] != ''}
    end

    def self.all_parameters
      sql_on_all_sids %q{select instance_name, name, display_value from gv$parameter, v$instance where gv$parameter.inst_id = v$instance.instance_number } 
    end

  end
end
