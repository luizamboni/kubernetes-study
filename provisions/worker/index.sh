#!/bin/bash

#!/bin/bash
BASEDIR=$(dirname "$0")

$BASEDIR/config.sh
$BASEDIR/modules.sh
bash /vagrant/join-cmd