C $Log: not supported by cvs2svn $
C Revision 1.4  2003/08/05 11:11:12  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.3  2001/02/26 10:30:23  richard
C Added changelog to top of file
C
C
CODE FOR XSPCGR
      SUBROUTINE XSPCGR
C
C -- THIS IS THE MAIN SUBROUTINE FOR THE 'SPACEGROUP' INSTRUCTION
C    PROVIDED BY ERIC GABE, NRCC, WITH PERMISSION TO DISTRIBUTE.
C
C -- THIS ROUTINE PROVIDES AN INTERFACE BETWEEN 'CRYSTALS' AND THE
C    ALLEN LARSON SPACEGROUP SYMBOL INTERPRETATION ROUTINE.
C
C      VERSION     DATE              BY          CHANGE
C      -------     ----              --          ------
C      1.00        JANUARY 1986      PWB         INITIAL VERSIONC
C      1.01        JUNE 1986         PWB         CORRECT HANDLING OF
C                                                NON-PRIMITIVE LATTICE
C                                                TRANSLATIONS
C      2.00        AUGUST 1990       DJW         UPDATE TO USE VOL 'A'
C                                                SG SYMBOLS, AND ADD
C                                                FOURIER LIMITS
C
C -- THE MAIN FUNCTIONS OF THIS ROUTINE ARE :-
C      COMMAND INPUT - NOTE SPECIAL PROCESSING REQUIRED FOR PARAMETER
C      TYPE 4.
C
C      SELECTING A UNIQUE AXIS BASED ON THE UNIT CELL, IF POSSIBLE
C
C      REFORMATTING THE SYMBOL TO USE THE UNIQUE AXIS ( ROUTINE XSPCFM )
C
C      DETERMINING THE MATRICES ( ROUTINE SGROUP AND OTHERS )
C
C      CONVERTING THE OUTPUT OF 'SGROUP' TO THE FORM REQUIRED FOR A
C      CRYSTALS LIST 2, AND WRITING THE RESULTS TO DISC.
C
C
C -- (SOME) LOCAL VARIABLES/PARAMETERS
C
C P    COSMIN      A CELL ANGLE WHOSE COSINE IS LESS THAN 'COSMIN' IS
C                  ASSUMED TO BE 90.0 DEGREES WHEN PERFORMING AUTOMATIC
C                  UNIQUE AXIS DETERMINATION
C
C P    MAXN2       MAXIMUM NUMBER OF MATRICES THAT CAN BE CALCULATED
C                  ( I.E. 24 )
C P    NWORK       SIZE OF WORK SPACE REQUIRED BY 'SGROUP'
C
C
C -- SGROUP PROVIDES SOME INFORMATION IN EITHER INTEGER FORM OR AS
C    AN ENCODED VALUE. APPROPRIATE TRANSLATIONS ARE MADE BY THIS ROUTINE
C
C
C
      PARAMETER ( NNPLAT = 7 )
C
      DIMENSION XNPLAT(NNPLAT)
C
      PARAMETER ( MAXN2 = 24 )
      PARAMETER ( NWORK = 1000 )
C
      CHARACTER *1 XYZ(3)
      CHARACTER*20 CBUFF1 , CBUFF2
      PARAMETER ( NBUFF2 = 10 )
C
C
      PARAMETER ( COSMIN = 0.003 )
C
      DIMENSION  RMI(3), RMA(3), ABC(6), JAXIS(3)
C
      DIMENSION TRANS(0:10)
      PARAMETER ( SIXTH =  1. / 6. , THIRD  = 1. / 3. )
      PARAMETER ( TWOTHD = 2. / 3. , FIVSXT = 5. / 6. )
C
\ISTORE
\ICOM02
\ICOM14
C
\STORE
\XLST01
\XLST02
\XLST14
\XCARDS
\XCHARS
\XLISTI
\XUNITS
\XSSVAL
\XERVAL
\XOPVAL
\XIOBUF
C
\QSTORE
\QLST02
\QLST14
C
C
C
C
      DATA XYZ /'X', 'Y', 'Z' /
      DATA XNPLAT / 1. , 5. , 6. , 7. , 2. , 4. , 3. /
C
      DATA IDIMBF / 2 /
      DATA IVERSN / 200 /
C
C
      DATA TRANS / 0.00          , 0.00 ,
     2             SIXTH         , 0.25 ,
     3             THIRD         , 0.00 ,
     4             0.50          , 0.00 ,
     5             TWOTHD        , 0.75 ,
     6             FIVSXT        /
C
C
C
      CALL XTIME1 ( 2 )
C
CMAR98
      ICOMBF = KSTALL ( IDIMBF )
      CALL XZEROF (STORE(ICOMBF), IDIMBF)
C
\IDIM02
\IDIM14
C      INITIALISE THE COMMON BLOCKS
      IDWZAP = 0
      CALL XFILL (IDWZAP, ICOM02, IDIM02)
      CALL XFILL (IDWZAP, ICOM14, IDIM14)
C
      IULN = 2
C
C
C
C -- COMMAND INPUT SECTION - DONE 'BY HAND'
C
C -- READ DIRECTIVE CARD
1000  CONTINUE
      ISTAT = KRDNDC ( ISTORE(ICOMBF) , IDIMBF )
      IF ( ISTAT .LT. 0 ) THEN
        GO TO 2000
      ELSE IF ( ISTAT .EQ. 0 ) THEN
        CALL XMONTR ( 0 )
        GO TO 1000
      ENDIF
C
      IF ( ISTAT .EQ. 1 ) THEN
C
C -- SEARCH FOR THE PARAMETER KEYWORD
C
        IDWZAP = 0
        IF ( KFNDNP(IDWZAP) .LE. 0 ) GO TO 9810
C
C -- STORE AWAY SYMBOL
C
        NC = KNEQUL ( NC , IB )
        IF ( NC .LE. 0 ) GO TO 9810
        IF ( NC .GT. LASTCH ) GO TO 9810
      ISIZE = MIN0 ( LASTCH - NC + 1 , LEN ( CBUFF1 ) )
        WRITE ( CBUFF1 , '(20A1)' ) ( IMAGE(J), J = NC, NC + ISIZE - 1 )
        NC = LASTCH + 1
        GO TO 1000
      ENDIF
C
C -- NORMAL DIRECTIVE. READ THE PARAMETER VALUE
1050  CONTINUE
      IDWZAP = 0
      IF ( KFNDNP ( IDWZAP ) .LE. 0 ) GO TO 1000
      ISTAT = KRDPV ( ISTORE(ICOMBF) , IDIMBF )
      IF ( ISTAT .LT. 0 ) GO TO 1000
      IF ( ISTAT .EQ. 0 ) GO TO 1050
      GO TO 9820
C
C
C
2000  CONTINUE
C
C
C
C -- INPUT COMPLETED
C
C -- CHECK FOR ERRORS DURING INPUT
C
      IF ( LEF .GT. 0 ) GO TO 9930
      IF ( IERFLG .LT. 0 ) GO TO 9900
C
      IUNIQU = ISTORE(ICOMBF+1)
      ISPECI = 1
C
C -- RESET STORE AFTER INPUT PHASE
C
      CALL XCSAE
      CALL XRSL
C
C----- TRY TO LOAD LIST 1
        IF ( KEXIST ( 1 ) .GT. 0 ) THEN
          CALL XFAL01
      IF ( IERFLG .LT. 0 ) GO TO 9900
            ABC(1) = STORE(L1P1  )
            ABC(2) = STORE(L1P1+1)
            ABC(3) = STORE(L1P1+2)
            ABC(4) = ABS ( COS ( STORE(L1P1+3) ) )
            ABC(5) = ABS ( COS ( STORE(L1P1+4) ) )
            ABC(6) = ABS ( COS ( STORE(L1P1+5) ) )
      ELSE
C-----      SET DUMMY CELL PARAMETERS
            ABC(1) = 10.
            ABC(2) = 10.
            ABC(3) = 10.
            ABC(4) = 0.
            ABC(5) = 0.
            ABC(6) = 0.
      ENDIF
C
C --  CHECK UP ON UNIQUE AXIS SPECIFIED. IF 'AUTOMATIC' WAS SELECTED,
C     TRY DETERMINING UNIQUE AXIS FROM LIST 1.
C
      IF ( IUNIQU .EQ. 0 ) THEN
        IUNIQU = 2
        ISPECI = 3
      DO 2100 I = 1,3
        IF ( ABC(3+I) .GT. COSMIN ) THEN
            IUNIQU = I
            ISPECI = 2
        ENDIF
2100      CONTINUE
      ENDIF
C
C -- REFORMAT INPUT SYMBOL ( DOES NOTHING AT THE MOMENT ). CONVERT
C    CHARACTER DATA BACK INTO INTEGERS, FOR USE WITH INTERPRETATION
C    ROUTINE
C
C
      CALL XSPCFM ( CBUFF1 , IUNIQU , ISPECI , CBUFF2 )
      IF ( IERFLG .LT. 0 ) GO TO 9900
C
C -- ALLOCATE BUFFER AND FILL WITH SPACES. LOAD SYMBOL INTO BUFFER
C
      LBUFF2 = KSTALL ( NBUFF2 )
      CALL XFILL ( IB , ISTORE(LBUFF2) , NBUFF2 )
C
      READ ( CBUFF2, '(10A1)' ) (ISTORE(J), J = LBUFF2, LBUFF2+NBUFF2-1)
C
C -- SET VARIABLES TO ASSUMED MAXIMUM VALUES.
C
      N2 = MAXN2
      N2I = MAXN2
      N2T = MAXN2
C
C -- ALLOCATE SPACE FOR THE NEW LIST 2
      CALL XCELST ( IULN , ICOM02 , IDIM02 )
C----- PACK THE SYMBOL INTO LIST 2
      CALL XSAVSG( LBUFF2, NBUFF2)
      IF (IERFLG .LT. 0) GOTO 9900
C
C -- ALLOCATE WORK SPACE REQUIRED BY INTERPRETATION ROUTINE
C
      IWORK = KSTALL ( NWORK )
C
C -- CALL THE SYMBOL INTERPRETATION ROUTINE
C
      CALL SGROUP ( STORE(LBUFF2) ,
     2 LAUENO , NAXIS , NCENT , LCENT ,
     3 N2 , NPOL , STORE(L2) ,
     4 STORE(L2P) , N2P ,
     5 NCAWU , NCAWU , STORE(IWORK))
C
      IF ( IERFLG .LT. 0 ) GO TO 9900
C
C----  FIND THE FOURIER LIMITS
      CALL XZEROF (RMI, 3)
      CALL XZEROF (RMA, 3)
      CALL   CDFOUN (LAUENO, NCENT, N2, N2P, ABC, ISTORE(L2),
     1 ISTORE(L2P), SPG, RMI, RMA, JAXIS )
C
C
C----- LOAD LIST 14 FOR UPDATING
      CALL XFAL14
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU, 2400)
      ENDIF
2400  FORMAT(/,1X, '   Fourier limits are :-')
C----- STORE REAL CELL LIMITS
      M14 = L14
      DO 2600 J = 1, 3
        DO 2550 L = 1, 3
            IF (JAXIS(L) .EQ. J) THEN
              STORE(M14  ) = RMI(JAXIS(L))
              STORE(M14+2) = RMA(JAXIS(L))
      IF (ISSPRT .EQ. 0) THEN
c              write(ncwu, '(a)') ' testing'
              WRITE(NCWU,2410) XYZ(J), STORE(M14), STORE(M14+2)
      ENDIF
2410  FORMAT(30X, A1, ' axis from ', F6.3, ' to ', F6.3)
            ENDIF
2550    CONTINUE
        M14 = M14 + MD14
2600  CONTINUE
C
C----- THE SORT DIRECTIONS
      DO 2650 J = 1,3
        ISTORE(L14O +J-1) = JAXIS(J)
2650  CONTINUE
C
C
C----  FIND THE PATTERSON LIMITS
      CALL XZEROF (RMI, 3)
      CALL XZEROF (RMA, 3)
C----- COPY THE SYMMETRY MATRICES, REMOVING THE TRANSLATIONAL PARTS
      CALL XMOVE(ISTORE(L2), ISTORE(IWORK), 288)
      J = IWORK + 9
      DO 2500 I = 1,24
            CALL XZEROF(ISTORE(J), 3)
            J = J + 12
2500  CONTINUE
      CALL   CDFOUN (LAUENO, 1, N2, N2P, ABC, ISTORE(IWORK),
     1 ISTORE(L2P), SPG, RMI, RMA, JAXIS )
C
C----- THE PATTERSON LIMITS - IN SAME ORDER AS REAL CELL
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU, 2420)
      ENDIF
2420  FORMAT(/,1X, '  Patterson limits are :-')
C
      M14P = L14P
      DO 2750 J = 1, 3
        DO 2700 L = 0, 2
            IF (ISTORE(L14O+L) .EQ. J) THEN
                  STORE(M14P  ) = RMI(J)
                  STORE(M14P+2) = RMA(J)
      IF (ISSPRT .EQ. 0) THEN
              WRITE(NCWU,2410) XYZ(J), STORE(M14P), STORE(M14P+2)
      ENDIF
            ENDIF
2700    CONTINUE
        M14P = M14P + MD14P
2750  CONTINUE
C
C -- ADJUST N2I AND N2T TO REFLECT ( POSSIBLY ) CHANGED VALUE OF N2
C
      N2I = N2
      N2T = N2
C
C -- CONVERT OPERATORS TO REAL FORM, TRANSLATE CODES FOR TRANSLATIONAL
C    PART, TRANSPOSE MATRIX
C
      M2 = L2 + ( N2 - 1 ) * MD2
      DO 5100 I = L2 , M2 , MD2
        DO 5050 J = I , I + 8
          STORE(J) = REAL ( ISTORE(J) )
5050    CONTINUE
C
        DO 5070 J = I + 9 , I + 11
          STORE(J) = TRANS ( ISTORE(J) )
5070    CONTINUE
C
        SAVE = STORE(I+3)
        STORE(I+3) = STORE(I+1)
        STORE(I+1) = SAVE
