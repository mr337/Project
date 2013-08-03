#NOTE: EC2 instances bootstrap this file on a S3 bucket, only here for version control

#Package stuff
package{'nginx':
    ensure => present,
    before => File['/etc/nginx/conf.d/server.conf']
}

package{'python-pip':
    ensure => present,
}

#create symlink to fix pip provider issue in python2.6
file{'/usr/bin/pip':
    ensure  => 'link',
    target  => '/usr/bin/pip-python',
    require => Package['python-pip']
}

package{'devpi':
    ensure   => present,
    provider => pip,
    require  => File['/usr/bin/pip']
}


#Prep and install devpi server
file{'/devpi':
    ensure  => 'directory',
    require => Package['devpi']
}

exec{'deployDevpi':
    command => 'devpi-server --gendeploy=/devpi',
    path    => '/usr/bin/',
    require => File['/devpi'] 
}

#copy devpi nginx conf
file{'/etc/nginx/conf.d/server.conf':
    owner => root,
    group => root,
    mode => 644,
    source => '/devpi/etc/nginx-devpi.conf',
    require => Exec['deployDevpi']
}

#restart service when site added to conf.d
service{'nginx':
    ensure    => 'running',
    enable    => 'true',
    subscribe => File['/etc/nginx/conf.d/server.conf']

}

#start devpi server itself
exec{'runDevpi':
    command   => 'devpi-ctl start all',
    path      => '/devpi/bin/',
    subscribe => Exec['deployDevpi']
}

#TODO
#Create cron to kick the puppet
