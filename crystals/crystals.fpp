CODE FOR CRYSTL
C      winapp 500000,1000000
&GID      SUBROUTINE CRYSTL
&GIL      SUBROUTINE CRYSTL
##GIDGIL      PROGRAM CRYSTL
C
C
C     ******************************************************
C     * THIS IS THE MAIN PROGRAM FOR THE 'CRYSTALS' SYSTEM *
C     ******************************************************
C
C BY DEFAULT, TERMINAL INPUT IS FROM UNIT 5 - NCUFU(1)
C             TERMINAL OUTPUT IS TO UNIT  6 - NCAWU
C             AND THE STARTUP FILE IS OPENED ON UNIT 20 - NCRU
C
C             THE NAME OF THE STARTUP FILE MAY EITHER BE SET AS
C             DATA IN PRESETS, OR IN AN ASSIGNMENT BELOW.
C
\ISTORE
      DIMENSION PROGLS(4,18)
C--
C
\STORE
\TSSCHR
&PPC      CHARACTER*40 theText
C
\XDRIVE
\XUNITS
\XSSVAL
\XCARDS
\XPRGNM
\XTAPES
\XDISC
\XDISCS
\XSSCHR
\XIOBUF
&PPC\XGSTOP
&PPC\CFLDAT
C
\QSTORE

      INTEGER PROGLS
C
C
C -- DECLARE EXTERNAL REFERENCES TO BLOCK DATA SEGMENTS
C
&PPCC**** Commented out for Mac OS, COMMON must be in the same module
&PPCC**** 13.11.1995 Ludwig Macko
&PPCC****
#PPC      EXTERNAL CRYBLK, SYNBLK, UTIBLK
C
C -- DECLARE LIST 11 REFERENCES TO RESERVE EXTENSIBLE COMMON
C
      EXTERNAL XFAL11,KADD11,XIN11
&DOS      EXTERNAL MYDRIV
C
C -- SET UP AVAILABLE PROGRAM LIST.
C    NAMES RESTRICTED TO FIRST 16 CHARACTERS OF THOSE IN COMMANDFILE
C
      DATA NPROG / 18 /
