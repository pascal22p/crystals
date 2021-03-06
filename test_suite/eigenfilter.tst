#
# This test takes a non-centro structure (cyclo) and tests all the
# refinement by eigenvalue filtering
#
#  Refinement, Scale, Calc            } These options are worked
#  Mixed ISO/ANISO refinement         } through in the instruction file
#  Extinction                         } cycloeig.dat.
#
#  F and F squared refinement FSQ or NOFSQ
#  Anomalous scattering ANOM or NOANOM
#

\set time slow
\rele print CROUTPUT:
\use cyclo.in
# Do a pretty picture:
\MOLAX
ATOM FIRST UNTIL LAST
PLOT
END

#                                         NOFSQ, NOANOM
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
\USE cycloeig.dat

#                                         NOFSQ, ANOM
\use cyclo.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=NO
END
\USE cycloeig.dat

#                                         FSQ, NOANOM
\use cyclo.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=YES
END
\USE cycloeig.dat

#                                         FSQ, ANOM
\use cyclo.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\USE cycloeig.dat

#                                         And close the program.
\FINISH
