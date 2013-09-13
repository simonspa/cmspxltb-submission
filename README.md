cmspxltb-submission
===================

Submission scripts, steering templates and config files for FNAL beam test

HowTo use these files:
* Source the environment things (EUTelescope etc):
  $ cd <your-installation-folder>
  $ source build_env.sh

* Go to the submission folder (here!)

* Edit the runlist to add new runs taken and to be anaylzed, e.g.
  $ emacs runlist.csv

  	RunNumber,Date,GearFile,BeamEnergy,
	000000,2013-10-9,gear_fnal_straight.xml,120

  Warning: DO NOT USE BLANKS AFTER COMMAS! This will screw up path reading from the runlist.

* Raw data should be stored in "data/cmspixel"
* Gear geometry files should be stored in "data/geometries"
* ROC gain calibrations should be stored in "data/calibration/chipXXX"
  with XXX being a three-digit chip id.

* Run that stuff, either single runs (just the numer)
  ...or ranges (with dash)
  ...or some at once (comma separated):

  $ jobsub -c config.cfg -csv runlist.csv convert 123-456
  $ jobsub -c config.cfg -csv runlist.csv clustering 546,547,548
  $ jobsub -c config.cfg -csv runlist.csv hitmaker 1000
  $ jobsub -c config.cfg -csv runlist.csv align 5000
  $ jobsub -c config.cfg -csv runlist.csv tracks 129084


