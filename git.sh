#!/bin/bash

#enable debug if necessary
if [[ -v JB_GIT_DEBUG ]]; then
  set -e -x -u
fi

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
d_command="if [[ -v JB_GIT_DEBUG ]]; then set -e -x -u; fi; cd /build; "${env_argz[@]}" /git-cmd.sh $(printf " %q" "$@")"

#precessing wrapping docker command
command="groupadd -g \"$(id -g)\" build || true; "
command+="useradd -d /build -g \"$(id -g)\" -M -u \"$(id -u)\" -s /bin/bash build; "
command+="su -l -c \"${d_command}\" build"

docker run -i --rm -v $(pwd):/build -w /build "${docker_image}" /bin/bash -c "if [[ -v JB_GIT_DEBUG ]]; then set -e -x -u; fi;  ${command}"

