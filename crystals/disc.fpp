C $Log: not supported by cvs2svn $
C Revision 1.4  2001/09/07 14:21:35  ckp2
C Fiddled around with #DISK to allow time and date to be stored for each entry.
C There is a year 2038 problems with the date format, it'll seem like 1970 again.
C Also added a punch directive which will allow scripts to get hold of the DSC
C info in a script readable format. Will write some scripts soon.
C
C Revision 1.3  2001/02/26 10:25:31  richard
C Added changelog to top of file
C
C
CODE FOR XUPF
      SUBROUTINE XUPF(I,IA,J)
C--TRANSFER FLOATING POINT NUMBERS FROM STORE TO THE DISC
C
C  I  ADDRESS OF THE FIRST WORD ON THE DISC (24 BIT WORD)
C  IA  ARRAY HOLDING THE DATA
C  J  NUMBER OF WORDS TO TRANSFER
C
C--
C
      DIMENSION IA(J)
C
C
      DATA K/0/,L/0/
C
      K=I
      L=KINCRF(J)
      CALL XUP(K,IA,L)
      RETURN
      END
C
CODE FOR XDOWNF
      SUBROUTINE XDOWNF(I,A,J)
C--TRANSFER FLOATING POINT NUMBERS FROM THE DISC TO STORE
C
C  I  ADDRESS OF THE FIRST WORD ON THE DISC (24 BIT WORDS)
C  A  ARRAY TO HOLD THE DATA
C  J  NUMBER OF WORDS TO TRANSFER
C
C--
C
      DIMENSION A(J)
C
C
      DATA K/0/,L/0/
C
      K=I
      L=KINCRF(J)
      CALL XDOWN(K,A,L)
      RETURN
      END
C
CODE FOR XDOWN
      SUBROUTINE XDOWN(NFW,IADD,NW)
C--TRANSFER FROM DISC TO STORE
C
C  NFW   ADDRESS OF FIRST WORD TO BE USED ON DISC
C  IADD  ADDRESS OF FIRST WORD IN CORE
C  NW    NUMBER OF WORDS TO TRANSFER
C
C--DISC ROUTINES VERSION 4, USING ONLY 'XDATA' OR SIMILAR ARRAYS AS STOR
C  THE BUFFERS.
C
C--RECORD 0 CONTAINS WORDS  0   - (NWR-1)
C  RECORD 1 CONTAINS WORDS  NWR - (2*NWR-1)
C  AND SUBSEQUENT RECORDS ARE THE SAME
C
C--
C
      DIMENSION IADD(NW)
C
\XLINK
\XDISCB
C
\QDISCB
C
C--TRANSFER THE ARGUMENTS TO THE COMMON BLOCK
      NFWD=NFW
      NWD=NW
      NV=1
C--CHECK IF THERE ARE ANY MORE WORDS TO TRANSFER
1000  CONTINUE
      IF(NWD)1050,1050,1100
1050  CONTINUE
      RETURN
C--CALCULATE THE RECORD NUMBER ETC. FOR THIS TRANSFER
1100  CONTINUE
      CALL XFINDB
C--READ SOME NUMBERS
      CALL XMOVE(LINK(J),IADD(NV),K)
      NV=NV+K
      GOTO 1000
      END
C
CODE FOR XUP
      SUBROUTINE XUP(NFW,IADD,NW)
C--TRANSFER FROM STORE TO DISC
C
C  NFW   ADDRESS OF FIRST WORD TO BE USED ON DISC
C  IADD  ADDRESS OF FIRST WORD IN CORE
C  NW    NUMBER OF WORDS TO TRANSFER
C
C--DISC ROUTINES VERSION 4, USING ONLY 'XDATA' OR SIMILAR ARRAYS AS STOR
C  THE BUFFERS.
C
C--RECORD 0 CONTAINS WORDS  0   - (NWR-1)
C  RECORD 1 CONTAINS WORDS  NWR - (2*NWR-1)
C  AND SUBSEQUENT RECORDS ARE THE SAME
C
C--
C
      DIMENSION IADD(NW)
C
\XLINK
\XDISCB
C
\QDISCB
C
C--TRANSFER THE ARGUMENTS TO THE COMMON BLOCK
      NFWD=NFW
      NWD=NW
      NV=1
C--CHECK IF THERE ARE ANY MORE WORDS TO TRANSFER
1000  CONTINUE
      IF(NWD)1050,1050,1100
1050  CONTINUE
      RETURN
C--CALCULATE THE RECORD NUMBER ETC. FOR THIS TRANSFER
1100  CONTINUE
      CALL XFINDB
C--WRITE SOME NUMBERS
      LINK(I+3)=-1
      CALL XMOVE(IADD(NV),LINK(J),K)
      NV=NV+K
      GOTO 1000
      END
C
CODE FOR XGIVE
      SUBROUTINE XGIVE
