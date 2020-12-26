# Server configuration

## Abstract 
This document relate all installation and configuration processes, needed on the server before launching an instance.

## Installation 
### Installation list 
- Docker (docker swarm is include)
- Docker compose
- gcloud 
- jq

### Process
- Install docker and docker-compose from official website
- Add your user to `docker` group
- Install jq tool from your package manager. It will allow for JSON parse 
- Install gcloud, from the google official online procedure
- Use `gcloud init` to configure gcloud with your account and project. No default region/zone is requiered (gcloud will help to retrieve secrets)
- Configure docker with gcloud. Use the command `gcloud auth configure-docker`. Prefere the online fresh documentation than this command

## Volume Mount
Some of these services store a lot of data and it's preferred to use an external volume, to store these data. Mount the partition using the following command: 
- `sudo mount /dev/sdx /mounting_point` (Think to use `mkdir` to create the mounting point) 
- `df -h` to see disk and mounting point
- Use `chown -R <user>:<group> <mounting_point>` to allow the current user to write on the partition
- Use `sudo blkid` to see ID of each partition. Note the UUID of the concerned partition
- Now use fstab to auto mount the disk at startup. Add to /etc/fstab a line with the following schemas
`UUID=<UUID retrieve from blkid> <mounting_point_path> ext4 nofail 0 0`

### List of mounting point 
Here is a list of a services that could use external volume. 
- mongodb with a mounting point at `/var/volumes/mongo-data/` use `chown` to attribute correct permission to the current user. 
