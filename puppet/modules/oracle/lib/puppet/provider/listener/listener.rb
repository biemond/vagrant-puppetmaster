Puppet::Type.type(:listener).provide(:listener) do
  def self.instances
    []
  end

  def listener( action)
    db_sid = oratab.first[:sid]
    command = "su - oracle -c 'export ORACLE_SID=#{db_sid};export ORAENV_ASK=NO;. oraenv;lsnrctl #{action}'"
    execute command, :failonfail => false, :override_locale => false, :squelch => true
  end

  def start
    listener :start
  end

  def stop
    listener :stop
  end

  def status
    listener :status
    if $CHILD_STATUS.exitstatus == 0
      return :running
    else
      return :stopped
    end
  end
end
