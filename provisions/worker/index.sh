#!/bin/bash

#!/bin/bash
BASEDIR=$(dirname "$0")

$BASEDIR/config.sh
$BASEDIR/modules.sh
sudo ./vagrant/join-cmd