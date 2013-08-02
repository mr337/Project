#NOTE: EC2 instances bootstrap this file on a S3 bucket, only here for version control

#Package stuff
package{'nginx':
    ensure => present,
}

package{'python-pip':
    ensure => present,
}

#create symlink to fix pip provider issue in python2.6
file{'/usr/bin/pip':
    ensure => 'link',
    target => '/usr/bin/pip-python'
}

package{'devpi':
    ensure => present,
    provider => pip
}


#Prep and install devpi server
file{'/devpi':
    ensure => 'directory'
}

exec{'deployDevpi':
    command => 'devpi-server --gendeploy=/devpi',
    path => '/'
}

#copy devpi nginx conf
file{'/etc/nginx/conf.d/server.conf':
    owner => root,
    group => root,
    mode => 644,
    source => '/devpi/etc/nginx-devpi.conf'
}

service{'ngingx':
    ensure => 'running',
    enable => 'true'
}