C
        SAVE = STORE(I+6)
        STORE(I+6) = STORE(I+2)
        STORE(I+2) = SAVE
C
        SAVE = STORE(I+7)
        STORE(I+7) = STORE(I+5)
        STORE(I+5) = SAVE
C
5100  CONTINUE
C
C
C -- CALCULATE INVERSE MATRICES
C
      M2 = L2
      M2I = L2I
      DO 5300 I = 1 , N2
        ISTAT = KINV2 ( 3 , STORE(M2) , STORE(M2I) , 9 , 0 ,
     2                  STORE(L2T) , STORE(L2T+3) , 3 )
        IF ( ISTAT .NE. 0 ) GO TO 9940
        STORE(M2I+9)=-STORE(M2+9)
        STORE(M2I+10)=-STORE(M2+10)
        STORE(M2I+11)=-STORE(M2+11)
        M2 = M2 + MD2
        M2I = M2I + MD2I
5300  CONTINUE
C
C -- CALCULATE AND STORE 'CONSTANTS'
C
      IC = NCENT
      G2 = REAL ( IC + 1 ) * REAL ( N2P )
      T2 = G2 * REAL ( N2 )
C
      STORE(L2C) = REAL ( IC )
      STORE(L2C+1) = XNPLAT ( LCENT )
      STORE(L2C+2) = G2
      STORE(L2C+3) = T2
C
C -- SAVE NEW LIST 2
      CALL XWLSTD ( IULN , ICOM02 , IDIM02 , -1 , 1 )
C -- SAVE NEW LIST 14
      CALL XWLSTD ( 14 , ICOM14 , IDIM14 , 0 , 1 )
C
      CALL XOPMSG( IOPSGP, IOPEND, IVERSN)
      CALL XTIME2 ( 2 )
C
      RETURN
C
C
9800  CONTINUE
      LEF = LEF + 1
      GO TO 1000
9810  CONTINUE
      CALL XMONTR(0)
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9815 )
      ENDIF
      WRITE ( CMON, 9815 )
      CALL XPRVDU(NCEROR, 1,0)
9815  FORMAT ( 1X, 'Illegal space group card. ' ,
     2 'The symbol should appear on the SPACE card.' )
      GO TO 9800
9820  CONTINUE
      CALL XMONTR(0)
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9825 )
      ENDIF
      WRITE ( CMON, 9825 )
      CALL XPRVDU(NCEROR, 1,0)
9825  FORMAT ( 1X , 'Parameter type is illegal for XSPCGR' )
      CALL XERHND ( IERPRG )
      GO TO 9800
C
C
9900  CONTINUE
      CALL XOPMSG (IOPSGP, IOPABN, 0)
      IDIRFL = -1
      RETURN
9930  CONTINUE
      CALL XOPMSG (IOPSGP, IOPCMI, 0)
      GO TO 9900
9940  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9945 )
      ENDIF
      WRITE ( CMON, 9945 )
      CALL XPRVDU(NCEROR, 1,0)
9945  FORMAT ( 1X , 'One of the calculated matrices failed to invert' )
      CALL XERHND ( IERPRG )
      GO TO 9900
      END
C
C
CODE FOR SGROUP
      SUBROUTINE SGROUP(SPG,LAUENO,NAXIS,NCENT,LCENT,NSYM,NPOL,JRT,
     $  CEN,NCV,LPT,LPTX,RT)
C
C
C
C----------------------------------------------------------------------
C       THIS PROGRAM WAS DEVELOPED FOR
C                  THE DIVISION OF CHEMISTRY
C                      OF
C             THE NATIONAL RESEARCH COUNCIL OF CANADA
C                      BY
C       ALLEN C. LARSON, P.O.BOX 5898, SANTA FE, NM 87502,USA
C----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C   THIS SR INTERPRETS THE SPACE GROUP SYMBOL
C   **NOTE**   Vol. A of Int Tab uses different symbols for cubic
C   2-July-87  space groups with -3 axes,
C              i.e. P n -3 n instead of P n 3 n.
C              The routine changes the symbol to the old form for
C              interpretation, but prints the new form.
C             DATA IN THE CALLING SEQUENCE ARE
C
C       SGP    INPUT  TEN WORDS CONTAINING THE SPACE GROUP SYMBOL 10A1
C       LAUENO OUTPUT THE LAUE GROUP NO.
C              1=1BAR, 2=2/M, 3=MMM, 4=4/M, 5=4/MM, 6=R3R, 7=R3MR,
C              8=3, 9=31M, 10=3M1, 11=6/M, 12=6/MMM, 13=M3 AND 14=M3M
C       NAXIS  OUTPUT UNIQUE AXIS IN MONOCLINIC SPACE GROUPS
C             = 4 ON ERROR EXITS
C       NCENT  OUTPUT 1BAR FLAG  (0/1) FOR (ACENTRIC/CENTRIC)
C       LCENT  OUTPUT LATTICE CENTERING NO.
C              1=P, 2=A, 3=B, 4=C, 5=I, 6=F AND 7=R
C       NSYM   OUTPUT THE NO. OF MATRICES GENERATED
C       JRT    OUTPUT THE NSYM (3,4,NSYM) MATRICES
C       CEN    OUTPUT THE LATTICE CENTERING VECTORS
C       NCV    OUTPUT THE NO. OF LATTICE CENTERING VECTORS
C       LPT    OUTPUT LISTING DEVICE FOR NORMAL OUTPUT.
C              IF .EQ.0 NO LISTING WILL BE PRODUCED
C       LPTX   OUTPUT LISTING DEVICE FOR ERROR LISTINGS
C       RT     SCRATCH ARRAY OF 500 WORDS NEEDED BY SGROUP
C-----------------------------------------------------------------------
C
C
C***********************************************************************
C
C                  CHANGES FOR 'CRYSTALS' VERSION
C
C      ARGUMENTS 'LPT' AND 'LPTX' TO THIS ROUTINE ARE IGNORED. OUTPUT
C      IS TO 'NCWU' AND 'NCAWU' AS APPROPRIATE
C
C      ROUTINES CALL 'XERHND' TO SIGNAL ERRORS.
C
C      ADD ',' TO FORMAT STATEMENTS WHERE NECESSARY. FORMAT STATEMENTS
C      MOVED NEXT TO APPROPRIATE 'WRITE' STATEMENT
C
C      IN SGERRS, ERROR MESSAGES ARE STORED IN CHARACTER VARIABLES
C
C      IN SGPRNT, OPERATORS ARE WRITTEN TO 'NCWU' ONLY
C
C      IN SGTRCF, DECLARE ARRAY AS (5,4,25) RATHER THAN (5,4,24)
C      IN SGMTML, DECLARE ARRAY AS (5,4,25) RATHER THAN (5,4,24)
C
C***********************************************************************
C
C
\XUNITS
\XSSVAL
C
C
      DIMENSION RMI(3), RMA(3), ABC(3)
      DIMENSION SPG(10),JRT(3,4,24),CEN(3,4)
      DIMENSION RT(5,4,25),D(3,3),L(4,4),LCEN(7)
      CHARACTER *1 CHR(25), CHAR
      CHARACTER *10 CSPG
C
C-----------------------------------------------------------------------
C               C B A P F I R
C-----------------------------------------------------------------------
      DATA LCEN/4,3,2,1,6,5,7/
C-----------------------------------------------------------------------
C                1   2   3   4   5   6   7   8   9  10  11  12  13  14
C-----------------------------------------------------------------------
      DATA CHR/' ','C','B','A','P','F','I','R','M','N','D','1','2','3',
     $         '4','5','6','-','/','H','.','0','0','0','0'/
C-----------------------------------------------------------------------
C               15  16  17  18  19  20  21
C-----------------------------------------------------------------------
      DO 101 I = 1,4
       DO 100 J = 1,4
        L(J,I) = 0
100    CONTINUE
101   CONTINUE
      WRITE (CSPG,10000) SPG
10000 FORMAT (10A1)
C-----------------------------------------------------------------------
C  CHECK THAT THERE ARE BLANKS IN THE SYMBOL, SO THAT IT HAS AT LEAST A
C  SPORTING CHANCE OF BEING INTERPRETED CORRECTLY
      DO 1012 I = 1,10
        J = 11 - I
        IF (CSPG(J:J) .NE. ' ') THEN
          DO 1010 K = 2,J
            IF (CSPG(K:K) .EQ. ' ') GO TO 1014
 1010     CONTINUE
        ENDIF
 1012 CONTINUE
      IER = 24
      GO TO 710
1014  CONTINUE
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C  Change the symbol for the cubic cases.  EJG   2-July-87
C  If the -3 symbol is preceded by a second kind symmetry element,
C  m, n, a, b, c or d then change -3 to 3
C-----------------------------------------------------------------------
      DO 104 J = 1,9
        IF (CSPG(J:J + 1) .EQ. '-3') THEN
          DO 102 JJ = 1,J - 1
            K = J - JJ
            CHAR = CSPG(K:K)
            IF (CHAR .EQ. ' ') GO TO 102
            IF (CHAR .EQ. 'M' .OR. CHAR .EQ. 'N' .OR.
     $          CHAR .EQ. 'D' .OR. CHAR .EQ. 'A' .OR.
     $          CHAR .EQ. 'B' .OR. CHAR .EQ. 'C') THEN
              CSPG(J:9) = CSPG(J + 1:10)
              CSPG(10:10) = ' '
              GO TO 106
            ENDIF
  102     CONTINUE
        ENDIF
  104 CONTINUE
  106 CONTINUE
      K = 0
      M = 0
      IER = 0
      NCENT = 0
      LAUENO = 0
      NAXIS = 0
      IERX = 0
      N = 0
C-----------------------------------------------------------------------
C  BREAK THE SPACE GROUP SYMBOL INTO THE 4 FIELDS AND CODE
C    AS NUMERICAL VALUES FOR MANIPULATION
C-----------------------------------------------------------------------
        DO 140 J = 1,10
          DO 110 I = 1,21
          IF (CSPG(J:J) .EQ. CHR(I)) GO TO 120
  110     CONTINUE
        GO TO 140
  120   IF (K + M + I .EQ. 1) GO TO 140
        IF (I .EQ. 1) GO TO 130
        IF (M .EQ. 0) K = K + 1
        M = M + 1
        L(M,K) = I
        IF (I .LT. 12) GO TO 130
        IF (M - 4) 140,130,130
  130   CONTINUE
        M = 0
        IF (K .GT. 3) GO TO 150
  140   CONTINUE
C-----------------------------------------------------------------------
C  IF ONLY 1 FIELD WAS FOUND.  THERE IS AN ERROR. GO TO 710
C-----------------------------------------------------------------------
  150 IF ( K .LE. 1 ) IER = 1
      IF ( IER .GT. 0 ) GO TO 710
C-----------------------------------------------------------------------
C  IF THE FIRST CHARACTER WAS NOT A P, A, B, C, F, I OR R  ERROR.
C-----------------------------------------------------------------------
      IF ( L(1,1) .GT. 8 ) IER = 2
      IF ( IER .GT. 0 ) GO TO 710
C-----------------------------------------------------------------------
C  CONVERT THE -N NOTATION TO THE NB(AR) NOTATION
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 18 ) CALL SGLPAK(L(1,2),IER)
      IF ( IER .GT. 0 ) GO TO 710
      IF ( L(1,3) .EQ. 18 ) CALL SGLPAK(L(1,3),IER)
      IF ( IER .GT. 0 ) GO TO 710
      IF ( L(1,4) .EQ. 18 ) CALL SGLPAK(L(1,4),IER)
      IF ( IER .GT. 0 ) GO TO 710
C-----------------------------------------------------------------------
C  SET THE MATRIX COUNT N TO 2
C-----------------------------------------------------------------------
      N = 2
C-----------------------------------------------------------------------
C  SET THE TRANSLATION FLAGS
C-----------------------------------------------------------------------
      D(1,1) = 0.0
      D(1,2) = 0.0
      D(1,3) = 0.0
      D(2,1) = 0.0
      D(2,2) = 0.0
      D(2,3) = 0.0
      D(3,1) = 0.0
      D(3,2) = 0.0
      D(3,3) = 0.0
C-----------------------------------------------------------------------
C  SET THE LATTICE CENTERING FLAG. 1=P, 2=A, 3=B, 4=C, 5=I, 6=F, 7=R
C-----------------------------------------------------------------------
      LCENT = L(1,1)-1
      LCENT = LCEN(LCENT)
      IF ( LCENT .NE. 7 ) GO TO 170
C-----------------------------------------------------------------------
C  RHOMBOHEDRAL LATTICE.
C  MAKE SURE THAT THERE IS A 3-AXIS.
C-----------------------------------------------------------------------
      IF ( L(1,2) .NE. 14 ) IER = 3
      IF ( IER .GT. 0 ) GO TO 710
      IF ( L(1,K) .EQ. 8 ) GO TO 160
C-----------------------------------------------------------------------
C  HEXAGONAL AXES. RETAIN R CENTERING AND SET LAUENO TO 8 OR 9
C-----------------------------------------------------------------------
      IF ( L(1,K) .EQ. 20 ) K = K-1
      LAUENO = K+6
      GO TO 190
  160 CONTINUE
C-----------------------------------------------------------------------
C RHOMBOHEDRAL AXES. DELETE R CENTERING AND SET LAUENO TO 6 OR 7
C-----------------------------------------------------------------------
      LCENT = 1
      K = K-1
      LAUENO = K+4
      GO TO 180
  170 CONTINUE
C-----------------------------------------------------------------------
C  CALL A S.R. TO DETERMINE LAUENO AND SOME PRELIMINARY DATA
C-----------------------------------------------------------------------
      IER = 0
      I209 = 0
      CALL SGLATC(K,L,D,LCENT,NCENT,LAUENO,NAXIS,LPT,IER,I209,ID)
      IF ( IER .GT. 0 ) GO TO 710
      IF ( I209 .EQ. 0 ) GO TO 190
  180 CONTINUE