C--SET UP THE USER DEFINED BUFFERS
C
C
C
C -- THIS ROUTINE SETS UP THE BUFFERS REQUIRED BY THE DISC ROUTINES.
C    EACH BUFFER IS THE SIZE OF A RECORD IN THE DIRECT ACCESS FILE AND
C    IS DESCRIBED BY A HEADER. THE HEADERS FORM A LINKED LIST. FOR
C    PERFORMANCE REASONS UNDER VMS THE HEADERS HAVE BEEN PLACED AT
C    THE BEGINNING OF THE ARRAY AND THE BUFFERS HAVE BEEN PAGE-ALIGNED
C
C -- THE FORMAT OF THE HEADERS IS :-
C
C      WORD       CONTENTS
C      0          UNIT NUMBER FOR THIS RECORD
C      1          LINK FORWARD ( -10000000 AT END )
C      2          RECORD NUMBER
C      3          READ/WRITE INDICATOR
C                        0      READ ONLY
C                        1      WRITE PENDING
C      4          ADDRESS OF CORRESPONDING BUFFER
C
C      THE SPACE AVAILABLE FOR DISC BUFFERING AND THE NUMBER OF
C      BUFFERS REQUIRED CAN BE SPECIFIED USING THE VARIABLES
C      'ISSBFS' AND 'ISSNBF' IN COMMON BLOCK /XSSVAL/
C
C--
\XLINK
\XDISCB
\XCONST
\XUNITS
\XSSVAL
\XERVAL
\XIOBUF
C
      DATA IHDRLN / 5 /
C
\QDISCB
C
C--SET THE NUMBER OF WORDS PER BLOCK EQUAL TO THE NUMBER PER RECORD
C----- ZERO THE BUFFER
      CALL XZEROF(LINK, LINKDM)
C
      CALL XDACVI ( NWR , NWDBLI , NBYWDI )
      NWB = NWR
C
C -- ASSIGN NEXT FREE ADDRESS IN ARRAY AND ADDRESS OF FIRST LINK
      IFREE = 1
      ILINK1 = 1
C -- CALCULATE THE SPACE REQUIRED FOR THE HEADERS IN WORDS AND PAGES
      IHDRSP = ( ISSNBF + 1 ) * IHDRLN
      IHDRPG = ( IHDRSP + ISSPAG - 1 ) / ISSPAG
      IFREE = IFREE + ( IHDRPG * ISSPAG )
C -- CALCULATE SPACE REQUIRED FOR BUFFERS IN WORDS
      IBUFPG = ( NWB + ISSPAG - 1 ) / ISSPAG
      IBUFSZ = IBUFPG * ISSPAG
      IBUFSP = ( ISSNBF ) * IBUFSZ
C
      ITEMP = IFREE+IBUFSP-1
      IF ( ( ITEMP ) .GT. ISSBFS ) GO TO 9910
C -- BEGIN CREATING HEADERS
      I = ILINK1 + IHDRLN
      J = ILINK1
      LINK(J) = NOWT
C
      DO 1100 ICOUNT = 1, ISSNBF
C
      LINK(J+1) = I
C
      LINK(I) = NOWT
      LINK(I+2) = NOWT
      LINK(I+3) = 0
      LINK(I+4) = IFREE
      IFREE = IFREE + IBUFSZ
      J = I
      I = I + IHDRLN
1100  CONTINUE
C
      LINK(J+1) = NOWT
      IACC = 1
      LLU = IFREE
C
      IADD1 = ILINK1
C
      RETURN
C
9910  CONTINUE
      WRITE ( CMON, 9915 ) ITEMP, ISSBFS, ISSNBF
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(A)' ) CMON(1)
      WRITE ( NCAWU , '(A)' ) CMON(1)
9915  FORMAT (' Insufficient space allocated for disc buffers',3I6)
      CALL XERHND ( IERPRG )
      RETURN
C
C
      END
C
CODE FOR XFINDB
      SUBROUTINE XFINDB
C--FIND THE REQUIRED DISC BUFFER
C
C--ARGUMENTS ARE IN THE COMMON BLOCK 'XDISC' :
C
C  IADD1  FIRST BUFFER WORD IN 'LINK'
C  NFWD   CURRENT DISC ADDRESS
C  NWD    NUMBER OF WORDS LEFT TO TRANSFER
C  NV     CURRENT POSITION IN THE INPUT OR OUTPUT ARRAY
C
C--THE ABOVE VARIABLES ARE SET ON ENTRY, AND RESET AS NECESSARY ON EXIT.
C
C--THE FOLLOWING VARIABLES ARE ALSO SET ON EXIT :
C
C  I  ADDRESS OF THE CURRENT BUFFER
C  J  ADDRESS OF THE FIRST WORD IN THE BUFFER FOR DATA
C  K  NUMBER OF WORDS TO BE TRANSFERED.
C
C--THE FOLLOWING VARIABLES MUST NOT BE CHANGED :
C
C  L
C  M
C  N
C--
\XLINK
\XDISC
\XDISCB
\XUNITS
\XSSVAL
\XERVAL
\XSTATS
\XIOBUF
C
\QDISCB
C
C--CHECK IF THE BUFFERS HAVE BEEN ALLOCATED
      IF ( IACC .LT. 0 ) GO TO 9910
