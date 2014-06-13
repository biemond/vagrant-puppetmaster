mounts
======

The mounts module will help manage mount points on linux systems.

This module depends on the [AlexCline-dirtree](http://forge.puppetlabs.com/AlexCline/dirtree) and [AlexCline-fstab](http://forge.puppetlabs.com/AlexCline/fstab) modules.  Installing with
`puppet module install` will install the required dependencies.

It also depends on [puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib/tree/4.1.0) 4.x 
or higher, because of the use of us of the following functions:

`concat()` in [AlexCline-fstab](http://forge.puppetlabs.com/AlexCline/fstab) and `ensure_resource()` in this Module (in puppetlabs-stdlib 3.x `ensure_resource()` can only be used with a string not with an array.


*Note: If using ensure=>absent, the destination directory will not be
automatically removed.  A notice will be displayed on the client about
removing the directory manually.

Examples
--------

     mounts { 'Mount point for NFS data':
       ensure => present,
       source => 'host.example.com:/data',
       dest   => '/opt/data',
       type   => 'nfs',
       opts   => 'nofail,defaults,noatime',
     }


Support
-------

Please file tickets and issues using [GitHub Issues](https://github.com/AlexCline/mounts/issues)


License
-------
   Copyright 2013 Alex Cline <alex.cline@gmail.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