#HOL      DATA PROGLS(1,1)  / 'CRYS' / , PROGLS(2,1)  / 'TALS' /
#HOL      DATA PROGLS(3,1)  / 'INPU' / , PROGLS(4,1)  / 'T   ' /
#HOL      DATA PROGLS(1,2)  / 'CRYS' / , PROGLS(2,2)  / 'TALS' /
#HOL      DATA PROGLS(3,2)  / 'FIDD' / , PROGLS(4,2)  / 'LE  ' /
#HOL      DATA PROGLS(1,3)  / 'CRYS' / , PROGLS(2,3)  / 'TALS' /
#HOL      DATA PROGLS(3,3)  / 'CALC' / , PROGLS(4,3)  / 'ULAT' /
#HOL      DATA PROGLS(1,4)  / 'CRYS' / , PROGLS(2,4)  / 'TALS' /
#HOL      DATA PROGLS(3,4)  / 'INVE' / , PROGLS(4,4)  / 'RT  ' /
#HOL      DATA PROGLS(1,5)  / 'CRYS' / , PROGLS(2,5)  / 'TALS' /
#HOL      DATA PROGLS(3,5)  / 'REST' / , PROGLS(4,5)  / 'RAIN' /
#HOL      DATA PROGLS(1,6)  / 'CRYS' / , PROGLS(2,6)  / 'TALS' /
#HOL      DATA PROGLS(3,6)  / 'GEOM' / , PROGLS(4,6)  / 'ETRY' /
#HOL      DATA PROGLS(1,7)  / 'CRYS' / , PROGLS(2,7)  / 'TALS' /
#HOL      DATA PROGLS(3,7)  / 'ANIS' / , PROGLS(4,7)  / 'O   ' /
#HOL      DATA PROGLS(1,8)  / 'CRYS' / , PROGLS(2,8)  / 'TALS' /
#HOL      DATA PROGLS(3,8)  / 'ALTE' / , PROGLS(4,8)  / 'R5  ' /
#HOL      DATA PROGLS(1,9)  / 'CRYS' / , PROGLS(2,9)  / 'TALS' /
#HOL      DATA PROGLS(3,9)  / 'WEIG' / , PROGLS(4,9)  / 'HT  ' /
#HOL      DATA PROGLS(1,10) / 'CRYS' / , PROGLS(2,10) / 'TALS' /
#HOL      DATA PROGLS(3,10) / 'DIST' / , PROGLS(4,10) / 'ANCE' /
#HOL      DATA PROGLS(1,11) / 'CRYS' / , PROGLS(2,11) / 'TALS' /
#HOL      DATA PROGLS(3,11) / 'FOUR' / , PROGLS(4,11) / 'IER ' /
#HOL      DATA PROGLS(1,12) / 'CRYS' / , PROGLS(2,12) / 'TALS' /
#HOL      DATA PROGLS(3,12) / 'INPU' / , PROGLS(4,12) / 'T6  ' /
#HOL      DATA PROGLS(1,13) / 'CRYS' / , PROGLS(2,13) / 'TALS' /
#HOL      DATA PROGLS(3,13) / 'PROC' / , PROGLS(4,13) / 'ESS6' /
#HOL      DATA PROGLS(1,14) / 'CRYS' / , PROGLS(2,14) / 'TALS' /
#HOL      DATA PROGLS(3,14) / 'TRIA' / , PROGLS(4,14) / 'L   ' /
#HOL      DATA PROGLS(1,15) / 'CRYS' / , PROGLS(2,15) / 'TALS' /
#HOL      DATA PROGLS(3,15) / 'PROC' / , PROGLS(4,15) / 'ESS ' /
#HOL      DATA PROGLS(1,16) / 'CRYS' / , PROGLS(2,16) / 'TALS' /
#HOL      DATA PROGLS(3,16) / 'PUBL' / , PROGLS(4,16) / 'ISH ' /
#HOL      DATA PROGLS(1,17) / 'CRYS' / , PROGLS(2,17) / 'TALS' /
#HOL      DATA PROGLS(3,17) / 'FORE' / , PROGLS(4,17) / 'IGN ' /
#HOL      DATA PROGLS(1,18) / 'CRYS' / , PROGLS(2,18) / 'TALS' /
#HOL      DATA PROGLS(3,18) / 'DIFA' / , PROGLS(4,18) / 'BS  ' /
&HOL      DATA PROGLS(1,1)  / 4HCRYS / , PROGLS(2,1)  / 4HTALS /
&HOL      DATA PROGLS(3,1)  / 4HINPU / , PROGLS(4,1)  / 4HT    /
&HOL      DATA PROGLS(1,2)  / 4HCRYS / , PROGLS(2,2)  / 4HTALS /
&HOL      DATA PROGLS(3,2)  / 4HFIDD / , PROGLS(4,2)  / 4HLE   /
&HOL      DATA PROGLS(1,3)  / 4HCRYS / , PROGLS(2,3)  / 4HTALS /
&HOL      DATA PROGLS(3,3)  / 4HCALC / , PROGLS(4,3)  / 4HULAT /
&HOL      DATA PROGLS(1,4)  / 4HCRYS / , PROGLS(2,4)  / 4HTALS /
&HOL      DATA PROGLS(3,4)  / 4HINVE / , PROGLS(4,4)  / 4HRT   /
&HOL      DATA PROGLS(1,5)  / 4HCRYS / , PROGLS(2,5)  / 4HTALS /
&HOL      DATA PROGLS(3,5)  / 4HREST / , PROGLS(4,5)  / 4HRAIN /
&HOL      DATA PROGLS(1,6)  / 4HCRYS / , PROGLS(2,6)  / 4HTALS /
&HOL      DATA PROGLS(3,6)  / 4HGEOM / , PROGLS(4,6)  / 4HETRY /
&HOL      DATA PROGLS(1,7)  / 4HCRYS / , PROGLS(2,7)  / 4HTALS /
&HOL      DATA PROGLS(3,7)  / 4HANIS / , PROGLS(4,7)  / 4HO    /
&HOL      DATA PROGLS(1,8)  / 4HCRYS / , PROGLS(2,8)  / 4HTALS /
&HOL      DATA PROGLS(3,8)  / 4HALTE / , PROGLS(4,8)  / 4HR5   /
&HOL      DATA PROGLS(1,9)  / 4HCRYS / , PROGLS(2,9)  / 4HTALS /
&HOL      DATA PROGLS(3,9)  / 4HWEIG / , PROGLS(4,9)  / 4HHT   /
&HOL      DATA PROGLS(1,10) / 4HCRYS / , PROGLS(2,10) / 4HTALS /
&HOL      DATA PROGLS(3,10) / 4HDIST / , PROGLS(4,10) / 4HANCE /
&HOL      DATA PROGLS(1,11) / 4HCRYS / , PROGLS(2,11) / 4HTALS /
&HOL      DATA PROGLS(3,11) / 4HFOUR / , PROGLS(4,11) / 4HIER  /
&HOL      DATA PROGLS(1,12) / 4HCRYS / , PROGLS(2,12) / 4HTALS /
&HOL      DATA PROGLS(3,12) / 4HINPU / , PROGLS(4,12) / 4HT6   /
&HOL      DATA PROGLS(1,13) / 4HCRYS / , PROGLS(2,13) / 4HTALS /
&HOL      DATA PROGLS(3,13) / 4HPROC / , PROGLS(4,13) / 4HESS6 /
&HOL      DATA PROGLS(1,14) / 4HCRYS / , PROGLS(2,14) / 4HTALS /
&HOL      DATA PROGLS(3,14) / 4HTRIA / , PROGLS(4,14) / 4HL    /
&HOL      DATA PROGLS(1,15) / 4HCRYS / , PROGLS(2,15) / 4HTALS /
&HOL      DATA PROGLS(3,15) / 4HPROC / , PROGLS(4,15) / 4HESS  /
&HOL      DATA PROGLS(1,16) / 4HCRYS / , PROGLS(2,16) / 4HTALS /
&HOL      DATA PROGLS(3,16) / 4HPUBL / , PROGLS(4,16) / 4HISH  /
&HOL      DATA PROGLS(1,17) / 4HCRYS / , PROGLS(2,17) / 4HTALS /
&HOL      DATA PROGLS(3,17) / 4HFORE / , PROGLS(4,17) / 4HIGN  /
&HOL      DATA PROGLS(1,18) / 4HCRYS / , PROGLS(2,18) / 4HTALS /
&HOL      DATA PROGLS(3,18) / 4HDIFA / , PROGLS(4,18) / 4HBS   /
C
C Re-initialise system variables in case starting again.
      CALL CRESET
