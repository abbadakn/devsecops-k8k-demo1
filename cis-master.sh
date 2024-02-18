############  Add cis-master.sh ############ 


#!/bin/bash
#cis-master.sh

# original command from the lecture
total_fail=$(kube-bench master --version 1.15 --check 1.2.7,1.2.8,1.2.9 --json | jq .[].total_fail)

# modified command to make it work with our localmachine installation
total_fail=$(./kube-bench run --targets master --version 1.15 --check 1.2.7,1.2.8,1.2.9 --config-dir `pwd`/cfg --config `pwd`/cfg/config.yaml --json | jq .Totals.total_fail)

if [[ "$total_fail" -ne 0 ]];
        then
                echo "CIS Benchmark Failed MASTER while testing for 1.2.7, 1.2.8, 1.2.9"
                exit 1;
        else
                echo "CIS Benchmark Passed for MASTER - 1.2.7, 1.2.8, 1.2.9"
fi;

############  Add cis-master.sh ############ 