C--CALCULATE THE RECORD NUMBER ETC. OF TRANSFERS TO BE MADE
      NR=NFWD/NWB
      N=NFWD-NR*NWB
C--SEARCH THROUGH THE BUFFER LIST FOR FREE BUFFERS AND/OR THE BUFFER
C  CONTAINING THIS RECORD
      I=LINK(IADD1+1)
      J=IADD1
      NBUFFR = 0
C--CHECK IF THIS BUFFER IS FOR THE CORRECT UNIT
1150  CONTINUE
      NBUFFR = NBUFFR + 1
      IF(LINK(I)-NU)1250,1200,1250
C--CHECK IF THIS IS THE CORRECT BUFFER
1200  CONTINUE
      IF ( LINK(I+2) .NE. NR ) GO TO 1250
      ICACHE = ICACHE + 1
      NCACHE(NBUFFR) = NCACHE(NBUFFR) + 1
      GO TO 1550
C
C--CHECK FOR A FREE BUFFER WHICH ALSO INDICATES THE END OF THE STACK
1250  CONTINUE
      IF(LINK(I+2))1500,1300,1300
C--CHECK IF THIS IS THE LAST BUFFER
1300  CONTINUE
      IF(LINK(I+1))1400,1400,1350
C--PICK UP THE NEXT BUFFER
1350  CONTINUE
      J=I
      I=LINK(I+1)
      GOTO 1150
C--REWRITE THE CONTENTS OF THE LAST BUFFER TO THE DISC IF NEC.
1400  CONTINUE
      IF(LINK(I+3))1450,1500,1500
1450  CONTINUE
      M=LINK(I+2)
      IPWRIT = IPWRIT + 1
      IBUFFR = LINK(I+4)
C -- TRANSFER DATA AND CHECK FOR ERRORS
      ISTAT = KSTORE ( LINK(I) , M , LINK(IBUFFR) , ISSRLI )
      IF ( ISTAT .LT. 0 ) GO TO 9920
      LINK(I+3)=0
C--FETCH THE RECORD OF INTEREST
1500  CONTINUE
      LINK(I)=NU
      LINK(I+2)=NR
      IPREAD = IPREAD + 1
      IBUFFR = LINK(I+4)
C -- TRANSFER DATA AND CHECK FOR ERRORS
      ISTAT = KFETCH ( LINK(I) , NR , LINK(IBUFFR) , ISSRLI )
      IF ( ISTAT .LT. 0 ) GO TO 9920
C--SWITCH THIS BUFFER TO THE TOP OF THE BUFFER STACK
C  ALL OTHER BUFFERS ARE FORCED ONE DOWN THE STACK , SO THAT THE
C  LEAST USED ONE ENDS UP AT THE END
1550  CONTINUE
      LINK(J+1)=LINK(I+1)
      LINK(I+1)=LINK(IADD1+1)
      LINK(IADD1+1)=I
C--CALCULATE THE NUMBER OF WORDS THAT CAN BE TRANFERED FROM THIS BUFFER
      J = LINK(I+4) + N
C
      K=MIN0(NWD,NWB-N)
      NWD=NWD-K
      NFWD=NFWD+K
      RETURN
C
9910  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9915 )
      ENDIF
      WRITE ( NCAWU , 9915 )
      WRITE ( CMON, 9915 )
      CALL XPRVDU(NCEROR, 1,0)
9915  FORMAT ( 1X , 'No buffers allocated to disc routines' )
      CALL XERHND ( IERPRG )
      RETURN
9920  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9925 )
      ENDIF
      WRITE ( NCAWU , 9925 )
      WRITE ( CMON, 9925 )
      CALL XPRVDU(NCEROR, 1,0)
9925  FORMAT ( 1X , 'Disc transfer ended in error' )
      CALL XERHND ( IERSEV )
      RETURN
C
      END
C
CODE FOR XDUMP
      SUBROUTINE XDUMP
C
C -- THIS ROUTINE PROVIDES A LINK TO THE NEW ROUTINE 'KDUMP'
C
\XERVAL
C
      DATA IN / 0 /
C
      ISTAT = KDUMP ( IN )
      IF ( ISTAT .LT. 0 ) CALL XERHND ( IERSEV )
C
      RETURN
C
      END
C
C
C
CODE FOR KDUMP
      FUNCTION KDUMP ( IN )
C
C--REWRITE ALL BUFFERS MARKED FOR WRITING TO THE DISC
C
C      IN      DUMMY VALUE ( IGNORED )
C
C -- RETURN VALUES :-
C
C      -VE      ERROR REWRITING DISC BUFFERS
C      +VE      SUCCESS
C
\XLINK
\XDISCB
\XUNITS
\XSSVAL
\XSTATS
C
      IDWZAP = IN