C-----------------------------------------------------------------------
C   CUBIC OR RHOMBOHEDRAL CELL. INSERT THE 3-FOLD AXIS
C-----------------------------------------------------------------------
      CALL SGRMAT(RT(1,1,2),0,1,0,0,0,1,1,0,0)
      CALL SGRMAT(RT(1,1,3),0,0,1,1,0,0,0,1,0)
      N = 4
  190 CONTINUE
      CALL SGRMAT(RT(1,1,1),1,0,0,0,1,0,0,0,1)
C-----------------------------------------------------------------------
C  DECODE THE LAST 3 FIELDS OF THE SYMBOL
C-----------------------------------------------------------------------
        DO 680 M = 2,K
        IF ( L(1,M) .EQ. 0 ) IER = 6
        IF ( IER .GT. 0 ) GO TO 710
        I = IABS(L(1,M)-5)
  200   IF ( I .LE. 0 .OR. I .GT. 15 ) IER = 7
        IF ( IER .GT. 0 ) GO TO 710
        NXI = N
C-----------------------------------------------------------------------
C                A   B   C   M   N   D   1   2   3   4   5   6   -   /
C-----------------------------------------------------------------------
        GO TO (210,210,210,210,210,330,390,400,500,520,710,540,560,560,
     $   560),I
C-----------------------------------------------------------------------
C        H
C-----------------------------------------------------------------------
  210   CONTINUE
C-----------------------------------------------------------------------
C  A MIRROR IS NEEDED
C-----------------------------------------------------------------------
        GO TO (710,220,240,260),M
C-----------------------------------------------------------------------
C                    A   B   C  AXIS
C-----------------------------------------------------------------------
  220   CONTINUE
        IF ( LAUENO .GT. 3 ) GO TO 270
        IF ( K .EQ. 2 ) GO TO 250
  230   CONTINUE
        IF ( I .EQ. 1 ) IER = 8
        IF ( IER .GT. 0 ) GO TO 710
C-----------------------------------------------------------------------
C  AN A-AXIS MIRROR
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),-1,0,0,0,1,0,0,0,1)
        RT(1,4,N) = D(1,1)
        IF ( I .EQ. 2 .OR. I .EQ. 5 ) RT(2,4,N) = 0.5
        IF ( I .EQ. 3 .OR. I .EQ. 5 ) RT(3,4,N) = 0.5
        GO TO 560
  240   IF ( L(1,2) .EQ. 14 .OR. L(1,2) .EQ. 17 ) GO TO 310
C-----------------------------------------------------------------------
C  IT IS NOT TRIGONAL OR HEXAGONAL
C-----------------------------------------------------------------------
        IF ( L(1,2) .EQ. 15 ) GO TO 230
C-----------------------------------------------------------------------
C  IT IS NOT TETRAGONAL
C-----------------------------------------------------------------------
  250   CONTINUE
        IF ( I .EQ. 2 ) IER = 9
        IF ( IER .GT. 0 ) GO TO 710
C-----------------------------------------------------------------------
C  A B-AXIS MIRROR
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),1,0,0,0,-1,0,0,0,1)
        RT(2,4,N) = D(2,2)
        IF ( I .EQ. 1 .OR. I .EQ. 5 ) RT(1,4,N) = 0.5
        IF ( I .EQ. 3 .OR. I .EQ. 5 ) RT(3,4,N) = 0.5
        GO TO 560
  260   IF ( L(1,3) .EQ. 14 .OR. L(1,2) .EQ. 15 ) GO TO 280
C-----------------------------------------------------------------------
C  IT IS NOT CUBIC OR TETRAGONAL
C-----------------------------------------------------------------------
        IF ( L(1,2) .EQ. 14 .OR. L(1,2) .EQ. 17 ) GO TO 280
C-----------------------------------------------------------------------
C  IT IS NOT TRIGONAL OR HEXAGONAL
C-----------------------------------------------------------------------
  270   CONTINUE
        IF ( I .EQ. 3 ) IER = 10
        IF ( IER .GT. 0 ) GO TO 710
C-----------------------------------------------------------------------
C  A C-AXIS MIRROR
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),1,0,0,0,1,0,0,0,-1)
        RT(3,4,N) = D(3,3)
        IF ( I .EQ. 1 .OR. I .EQ. 5 ) RT(1,4,N) = 0.5
        IF ( I .EQ. 2 .OR. I .EQ. 5 ) RT(2,4,N) = 0.5
        IF ( M .NE. 2 .OR. L(1,2) .NE. 17) GO TO 560
C-----------------------------------------------------------------------
C  IF THIS A 63-AXIS THE MIRROR IS AT 1/4
C-----------------------------------------------------------------------
        IF ( L(2,2) .EQ. 14 ) RT(3,4,N) = 0.5
        GO TO 560
  280   CONTINUE
C-----------------------------------------------------------------------
C  A DIAGONAL MIRRROR PERPENDICULAR TO -110
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),0,1,0,1,0,0,0,0,1)
        RT(1,4,N) = D(2,2)
        RT(2,4,N) = -D(2,2)
        IF ( I .EQ. 3 .OR. I .EQ. 5 ) RT(3,4,N) = 0.5
        IF ( LAUENO .EQ. 7 .AND. I .EQ. 3 ) GO TO 290
        IF ( I .EQ. 3 .OR. I .EQ. 4 ) GO TO 560
  290   CONTINUE
        IF ( LCENT .EQ. 6 .OR. LCENT .EQ. 4 ) GO TO 300
        RT(1,4,N) = 0.5+RT(1,4,N)
        RT(2,4,N) = 0.5+RT(2,4,N)
        GO TO 560
  300   CONTINUE
C-----------------------------------------------------------------------
C  EITHER F OR C-CENTERED TETRAGONAL. GLIDES ARE 1/4,1/4
C-----------------------------------------------------------------------
        RT(1,4,N) = 0.25+RT(1,4,N)
        RT(2,4,N) = 0.25+RT(2,4,N)
        GO TO 560
  310   CONTINUE
        IF ( LAUENO .EQ. 7 ) GO TO 280
C-----------------------------------------------------------------------
C  MIRROR NORMAL TO (1000) IN HEX CELL
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),-1,1,0,0,1,0,0,0,1)
        IF ( I .EQ. 3 ) RT(3,4,N) = 0.5
  320   CONTINUE
        GO TO 560
C-----------------------------------------------------------------------
C    D TYPE MIRROR
C-----------------------------------------------------------------------
  330   CONTINUE
        IF ( LCENT .LE. 1 ) IER = 11
        IF ( IER .GT. 0 ) GO TO 710
        GO TO (710,340,350,360),M
  340   IF ( LAUENO .GT. 3 ) GO TO 370
        IF ( K .EQ. 2 ) GO TO 350
        CALL SGRMAT(RT(1,1,N),-1,0,0,0,1,0,0,0,1)
        IF ( ID .EQ. 2 ) RT(1,4,N) = 0.25
        RT(2,4,N) = 0.25
        RT(3,4,N) = 0.25
        GO TO 560
  350   CONTINUE
        CALL SGRMAT(RT(1,1,N),1,0,0,0,-1,0,0,0,1)
        RT(1,4,N) = 0.25
        IF ( ID .EQ. 2 ) RT(2,4,N) = 0.25
        IF ( LAUENO .EQ. 5 ) RT(2,4,N) = D(2,1)
        RT(3,4,N) = 0.25
        GO TO 560
  360   IF ( L(1,2) .EQ. 15 .OR. L(1,3) .EQ. 14 ) GO TO 380
C-----------------------------------------------------------------------
C  IT IS NOT TETRAGONAL OR CUBIC
C-----------------------------------------------------------------------
  370   CONTINUE
        CALL SGRMAT(RT(1,1,N),1,0,0,0,1,0,0,0,-1)
        RT(1,4,N) = 0.25
        RT(2,4,N) = 0.25
        IF ( ID .EQ. 2 ) RT(3,4,N) = 0.25
        GO TO 560
  380   CONTINUE
C-----------------------------------------------------------------------
C  CUBIC OR TETRAGONAL. D-GLIDE ALONG DIAGONAL
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),0,1,0,1,0,0,0,0,1)
        RT(1,4,N) = 0.25
        RT(2,4,N) = 0.25
        RT(3,4,N) = 0.25
        IF (L(1,3) .NE. 13) GO TO 320
        RT(1,4,N) = 0.0
        RT(2,4,N) = 0.5
        GO TO 560
C-----------------------------------------------------------------------
C    1 FOLD ROTATION
C-----------------------------------------------------------------------
  390   IF ( L(2,M) .NE. 3 ) GO TO 680
C-----------------------------------------------------------------------
C  WE HAVE A CENTER OF SYMMETRY
C-----------------------------------------------------------------------
        NCENT = 1
        GO TO 680
C-----------------------------------------------------------------------
C    2 FOLD ROTATION AXIS
C-----------------------------------------------------------------------
  400   CONTINUE
C-----------------------------------------------------------------------
C  WE WILL NOT ALLOW A -2 AXIS.
C-----------------------------------------------------------------------
        IF ( L(2,M) .EQ. 3 ) IER = 19
        IF ( IER .GT. 0 ) GO TO 710
        GO TO (710,410,420,440),M
  410   IF ( K .EQ. 2 ) GO TO 430
        CONTINUE
C-----------------------------------------------------------------------
C  ROTATION ABOUT THE A-AXIS. (ORTHOGONAL CELL)
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),1,0,0,0,-1,0,0,0,-1)
        RT(2,4,N) = D(2,1)
        RT(3,4,N) = D(3,1)
        IF ( IABS(L(2,M)-13) .EQ. 1 ) RT(1,4,N) = 0.5
        GO TO 560
  420   CONTINUE
        IF ( L(1,2) .EQ. 14 ) GO TO 460
        IF ( L(1,2) .EQ. 17 ) GO TO 450
C-----------------------------------------------------------------------
C  IT IS NOT A HEXAGONAL OR TRIGONAL SPACE GROUP
C-----------------------------------------------------------------------
  430   CONTINUE
C-----------------------------------------------------------------------
C  ROTATION ABOUT THE B-AXIS
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),-1,0,0,0,1,0,0,0,-1)
        RT(1,4,N) = D(1,2)
        RT(3,4,N) = D(3,2)
        IF ( L(2,M) .EQ. 12 ) RT(2,4,N) = 0.5
        GO TO 560
  440   IF ( L(1,2) .GE. 14   ) GO TO 490
        IF ( L(1,3) .EQ. 14 ) GO TO 490
        CONTINUE
        CALL SGRMAT(RT(1,1,N),-1,0,0,0,-1,0,0,0,1)
        RT(1,4,N) = D(1,3)
        RT(2,4,N) = D(2,3)
        IF ( IABS(L(2,M)-13) .EQ. 1 ) RT(3,4,N) = 0.5
        IF (   L(2,M) .EQ. 16    ) RT(3,4,N) = 0.5
        GO TO 560
  450   CONTINUE
        IF ( L(1,4) .EQ. 12 ) GO TO 460
C-----------------------------------------------------------------------
C  2-AXIS NORMAL TO (-2110)
C     USED FOR THE P 6N22 GROUPS
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),1,-1,0,0,-1,0,0,0,-1)
        GO TO 560
  460   CONTINUE
        IF ( LAUENO .EQ. 7 ) GO TO 480
  470   CONTINUE
C-----------------------------------------------------------------------
C  2-AXIS ALONG TO (11-20) TRIG  AND (110) TETRAG
C     USED FOR THE P 3N21 GROUPS
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),0,1,0,1,0,0,0,0,-1)
        RT(1,4,N) = D(2,1)
        IF ( L(2,M) .EQ. 12 ) RT(1,4,N) = RT(1,4,N)+0.5
        RT(2,4,N) = -D(2,1)
        RT(3,4,N) = D(3,1)
        GO TO 560
  480   CONTINUE
C-----------------------------------------------------------------------
C  2-AXIS NORMAL TO (110)
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),0,-1,0,-1,0,0,0,0,-1)
        GO TO 560
  490   CONTINUE
        IF ( L(1,2) .EQ. 15 ) GO TO 470
C-----------------------------------------------------------------------
C  2-AXIS NORMAL TO (10-10)
C-----------------------------------------------------------------------
        CALL SGRMAT(RT(1,1,N),1,0,0,1,-1,0,0,0,-1)
        GO TO 560
C-----------------------------------------------------------------------
C    3 FOLD ROTATION
C-----------------------------------------------------------------------
  500   GO TO (710,510,390,710),M
  510   CONTINUE
        IF ( LAUENO .LE. 7 ) GO TO 390
        CALL SGRMAT(RT(1,1,N),0,-1,0,1,-1,0,0,0,1)
        IF ( L(2,M) .EQ. 12 ) RT(3,4,N) = 0.33333333
        IF ( L(2,M) .EQ. 13 ) RT(3,4,N) = 0.66666667
        IF ( L(2,2) .EQ. 3 ) NCENT = 1
        GO TO 560
  520   CONTINUE
C-----------------------------------------------------------------------
C  FOUR FOLD AXIS
C-----------------------------------------------------------------------
        IF ( M .NE. 2 ) IER = 12
        IF ( IER .GT. 0 ) GO TO 710
        IF ( L(2,2) .EQ. 3 ) GO TO 530
        CALL SGRMAT(RT(1,1,N),0,-1,0,1,0,0,0,0,1)
        RT(1,4,N) = D(1,3)
        RT(2,4,N) = D(2,3)
        IF ( L(2,2) .EQ. 12 ) RT(3,4,N) = 0.25
        IF ( L(2,2) .EQ. 13 ) RT(3,4,N) = 0.5
        IF ( L(2,2) .EQ. 14 ) RT(3,4,N) = 0.75
        GO TO 560
  530   CONTINUE
        CALL SGRMAT(RT(1,1,N),0,1,0,-1,0,0,0,0,-1)
        RT(1,4,N) = D(1,3)
        RT(2,4,N) = D(2,3)
        RT(3,4,N) = D(3,3)
        GO TO 560
  540   CONTINUE
