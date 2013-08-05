##Project - DevPi HA cluster

This is a repo of, hopefully, different working implementations on providing a Devpi HA cluster.


###Content
* Base - this is the bare minimum to get a devpi server up, simply run cloud formation script with nodeless puppet
* V1 - Base plus ELB and auto-scaling
* V2 - V1 with self voting puppet master (not for sure if possible)? 

###Status
* Base - Almost all working except for cron to kick puppet
* V1 - Have not started