\QDISCB
C
C -- SET ERROR FLAG CLEAR
      IERROR = 1
C
C--CHECK IF ANY BUFFERS ARE ALLOCATED
      IF(IACC)1250,1000,1000
C--LINK INTO THE FIRST BUFFER
1000  CONTINUE
      I=LINK(IADD1+1)
      J=-1
C--CHECK IF THE BUFFER REQUIRED WRITING
1050  CONTINUE
      IF(LINK(I+3))1100,1150,1150
C--WRITE THE BUFFER OUT
1100  CONTINUE
      J=LINK(I+2)
      IBUFFR = LINK(I+4)
C
      IPWRIT = IPWRIT + 1
      ISTAT = KSTORE ( LINK(I) , J , LINK(IBUFFR)  , ISSRLI )
      IF ( ISTAT .LT. 0 ) IERROR = ISTAT
      LINK(I+3)=0
C--CHECK IF THIS IS THE LAST BUFFER
1150  CONTINUE
      IF(LINK(I+1))1250,1250,1200
1200  CONTINUE
      I=LINK(I+1)
      GOTO 1050
1250  CONTINUE
C -- SET RETURN VALUE
      KDUMP = IERROR
      RETURN
      END
C
CODE FOR KNWR
      FUNCTION KNWR(IN)
C--NUMBER OF WORDS PER RECORD
C
C
C--
\XSSVAL
C
      IDWZAP = IN
      KNWR = ISSRLI
C
      RETURN
      END
C
CODE FOR KNWRF
      FUNCTION KNWRF(IN)
C--NUMBER OF FLOATING POINT NUMBERS PER RECORD
C
C
C--
\XSSVAL
C
      IDWZAP = IN
      KNWRF = ISSRLF
C
      RETURN
      END
C
CODE FOR XFETCH
      SUBROUTINE XFETCH(NU,I,J,K)
C
C -- **** DUMMY ROUTINE ****
C
      NU = NU
      I = I
      J = J
      K = K
C      STOP 'XFETCH'
      CALL GUEXIT(2007)
C
      END
C
C
C
CODE FOR KFETCH
      FUNCTION KFETCH ( NU , I , J , NWORD )
C
C -- THIS ROUTINE TRANSFERS DATA FROM A DIRECT ACCESS FILE
C--FETCH DATA FROM THE DISC  -  THIS LINK CONTROLS THE DISC
C
C  NU UNIT TO BE USED FOR THE TRANSFER
C  I  DISC ADDRESS OF THE INFORMATION IN USER RECORDS
C  J  INTEGER ARRAY INTO WHICH THE DATA GOES
C   NWORD  NUMBER OF WORDS TO TRANSFER
C
C
C
C -- RETURN VALUES :-
C
C      -VE ERROR DURING TRANSFER . MESSAGE PRINTED
C      +VE SUCCESS
C
C
C**THIS LINK IS MACHINE SPECIFIC AS IT RELATES THE
C  THE LENGTH OF RECORDS SEEN BY THE USER TO THE LENGTH
C  OF HARDWARE BLOCKS ON THE DISC
C
C--
C
C -- VARIABLES USED TO CONTROL AUTOMATIC DISC EXTENSION :-
C
C      STORED IN COMMON BLOCK /XDAVAL/ . INITIAL VALUES SET IN 'CRYBLK'
C      ALL DISC SIZES ARE IN RECORDS.
C
C      IDAINI      INITIAL DISC SIZE
C      IDATOT      CURRENT TOTAL DISC SIZE ( -1 IF NOT KNOWN )
C      IDAMAX      MAXIMUM DISC SIZE ( 0 - NO MAXIMUM )
C      IDAMIN      MINIMUM DISC SIZE
C
C      IDAAUT      AUTOMATIC EXTENSION CONTROL
C                        0      NO AUTOMATIC EXTENSION
C                        1      AUTOMATIC EXTENSION ENABLED
C      IDAQUA      EXTENSION QUANTITY ( IF 0 , EXTEND TO REQUIRED SIZE)
C      IDATRY      NUMBER OF TRIES AT EXTENSION BEFORE ERROR SIGNALLED.
C                  A VALUE OF ZERO WILL STOP EXTENSION
C
C -- VARIABLES LOCAL TO THIS ROUTINE :-
C
C      IDAERR      NUMBER OF RETRIES REMAINING. WHEN THIS BECOMES ZERO
C                  AN ERROR IS SIGNALLED.
C
C
C
      DIMENSION J(NWORD)
C
\XUNITS
\XSSVAL
\XERVAL
\XDAVAL
\XIOBUF
C
C
C
C
      KFETCH = 1
C
      N = I + 1
C
      IDAERR = IDATRY
      IF ( IDAAUT .LE. 0 ) IDAERR = 0