C-----------------------------------------------------------------------
C  6-AXIS
C-----------------------------------------------------------------------
        IF ( M .NE. 2 ) IER = 13
        IF ( IER .GT. 0 ) GO TO 710
        IF ( L(2,2) .EQ. 3 ) GO TO 550
        CALL SGRMAT(RT(1,1,N),1,-1,0,1,0,0,0,0,1)
        IF ( L(2,2) .GT. 11 .AND. L(2,2) .LT. 18 ) RT(3,4,N) = (L(2,2)-
     $   11)/6.0
        GO TO 560
  550   CONTINUE
        CALL SGRMAT(RT(1,1,N),-1,1,0,-1,0,0,0,0,-1)
        IF ( L(1,3) .EQ. 2 .OR. L(1,4) .EQ. 2 ) RT(3,4,N) = 0.5
  560   CONTINUE
        RT(1,4,N) = AMOD(RT(1,4,N)+5.0,1.0)
        RT(2,4,N) = AMOD(RT(2,4,N)+5.0,1.0)
        RT(3,4,N) = AMOD(RT(3,4,N)+5.0,1.0)
        RT(5,2,N) = 1728*RT(1,4,N)+144*RT(2,4,N)+12*RT(3,4,N)
          DO 580 M2 = 1,N-1
          IF ( RT(5,1,M2) .EQ. RT(5,1,N) ) GO TO 570
          IF ( RT(5,1,M2) .NE. -RT(5,1,N) ) GO TO 580
          NCENT = 1
  570     CONTINUE
          IF ( RT(5,2,N) .NE. RT(5,2,M2) ) GO TO 670
          GO TO 680
  580     CONTINUE
        N = N+1
        IF ( N .GT. 25 ) IER = 14
        IF ( IER .GT. 0 ) GO TO 710
  590   CONTINUE
        IDENT = 0
        NXL = N-1
        IF ( NXL .LT. NXI ) GO TO 640
          DO 630 NX = NXI,NXL
            DO 620 M1 = 2,NX
            CALL SGMTML(RT,M1,RT,NX,RT,N)
              DO 610 M2 = 1,N-1
              IF ( RT(5,1,N) .EQ. RT(5,1,M2) ) GO TO 600
              IF ( -RT(5,1,N) .NE. RT(5,1,M2) ) GO TO 610
              NCENT = 1
  600         CONTINUE
              GO TO 620
  610         CONTINUE
            N = N+1
            IF ( N .GT. 25 ) IER = 15
            IF ( IER .GT. 0 ) GO TO 710
  620       CONTINUE
          IF ( N-1 .EQ. NXL ) GO TO 640
  630     CONTINUE
        NXI = NXL+1
        GO TO 590
  640   CONTINUE
        IF ( L(1,M) .LT. 12 ) GO TO 680
C-----------------------------------------------------------------------
C  SEARCH FOR A / TO INDICATE A MIRROR PERPENDICULAR TO THIS AXIS
C-----------------------------------------------------------------------
        IF ( L(2,M) .EQ. 3 ) GO TO 680
          DO 650 I = 2,3
          IF ( L(I,M) .EQ. 0 ) GO TO 680
          IF ( L(I,M) .EQ. 19 ) GO TO 660
          IF ( L(I,M) .LT. 12 ) IER = 16
          IF ( IER .GT. 0 ) GO TO 710
  650     CONTINUE
        GO TO 680
  660   IF ( L(I+1,M) .LE. 1 ) IER = 17
        IF ( IER .GT. 0 ) GO TO 710
        I = IABS(L(I+1,M)-5)
        GO TO 200
  670   CONTINUE
        CALL SGTRCF(M,RT,N,M2,LCENT,LAUENO,IER,LPTX)
        IF ( IER .GT. 0 ) IERX = IER
        IER = 0
  680   CONTINUE
      NSYM = N-1
        DO 700 I = 1,3
          DO 700 K = 1,NSYM
            DO 690 J = 1,3
            JRT(I,J,K) = RT(I,J,K)
  690       CONTINUE
          JRT(I,4,K) = 12*RT(I,4,K)+144.1
          JRT(I,4,K) = JRT(I,4,K)-12*(JRT(I,4,K)/12)
  700     CONTINUE
      CALL SGPRNT(SPG,JRT,LAUENO,NAXIS,NCENT,LCENT,NSYM,NPOL,CEN,NCV,
     $ LPT)
C
C
C
C
      IF ( IERX .EQ. 0 ) RETURN
      IER = IERX
  710 CONTINUE
      IF ( LPTX .GT. 0 ) CALL SGERRS(SPG,IER,LPTX)
      NAXIS = 4
      RETURN
      END
C
C
CODE FOR SGLATC
      SUBROUTINE SGLATC(K,L,D,LCENT,NCENT,LAUENO,NAXIS
     $  ,LPT,IER,I209,ID)
C-----------------------------------------------------------------------
C  SPACE GROUP LATTICE AND OPERATOR INTERPRETATION
C-----------------------------------------------------------------------
C
      DIMENSION D(3,3),L(4,4)
CDJW -- INITIALISE MIRROR COUNTS
      IM = 0
      IR = 0
      IA = 0
      IB = 0
      IC = 0
      ID = 0
      I21 = 0
C-----------------------------------------------------------------------
C  NOW LET US DETERMINE THE LAUE GROUP AND UNIQUE AXIS IF MONOCLINIC
C-----------------------------------------------------------------------
      IF ( K-3 ) 100,180,190
  100 CONTINUE
C-----------------------------------------------------------------------
C  ONLY 2 FIELDS WERE READ
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 17 ) GO TO 120
      IF ( L(1,2) .EQ. 14 ) GO TO 130
      IF ( L(1,2) .EQ. 15 ) GO TO 140
      IF ( L(1,2) .EQ. 12 ) GO TO 170
C-----------------------------------------------------------------------
C  2/M, B-AXIS UNIQUE
C-----------------------------------------------------------------------
      IM = 2
      GO TO 350
  110 CONTINUE
C-----------------------------------------------------------------------
C  WE HAVE SOMETHING LIKE P 6N 1 *
C-----------------------------------------------------------------------
      IF ( L(1,4) .NE. 12 ) GO TO 460
  120 CONTINUE
C-----------------------------------------------------------------------
C  6/M
C-----------------------------------------------------------------------
      LAUENO = 11
      GO TO 620
  130 CONTINUE
C-----------------------------------------------------------------------
C  3BAR
C-----------------------------------------------------------------------
      LAUENO = 8
      GO TO 620
  140 CONTINUE
C-----------------------------------------------------------------------
C  4/M
C-----------------------------------------------------------------------
      LAUENO = 4
C-----------------------------------------------------------------------
C  IS IT I-CENTERED OR F-CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .GE. 5 ) GO TO 150
C-----------------------------------------------------------------------
C  IS IT C-CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 4 ) GO TO 160
C-----------------------------------------------------------------------
C  NO.  IS THERE A N-GLIDE NORMAL TO C?
C-----------------------------------------------------------------------
      IF ( L(3,2) .EQ. 10 ) GO TO 520
      IF ( L(4,2) .EQ. 10 ) D(2,3) = 0.5
C-----------------------------------------------------------------------
C  NO. OK LET'S GET ON WITH THIS.
C-----------------------------------------------------------------------
      GO TO 620
  150 CONTINUE
C-----------------------------------------------------------------------
C  IS THERE EITHER AN A-GLIDE OR A D-GLIDE NORMAL TO C?
C-----------------------------------------------------------------------
      IF ( L(4,2) .NE. 4 .AND. L(4,2) .NE. 11 ) GO TO 530
C-----------------------------------------------------------------------
C  YES.
C-----------------------------------------------------------------------
      D(1,3) = 0.75
      IF ( LCENT .EQ. 5 ) D(2,3) = 0.25
      GO TO 620
  160 CONTINUE
C-----------------------------------------------------------------------
C  C-CENTERED 4/M TETRAGONAL
C  IF THERE IS NO A-GLIDE NORMAL TO C WE ARE THROUGH
C-----------------------------------------------------------------------
      IF ( L(3,2) .NE. 4 .AND. L(4,2) .NE. 4 ) GO TO 620
      D(1,3) = 0.25
      D(2,3) = 0.25
      IF ( L(4,2) .EQ. 4 ) D(2,3) = 0.75
      GO TO 620
  170 CONTINUE
C-----------------------------------------------------------------------
C  1BAR
C-----------------------------------------------------------------------
      LAUENO = 1
      GO TO 620
  180 CONTINUE
C-----------------------------------------------------------------------
C  3 FIELDS WERE READ.  MUST BE M3 CUBIC. (R3R HAS BEEN TAKEN CARE OF)
C-----------------------------------------------------------------------
      IF ( L(1,3) .NE. 14 ) IER = 20
      IF ( IER .GT. 0 ) GO TO 630
      LAUENO = 13
C-----------------------------------------------------------------------
C  SET THE B-AXIS TRANSLATION FLAG IF A 21 ALONG A
C-----------------------------------------------------------------------
      IF ( L(2,2) .EQ. 12 ) D(2,1) = 0.5
C-----------------------------------------------------------------------
C  SET THE C-AXIS TRANSLATION FLAG IF AN A-GLIDE NORMAL TO C
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 3 .OR. L(1,2) .EQ. 4 ) D(3,3) = 0.5
      GO TO 610
C-----------------------------------------------------------------------
C  FOUR FIELDS WERE READ
C-----------------------------------------------------------------------
  190 IF ( L(1,3) .EQ. 14 ) GO TO 390
C-----------------------------------------------------------------------
C  IT IS NOT CUBIC
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 17 ) GO TO 450
C-----------------------------------------------------------------------
C  IT IS NOT HEXAGONAL
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 14 ) GO TO 470
C-----------------------------------------------------------------------
C  IT IS NOT TRIGONAL
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 15 ) GO TO 480
C-----------------------------------------------------------------------
C  IT IS NOT TETRAGONAL
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 12 ) GO TO 340
      IF ( L(1,3) .EQ. 12 ) GO TO 360
C-----------------------------------------------------------------------
C  IT MAY BE ORTHORHOMBIC
C-----------------------------------------------------------------------
  200 CONTINUE
C-----------------------------------------------------------------------
C  IT IS ORTHORHOMBIC
C-----------------------------------------------------------------------
      LAUENO = 3
C-----------------------------------------------------------------------
C  SET UP COUNTS OF THE VARIOUS TYPES OF MIRRORS.
C-----------------------------------------------------------------------
CDJW -- MIRROR COUNTS INITIALISED AT TOP OF ROUTINE NOW
C-----------------------------------------------------------------------
C  DO WE HAVE A 2-AXIS ALONG A
C-----------------------------------------------------------------------
      IF ( L(1,2) .NE. 13 ) GO TO 210
C-----------------------------------------------------------------------
C  YES, IS IT A 21?
C-----------------------------------------------------------------------
      IF ( L(2,2) .NE. 12 ) GO TO 220
      D(1,2) = 0.5
      D(1,3) = 0.5
      I21 = 4
      GO TO 220
  210 CONTINUE
      IR = 1
      IF ( L(1,2) .EQ. 9 ) IM = 4
      IF ( L(1,2) .EQ. 3 ) IB = 1
      IF ( L(1,2) .EQ. 2 ) IC = 1
      IF ( L(1,2) .EQ. 11 ) ID = 1
      IF ( L(1,3) .EQ. 4 .OR. L(1,3) .EQ. 10 ) D(1,1) = 0.5
      IF ( L(1,4) .EQ. 4 .OR. L(1,4) .EQ. 10 ) D(1,1) = D(1,1)+0.5
  220 CONTINUE
C-----------------------------------------------------------------------
C  DO WE HAVE A 2-AXIS ALONG B
C-----------------------------------------------------------------------
      IF ( L(1,3) .NE. 13 ) GO TO 230
C-----------------------------------------------------------------------
C  YES, IS IT A 21?
C-----------------------------------------------------------------------
      IF ( L(2,3) .NE. 12 ) GO TO 240
      D(2,1) = 0.5
      D(2,3) = 0.5
      I21 = I21+2
      GO TO 240
  230 CONTINUE
      IR = IR+1
      IF ( L(1,3) .EQ. 9 ) IM = IM+2
      IF ( L(1,3) .EQ. 4 ) IA = 1
      IF ( L(1,3) .EQ. 2 ) IC = IC+1
      IF ( L(1,3) .EQ. 11 ) ID = ID+1
      IF ( L(1,2) .EQ. 3 .OR. L(1,2) .EQ. 10 ) D(2,2) = 0.5
      IF ( L(1,4) .EQ. 3 .OR. L(1,4) .EQ. 10 ) D(2,2) = D(2,2)+0.5
  240 CONTINUE
C-----------------------------------------------------------------------
C  DO WE HAVE A 2-AXIS ALONG C
C-----------------------------------------------------------------------
      IF ( L(1,4) .NE. 13 ) GO TO 250
C-----------------------------------------------------------------------
C  YES, IS IT A 21?
C-----------------------------------------------------------------------
      IF ( L(2,4) .NE. 12 ) GO TO 260
      D(3,1) = 0.5
      D(3,2) = 0.5
      I21 = I21+1
      GO TO 260
  250 CONTINUE
      IR = IR+1
      IF ( L(1,4) .EQ. 9 ) IM = IM+1
      IF ( L(1,4) .EQ. 4 ) IA = IA+1
      IF ( L(1,4) .EQ. 3 ) IB = IB+1
      IF ( L(1,4) .EQ. 11 ) ID = ID+1
      IF ( L(1,2) .EQ. 2 .OR. L(1,2) .EQ. 10 ) D(3,3) = 0.5
      IF ( L(1,3) .EQ. 2 .OR. L(1,3) .EQ. 10 ) D(3,3) = D(3,3)+0.5
  260 CONTINUE
C-----------------------------------------------------------------------
C  IF THERE ARE 3 MIRRORS CHECK FOR CENTERING
C     WHICH MAY ALTER THE ORIGIN LOCATION
C-----------------------------------------------------------------------
      IF ( IR .EQ. 3 ) GO TO 300
