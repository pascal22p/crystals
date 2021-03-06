CRYSTALS CODE FOR BUTTON.FOR                                                    
      SUBROUTINE ZMNINI
C INITIALISE MENUS
C FIRST CALL THE BUTTON DRAWING ROUTINE
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      LOGICAL LFILES
C READ IN THE FILE
      IF (.NOT.LFILES(-1,'button.cmn',IINPT)) THEN
        CALL ZMORE('ERROR BUTTON.CMN NOT FOUND',0)
        IMENCN = 0
        RETURN
      ENDIF
      READ (IINPT,*) IBNWID,IBNHEI
      INTOT = IBNWID*IBNHEI
C READ IN THE NAMES
      DO 10 I = 1 , INTOT
        READ (IINPT,'(A20)') CBUTTS(I)
        READ (IINPT,'(A80)') CBUTTX(I)
10    CONTINUE
      IF (.NOT.LFILES(0,' ',IINPT)) THEN
        CALL ZMORE('ERROR CLOSING BUTTON.CMN',0)
      ENDIF
      CALL ZSETUP ( IBBACK, IBTEXT, IBBORD, 1)
      IMENCN = 2
      CALL ZDOBUT (CBUTTS,INTOT,500,0,139,440,IBNWID,IBNHEI)
      RETURN
      END


C Load the menu info, one line at a time. This routine
C is called repeatedly until it sets LINPMN to FALSE.
      SUBROUTINE ZMNLOD

      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'CAMIMN.INC'

      INTEGER KOUNT, INTOT, IODD
      SAVE KOUNT, INTOT, IODD
      DATA KOUNT /0/, INTOT /0/, IODD /0/


      IF ( KOUNT .EQ. 0 ) THEN
            READ (LLINE(ILINE),*,ERR=999) IBNWID,IBNHEI
            INTOT = IBNWID*IBNHEI
            KOUNT = 1
            RETURN
      ENDIF

      
      IF ( IODD .EQ. 0 ) THEN
            READ(LLINE(ILINE),'(A20)',ERR=999) CBUTTS(KOUNT)
            IODD = 1
            RETURN
      ENDIF

      IF ( IODD .EQ. 1 ) THEN
            READ(LLINE(ILINE),'(A80)',ERR=999) CBUTTX(KOUNT)
            IODD = 0
C Remove underscore prefix, which can be used to hide
C for example #SCRIPT from KRDREC during processing.
            IF(CBUTTX(KOUNT)(1:1).EQ.'_')THEN
                  READ(CBUTTX(KOUNT)(2:),'(A)') CBUTTX(KOUNT)
            ENDIF

            KOUNT = KOUNT + 1

            IF ( KOUNT .GT. INTOT ) THEN
                  LINPMN = .FALSE.
                  KOUNT = 0
                  INTOT = 0
                  IODD = 0
                  CALL ZSETUP ( IBBACK, IBTEXT, IBBORD, 1)
                  IMENCN = 2
                  CALL ZDOBUT (CBUTTS,INTOT,500,0,139,440,IBNWID,IBNHEI)
            ENDIF

            RETURN
      ENDIF

999   CONTINUE
      CALL ZMORE('Error inputting menu buttons',0)
      CALL ZMORE1('Error inputting menu buttons',0)
      LINPMN = .FALSE.
      KOUNT = 0
      INTOT = 0
      IODD = 0
      RETURN

      END

CODE FOR IBDRAW
      INTEGER FUNCTION IBDRAW (IX,IY,CTEXT)
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      CHARACTER*(*) CTEXT
      INTEGER IXX(5),IYY(5)
      INTEGER IX,IY
      INTEGER IXT,IYT
      IBDRAW = -1
      IBUTNO = IBUTNO + 1
      IF (IBUTNO.GT.MAXBUT) RETURN
C FIND THE BUTTON LENGTH
      ILENB = LEN(CTEXT)
      IMAX = 0
      DO 10 I = ILENB , 1 , -1
        IF (CTEXT(I:I).NE.' ') THEN
          IMAX = I
          GOTO 20
        ENDIF
10    CONTINUE
20    CONTINUE
      IF (IMAX.EQ.0) THEN
        IBUTTS(1,IBUTNO) = -1
        RETURN
      ENDIF
C LOOK FOR THE BUTTON SPLITTING CHARACTER '_'
      ISPLIT = INDEX(CTEXT,'_')
      IF (ISPLIT.EQ.0) THEN
        ILENB = IMAX*8.0
      ELSE
        ILEN1 = (ISPLIT-1)*8.0
        ILEN2 = (IMAX-ISPLIT)*8.0
      ENDIF
      IBDRAW = IBUTNO