C
C
1000  CONTINUE
C
          READ ( NU, REC = N, ERR = 2000, IOSTAT = IOS ) J
          IF (IOS .NE. ISSOKF) GOTO 2000
      RETURN
C
C--TRANSFER ERROR
2000  CONTINUE
C
      IF ( IDAERR .LE. 0 ) GO TO 9900
      IDAERR = IDAERR - 1
C
      CALL XDAEND ( NU , INEXT )
C
      IF ( IDAQUA .GT. 0 ) GO TO 2020
      IREQ = ( N - INEXT ) + 1
      IDAERR = 0
      GO TO 2030
C
2020  CONTINUE
      IREQ = IDAQUA
C
2030  CONTINUE
C
      CALL XDAXTN ( NU , INEXT , IREQ )
      IDATOT = INEXT + IREQ - 1
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 2110) NU , IREQ
      ENDIF
      WRITE ( NCAWU , 2110 ) NU , IREQ
2110  FORMAT ( 1X , ' Disc file on unit ' , I3 , ' extended by ' ,
     1 I5 , ' records ' )
C
      GO TO 1000
C
C
9900  CONTINUE
C
C -- REPEATED READ ERROR ON THIS UNIT
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU,9910 ) NU , N
      ENDIF
      WRITE ( NCAWU,9910 ) NU , N
      WRITE ( CMON, 9910 ) NU, N
      CALL XPRVDU(NCEROR, 2,0)
9910  FORMAT ( 1X , 'Fatal read error on unit ' , I3 ,
     1 ' -- record ', I8, /, ' You may need to extend your DISC file')
      CALL XERIOM ( NU , IOS )
      GO TO 9990
C
9990  CONTINUE
C -- ERROR EXIT FROM THIS ROUTINE
      KFETCH = ISIGN ( IOS , -1 )
      RETURN
C
      END
C
CODE FOR XSTORE
      SUBROUTINE XSTORE(NU,I,J,K)
C
C -- **** DUMMY ROUTINE ****
C
      NU = NU
      I = I
      J = J
      K = K
C      STOP 'XSTORE'
      CALL GUEXIT(2008)
C
      END
C
C
C
CODE FOR KSTORE
      FUNCTION KSTORE ( NU , I , J , NWORD )
C
C -- THIS ROUTINE WRITES DATA TO A DIRECT ACCESS FILE
C
C
C    NU    UNIT NUMBER FOR TRANSFER
C     I    RECORD NUMBER FOR TRANSFER ( 0 - END )
C     J    INTEGER ARRAY FROM WHICH DATA IS READ
C     NWORD NUMBER OF WORDS TO TRANSFER
C
C      RETURN VALUES :-
C
C      -VE      ERROR DURING TRANSFER - MESSAGE HAS BEEN PRINTED
C      +VE      SUCCESS
C
C**THIS LINK IS MACHINE SPECIFIC AS IT RELATES THE
C  THE LENGTH OF RECORDS SEEN BY THE USER TO THE LENGTH
C  OF HARDWARE BLOCKS ON THE DISC
C
C--THE TRANSFER IS ROUNDED UP TO FILL ONE OR MORE DISC BLOCKS
C
C
C
      DIMENSION J(NWORD)
C
\XUNITS
\XSSVAL
\XIOBUF
C
C
      KSTORE = 1
C
      N = I + 1
C
      WRITE ( NU , REC = N , ERR = 100 , IOSTAT = IOS ) J
      IF (IOS .NE. ISSOKF) GOTO 100
      RETURN
100   CONTINUE
       WRITE(NCAWU,200) NU,N
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,200) NU,N
      ENDIF
      WRITE ( CMON, 200) NU,N
      CALL XPRVDU(NCEROR, 1,0)
200   FORMAT(' Write to unit ',I5,' fails for record ',I8)
      CALL XERIOM ( NU , IOS )
C
C
      KSTORE = ISIGN ( IOS , -1 )
      RETURN
C
      END
C
CODE FOR KINCRS
      FUNCTION KINCRS(IN)
C--CALCULATE THE INCREMENT FOR WRITING 'IN' 24 BIT WORDS
C
C**MACHINE SPECIFIC  -  INCREMENT FOR INTEGER WORDS
C
C--
      KINCRS=IN
      RETURN
      END
C
CODE FOR KINCRF
      FUNCTION KINCRF(IN)
C--CALCULATE THE INCREMENT FOR WRITING 'IN' FLOATING POINT WORDS
C
C**MACHINE SPECIFIC  -  INCREMENT FOR FLOATING POINT NUMBERS
C
C--
      KINCRF=IN
      RETURN
      END
C
C
C
C
CODE FOR KSWPDU
      FUNCTION KSWPDU ( IUNIT )
C
C -- ALTER DIRECT ACCESS FILE UNIT TO 'IUNIT' . THE PREVIOUS UNIT IS
C    RETURNED AS 'KSWPDU'
C
\XDISC
\XUNITS
\XIOBUF
C
C -- DUMP DATA MARKED TO BE REWRITTEN
C
      CALL XDUMP
