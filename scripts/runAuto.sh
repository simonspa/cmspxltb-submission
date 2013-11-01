#!/bin/bash
shopt -s expand_aliases

#Only things you should need to change
WORKDIR=/tmp/grundler/batchsub
CFGFILE=/afs/cern.ch/work/g/grundler/public/fnal2013/cmspxltb-submission/batch.cfg
OUTPUTDIR=/afs/cern.ch/work/g/grundler/public/output/
MODES=(convert clustering hitmaker tracks)

if [ -z ${1} ]; then
	echo "usage: runAuto.sh runNumber"
	exit
fi

RUN=$1
RUN0=`printf "%06d" ${RUN}`
EOSDIR=cms/store/cmst3/group/tracktb/FNAL2013

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
mkdir ${WORKDIR}/myeos
eos -b fuse mount ${WORKDIR}/myeos
cd data/cmspixel/${RUN0}
for file in `ls ${WORKDIR}/myeos/${EOSDIR}/${RUN}/*.dat`; do
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
	echo "jobsub -c batch.cfg ${mode} ${RUN}"
	jobsub -c batch.cfg ${mode} ${RUN}
done

#jobsub -c batch.cfg convert    ${RUN}
#jobsub -c batch.cfg clustering ${RUN}
#jobsub -c batch.cfg hitmaker   ${RUN}
#jobsub -c batch.cfg align      ${RUN}
#jobsub -c batch.cfg tracks     ${RUN}

#Move output to permanent location
mv -f logs/* ${OUTPUTDIR}
mv -f lcio/* ${OUTPUTDIR}
mv -f databases/* ${OUTPUTDIR}
mv -f histograms/* ${OUTPUTDIR}

#Clean up
eos -b fuse umount ${WORKDIR}/myeos
cd ${WORKDIR}/..
rm -r ${WORKDIR}