C FIRST MAKE UP THE POLYGON
C STORE THE CORNERS IN THE ARRAY
      IBUTTS(1,IBUTNO) = IX
      IBUTTS(2,IBUTNO) = IY
      IBUTTS(3,IBUTNO) = IX+IWIDTH
      IBUTTS(4,IBUTNO) = IY+IHEIGT
      IXX(1) = IX
      IYY(1) = IY
      IXX(2) = IBUTTS(3,IBUTNO)
      IYY(2) = IYY(1)
      IXX(3) = IXX(2)
      IYY(3) = IBUTTS(4,IBUTNO)
      IXX(4) = IXX(1)
      IYY(4) = IYY(3)
      IXX(5) = IXX(1)
      IYY(5) = IYY(1)
C----- DRAW A PALE POLYGON
      NPVERT = 5
      CALL ZPOLGN (IXX,IYY,NPVERT,7)
C      CALL ZPLINE (IXX,IYY,5,IBBORD)
C----- DRAW A DARK OFFSET POLYGON
      IXX(1) = IXX(1)+2
      IYY(1) = IYY(1)+2
      IYY(2) = IYY(2)+2
      IXX(4) = IXX(4)+2
      IXX(5) = IXX(1)
      IYY(5) = IYY(1)
      NPVERT = 5
      call zpolgn (ixx, iyy, NPVERT, 8)
C----- DRAW THE BUTTON TOP
      IXX(2) = IXX(2)-3
      IXX(3) = IXX(3)-3
      IYY(3) = IYY(3)-3
      IYY(4) = IYY(4)-3
      NPVERT = 5
      CALL ZPOLGN (IXX, IYY, NPVERT, IBBACK)
C
C CENTRE THE STRING IN THE BUTTON
      IF (IHEIGT.GT.10) THEN
        IF (ISPLIT.EQ.0) THEN
          IHPOS = (IHEIGT-10.0)/2.0
        ELSE
          IHPOS = (IHEIGT-20.0)/2.0
        ENDIF
        IYT = IY + IHPOS
      ELSE
        IYT = IY
      ENDIF
      IF (ICENTR.EQ.1) THEN
        IF (ISPLIT.EQ.0) THEN
          IF (ILENB.GT.IWIDTH) RETURN
          IXT = (IWIDTH-ILENB)/2.0 + IX
        ELSE
          IF (ILEN1.GT.IWIDTH.OR.ILEN2.GT.IWIDTH) RETURN
          IXT = (IWIDTH-ILEN1)/2.0 + IX
        ENDIF
C STORE THE XY COORDINATES OF THE TEXT
        IBUTTS(5,IBUTNO) = IXT
        IBUTTS(6,IBUTNO) = IYT
        IF (ISPLIT.EQ.0) THEN
          CALL ZDTEXT (CTEXT(1:IMAX),IXT,IYT,IBTEXT)
          IBUTTS(7,IBUTNO) = -1
          IBUTTS(8,IBUTNO) = 0
        ELSE
          CALL ZDTEXT (CTEXT(1:ISPLIT-1),IXT,IYT,IBTEXT)
          IYT = IYT + 10
          IXT = (IWIDTH-ILEN2)/2.0 + IX
          CALL ZDTEXT (CTEXT(ISPLIT+1:IMAX),IXT,IYT,IBTEXT)
          IBUTTS(7,IBUTNO) = IXT
          IBUTTS(8,IBUTNO) = IYT
        ENDIF
      ELSE
        IXT = IX + 10
        IF (ISPLIT.EQ.0) THEN
          CALL ZDTEXT (CTEXT(1:IMAX),IXT,IYT,IBTEXT)
        ELSE
          CALL ZDTEXT (CTEXT(1:ISPLIT-1),IXT,IYT,IBTEXT)
          IYT= IYT + 10
          CALL ZDTEXT(CTEXT(ISPLIT+1:IMAX),IXT,IYT,IBTEXT)
        ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZSETUP
      SUBROUTINE ZSETUP (ICOL1,ICOL2,ICOL3,IFLAG1)
c^^^      INCLUDE 'BUTTON.INC'
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      IBBACK = ICOL1
      IBTEXT = ICOL2
      IBBORD = ICOL3
      ICENTR = IFLAG1
      RETURN
      END
 
CODE FOR ZDOBUT
      SUBROUTINE ZDOBUT (CTEXT,N,IXPOS,IYPOS,IWID,IHEI,INWID,INHEI)
      CHARACTER*(*) CTEXT(N)