C-----------------------------------------------------------------------
C  LESS THAN 3 MIRRORS. SET UP THE 2-AXES LOCATIONS
C-----------------------------------------------------------------------
      IF ( I21 .EQ. 4 .OR. I21 .EQ. 5 .OR. I21 .EQ. 7 ) D(1,2) = 0.0
      IF ( I21 .EQ. 6 .OR. I21 .EQ. 7 ) D(1,3) = 0.0
      IF ( I21 .EQ. 3 ) D(2,1) = 0.0
      IF ( I21 .EQ. 2 .OR. I21 .EQ. 6 .OR. I21 .EQ. 7 ) D(2,3) = 0.0
      IF ( I21 .EQ. 1 .OR. I21 .EQ. 3 .OR. I21 .EQ. 7 ) D(3,1) = 0.0
      IF ( I21 .EQ. 5 ) D(3,2) = 0.0
      IF ( IM .LE. 0 ) GO TO 620
      IF ( IM .EQ. 1 .AND. (I21 .EQ. 4 .OR. I21 .EQ. 2)) GO TO 270
      IF ( IM .EQ. 2 .AND. (I21 .EQ. 4 .OR. I21 .EQ. 1)) GO TO 280
      IF ( IM .EQ. 4 .AND. (I21 .EQ. 2 .OR. I21 .EQ. 1)) GO TO 290
      GO TO 620
  270 CONTINUE
      IF ( D(3,3) .EQ. 0.0 ) GO TO 620
      D(3,3) = 0.0
      D(3,2) = D(3,2)+0.5
      GO TO 620
  280 CONTINUE
      IF ( D(2,2) .EQ. 0.0 ) GO TO 620
      D(2,2) = 0.0
      D(2,1) = D(2,1)+0.5
      GO TO 620
  290 CONTINUE
      IF ( D(1,1) .EQ. 0.0 ) GO TO 620
      D(1,1) = 0.0
      D(1,3) = D(1,3)+0.5
      GO TO 620
  300 CONTINUE
C-----------------------------------------------------------------------
C  3 MIRRORS PRESENT.  IS THE LATTICE CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 1 ) GO TO 620
C-----------------------------------------------------------------------
C  YES.  IS IT A-CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 2 ) GO TO 310
C-----------------------------------------------------------------------
C  NO.   IS IT B=CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 3 ) GO TO 320
C-----------------------------------------------------------------------
C  NO.  IS IT C-CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 4 ) GO TO 330
C-----------------------------------------------------------------------
C  NO.   IS IT I-CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .NE. 5 ) GO TO 620
C-----------------------------------------------------------------------
C  YES.  IF ONLY 1 GLIDE PLANE SHIFT THE MIRRORS BY I
C-----------------------------------------------------------------------
      IF ( IA+IB+IC .NE. 1 ) GO TO 620
      D(1,1) = D(1,1)+0.5
      D(2,2) = D(2,2)+0.5
      D(3,3) = D(3,3)+0.5
      GO TO 620
  310 CONTINUE
C-----------------------------------------------------------------------
C  AN A-CENTERED LATTICE.
C   IF ONLY ONE B OR C GLIDE PRESENT RELOCATE THE MIRRORS BY A
C-----------------------------------------------------------------------
      IF ( IB+IC .NE. 1 ) GO TO 620
      IF ( IA .EQ. 2 ) GO TO 620
      D(2,2) = D(2,2)+0.5
      D(3,3) = D(3,3)+0.5
      GO TO 620
  320 CONTINUE
C-----------------------------------------------------------------------
C  A B-CENTERED LATTICE
C-----------------------------------------------------------------------
      IF ( IA+IC .NE. 1 ) GO TO 620
      IF ( IB .EQ. 2 ) GO TO 620
      D(1,1) = D(1,1)+0.5
      D(3,3) = D(3,3)+0.5
      GO TO 620
  330 CONTINUE
C-----------------------------------------------------------------------
C  A C-CENTERED LATTICE
C-----------------------------------------------------------------------
      IF ( IA+IB .NE. 1 ) GO TO 620
      IF ( IC .EQ. 2 ) GO TO 620
      D(1,1) = D(1,1)+0.5
      D(2,2) = D(2,2)+0.5
      GO TO 620
  340 IF ( L(1,3) .EQ. 12 ) GO TO 370
C-----------------------------------------------------------------------
C  IT IS NOT C-AXIS UNIQUE MONOCLINIC
C-----------------------------------------------------------------------
      IF ( L(1,4) .NE. 12 ) GO TO 200
      IM = 3
  350 CONTINUE
C-----------------------------------------------------------------------
C  IT IS B-AXIS UNIQUE MONOCLINIC. (FULL SYMBOL USED)
C-----------------------------------------------------------------------
      LAUENO = 2
      NAXIS = 2
      IA = 4
      IC = 2
      NA = 1
      NB = 2
      NC = 3
      GO TO 380
  360 IF ( L(1,4) .NE. 12 ) GO TO 200
C-----------------------------------------------------------------------
C  IT IS A-AXIS UNIQUE MONOCLINIC
C-----------------------------------------------------------------------
      LAUENO = 2
      NAXIS = 1
      IA = 3
      IC = 2
      NA = 2
      NB = 1
      NC = 3
      IM = 2
      GO TO 380
  370 IF ( L(1,4) .EQ. 12 ) GO TO 170
C-----------------------------------------------------------------------
C  IT IS C-AXIS UNIQUE MONOCLINIC
C-----------------------------------------------------------------------
      LAUENO = 2
      NAXIS = 3
      IA = 4
      IC = 3
      NA = 1
      NB = 3
      NC = 2
      IM = 4
  380 CONTINUE
      IF ( L(2,IM) .EQ. 12 ) D(NB,NAXIS) = 0.5
      IF ( L(3,IM) .EQ. IA .OR. L(3,IM) .EQ. 10 ) D(NA,NAXIS) = 0.5
      IF ( L(3,IM) .EQ. IC .OR. L(3,IM) .EQ. 10 ) D(NC,NAXIS) = 0.5
      IF ( L(4,IM) .EQ. IA .OR. L(4,IM) .EQ. 10 ) D(NA,NAXIS) = 0.5
      IF ( L(4,IM) .EQ. IC .OR. L(4,IM) .EQ. 10 ) D(NC,NAXIS) = 0.5
      GO TO 620
  390 CONTINUE
C-----------------------------------------------------------------------
C  IT IS M3M CUBIC
C-----------------------------------------------------------------------
      LAUENO = 14
C-----------------------------------------------------------------------
C  SET THE C-AXIS TRANSLATION FLAG IF AN A-GLIDE NORMAL TO C
C-----------------------------------------------------------------------
      IF ( L(1,2) .EQ. 3 .OR. L(1,2) .EQ. 4 ) D(3,3) = 0.5
C-----------------------------------------------------------------------
C  IS A 4N-AXIS SPECIFIED
C-----------------------------------------------------------------------
      IF ( L(1,2) .NE. 15 ) GO TO 610
C-----------------------------------------------------------------------
C  YES.  IS IT 4BAR?
C-----------------------------------------------------------------------
      IF ( L(2,2) .EQ. 3 ) GO TO 400
C-----------------------------------------------------------------------
C  NO.  IS IT A 4?
C-----------------------------------------------------------------------
      IF ( L(2,2) .LT. 12 ) GO TO 610
      IF ( L(2,2) .GT. 14 ) GO TO 610
C-----------------------------------------------------------------------
C  NO. IS IT A 41?
C-----------------------------------------------------------------------
      IF ( L(2,2) .EQ. 12 ) GO TO 410
C-----------------------------------------------------------------------
C  NO. IS IT A 42?
C-----------------------------------------------------------------------
      IF ( L(2,2) .EQ. 13 ) GO TO 420
C-----------------------------------------------------------------------
C  NO.  IT MUST BE A 43
C  P 43 3 2
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 6 ) GO TO 430
      D(1,3) = 0.75
      D(2,3) = 0.25
      GO TO 610
  400 CONTINUE
C-----------------------------------------------------------------------
C  4B.  IS IT 4B 3 M
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 9 ) GO TO 610
C-----------------------------------------------------------------------
C  NO.  IS IT 4B 3 D?
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 11 ) GO TO 440
C-----------------------------------------------------------------------
C  NO.
C-----------------------------------------------------------------------
      D(1,3) = 0.5
      D(2,3) = 0.5
      D(3,3) = 0.5
      GO TO 610
  410 CONTINUE
C-----------------------------------------------------------------------
C  41-AXIS. IS IT F 41 3 2?
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 6 ) GO TO 430
C-----------------------------------------------------------------------
C  NO. IT IS EITHER P 41 3 2 OR I 41 3 2
C-----------------------------------------------------------------------
      D(1,3) = 0.25
      D(2,3) = -0.25
      GO TO 610
  420 CONTINUE
C-----------------------------------------------------------------------
C  P 42 3 2
C-----------------------------------------------------------------------
      D(1,3) = 0.5
      D(2,3) = 0.5
      GO TO 610
  430 CONTINUE
C-----------------------------------------------------------------------
C  F 41 3 2
C-----------------------------------------------------------------------
      D(1,3) = 0.25
      D(2,3) = 0.25
      GO TO 610
  440 CONTINUE
C-----------------------------------------------------------------------
C  I 4B 3 D WE HOPE
C-----------------------------------------------------------------------
      IF ( LCENT .NE. 5 ) IER = 21
      IF ( IER .GT. 0 ) GO TO 630
      D(1,3) = 0.75
      D(2,3) = 0.25
      D(3,3) = 0.75
      GO TO 610
  450 CONTINUE
      IF ( L(1,3) .EQ. 12 ) GO TO 110
  460 CONTINUE
C-----------------------------------------------------------------------
C  IT IS HEXAGONAL 6/MMM
C-----------------------------------------------------------------------
      LAUENO = 12
      GO TO 620
  470 CONTINUE
C-----------------------------------------------------------------------
C  IT IS TRIGONAL P3**
C-----------------------------------------------------------------------
      IF ( L(1,3) .EQ. 12 ) GO TO 600
      IF ( L(1,4) .NE. 12 ) GO TO 460
C-----------------------------------------------------------------------
C  IT IS TRIGONAL 3M1
C-----------------------------------------------------------------------
      LAUENO = 9
      GO TO 620
  480 CONTINUE
C-----------------------------------------------------------------------
C  IT IS TETRAGONAL 4/MMM
C-----------------------------------------------------------------------
      LAUENO = 5
C-----------------------------------------------------------------------
C  IF THERE IS AN N-GLIDE NORMAL TO C PLACE ANY
C         MIRROR NORMAL TO A AT 1/4
C-----------------------------------------------------------------------
      IF ( L(3,2) .EQ. 10 .OR. L(4,2) .EQ. 10 ) D(1,1) = 0.5
C-----------------------------------------------------------------------
C  IF THERE IS AN A-GLIDE NORMAL TO C PLACE ANY
C         MIRROR NORMAL TO (110) AT 1/4
C-----------------------------------------------------------------------
      IF ( L(3,2) .EQ. 4 .OR. L(4,2) .EQ. 4 ) D(2,2) = 0.25
C-----------------------------------------------------------------------
C  IF THERE IS A 21 ALONG B MOVE PLACE IT AT X=1/4
C-----------------------------------------------------------------------
      IF ( L(1,3) .EQ. 13 .AND. L(2,3) .EQ. 12 ) D(1,2) = 0.5
C-----------------------------------------------------------------------
C  IF THERE IS A 21 ALONG (110) MOVE PLACE IT AT X=1/4
C       IF ( L(1,4).EQ.13.AND.L(2,4).EQ.12 ) D(2,1)=0.5
C  IF THERE IS EITHER A B- OR N-GLIDE NORMAL TO THE A-AXIS
C         SHIFT THE MIRROR BY 1/4 ALONG THE A-AXIS
C-----------------------------------------------------------------------
      IF ( L(1,3) .EQ. 3 .OR. L(1,3) .EQ. 10 ) D(1,1) = D(1,1)+0.5
C-----------------------------------------------------------------------
C  IF THERE IS EITHER A B- OR N-GLIDE NORMAL TO (110)
C         SHIFT THE MIRROR BY 1/4 ALONG THE A-AXIS
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 3 .OR. L(1,4) .EQ. 10 ) D(2,2) = D(2,2)+0.25
C-----------------------------------------------------------------------
C  SET THE Z LOCATION FOR 2-AXES ALONG (110)
C-----------------------------------------------------------------------
      IF ( L(2,2) .GT. 11 .AND. L(2,2) .LT. 15 .AND. L(2,3) .NE. 12 ) D
     $ (3,1) = -(L(2,2)-11)/4.0
C-----------------------------------------------------------------------
C  SET THE Z-TRANSLATION FOR 21-AXES ALONG (110)
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 13 .AND. L(2,4) .NE. 12 ) GO TO 490
      IF ( L(2,2) .GT. 11 .AND. L(2,2) .LT. 15 ) D(3,1) = (L(2,2)-11)/
     $ 4.0
  490 CONTINUE
C-----------------------------------------------------------------------
C  SET THE Z-TRANSLATION FOR 21-AXES ALONG B
C-----------------------------------------------------------------------
      IF ( L(1,3) .EQ. 13 .AND. L(2,3) .NE. 12 ) GO TO 500
      IF ( L(2,2) .GT. 11 .AND. L(2,2) .LT. 15 ) D(3,2) = (L(2,2)-11)/
     $ 4.0
  500 CONTINUE
C-----------------------------------------------------------------------
C  PLACE THE D IN F 4* D * AT Y=7/8
C-----------------------------------------------------------------------
      IF ( L(1,3)+L(3,2) .EQ. 11 .AND. LCENT .EQ. 6 ) D(2,1) = 0.75
C-----------------------------------------------------------------------
C  SET POSITION OF M IN F 4** * * AT X=1/8 IF THERE IS A C ALONG (110)
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 2 .AND. LCENT .EQ. 6 ) D(1,1) = 0.5
C-----------------------------------------------------------------------
C IS THIS A 4BAR?
C-----------------------------------------------------------------------
      IF ( L(2,2) .EQ. 3 ) GO TO 560
C-----------------------------------------------------------------------
C IS THE LATTICE PRIMATIVE?
C-----------------------------------------------------------------------
      IF ( LCENT .GT. 1 ) GO TO 530
