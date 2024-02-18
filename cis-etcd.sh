############  Add cis-etcd.sh ############ 

#!/bin/bash
#cis-etcd.sh

# original command from the lecture
#total_fail=$(kube-bench run --targets etcd  --version 1.15 --check 2.2 --json | jq .[].total_fail)


# modified command to make it work with our localmachine installation
total_fail=$(./kube-bench run --targets etcd --version 1.15 --check 2.2 --config-dir `pwd`/cfg --config `pwd`/cfg/config.yaml --json | jq .Totals.total_fail)

if [[ "$total_fail" -ne 0 ]];
        then
                echo "CIS Benchmark Failed ETCD while testing for 2.2"
                exit 1;
        else
                echo "CIS Benchmark Passed for ETCD - 2.2"
fi;

############  Add cis-etcd.sh ############ 