C
      KSWPDU = NU
      NU = IUNIT
C
      RETURN
      END
C
C --
C
C
CODE FOR XDAINI
      SUBROUTINE XDAINI ( IDUNIT )
C
C -- INITIALISE THE NEW DIRECT ACCESS FILE ON UNIT 'IDUNIT'
C
C
\XDISC
      CHARACTER*10 NEWNAM
\XUNITS
\XSSVAL
\XDAVAL
\XIOBUF
C
      IDATOT = -1
      IREQ = MIN0 ( IDAINI , IDAQUA )
      IREQ = MAX0 ( IREQ , IDAMIN )
      IRECNO = 1
C
C -- WRITE A FEW RECORDS TO THE FILE
C
      CALL XDAXTN ( IDUNIT , IRECNO , IREQ )
      IDATOT = IRECNO + IREQ -  1
C
C -- INITIALISE FILE AND CURRENT LIST INDEXES
C
      NSAVEU = KSWPDU ( IDUNIT )
C
      CALL XSETFI
      CALL XSETLI
C
      N = KSWPDU ( NSAVEU )
C
      CALL XDANAM ( IDUNIT , NEWNAM )
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1010 ) IDUNIT , NEWNAM
      ENDIF
      WRITE ( NCAWU , 1010 ) IDUNIT , NEWNAM
1010  FORMAT ( // , 1X , 72 ( '*' ) , / ,
     2 1X , 'A new direct access file has been created ' ,
     3 'on unit ' , I3 , ' -- ' , A10 , ' file' , / ,
     4 1X , 72 ( '*' ) , // )
      WRITE ( CMON, 1011 ) IDUNIT , NEWNAM
      CALL XPRVDU(NCVDU, 1,0)
1011  FORMAT( 1X , 'A new direct access file has been created ' ,
     2 'on unit ' , I3 , ' -- ' , A10 , ' file')
C
      RETURN
      END
C
C --
C
CODE FOR XDAXTN
      SUBROUTINE XDAXTN ( IUNIT,IBEGIN,ICOUNT )
C
C -- WRITE 'ICOUNT' RECORDS TO DISC FILE ON UNIT 'IUNIT'
C    STARTING AT RECORD 'IBEGIN'
C
C
C
C -- IF IT IS NOT POSSIBLE TO WRITE NEW RECORDS TO A DIRECT ACCESS
C    FILE, REPLACE THIS ROUTINE WITH A SUITABLE DUMMY. IT WILL BE
C    NECESSARY IN THIS CASE TO PROVIDE A METHOD OF EXTENDING DISC
C    FILES MANUALLY, AS WELL AS A MEANS OF CREATING NEW DIRECT ACCESS
C    FILES. THIS MIGHT BE DONE BY APPENDING A NEW SMALL FILE ONTO THE
C    EXISTING ONE.
C
C
\XUNITS
\XSSVAL
\XERVAL
\XDAVAL
\XIOBUF
C
C    IF IBEGIN IS LESS THAN OR EQUAL TO 0, THE END OF FILE WILL
C    BE SEARCHED FOR.
C
C -- IBEGIN MAY BE A CONSTANT AND SO SHOULD NOT BE MODIFIED
C
      ISTART = IBEGIN
C
      IF ( ISTART .LT. 0 ) CALL XDAEND ( IUNIT,ISTART )
C
C -- NO OPERATION
      IF ( ICOUNT .LE. 0 ) GO TO 8000
C
      IEND = ISTART + ICOUNT - 1
      IF ( IDAMAX .LE. 0 ) GO TO 1900
      IF ( IEND .GT. IDAMAX ) GO TO 9920
1900  CONTINUE
C
      DO 2000 I=ISTART,IEND
      WRITE ( IUNIT , REC = I , ERR = 9900 , IOSTAT = IOS ) I
      IF (IOS .NE. ISSOKF) GOTO 9900
2000  CONTINUE
C
8000  CONTINUE
      RETURN
C
9900  CONTINUE
C -- ERROR WHILE EXTENDING DISC FILE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9910 ) IUNIT
      ENDIF
      WRITE ( NCAWU , 9910 ) IUNIT
      WRITE ( CMON, 9910 ) IUNIT
      CALL XPRVDU(NCEROR, 1,0)
9910  FORMAT ( 1X , 'An error has occured while extending file ' ,
     1 'on unit ' , I3 )
      CALL XERIOM ( IUNIT , IOS )
      CALL XERHND ( IERCAT )
9920  CONTINUE
C -- SIZE TOO GREAT
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9925 ) IUNIT
      ENDIF
      WRITE ( NCAWU , 9925 ) IUNIT
      WRITE ( CMON, 9925 ) IUNIT
      CALL XPRVDU(NCEROR, 1,0)