C
C----- INITIALISE THE CARRIAGE CONTROL VARIABLES
      CALL FBCINI
&PPC      CALL envini
&PPC      CALL cabout
&PPC      DISKOP = 0
&PPC      GLSTOP = 0
C
cnov98 - disable argument type checking
&DOS      call suppress_argument_type_checks@
      CALL STCTLC
C
C -- ASSIGN AND OPEN STARTUP CONTROL FILE - CSSCST AND LSSCST
C    ARE SET IN BLOCK DATA IN PRESETS. THE LOGICAL NAME MAT BE
C    EXPANDED
#PPC      CALL MTRNLG ( CSSCST, 'OLD', LSSCST)
C----- ALTERNATIVELY, THAY CAN BE SET HERE
C      CSSCST = '\CRYSTALS\SRT\CRYSTALS.SRT'
C      LSSCST =  26
C
&DOSC----- HOOK IN THE SALFORD DOS DRIVER TO COUNT LINES
CWIN_32&DOS      OPEN ( NCVDU, STATUS = 'UNKNOWN', DRIVER = MYDRIV)
C
      IF ( ISSSFI .GT. 0 ) THEN
        ISTAT = KFLOPN ( NCRU ,CSSCST(1:LSSCST),ISSOLD,ISSREA,1,ISSSEQ)
        IF ( ISTAT .LE. 0 ) THEN
            WRITE(6,*) 'UNIT =', NCRU, 'FILE =', CSSCST
            CALL XERIOM ( NCRU, ISTAT)
C            STOP 'ERROR OPENING STARTUP FILE'
            CALL GUEXIT (2003)
        ENDIF
      ENDIF
C
      I = KNXTOP ( LSTOP,LSTNO,ICLASS )
1210  CONTINUE
&PPCCS***
&PPC      IF ( GLSTOP .EQ. 1 ) GOTO 9999
&PPCCE***
C----- CHECK IF THIS SEGMENT NAME IS AVAILABLE
      I=KCOMP(4,KPRGNM,PROGLS,NPROG,4)
      IF ( I .LE. 0 ) GO TO 9920
C----- GOTO THE APPROPRIATE SECTION
       GOTO(3010,3020,3030,3040,3050,3060,3070,3080,3090,
     2 3100 , 3110 , 3120 , 3130 , 3140 ,
     3 3150 , 3160 , 3170 , 3180 , 9920 ) , I
      GO TO 9920
C
C
3010  CONTINUE
      CALL INPUT
      GOTO 1210
3020  CONTINUE
      CALL FIDDLE
      GOTO 1210
3030  CONTINUE
      CALL CALCUL
      GOTO 1210
3040  CONTINUE
      CALL INVERT
      GOTO 1210
3050  CONTINUE
      CALL RESTR
      GOTO 1210
3060  CONTINUE
      CALL GEOMET
      GOTO 1210
3070  CONTINUE
      CALL ANISO
      GOTO 1210
3080  CONTINUE
      CALL ALTER5
      GOTO 1210
3090  CONTINUE
      CALL WEIGHT
      GOTO 1210
C
3100  CONTINUE
      CALL DISTAN
      GOTO 1210
3110  CONTINUE
      CALL FOURIE
      GOTO 1210
3120  CONTINUE
      CALL INPUT6
      GOTO 1210
3130  CONTINUE
      CALL PRCSS6
      GOTO 1210
3140  CONTINUE
      CALL TRIAL
      GOTO 1210
3150  CONTINUE
      CALL PRCSS
      GOTO 1210
3160  CONTINUE
      CALL PUBLSH
      GOTO 1210
3170  CONTINUE
      CALL FOREIG
      GO TO 1210
3180  CONTINUE
      CALL DIFABS
      GO TO 1210
C
C
C
9920  CONTINUE
      WRITE ( CMON, 9925)
      CALL XPRVDU(NCEROR, 1,0)
9925  FORMAT ( 1X , 'Illegal program name selected' )
      GO TO 9990
C
9990  CONTINUE
C      STOP 'CRYSTALS START ERROR'
      CALL GUEXIT (2004)
&PPCCS***
&PPC9999  CONTINUE
&PPCCE***
      END
&PPCC
