#!/bin/bash

echo ${PWD}

echo -n "run number  "
read runnum

/afs/cern.ch/project/eos/installation/0.2.31/bin/eos.select ls -l /eos/cms/store/cmst3/group/tracktb/FNAL2013/${runnum}

echo -n "file name  "
read fname

/afs/cern.ch/project/eos/installation/0.2.31/bin/eos.select cp /eos/cms/stor\
e/cmst3/group/tracktb/FNAL2013/${runnum}/${fname} ${PWD}/data/cmspixel/

mkdir data/cmspixel/0${runnum}
ln -s ${PWD}/data/cmspixel/${fname} ${PWD}/data/cmspixel/0${runnum}/mtb.bin 

#source build_env.sh
jobsub -c config.cfg convert ${runnum}