9925  FORMAT ( 1X , 'The maximum size of the file on unit ' , I3 ,
     2 ' has been exceeded' )
      CALL XERHND ( IERCAT )
      GO TO 9900
      END
C
C
C
CODE FOR KDAFRE
      FUNCTION KDAFRE ( IUNIT , IEND , IFREE )
C
C -- THIS ROUTINE EXSURES THAT THE DISC FILE ON UNIT 'IUNIT' HAS
C    AT LEAST 'IFREE' RECORDS FREE
C
C    IF 'IFREE' IS LESS THAN OR EQUAL TO 0,CONTROL RETURNS IMMEDIATELY
C    IF IEND IS LESS THAN OR EQUAL TO 0 , THE END OF FILE IS DETERMINED
C      USING 'XDAEND'
C
C      RETURN VALUE IS NUMBER OF RECORDS ADDED
C
      IADD = 0
      IF ( IFREE .LE. 0 ) GO TO 9000
      LAST = IEND
      IF ( LAST .LE. 0 ) CALL XDAEND ( IUNIT , LAST )
C -- CALCULATE PRESENT USAGE IN RECORDS
      CALL XDACVI ( NWDRCI , NWDBLI , NBYWDI )
      IDWZAP = 0
      ILASTU = ( KNEXTF ( IDWZAP ) / NWDRCI ) + 1
      IUNUSE = LAST - ILASTU - 1
      IADD = MAX0 ( ( IFREE - IUNUSE ) , 0 )
C -- ADD REQUIRED EXTRA RECORDS TO FILE
      IF ( IADD .GT. 0 ) CALL XDAXTN ( IUNIT , LAST , IADD )
C
9000  CONTINUE
      KDAFRE = IADD
      RETURN
      END
C
C
CODE FOR XDANAM
      SUBROUTINE XDANAM ( IDUNIT , NAME )
C
C -- RETURNS A CHARACTER STRING 'NAME' WHICH IS THE TYPE OF THE FILE
C    ON UNIT 'IDUNIT'
C
      INTEGER IDUNIT
      CHARACTER*10 NAME
C
C
      CHARACTER*10 UNITNM(5)
C
\XUNTNM
C
      DATA UNITNM / '  Unknown ' , '   Data   ' , '  Command ' ,
     2              ' New data ' , '  Command ' /
C
      NUNITS = 5
C
      NAME = UNITNM(1)
C
      DO 2000 I = 1 , NUNITS
      IF (IUNITN(I) .EQ. IDUNIT ) NAME = UNITNM(I)
2000  CONTINUE
C
      RETURN
      END
C
C
C
CODE FOR XDAEXC
      SUBROUTINE XDAEXC
C
C -- INITIALISE CONTROL AREA FOR DIRECT ACCESS FILES
C
C
\XDAVAL
C
      IDATOT = -1
C
      RETURN
      END
C
C
C
CODE FOR XDASUM
      SUBROUTINE XDASUM ( IPUNCH )
C
C -- PRINT A SUMMARY OF DISC USAGE
C
      CHARACTER*8 CPLACE(3)
C
\XUNITS
\XSSVAL
\XCBVAL
\XIOBUF
C
      DATA CPLACE / ' In use ' , ' In file' , ' Free   ' /
C
      CALL XDACVI ( NWDRCI , NWDBLI , NBYWDI )
C
C -- **** TEMP ****
C
      IDWZAP = 0
      NWDUSE = KNEXTF ( IDWZAP )
      NRCFIL = -1
C
C      NWDUSE = KCBRDH ( ICBNFL )
C      NRCFIL = KCBRDH ( ICBMRN )
C
C -- **** TEMP ENDS ****
C
      NRCUSE = ( NWDUSE / NWDRCI ) + 1
      NBLUSE = ( NWDUSE / NWDBLI ) + 1
      NBYUSE = ( NWDUSE * NBYWDI )
      NKBUSE = ( NBYUSE / 1000 ) + 1
C
      NWDFIL = ( NRCFIL * NWDRCI )
      NBLFIL = ( NWDFIL / NWDBLI )
      NBYFIL = ( NWDFIL * NBYWDI )
      NKBFIL = ( NBYFIL / 1000 )
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1005 ) NWDUSE
      ENDIF
      WRITE ( NCAWU , 1005 ) NWDUSE
1005  FORMAT ( / , 1X , 'Next free disc address is ' , I7 , / ,
     1 11X , 'Records' , 5X, 'Blocks' , 7X , 'Kbytes' )
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1010 ) CPLACE(1) , NRCUSE , NBLUSE , NKBUSE
      ENDIF
      WRITE ( NCAWU , 1010 ) CPLACE(1) , NRCUSE , NBLUSE , NKBUSE
      IF(IPUNCH.EQ.1)WRITE(NCPU,1010) CPLACE(1),NRCUSE,NBLUSE,NKBUSE
