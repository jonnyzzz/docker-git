#!/bin/bash

#enable debug if necessary
set -e -x -u

docker_image="jonnyzzz/docker-git:${GIT_VERSION}"

# processing selected env variables to pass to the docker process
env_argz=("GIT_JB_DOCKER=1" )
while read line; do
  key=$line
  value=${!key}
  key_value=$(printf "%q" "$key=$value" )
  env_argz+=( "${key_value}" )
done < <( printenv | sed -n -r 's/^((JB|GIT)[^=]+)=.*$/\1/p' )

# processing actual inner docker command
d_command="set -e -x -u; cd /build; "${env_argz[@]}" /git-call.sh $(printf " %q" "$@")"

#precessing wrapping docker command
command="groupadd -g "$(id -g)" build; "
command+="useradd -d /build -g build -M -u \"$(id -u)\" -s /bin/bash build; "
command+="su -l -c \"${d_command}\" build"

docker run -i --rm -v $(pwd):/build -w /build "${docker_image}" /bin/bash -c "set -e -x -u; ${command}"