C-----------------------------------------------------------------------
C  YES.  DO WE HAVE A N-GLIDE NORMAL TO C?
C-----------------------------------------------------------------------
      IF ( L(3,2) .EQ. 10 .OR. L(4,2) .EQ. 10 ) GO TO 520
C-----------------------------------------------------------------------
C  NO.  DO WE HAVE A 21 ALONG B?
C-----------------------------------------------------------------------
      IF ( L(1,3) .EQ. 13 .AND. L(2,3) .EQ. 12 ) GO TO 510
C-----------------------------------------------------------------------
C  NO. DO WE HAVE A N-GLIDE NORMAL TO A?
C-----------------------------------------------------------------------
      IF ( L(1,3) .NE. 10 ) GO TO 620
      IF ( L(2,2) .LE. 0 ) GO TO 620
      IF ( L(2,2) .GT. 15 ) GO TO 620
  510 CONTINUE
      D(1,3) = 0.5
      D(2,3) = 0.5
      GO TO 620
  520 CONTINUE
C-----------------------------------------------------------------------
C  P 4N/N * *
C-----------------------------------------------------------------------
      D(1,3) = 0.5
      GO TO 620
  530 CONTINUE
C-----------------------------------------------------------------------
C  IS THE LATTICE I OR F-CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .LT. 5 ) GO TO 550
C-----------------------------------------------------------------------
C  YES.
C  IF THERE IS A C ALONG (110) PLACE THE D AT Y=1/4
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 2 ) D(2,1) = D(2,1)+0.5
C-----------------------------------------------------------------------
C  IS THIS I 41/A * * OR F 41/D * * ?
C-----------------------------------------------------------------------
      IF ( L(4,2) .NE. 4 .AND. L(4,2) .NE. 11 ) GO TO 540
C-----------------------------------------------------------------------
C  YES.
C-----------------------------------------------------------------------
      D(1,3) = 0.25
      IF ( LCENT .EQ. 5 ) D(2,3) = 0.75
      GO TO 620
  540 CONTINUE
C-----------------------------------------------------------------------
C  IS THERE A 41 PRESENT?
C-----------------------------------------------------------------------
      IF ( L(2,2) .NE. 12 ) GO TO 620
C-----------------------------------------------------------------------
C  YES.
C  IF F-CENTERED GO TO 1558
C-----------------------------------------------------------------------
      IF ( LCENT .EQ. 6 ) GO TO 580
      D(2,3) = 0.5
C-----------------------------------------------------------------------
C  SET THE B-AXIS TRANSLATION FLAGS FOR I 41 2 2
C-----------------------------------------------------------------------
      GO TO 570
  550 CONTINUE
C-----------------------------------------------------------------------
C  IS THE LATTICE C-CENTERED?
C-----------------------------------------------------------------------
      IF ( LCENT .NE. 4 ) IER = 23
      IF ( IER .GT. 0 ) GO TO 630
C-----------------------------------------------------------------------
C  C-CENTERED.  AN A NORMAL TO C
C-----------------------------------------------------------------------
      IF ( L(3,2) .EQ. 4 .OR. L(4,2) .EQ. 4 ) GO TO 590
C-----------------------------------------------------------------------
C       IF ( L(3,2).EQ.0 ) D(1,1)=2.0*D(2,2)+D(1,1)
C-----------------------------------------------------------------------
      IF ( D(1,1) .EQ. 0.0 ) D(1,1) = 2.0*D(2,2)
C-----------------------------------------------------------------------
C    IS THERE A 21 ON THE DIAGONAL?
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 13 .AND. L(2,4) .EQ. 12 ) GO TO 520
      IF ( L(2,2) .LE. 0 ) GO TO 620
C-----------------------------------------------------------------------
C  IS THERE A N-GLIDE NORMAL TO (110)?
C-----------------------------------------------------------------------
      IF ( L(1,4) .NE. 10 ) GO TO 620
      IF ( L(2,2) .GT. 15 ) GO TO 620
      D(1,1) = D(1,1)-2.0*D(2,2)
      GO TO 520
  560 CONTINUE
C-----------------------------------------------------------------------
C  ACCOUNT FOR TRANSLATIONS DUE TO DIAGONAL SYMMETRY OPERATION
C  IF F 4B D 2 WE WANT THE 2 AT Z=1/8
C-----------------------------------------------------------------------
      IF ( L(1,3) .EQ. 11 .AND. LCENT .EQ. 6 ) D(3,1) = 0.25
C-----------------------------------------------------------------------
C  IF * 4B * 21 WE WANT THE MIRROR AT X=1/4
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 13 .AND. L(2,4) .EQ. 12 ) D(1,1) = 0.5
C-----------------------------------------------------------------------
C  IF THERE IS A C- OR A N-GLIDE ALONG (110) SET THE 2-AXIS AT Z=1/4
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 2 .OR. L(1,4) .EQ. 10 ) D(3,2) = 0.5
C-----------------------------------------------------------------------
C  IF THERE IS A B- OR A N-GLIDE ALONG (110) SET THE 2 AT X=1/4
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 3 .OR. L(1,4) .EQ. 10 ) D(1,2) = 0.5
      IF ( L(1,4) .NE. 11 ) GO TO 620
  570 CONTINUE
      IF ( LCENT .EQ. 5 ) D(1,2) = 0.5
      D(3,2) = 0.75
      GO TO 620
  580 CONTINUE
C-----------------------------------------------------------------------
C  F 41 * *
C-----------------------------------------------------------------------
      D(1,3) = 0.25
      D(2,3) = 0.75
      GO TO 620
  590 CONTINUE
C-----------------------------------------------------------------------
C  C 4* /A * *
C-----------------------------------------------------------------------
      D(1,3) = 0.25
      D(2,3) = 0.25
      IF ( L(1,4) .EQ. 3 .OR. L(1,4) .EQ. 10 ) D(1,1) = 0.5
      GO TO 620
  600 CONTINUE
C-----------------------------------------------------------------------
C  IT IS TRIGONAL 31*
C-----------------------------------------------------------------------
      IF ( L(1,4) .EQ. 12 ) GO TO 130
C-----------------------------------------------------------------------
C  IT IS TRIGONAL 31M
C-----------------------------------------------------------------------
      LAUENO = 10
      GO TO 620
  610 CONTINUE
      I209 = 1
  620 CONTINUE
      RETURN
  630 CONTINUE
      IF ( IER .EQ. 0 ) IER = 5
      RETURN
      END
C
C
CODE FOR SGTRCF
      SUBROUTINE SGTRCF(M,RT,N,M2,LCENT,LAUENO,IER,LPT)
      DIMENSION RT(5,4,25)
      DIMENSION ICENV(3,5),NCVT(7),JCVT(7)
C
\XUNITS
\XSSVAL
\XIOBUF
C
      DATA ICENV/0,0,0,0,6,6,6,0,6,6,6,0,6,6,6/
      DATA NCVT/1,2,3,4,5,4,1/
      DATA JCVT/1,1,2,3,4,1,1/
      IER = 0
      IRN = RT(5,2,N)
      IRM = RT(5,2,M2)
      IRX = MOD((IRN/144+IRM/144),12)
      IRY = MOD((IRN/12 +IRM/12 ),12)
      IRZ = MOD(IRN+IRM,12)
      NCV = NCVT(LCENT)
      JCV = JCVT(LCENT)
        DO 120 ICV = 1,NCV,JCV
        IRX1 = MOD(IRX+ICENV(1,ICV),12)
        IRY1 = MOD(IRY+ICENV(2,ICV),12)
        IRZ1 = MOD(IRZ+ICENV(3,ICV),12)
C-----------------------------------------------------------------------
C  DOES THIS PAIR MAKE A 1BAR?
C-----------------------------------------------------------------------
        M2Z = M2
        IF ( RT(5,1,N)+RT(5,1,M2) .EQ. 0 ) M2Z = 1
C-----------------------------------------------------------------------
C  NO.
C-----------------------------------------------------------------------
        IF ( RT(3,3,N)+RT(3,3,M2Z) .LE. 0 ) IRZ1 = 0
C-----------------------------------------------------------------------
C  IS THIS AN OPERATOR OPERATING ALONG THE FACE DIAGONAL?
C-----------------------------------------------------------------------
        IF ( LAUENO .LE. 3 .OR. M .NE. 4 ) GO TO 100
C-----------------------------------------------------------------------
C  YES.
C-----------------------------------------------------------------------
        IRX1 = MOD(IRX1+IRY1,12)
        IRY1 = 0
        GO TO 110
  100   CONTINUE
C-----------------------------------------------------------------------
C  NO.
C-----------------------------------------------------------------------
        IF ( RT(1,1,N)+RT(1,1,M2Z) .LE. 0 ) IRX1 = 0
        IF ( RT(2,2,N)+RT(2,2,M2Z) .LE. 0 ) IRY1 = 0
  110   CONTINUE
        TOTTR = 144*IRX1+12*IRY1+IRZ1
        IF ( TOTTR .EQ. 0 ) RETURN
  120   CONTINUE
      CONTINUE
C
C -- ERROR
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE (NCWU,10000) RT(5,2,N),RT(5,2,M2),TOTTR,IRX,
     2 IRY,IRZ,RT(5,1,N),RT(5,1,M2)
      ENDIF
      WRITE ( CMON, 10000) RT(5,2,N),RT(5,2,M2),TOTTR,IRX,
     2                      IRY,IRZ,RT(5,1,N),RT(5,1,M2)
      CALL XPRVDU(NCEROR, 1,0)
10000 FORMAT (3F10.1,3I5,2F10.1)
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE (NCWU,11000) M,N,M2
      ENDIF
      WRITE ( CMON, 11000) M,N,M2
      CALL XPRVDU(NCEROR, 1,0)
11000 FORMAT (1X,'Operator',I2,' generates matrix',I3,
     2 ' which has a translation conflict',2I3)
C
      IER = 18
C
C
      RETURN
      END
C
C
C
CODE FOR SGLPAK
      SUBROUTINE SGLPAK(L,IER)
      DIMENSION L(4)
      IF ( L(2) .LT. 12 ) IER = 4
      IF ( L(2) .GT. 17 ) IER = 4
      L(1) = L(2)
      L(2) = 3
      RETURN
      END
C
C
C
CODE FOR SGERRS
      SUBROUTINE SGERRS(SGP,IER,LPT)
      DIMENSION SGP(10)
C
      CHARACTER *52 CMESSG(25)
C
\XUNITS
\XSSVAL
\XERVAL
\XIOBUF
C
      DATA CMESSG(1)  /
     2 'Either a 5-axis anywhere or a 3-axis in field 4' /
      DATA CMESSG(2)  / 'Less than 2 operator fields were found' /
      DATA CMESSG(3)  /
     2 'Lattice operator was not a P, A, B, C, I, F or R' /
      DATA CMESSG(4)  / 'Rhombohedral lattice without a 3-axis' /
      DATA CMESSG(5)  / 'Minus sign does not precede 1, 2, 3, 4 or 6 ' /
      DATA CMESSG(6)  / 'Lattice S. R. found an error'/
      DATA CMESSG(7)  /
     2 '1st operator in a field was a space. Impossible' /
      DATA CMESSG(8)  / 'I for computed GO TO out of range' /
      DATA CMESSG(9) / 'An a-glide mirror normal to a' /
      DATA CMESSG(10) / 'A b-glide mirror normal  to b' /
      DATA CMESSG(11) / 'A c-glide mirror normal  to c' /
      DATA CMESSG(12) / 'A d-glide in a primitive lattice' /
      DATA CMESSG(13) / 'A 4-axis not in the 2nd operator field' /
      DATA CMESSG(14) / 'A 6-axis not in the 2nd operator field' /
      DATA CMESSG(15) /
     2 'More than 24 matrices needed to define the group' /
      DATA CMESSG(16) /
     2 'More than 24 matrices needed to define the group' /
      DATA CMESSG(17) / 'Improper construction of a rotation operator' /
      DATA CMESSG(18) / 'No mirror following a /' /
      DATA CMESSG(19) / 'A translation conflict between operators' /
      DATA CMESSG(20) / 'The 2bar operator is not allowed' /
      DATA CMESSG(21) /
     2 '3 fields are legal only in R lattices and m3 cubic' /
      DATA CMESSG(22) / 'Syntax error. Expected I-43d at this point' /
      DATA CMESSG(23) / '**** THERE IS NO ERROR MESSAGE 23 ****' /
      DATA CMESSG(24) / 'A or B centered tetragonal?  Impossible!!!!' /
      DATA CMESSG(25) / 'No delimiter blanks in symbol. Try again. '/
C
C
C
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE (NCWU,10000) SGP, CMESSG(IER+1)
      ENDIF
      WRITE ( CMON, 10000) SGP, CMESSG(IER+1)
      CALL XPRVDU(NCEROR, 2,0)
10000 FORMAT (1X,'Error while processing space group symbol ',10A1,/,
     2 1X,A)
C
C
      CALL XERHND ( IERERR )
C
C
      RETURN
      END
C
C
C
CODE FOR SGPRNT
      SUBROUTINE SGPRNT (SPG,JRT,LAUENO,NAXIS,NCENT,LCENT,NSYM,NPOL,CEN,
     $                   NCV,LPT)
C-----------------------------------------------------------------------
C  SPACE GROUP ROUTINE PRINTING
C-----------------------------------------------------------------------
      DIMENSION SPG(10),JRT(3,4,25),CEN(3,4),NCVT(7),CENV(3,6),NSYS(14)
      CHARACTER*3 XYZ(12),TRA(11),OUTL(3,2,3),POLAR(8)
      CHARACTER*4 LTYP(3,7),SYST(3,8),LAUE(2,14)
      CHARACTER*1 NAX(3),NC(2)
C
      CHARACTER *16 CLINE
