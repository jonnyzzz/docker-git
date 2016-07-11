This is a root repository to build docker container where git client of given version is

See branches for each version

Usage
=====

```
   docker run jonnyzzz/docker-git:<VERSION> >git
   chmod +x git
   ./git --version
```

The script from container mounts currect working dir into container and 
executes git client there.

We do a trick to have all files being create under the same user account
that calls the script on the host. Some environment variables are 
transmitted into container. 




