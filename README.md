Kubernetes Vagrant Cluster
===

# install vagrant disk plugin
vagrant plugin install vagrant-disksize

# upgrade virtual box
sudo apt upgrade virtualbox

# update last version of vagrant boxes
vagrant box outdated



# Create images, up then and take snapshots
```bash
$ ./cli build
```

# Restore initial images
```bash
$ ./cli restore
```
# Destroy images and snapshots
```bash
$ ./cli restore
```