1010  FORMAT ( 1X , A , 4X , I5 , 5X , I5 , 8X , I5 )
C
      IF ( NRCFIL .LE. 0 ) GO TO 9000
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1010 ) CPLACE(2) , NRCFIL , NBLFIL , NKBFIL
      ENDIF
      WRITE ( NCAWU , 1010 ) CPLACE(2) , NRCFIL , NBLFIL , NKBFIL
C
9000  CONTINUE
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9005 )
      ENDIF
      WRITE ( NCAWU , 9005 )
9005  FORMAT ( / )
C
      RETURN
      END
C
C
C
CODE FOR XDACVF
      SUBROUTINE XDACVF ( NWDRCF , NWDBLF , NBYWDF )
C -- THIS ROUTINE RETURNS THE FOLLOWING CONVERSION FACTORS :-
C
C      NWDRCF   NUMBER OF FLOATING POINT WORDS PER DISC RECORD
C      NWDBLF   NUMBER OF FLOATING POINT WORDS PER DISC BLOCK
C      NBYWDF   NUMBER OF BYTES PER FLOATING POINT WORD
C
C
\XSSVAL
C
C
      NWDRCF = ISSRLF
      NWDBLF = ISSBLF
      NBYWDF = ISSWLF
C
      RETURN
      END
C
C --
C
CODE FOR XDACVI
      SUBROUTINE XDACVI ( NWDRCI , NWDBLI , NBYWDI )
C -- THIS ROUTINE RETURNS THE FOLLOWING CONVERSION FACTORS :-
C
C      NWDRCI   NUMBER OF INTEGER WORDS PER DISC RECORD
C      NWDBLI   NUMBER OF INTEGER WORDS PER DISC BLOCK
C      NBYWDI   NUMBER OF BYTES PER INTEGER WORD
C
C
\XSSVAL
C
C
      NWDRCI = ISSRLI
      NWDBLI = ISSBLI
      NBYWDI = ISSWLI
C
      RETURN
      END
C
C
C
CODE FOR KCBRDH
      FUNCTION KCBRDH ( IOFF )
C
C
C -- READ VALUE AT OFFSET 'IOFF' IN DISC CONTROL BLOCK
C
C      VARIABLES USED :-
C
C      ICBHDR(N)   CONTAINS FIRST N WORDS OF CONTROL BLOCK. THE HEADER
C      ICBDIM      THE LENGTH OF THE HEADER ( = 9 )
C      ICBLDD      THE LOAD FLAG. -VE HEADER IS NOT LOADED. +VE HAS
C                  BEEN LOADED.
C      ICBDAD      DISK ADDRESS OF CONTROL BLOCK. ( = 0 )
C
C      VARIABLES CONTAINING OFFSETS IN DISC CONTROL BLOCK HEADER :-
C
C      ICBNFL      NEXT FREE DISC LOCATION
C      ICBMRN      HIGHEST RECORD NUMBER IN FILE
C      ICBFIN      DISC ADDRESS OF FIRST FILE INDEX BLOCK
C      ICBDEQ      DEFAULT EXTENSION QUANTITY
C      ICBCIN      DISC ADDRESS OF CURRENT LIST INDEX
C      ICBMAX      MAXIMUM SIZE OF FILE ( RECORDS )
C      ICBTTL      DISC ADDRESS OF TITLE
C      ICBAUT      AUTOMATIC EXTENSION FLAG
C      ICBLNF      LENGTH OF FILE INDEX BLOCK
C
\XDISC
\XUNITS
\XSSVAL
\XCBVAL
\XERVAL
\XOPVAL
\XIOBUF
C
      IF ( ICBLDD .GE. 0 ) GO TO 2000
C -- LOAD CONTROL BLOCK HEADER
      CALL XDOWN ( ICBDAD , ICBHDR(1) , ICBDIM )
C -- CHECK VALUES
      DO 1990 I = 1 , ICBDIM , 2
      IF ( ICBHDR(I) .LE. 0 ) GO TO 9910
1990   CONTINUE
      ICBLDD = 1
C
      IF ( ICBHDR(ICBMRN) .GT. 0 ) GO TO 2000
      CALL XDAEND ( NU , NEXTRC )
      ICBHDR(ICBMRN) = NEXTRC - 1
C
2000  CONTINUE
C -- CHECK THAT REQUEST WAS VALID
      IF ( IOFF .LE. 0 ) GO TO 9920
      IF ( IOFF .GT. ICBDIM ) GO TO 9920
      KCBRDH = ICBHDR(IOFF)
      RETURN
C
9910  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9915 )
      ENDIF
      WRITE ( NCAWU , 9915 )
      WRITE ( CMON, 9915 )
      CALL XPRVDU(NCEROR, 1,0)
9915  FORMAT (1X, 'Disc file is corrupt or not a CRYSTALS .DSC file')
      CALL XERHND ( IERPRG )
9920  CONTINUE
      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
      KCBRDH = 0
      RETURN
      END
