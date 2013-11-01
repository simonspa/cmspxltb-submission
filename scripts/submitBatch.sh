#!/bin/bash

QUEUE=1nh
COMMAND=/afs/cern.ch/work/g/grundler/public/fnal2013/cmspxltb-submission/scripts/runAuto.sh

SUBMIT=true
CLEANUP=true

for RUN in "$@"; do
	SCRIPT=batchRun${RUN}.sh
	if [ -f ${SCRIPT} ]; then
		rm -f ${SCRIPT}
	fi
	echo "Create job script for run ${RUN}"
	touch ${SCRIPT}
	chmod a+x ${SCRIPT}
	echo "#!/bin/bash" >> ${SCRIPT}
	echo "${COMMAND} ${RUN}" >> ${SCRIPT}

	if ${SUBMIT}; then
		echo "Submitting ${SCRIPT} to queue ${QUEUE}"
		bsub -q ${QUEUE} ${SCRIPT}
	fi
done

if $CLEANUP; then
	echo "Cleaning up batch scripts (rm -f batchRun*.sh)"
	rm -f batchRun*.sh
fi