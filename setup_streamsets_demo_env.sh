#!/bin/bash

function bootstrap_os {
  OS=`uname -s`

  if [ "${OS}" = "Linux" ]; then
      #for now just assume its ubuntu or centos
      if [ -x "$(command -v lsb_release)" ]; then
          if [ "$(/usr/bin/lsb_release -si )" == "Ubuntu" ] && [ "$(/usr/bin/lsb_release -sr )" == "14.04" ]; then
            echo 'we are on ubuntu 14.04 - good'
            echo 'Installing required software for this platform'
            sh ./ubuntu-bootstrap.sh

          else
            echo 'sorry need ubuntu 14.04'
            exit
          fi
      elif [ -f "$(command -v /etc/redhat-release)" ]; then
        echo 'We are on redhat'
      fi

  else
    echo 'Sorry I can only run this on Linux (ubuntu or centos) for now'
  fi

}

function execute_dockercompose {
  docker-compose up -d
}

function build_inventory_demo {
  aws s3 cp --recursive  --include "*.*" s3://streamsets-productmgmt/demo/inventory_demo/ .
}
bootstrap_os
execute_dockercompose