c^^^      INCLUDE 'BUTTON.INC'
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

C IVFLAG = 1, VERTICAL COLUMNS
C IVFLAG = 0, HORIZONTAL
      INTEGER IWID,IHEI
C WORK OUT THE WIDTH AND HEIGHT OF THE BUTTONS
      IWIDTH = IWID/INWID
      IHEIGT = IHEI/INHEI
      IBUTNO = 0
C LOOP OVER THE BUTTONS
      DO 10 I = 1 , INWID
        DO 20 J = 1, INHEI
          IX = IXPOS + (I-1)*IWIDTH
          IHPOS = MOD(J,INHEI+1)
          IY = IYPOS + (IHPOS-1)*IHEIGT
          INBUT = (I-1)*INHEI + IHPOS
          IBNO = IBDRAW (IX,IY,CTEXT(INBUT))
          IF (IBNO.EQ.-1) THEN
            WRITE (6,*) 'ERROR - BUTTON NAME TOO LONG'
            WRITE (6,*) CTEXT(INBUT)
          ENDIF
20      CONTINUE
10    CONTINUE
      RETURN
      END
           
 
CODE FOR ZMENUS
      SUBROUTINE ZMENUS
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      INTEGER IX(5),IY(5)
      CHARACTER*(ICLEN) CTEXT
      IFLAG = 0
C DRAW THE MENU BUTTONS
C      INTOT = IBNWID*IBNHEI
C      CALL ZDOBUT (CBUTTS,INTOT,500,0,139,460,IBNWID,IBNHEI)
C NOW NEED TO DRAW THE BUTTONS
      DO 10 I = 1 , IBUTNO
        IX(1) = IBUTTS(1,I)
        IX(2) = IBUTTS(3,I)
        IX(3) = IX(2)
        IX(4) = IX(1)
        IX(5) = IX(1)
        IY(1) = IBUTTS(2,I)
        IY(2) = IY(1)
        IY(3) = IBUTTS(4,I)
        IY(4) = IY(3)
        IY(5) = IY(1)
C----- DRAW A PALE POLYGON
       NPVERT = 5
       CALL ZPOLGN (IX,IY,NPVERT,7)
C      CALL ZPLINE (IX,IY,5,IBBORD)
C----- DRAW A DARK OFFSET POLYGON
      IX(1) = IX(1)+2
      IY(1) = IY(1)+2
      IY(2) = IY(2)+2
      IX(4) = IX(4)+2
      IX(5) = IX(1)
      IY(5) = IY(1)
      NPVERT = 5
      call zpolgn (ix, iy, NPVERT, 8)
C----- DRAW THE BUTTON TOP
      IX(2) = IX(2)-3
      IX(3) = IX(3)-3
      IY(3) = IY(3)-3
      IY(4) = IY(4)-3
      NPVERT = 5
      CALL ZPOLGN (IX, IY, NPVERT, IBBACK)
C
C NOW DRAW IN THE TEXT
        ISPLIT = INDEX (CBUTTS(I),'_')
        IF (ISPLIT.EQ.0) THEN
          CALL ZDTEXT (CBUTTS(I),IBUTTS(5,I),IBUTTS(6,I),IBTEXT)
        ELSE
          CALL ZDTEXT (CBUTTS(I)(1:ISPLIT-1),IBUTTS(5,I),IBUTTS(6,I),
     c    IBTEXT)
          CALL ZDTEXT (CBUTTS(I)(ISPLIT+1:20),IBUTTS(7,I),IBUTTS(8,I),
     c    IBTEXT)
        ENDIF
10    CONTINUE
C DRAW THE INPUT REGION - USE THE SCREEN COORDINATES XCENS, YCENS
C      CALL ZMNINP
      RETURN

      END

CODE FOR ZMNINP
      SUBROUTINE ZMNINP
C DRAW THE INPUT REGION - USE THE SCREEN COORDINATES XCENS, YCENS
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INTEGER IX(5),IY(5)
      IX(1) = 0
      IY(1) = YCENS*2.0
      IX(2) = XCENS*2.0+139
      IY(2) = IY(1)
      IX(3) = IX(2)
      IY(3) = 2.0*YCENS+42
      IX(4) = IX(1)
      IY(4) = IY(3)
      IX(5) = IX(1)
      IY(5) = IY(1)
      NPVERT = 5
      CALL ZPOLGN (IX,IY,NPVERT,IBBACK)
      CALL ZPLINE (IX,IY,NPVERT,IBBORD)
      RETURN
      END

