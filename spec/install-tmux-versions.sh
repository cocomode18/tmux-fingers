#!/usr/bin/env bash
set -e

if [[ -n "$CI_TMUX_VERSION" ]]; then
  VERSIONS=("$CI_TMUX_VERSION")
else
  #VERSIONS=("3.0a" "3.1c" "3.2a" "3.3a" "3.4" "3.5a" "3.6a" "master")
  VERSIONS=("float-border-offset")
fi

# clone as bare repo
git clone --bare https://github.com/daneofmanythings/tmux /opt/tmux-repo

mkdir -p /opt

pushd /tmp
  for version in "${VERSIONS[@]}";
  do
    if [[ -d "/opt/tmux-${version}" ]]; then
      continue
    fi

    echo "Building tmux version ${version}"

    git clone /opt/tmux-repo /opt/tmux-${version}

    pushd "/opt/tmux-${version}"
      git checkout "${version}"
      sh autogen.sh
      ./configure
      make
      chmod -R a+r /opt/tmux-${version}
    popd
  done
popd
