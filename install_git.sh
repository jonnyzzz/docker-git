#!/bin/bash

set -x -e -u

git_version="$1"
git_sources="/gitz/src/git"
git_bin="/gitz/bin/git"
git_sh="/git-cmd.sh"

mkdir -p ${git_sources} 
mkdir -p ${git_bin}

wget -O ${git_sources}/git.tar.gz https://www.kernel.org/pub/software/scm/git/git-${git_version}.tar.gz
tar xzf ${git_sources}/git.tar.gz -C ${git_sources}

pushd ${git_sources}/git-${git_version}
make prefix=${git_bin} all && make prefix=${git_bin} install
popd

echo '#!/bin/bash' > ${git_sh}
echo "GIT_EXEC_PATH=${git_bin}/libexec/git-core PATH=${git_bin}/bin:\$PATH GITPERLLIB=${git_bin}/perl/blib/lib ${git_bin}/bin/git \"\$@\"" >> ${git_sh}
chmod a+rx ${git_sh}

cat ${git_sh}
${git_sh} --version

[[ $( ${git_sh} --version ) == *${git_version}* ]]

root_git=/git
echo '#!/bin/bash' > ${root_git}
echo "GIT_VERSION=${git_version}" >> ${root_git}
echo "" >> ${root_git}
cat /root/git.sh >> ${root_git}

sync
chmod a+rx ${root_git}

## cleanup
rm -rf ${git_sources}/git.tar.gz
rm -rf ${git_sources}/git-${git_version}