\ISTORE
\STORE
\XLST02
\XUNITS
\XSSVAL
\QSTORE
\XIOBUF
C
      DATA XYZ/'-z','-y','-x','x-y','Err','y-x',' x',' y',' z','+x',
     $         '+y','+z'/
      DATA TRA/'   ','Err','1/6','1/4','1/3','Err','1/2','Err','2/3',
     $         '3/4','5/6'/
      DATA LTYP/'  Pr','imit','ive ',
     $          ' A-C','ente','red ',' B-C','ente','red ',
     $          ' C-C','ente','red ',' I-C','ente','red ',
     $          ' F-C','ente','red ',' R-C','ente','red '/
      DATA SYST/'Tric','lini','c   ','Mono','clin','ic  ',
     $          'Orth','orho','mbic','Tetr','agon','al  ',
     $          'Rhom','bohe','dral','Trig','onal','    ',
     $          'Hexa','gona','l   ','Cubi','c   ','    '/
      DATA LAUE/'1bar','    ','2/m ','    ','mmm ','    ','4/m ','    ',
     $          '4/mm','m   ','3bar','    ','3bar',' M  ','3bar','    ',
     $          '3bar','m 1 ','3bar','1 m ','6/m ','    ','6/mm','m   ',
     $          'M 3 ','    ','M 3 ','M   '/
      DATA POLAR/'x','y','x y','z','x z','y z','xyz','111'/
      DATA NAX/'a','b','c'/
      DATA NSYS/1,2,3,4,4,5,5,6,6,6,7,7,8,8/
      DATA NC/'A',' '/
      DATA NCVT/1,2,2,2,2,4,3/
      DATA CENV/  0,0.5,0.5,  0.5,0,0.5,  0.5,0.5,0,  0.5,0.5,0.5,
     $      0.3333333,0.6666667,0.6666667,0.6666667,0.3333333,0.3333333/
      NCV = NCVT(LCENT)
      MULT = NCV*NSYM*(NCENT + 1)
      LSYS = NSYS(LAUENO)
      CEN(1,1) = 0.0
      CEN(2,1) = 0.0
      CEN(3,1) = 0.0
      IF (NCV .LE. 1) GO TO 110
      J = LCENT - 1
      IF (LCENT .EQ. 6) J = 1
      IF (LCENT .EQ. 7) J = 5
        DO 100 I = 2,NCV
        CEN(1,I) = CENV(1,J)
        CEN(2,I) = CENV(2,J)
        CEN(3,I) = CENV(3,J)
        J = J + 1
  100   CONTINUE
  110 CONTINUE
      NPX = 1
      NPY = 2
      NPZ = 4
      NPXYZ = 0
      NPYXZ = 1
        DO 120 I = 1,NSYM
        IF (JRT(1,1,I) .LE. 0) NPX = 0
        IF (JRT(2,2,I) .LE. 0) NPY = 0
        IF (JRT(3,3,I) .LE. 0) NPZ = 0
        IF (JRT(1,3,I) .GT. 0) NPXYZ = 8
        IF (JRT(1,3,I) .LT. 0) NPYXZ = 0
  120   CONTINUE
      NPOL = (NPX + NPY + NPZ + NPXYZ*NPYXZ)*(1 - NCENT)
      IF (ISSPRT .EQ. 0) THEN
      WRITE (NCWU,10000) SPG,NC(NCENT + 1),
     $                  LTYP(1,LCENT),LTYP(2,LCENT),LTYP(3,LCENT),
     $                  SYST(1,LSYS),SYST(2,LSYS),SYST(3,LSYS),
     $                  LAUE(1,LAUENO),LAUE(2,LAUENO),MULT
      ENDIF
      WRITE ( CMON, 10000) SPG,NC(NCENT + 1),
     2                  LTYP(1,LCENT),LTYP(2,LCENT),LTYP(3,LCENT),
     3                  SYST(1,LSYS),SYST(2,LSYS),SYST(3,LSYS),
     2                  LAUE(1,LAUENO),LAUE(2,LAUENO),MULT
      CALL XPRVDU(NCVDU, 3,1)
      IF (NAXIS .GT. 0) THEN
      IF (ISSPRT .EQ. 0) THEN
        WRITE (NCWU,11000) NAX(NAXIS)
      ENDIF
         WRITE ( CMON, 11000) NAX(NAXIS)
         CALL XPRVDU(NCVDU, 1,1)
      ENDIF
      IF (NPOL  .GT. 0) THEN
      IF (ISSPRT .EQ. 0) THEN
        WRITE (NCWU,12000) POLAR(NPOL)
      ENDIF
        WRITE ( CMON, 12000) POLAR(NPOL)
        CALL XPRVDU(NCVDU, 1,1)
      ENDIF
      IF (ISSPRT .EQ. 0) WRITE (NCWU,13000)
      WRITE ( CMON, 13000)
      CALL XPRVDU(NCVDU, 1,0)
10000 FORMAT (1X,' Space Group ',10A1/
     $        '  The Space Group is ',A1,'Centric',6A4,
     $        '  Laue Symmetry ',2A4/
     $        '  Multiplicity of a General Site is',I4)
11000 FORMAT ('  The Unique Axis is ',A1)
12000 FORMAT ('  The location of the origin is arbitrary in ',A3)
13000 FORMAT (1X,' The Equivalent Positions are:'/)
      KI = 1
      KL = 2
      IF (LAUENO .GT. 5) KL = 3
        DO 140 I = 1,NSYM
          DO 130 J = 1,3
          IJ = 2*JRT(J,1,I) + 3*JRT(J,2,I) + 4*JRT(J,3,I) + 5
          IK = JRT(J,4,I) + 1
          IF (IK .GT. 1 .AND. IJ .GT. 5) IJ = IJ + 3
          OUTL(J,2,KI) = XYZ(IJ)
          OUTL(J,1,KI) = TRA(IK)
  130     CONTINUE
        KI = KI + 1
        IF (KI .LE. KL) GO TO 140
      IF (ISSPRT .EQ. 0) THEN
        WRITE (NCWU,15000)
     $        ((OUTL(I1,1,K),OUTL(I1,2,K),I1 = 1,3),K = 1,KL)
      ENDIF
        WRITE ( CMON, 15000)
     2        ((OUTL(I1,1,K),OUTL(I1,2,K),I1 = 1,3),K = 1,KL)
        CALL XPRVDU(NCVDU, 1,0)
        KI = 1
  140   CONTINUE
      IF (LAUENO .EQ. 1) THEN
      IF (ISSPRT .EQ. 0) THEN
        WRITE (NCWU,15000)
     $  (OUTL(I,1,1),OUTL(I,2,1),I = 1,3)
      ENDIF
        WRITE ( CMON, 15000)
     2                   (OUTL(I,1,1),OUTL(I,2,1),I = 1,3)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      IF (ISSPRT .EQ. 0) THEN
      WRITE (NCWU,14000)
      ENDIF
c      WRITE ( CMON, 14000)
c      CALL XPRVDU(NCVDU, 1,0)
C----- SAVE THE CRYSTAL CLASS
      CLINE = SYST(1,LSYS)(1:4)//SYST(2,LSYS)(1:4)
     1 //SYST(3,LSYS)(1:4)
      READ(CLINE,'(4A4)') (ISTORE(I),I=L2CC, L2CC+MD2CC-1)
      RETURN
14000 FORMAT (' ')
15000 FORMAT (3(2X,3(1X,2A3)))
      END
C
C
C
CODE FOR SGMTML
      SUBROUTINE SGMTML(X,I,Y,J,Z,K)
      DIMENSION X(5,4,25),Y(5,4,25),Z(5,4,25)
        DO 100 L = 1,4
          DO 100 M = 1,4
          Z(L,M,K) = 0.0
            DO 100 N = 1,4
            Z(L,M,K) = Z(L,M,K)+Y(L,N,J)*X(N,M,I)
  100       CONTINUE
      Z(1,4,K) = AMOD(5.0+Z(1,4,K),1.0)
      Z(2,4,K) = AMOD(5.0+Z(2,4,K),1.0)
      Z(3,4,K) = AMOD(5.0+Z(3,4,K),1.0)
      Z(5,1,K) = 81*(2*Z(1,1,K)+3*Z(1,2,K)+4*Z(1,3,K))+9*(2*Z(2,1,K)+3*
     $ Z(2,2,K)+4*Z(2,3,K))+2*Z(3,1,K)+3*Z(3,2,K)+4*Z(3,3,K)
      Z(5,2,K) = 1728*Z(1,4,K)+144*Z(2,4,K)+12*Z(3,4,K)
      Z(5,3,K) = 0.0
      Z(5,4,K) = 0.0
      CONTINUE
      RETURN
      END
C
C
C
CODE FOR SGRMAT
      SUBROUTINE SGRMAT(RT,A,B,C,D,E,F,G,H,O)
      INTEGER A,B,C,D,E,F,G,H,O
      DIMENSION RT(5,4)
      RT(1,1) = A
      RT(1,2) = B
      RT(1,3) = C
      RT(1,4) = 0.0
      RT(2,1) = D
      RT(2,2) = E
      RT(2,3) = F
      RT(2,4) = 0.0
      RT(3,1) = G
      RT(3,2) = H
      RT(3,3) = O
      RT(3,4) = 0.0
      RT(4,1) = 0.0
      RT(4,2) = 0.0
      RT(4,3) = 0.0
      RT(4,4) = 1.0
      RT(5,1) = 81*(2*RT(1,1)+3*RT(1,2)+4*RT(1,3))+9*(2*RT(2,1)+3*RT(2,
     $ 2)+4*RT(2,3))+2*RT(3,1)+3*RT(3,2)+4*RT(3,3)
      RT(5,2) = 1728*RT(1,4)+144*RT(2,4)+12*RT(3,4)
      RT(5,3) = 10.0
      RT(5,4) = 20.
      RETURN
      END
C
C
CODE FOR XCONOP
      SUBROUTINE XCONOP( TXTIN, LIN, TXTOUT, LOUT)
C
C-----CONVERT FRACTIONAL SYMMETRY OPERATOR TO DECIMAL
C
C      TXTIN      TEXT OF FRACTIONAL OPERATOR (FROM XSUMOP)
C      LIN        LENGTH OF TEXT
C      TXTOUT     TEXT OF DECIMAL OPERATOR
C      LOUT       LENGTH OF TEXT
C
      CHARACTER *(*) TXTIN
      CHARACTER *(*) TXTOUT
      CHARACTER *8 CVALUE
      CHARACTER *3 CSIGN
      CHARACTER *1 CTERM
      CHARACTER *10 CNUM
C
\XUNITS
\XSSVAL
C
      DATA CSIGN / '--+' /
      DATA CNUM / '1234567890' /
C
C----- CLEAR BUFFER
      TXTOUT = ' '
      JIN = 1
      LOUT = 0
C
1000  CONTINUE
      JSIGN = (INDEX (CSIGN, TXTIN(JIN:JIN)))
      IF (JSIGN .LE. 0) THEN
            LOUT = LOUT + 1
            TXTOUT(LOUT:LOUT) = TXTIN(JIN:JIN)
            JIN = JIN + 1
      ELSE
            JIN = JIN + 1
            IF (INDEX( CNUM, TXTIN(JIN:JIN)) .GT. 0) THEN
                  JSIGN = JSIGN - 2
                  I = KGTNUM (TXTIN(JIN:LIN), CTERM, NCHAR)
                  JIN = JIN + NCHAR + 1
                  IF (I .LE. 0) GOTO 9000
                  IF (CTERM .NE. '/') GOTO 9000
                  J = KGTNUM (TXTIN(JIN:LIN), CTERM, NCHAR)
                  JIN = JIN + NCHAR + 1
                  IF (J .LE. 0) GOTO 9000
                  IF (CTERM .EQ. '/') GOTO 9000
                  VALUE = FLOAT( I * JSIGN) / FLOAT(J)
                  WRITE( CVALUE,'(SP,F7.4)') VALUE
                  I = LOUT + 1
                  LOUT = LOUT + 6
                  TXTOUT( I:LOUT) = CVALUE(1:7)
                  LOUT = LOUT + 1
                  TXTOUT( LOUT:LOUT ) = CTERM
            ELSE
                  LOUT = LOUT + 1
                  J = JIN - 1
                  TXTOUT(LOUT:LOUT) = TXTIN(J:J)
            ENDIF
      ENDIF
C
      IF (JIN .LE. LIN) GOTO 1000
      RETURN
9000  CONTINUE
C      STOP 'XCONOP ERROR'
      CALL GUEXIT (2026)
      END
C
C
CODE FOR CDFOUN
      SUBROUTINE CDFOUN (LAUE,ICEN,NEQV,NCV,ABC,JRT,CEN,SPG,
     1 RMI, RMA, JAXIS )
C-----------------------------------------------------------------------
C
C           NRCVAX Structure Package Fourier Unit Generator
C
C                            E. J. Gabe
C           Chemistry Division,  N. R. C.   Ottawa   Canada
C
C *********************************************************************
C * THIS ROUTINE MAY NOT BE REPRODUCED WITHOUT PERMISSION FROM N.R.C. *
C *********************************************************************
C
C  The routine generates the x, y and z limits of the portion of the
C  unit cell to be computed by a Fourier routine, in order to ensure
C  that at least one assymetric unit is computed.  The unit is computed
C  as a parallelepiped, with bounding surfaces parallel to cell faces.
C  this means that in higher symmetry space-groups there will be some
C  redundancy. This is unavoidable.
C
C  The routine functions by setting up a grid of test points within the
C  unit cell, spaced at fractions of a cell which depend on the Laue
C  group and which are chosen to be adequately small for that group.
C  The axes can be in any order and are represented symbolically by I1,
C  I2 and I3.  There are NX1, NX2 and NX3 points in each of the 3
C  directions.  NEQV is the number of equivalent positions (24 max),
C  ICENT is the centrosymmetric indicator (1 or 2) and NCV is the
C  number of lattice centring points (4 max).
C
C  The limits are found by generating all equivalents for each test
C     point, i.e. NEQV*ICENT*NCV equivs for each of NX1*NX2*NX3 points
C     and then finding the min (or max) value of the I3 coordinate.
C     The max Fourier limit is then the maximum of the minimum values.
C     The minimum value is found with the same procedure, but only using
C     those values less than the previously found maximum in the search
C     for the maximum remaining I3 coordinate for each test point.
C     The min Fourier limit is then the minimum of these maximum values.
C     I1, I2 and I3 are then rotated and the new I3 limits found, subect
C     to the constraints of the limit found for the previous I3
C     direction(s).
C
C  Because of the large number of points and equivs involved the
C  procedure can be quite lengthy for higher symmetry space-groups, but
C  for all commonly occurring groups it takes only a second or so.
C
C-----------------------------------------------------------------------
C----- CHANGES BY DJW, AFTER IUCR XV
C
C      USE REAL SPG IN CALL, AND COPY TO CHARACTER SGDUM
C      REPLACE INTEGER RT BY JRT
C      COMMON BLOCK FUNIT ADDED TO CALL ARGUMENT LIST
C
      DIMENSION ABC(6),JRT(3,4,24),CEN(3,4),NXYZ(3),MXYZ(3),IDXYZ(3),
     $  IDMXYZ(3),MA(3),MI(3),IAX(3,6),LET(3),RMIS(3),RMAS(3),
     $  JCEN(3,4),IRT(3,24),SPG(10),
     1  RMI(3),RMA(3), JAXIS(3)
      CHARACTER C1*2,C2*2,C3*2,LET*1,SGDUM*10
