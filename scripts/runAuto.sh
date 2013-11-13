#!/bin/bash
shopt -s expand_aliases

#Only things you should need to change
CFGFILE=/afs/cern.ch/work/g/grundler/public/fnal2013/cmspxltb-submission/batch.cfg
OUTPUTDIR=/afs/cern.ch/work/g/grundler/public/output/
MODES=(convert clustering) # hitmaker tracks)

if [ -z ${1} ]; then
	echo "usage: runAuto.sh runNumber"
	exit
fi

echo "runAuto.sh run by ${USER} on ${HOSTNAME}"
echo "Configuration file: ${CFGFILE}"
echo ""

RUN=$1
RUN0=`printf "%06d" ${RUN}`
EOSDIR=cms/store/cmst3/group/tracktb/FNAL2013
WORKDIR=/tmp/${USER}/batchsub
EOSMOUNT=/tmp/${USER}/eos

#source the environment
if [ -z ${MARLIN} ] ; then
	echo "Sourcing environment"
	source /afs/cern.ch/user/g/grundler/work/public/fnal2013/cmspxltb-analysis/build_env.sh
fi
alias eos='/afs/cern.ch/project/eos/installation/0.2.31/bin/eos.select'

#Create a working directory
mkdir -p ${WORKDIR}
cd ${WORKDIR}
cp ${CFGFILE} .

#Link data from EOS
mkdir -p data/cmspixel/${RUN0}
#Create a directory to mount to if nonexistent
if [ ! -d ${EOSMOUNT} ]; then
	mkdir -p ${EOSMOUNT}
fi
#Mount if not mounted already
if [ ! -d "${EOSMOUNT}/cms" ]; then
	eos -b fuse mount ${EOSMOUNT}
fi
cd data/cmspixel/${RUN0}
for file in `ls ${EOSMOUNT}/${EOSDIR}/${RUN}/*.dat`; do
	ln -sf ${file} mtb.bin
done
cd ${WORKDIR}

#Create output directories
mkdir logs
mkdir lcio
mkdir databases
mkdir histograms

#Run
for mode in ${MODES[@]}; do
	echo ""
	echo "jobsub -c batch.cfg ${mode} ${RUN}"
	jobsub -c batch.cfg ${mode} ${RUN}
done

#Move output to permanent location
echo ""
echo "Moving files to ${OUTPUTDIR}"
mv -f logs/* ${OUTPUTDIR}
mv -f lcio/* ${OUTPUTDIR}
mv -f databases/* ${OUTPUTDIR}
mv -f histograms/* ${OUTPUTDIR}

#Clean up
#Unmount if mounted
echo "Time to clean up"
if [ -d "${EOSMOUNT}/cms" ]; then
	eos -b fuse umount ${EOSMOUNT}
fi
rmdir ${EOSMOUNT}
cd ${WORKDIR}/..
rm -r ${WORKDIR}

echo "Finished."