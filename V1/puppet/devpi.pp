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
    ensure  => 'link',
    target  => '/usr/bin/pip-python',
}

package{'devpi':
    ensure   => present,
    provider => pip,
}


#Prep and install devpi server
exec{'deployDevpi':
    command => 'devpi-server --gendeploy=/devpi',
    creates => '/devpi',
    path    => '/usr/bin/',
}

#copy devpi nginx conf
file{'/etc/nginx/conf.d/server.conf':
    owner => root,
    group => root,
    mode => 644,
    source => '/devpi/etc/nginx-devpi.conf',
}

#restart service when site added to conf.d
service{'nginx':
    ensure    => 'running',
    enable    => 'true',
}

#start devpi server itself
exec{'runDevpi':
    command   => 'devpi-ctl start all',
    path      => '/devpi/bin/',
}

#setup cron job
file{'/tmp/devpi.pp':
    ensure => 'file'
}
cron::job{
    'kickPuppet':
        minute  => '*/5',
        hour    => '*',
        month   => '*',
        weekday => '*',
        user    => 'root',
        command => '/usr/bin/curl -o /tmp/devpi.pp https://s3-us-west-2.amazonaws.com/devpi-config/devpi.pp; /usr/bin/puppet apply -l /tmp/puppetApply.log /tmp/devpi.pp',
}

Package['python-pip'] -> File['/usr/bin/pip'] -> Package['devpi'] -> Exec['deployDevpi'] -> Exec['runDevpi']
Package['nginx'] -> File['/etc/nginx/conf.d/server.conf'] -> Service['nginx'] 
File['/tmp/devpi.pp'] -> Cron::Job['kickPuppet']
