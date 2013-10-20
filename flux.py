#!/usr/bin/python
import sys

flux=sys.argv[1]
nbunch=sys.argv[2]

print flux, nbunch

np = float(flux) / int(nbunch) / 91000 / 4

print "no of proton per bunch", np
print "no of proton in 25ns ", np/17*25
print " eff. flux in MHz ", np/17*25*40

