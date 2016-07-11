#!/bin/bash

set -x -e -u

# udevadm may not upgrade correctly
yum remove -y udev

yum update -y 
yum groupinstall -y "Development tools" 
yum install -y tar wget m4
yum install -y autoconf 
yum install -y gcc 
yum install -y perl-ExtUtils-MakeMaker 
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel 
yum clean all

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
echo "GIT_EXEC_PATH=${git_bin}/libexec/git-core PATH=${git_bin}/bin:\$PATH GITPERLLIB=${git_bin}/perl/blib/lib ${git_bin}/bin/git \"\$@\"" > ${git_sh}
chmod a+rx ${git_sh}

cat ${git_sh}
${git_sh} --version

[[ $( ${git_sh} --version ) == *${git_version}* ]]

## cleanup
rm -rf ${git_sources}/git.tar.gz
rm -rf ${git_sources}/git-${git_version}