\XUNITS
\XSSVAL
      EQUIVALENCE (NXYZ(1),  NX),  (NXYZ(2),  NY),  (NXYZ(3),  NZ),
     $  (MXYZ(1),  MX),  (MXYZ(2),  MY),  (MXYZ(3),  MZ),
     $  (IDXYZ(1), IDX), (IDXYZ(2), IDY), (IDXYZ(3), IDZ),
     $  (IDMXYZ(1),IDMX),(IDMXYZ(2),IDMY),(IDMXYZ(3),IDMZ)
      DATA IAX/1,2,3, 3,1,2, 2,3,1, 3,2,1, 1,3,2, 2,1,3/
      DATA LET/'X','Y','Z'/
C----- CONVERT SYMBOL TO CHARACTER FORM
      WRITE(SGDUM,10000) SPG
10000 FORMAT(10A1)
C-----------------------------------------------------------------------
C  Initialize for the limit search
C-----------------------------------------------------------------------
      ICENT = ICEN + 1
      ICELL = 48
      ICELL2 = ICELL + ICELL
      ITRANS = ICELL/12
      DO 130 I = 1,NCV
        DO 120 J = 1,3
  120     JCEN(J,I) = ICELL*CEN(J,I) + 0.01
  130 CONTINUE
      DO 140 I = 1,NEQV
        DO 140 J = 1,3
  140   IRT(J,I) = ITRANS*JRT(J,4,I)
C-----------------------------------------------------------------------
C  Get the cell-search fractions depending on the Laue group as follows
C
C  Laue Group     Number      Nx  Ny  Nz         Comment
C      1             1         4   4   4     Triclinic
C     2/m            2         8   8   8     Monoclinic
C     mmm            3         8   8   8     Orthorhombic  (Fddd 16)
C     4/m            4         8   8  16     Tetragonal
C     4/mmm          5         8   8  16     Tetragonal
C     -3R            6         8   8   8     Rhombohedral
C     -3mR           7         8   8   8     Rhombohedral
C     -3             8        12  12  24     Hexagonal
C     -3m1           9        12  12  24     Hexagonal
C     -31m          10        12  12  24     Hexagonal
C     6/m           11        12  12  24     Hexagonal
C     6/mmm         12        12  12  24     Hexagonal
C     m3            13        16  16  16     Cubic
C     m3m           14        16  16  16     Cubic
C  The values for groups 8 and 9 are OK for the order X,Y,Z, if the 2
C  other orders are searched NX and NY should be 24
C-----------------------------------------------------------------------
      IF (LAUE .EQ.  1) NX = 4
      IF (LAUE .GE.  2 .AND. LAUE .LE.  7) NX =  8
      IF (SGDUM .EQ. 'F D D D') NX = 16
      IF (LAUE .GE.  8 .AND. LAUE .LE. 12) NX = 12
      IF (LAUE .EQ. 13 .OR.  LAUE .EQ. 14) NX = 16
      NY = NX
      NZ = NY
      IF (LAUE .GE.  4 .AND. LAUE .LE.  5) NZ = 16
      IF (LAUE .GE.  8 .AND. LAUE .LE. 12) NZ = 24
C-----------------------------------------------------------------------
C  Set up the test point and min/max steps
C-----------------------------------------------------------------------
      MX = NX/2
      MY = NY/2
      MZ = NZ/2
      IDX = ICELL/NX
      IDY = ICELL/NY
      IDZ = ICELL/NZ
      IDMX = ICELL/MX
      IDMY = ICELL/MY
      IDMZ = ICELL/MZ
C-----------------------------------------------------------------------
C  Section to generate the minimum values of a selected coordinate
C  I3 is the direction for which min/max values are being sought.
C  I1 and I2 are the directions for which min and max Fourier limits
C     may have already been found.  These are 0 and 1 at the start.
C
C  The IORD loop allows the axes to be searched in the 3 orders
C  X,Y,Z    Z,X,Y    Y,Z,X.   This will give all possible distinct
C  Fourier limits and in higher symmetry groups allows the routine to
C  find the minimum volume which contains the assymetric unit.
C
C  In the interests of speed only the order X,Y,Z is used.
C-----------------------------------------------------------------------
      RATMIN = 100.0
C     DO 300 IORD = 1,3
      IORD = 1
        I1 = IAX(1,IORD)
        I2 = IAX(2,IORD)
        I3 = IAX(3,IORD)
        C1 = ' X'
        C2 = ' Y'
        C3 = ' Z'
        IF (I1 .EQ. 2) C1 = ' Y'
        IF (I1 .EQ. 3) C1 = ' Z'
        IF (I2 .EQ. 1) C2 = ' X'
        IF (I2 .EQ. 3) C2 = ' Z'
        IF (I3 .EQ. 1) C3 = ' X'
        IF (I3 .EQ. 2) C3 = ' Y'
        DO 150 I = 1,3
          MI(I) = 0
          MA(I) = ICELL
  150     CONTINUE
C-----------------------------------------------------------------------
C  First the loop for the 3 coordinates (ILIM)
C-----------------------------------------------------------------------
        DO 290 ILIM = 1,3
          NX1 = NXYZ(I1) - 1
          NX2 = NXYZ(I2) - 1
          NX3 = NXYZ(I3) - 1
          MAXLIM = NX3*IDXYZ(I3)
          MINLIM = IDXYZ(I3)
          MAI1 = MA(I1)
          MAI2 = MA(I2)
          MAI3 = MA(I3)
          MII1 = MI(I1)
          MII2 = MI(I2)
          MII3 = MI(I3)
C-----------------------------------------------------------------------
C  Now the loop for the min and max values of the I3 direction (IMM),
C  then the loops for the J1, J2 and J3 search directions
C-----------------------------------------------------------------------
          DO 280 IMM = 1,2
            MAX3 = 0
            MIN3 = ICELL
            DO 260 J1 = 1,NX1
              K1 = J1*IDXYZ(I1)
              DO 250 J2 = 1,NX2
                K2 = J2*IDXYZ(I2)
                DO 230 J3 = 1,NX3
                  K3 = J3*IDXYZ(I3)
C-----------------------------------------------------------------------
C  Generate all equivs of each test point K1,K2,K3 and from them find
C  the minimum and maximum I3 values, under the constraint that only I3
C  values for which the I1 and I2 values are within the present limits
C  on the I1 and I2 directions and that the I3 value is less than the
C  present I3 maximum limit.
C-----------------------------------------------------------------------
                  MINEQ = ICELL
                  MAXEQ = 0
                  DO 226 NE = 1,NEQV
                    NE1 = K1*JRT(I1,I1,NE) + K2*JRT(I1,I2,NE) +
     $                    K3*JRT(I1,I3,NE) +   IRT(I1,NE)
                    NE2 = K1*JRT(I2,I1,NE) + K2*JRT(I2,I2,NE) +
     $                    K3*JRT(I2,I3,NE) +   IRT(I2,NE)
                    NE3 = K1*JRT(I3,I1,NE) + K2*JRT(I3,I2,NE) +
     $                    K3*JRT(I3,I3,NE) +   IRT(I3,NE)
                    DO 224 NC = 1,NCV
                      KE1 = NE1 + JCEN(I1,NC)
                      KE2 = NE2 + JCEN(I2,NC)
                      KE3 = NE3 + JCEN(I3,NC)
                      DO 220 NIC = 1,ICENT
                        IF (NIC  .EQ.    2) KE1 = ICELL2 - KE1
                        IF (KE1 .LT.     0) KE1 = KE1 + ICELL
                        IF (KE1 .GT. ICELL) KE1 = KE1 - ICELL
                        IF (KE1 .GE. ICELL) KE1 = KE1 - ICELL
                        IF (KE1 .LT. MII1 .OR. KE1 .GT. MAI1) GO TO 220
                        IF (NIC  .EQ.    2) KE2 = ICELL2 - KE2
                        IF (KE2 .LT.     0) KE2 = KE2 + ICELL
                        IF (KE2 .GT. ICELL) KE2 = KE2 - ICELL
                        IF (KE2 .GE. ICELL) KE2 = KE2 - ICELL
                        IF (KE2 .LT. MII2 .OR. KE2 .GT. MAI2) GO TO 220
                        IF (NIC  .EQ.    2) KE3 = ICELL2 - KE3
                        IF (KE3 .LT.     0) KE3 = KE3 + ICELL
                        IF (KE3 .GT. ICELL) KE3 = KE3 - ICELL
                        IF (KE3 .GE. ICELL) KE3 = KE3 - ICELL
                        IF (KE3 .GT. MAI3) GO TO 220
                        IF (KE3 .LT. MINEQ) MINEQ = KE3
                        IF (KE3 .GT. MAXEQ) MAXEQ = KE3
  220                   CONTINUE
  224                 CONTINUE
  226               CONTINUE
                  IF (IMM .EQ. 1) THEN
                    IF (MINEQ .GT. MAX3) MAX3 = MINEQ
                    IF (MAX3 .GE. MAXLIM) GO TO 270
                  ELSE
                    IF (MAXEQ. LT. MIN3) MIN3 = MAXEQ
                    IF (MIN3 .LE. MINLIM) GO TO 270
                  ENDIF
  230             CONTINUE
  250           CONTINUE
  260         CONTINUE
  270       IF (IMM .EQ. 1) THEN
              MAX3 = IDMXYZ(I3)*((MAX3 + IDXYZ(I3))/IDMXYZ(I3))
              MA(I3) = MAX3
              MAI3 = MAX3
            ELSE
              MIN3 = IDMXYZ(I3)*(MIN3/IDMXYZ(I3))
              MI(I3) = MIN3
              MII3 = MIN3
            ENDIF
  280       CONTINUE
          R = MA(I3)
          RMA(I3) = R/ICELL
          R = MI(I3)
          RMI(I3) = R/ICELL
          I  = I3
          I3 = I2
          I2 = I1
          I1 = I
          MINEQ = MII3
          MAXEQ = MAI3
          MII3 = MII2
          MAI3 = MAI2
          MII2 = MII1
          MAI2 = MAI1
          MII1 = MINEQ
          MAI1 = MAXEQ
  290     CONTINUE
        ASSYM = NEQV*ICENT*NCV
        D1 = MA(I1) - MI(I1)
        D2 = MA(I2) - MI(I2)
        D3 = MA(I3) - MI(I3)
        FOUND = ICELL*ICELL*ICELL/(D1*D2*D3)
        RATIO = ASSYM/FOUND
C-----------------------------------------------------------------------
C  Triclinic, Monoclinic, Orthorhombic and Cubic are finished.
C  Tetragonal and Hexagonal are finished if Ratio = 1.0.
C  Otherwise find the minimum ratio.
C-----------------------------------------------------------------------
        IF (LAUE .LE. 3 .OR. LAUE .GE. 13) GO TO 310
        IF (RATIO .LT. 1.001) GO TO 310
        IF (RATIO .LT. RATMIN) THEN
          RATMIN = RATIO
          I1S = I1
          I2S = I2
          I3S = I3
          RMIS(I1) = RMI(I1)
          RMAS(I1) = RMA(I1)
          RMIS(I2) = RMI(I2)
          RMAS(I2) = RMA(I2)
          RMIS(I3) = RMI(I3)
          RMAS(I3) = RMA(I3)
          ENDIF
  300   CONTINUE
        I1 = I1S
        I2 = I2S
        I3 = I3S
        RMI(I1) = RMIS(I1)
        RMA(I1) = RMAS(I1)
        RMI(I2) = RMIS(I2)
        RMA(I2) = RMAS(I2)
        RMI(I3) = RMIS(I3)
        RMA(I3) = RMAS(I3)
C-----------------------------------------------------------------------
C  Work out the Fourier order from the limits
C-----------------------------------------------------------------------
  310 D1 = (RMA(I1) - RMI(I1))*ABC(I1)
      D2 = (RMA(I2) - RMI(I2))*ABC(I2)
      D3 = (RMA(I3) - RMI(I3))*ABC(I3)
C-----------------------------------------------------------------------
C  The shortest length is assigned to sections and the longest across
C-----------------------------------------------------------------------
      IF (D1 .LE. D2 .AND. D1 .LE. D3) THEN
        J3 = I1
        J2 = I2
        J1 = I3
        IF (D3 .GE. D2) THEN
          J2 = I3
          J1 = I2
        ENDIF
      ENDIF
      IF (D2 .LE. D1 .AND. D2 .LE. D3) THEN
        J3 = I2
        J2 = I1
        J1 = I3
        IF (D3 .GE. D1) THEN
          J2 = I3
          J1 = I1
        ENDIF
      ENDIF
      IF (D3 .LE. D2 .AND. D3 .LE. D1) THEN
        J3 = I3
        J2 = I1
        J1 = I2
        IF (D2 .GE. D1) THEN
          J2 = I2
          J1 = I1
        ENDIF
      ENDIF
C----- SAVE JAXIS
      JAXIS(1) = J1
      JAXIS(2) = J2
      JAXIS(3) = J3
      RETURN
      END
