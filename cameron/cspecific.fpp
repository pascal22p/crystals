C ---- changes to this file
C 1. include \CAMWIN for rescaling pixel values
C 2. most mouse routines commented out - not required under Windows
C 3. see cljf for many other changes (mostly in lower case)

CRYSTALS CODE FOR SPECIFIC.FOR
CAMERON CODE FOR SPECIFIC
CODE FOR ZCLRA
      SUBROUTINE ZCLRA (IX1,IY1,IX2,IY2,ICOL)
&DOS\CAMWIN
&GID\CAMCOL
&GIL\CAMCOL
      INTEGER IX1,IY1,IX2,IY2,ICOL

&DOS      INTEGER*2 IXX1,IYY1,IXX2,IYY2,ICOL1
&DOS      ixx1 = nint(float(ix1)*scale_X)
&DOS      iyy1 = nint(float(iy1)*scale_Y)
&DOS      ixx2 = nint(float(ix2)*scale_X) - 1
&DOS      iyy2 = nint(float(iy2)*scale_Y) - 1
&DOS      ICOL1 = ICOL
&DOS      CALL CLEAR_SCREEN_AREA@(IXX1,IYY1,IXX2,IYY2,ICOL1)

C&&GIDGIL      CHARACTER*80 CHARTC
&&GIDGIL      INTEGER IPTS(8)

C &&GIDGIL      WRITE(CHARTC,1)'^^CH CLEAR'
C &&GIDGIL1     FORMAT (A)
C &&GIDGIL      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTCLR

C &&GIDGIL      WRITE(CHARTC,2)'^^CH RGB',
C &&GIDGIL     1 NINT(4.05*IVGACL(1,ICOL+1)),
C &&GIDGIL     2 NINT(4.05*IVGACL(2,ICOL+1)),
C &&GIDGIL     3 NINT(4.05*IVGACL(3,ICOL+1))
C &&GIDGIL2     FORMAT (A,3(1X,I3))
C &&GIDGIL      CALL ZMORE(CHARTC,0)
&&GIDGIL              CALL FSTCOL ( NINT(4.05*IVGACL(1,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(2,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(3,ICOL+1)) )

C &&GIDGIL      WRITE(CHARTC,3)'^^CH POLYF 4',IX1,IY1,IX1,IY2,
C &&GIDGIL     1  IX2,IY2,IX2,IY1
C &&GIDGIL3     FORMAT(A,8(1X,I5))
C &&GIDGIL      CALL ZMORE(CHARTC,0)

&&GIDGIL      IPTS(1) = IX1
&&GIDGIL      IPTS(2) = IY1
&&GIDGIL      IPTS(3) = IX1
&&GIDGIL      IPTS(4) = IY2
&&GIDGIL      IPTS(5) = IX2
&&GIDGIL      IPTS(6) = IY2
&&GIDGIL      IPTS(7) = IX2
&&GIDGIL      IPTS(8) = IY1
&&GIDGIL      CALL FSTFPO(4,IPTS)

      RETURN
      END
 
CODE FOR ZDLINE
      SUBROUTINE ZDLINE (IX1,IY1,IX2,IY2,ICOL)
&DOS\CAMWIN
&&GIDGIL\CAMCOL
      INTEGER IX1,IY1,IX2,IY2,ICOL
&DOS      INTEGER*2 IXX1,IYY1,IXX2,IYY2,ICOL1
&DOS      ixx1 = nint(float(ix1)*scale_X)
&DOS      iyy1 = nint(float(iy1)*scale_Y)
&DOS      ixx2 = nint(float(ix2)*scale_X) 
&DOS      iyy2 = nint(float(iy2)*scale_Y)
&DOS      ICOL1 = ICOL
&DOS      CALL DRAW_LINE@ (IXX1,IYY1,IXX2,IYY2,ICOL1)

&&GILGID      CHARACTER*80 CHARTC
C &&GILGID      WRITE(CHARTC,2)'^^CH RGB',
C &&GILGID     1 NINT(4.05*IVGACL(1,ICOL+1)),
C &&GILGID     2 NINT(4.05*IVGACL(2,ICOL+1)),
C &&GILGID     3 NINT(4.05*IVGACL(3,ICOL+1))
C &&GILGID2     FORMAT (A,3(1X,I3))
C &&GILGID      CALL ZMORE(CHARTC,0)
c
&&GIDGIL              CALL FSTCOL ( NINT(4.05*IVGACL(1,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(2,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(3,ICOL+1)) )

C &&GILGID      WRITE(CHARTC,3)'^^CH LINE',IX1,IY1,IX2,IY2
C &&GILGID3     FORMAT(A,4(1X,I4))
C &&GILGID      CALL ZMORE(CHARTC,0)
&&GILGID      CALL FSTLIN( IX1, IY1, IX2, IY2 )
      RETURN
      END
 
CODE FOR ZDTEXT
      SUBROUTINE ZDTEXT (TEXT,IX,IY,ICOL)
&DOS\CAMWIN
&&GILGID\CAMCOL
      CHARACTER*(*) TEXT
      INTEGER ICOL
&DOS      INTEGER*2 ICOL1,IXX,IYY
&DOS      increment=10
&DOS      if(xwin .eq. 800)  increment=15
&DOS      if(xwin .eq. 1024) increment=20
&DOS      if(xwin .gt. 1024) increment=25
&DOS      ixx = nint(float(ix)*scale_X)
&DOS      iyy = nint(float(iy)*scale_Y) + increment
&DOS      call set_text_attribute@(font,size,rotation,italic)
&DOS      if(xwin .gt. 800) call BoldFont(1)
&DOS      ICOL1 = ICOL
&DOS      CALL DRAW_TEXT@( TEXT,IXX,IYY,ICOL1)

C &&GILGID      CHARACTER*80 CHARTC
C &&GILGID      WRITE(CHARTC,2)'^^CH RGB',
C &&GILGID     1 NINT(4.05*IVGACL(1,ICOL+1)),
C &&GILGID     2 NINT(4.05*IVGACL(2,ICOL+1)),
C &&GILGID     3 NINT(4.05*IVGACL(3,ICOL+1))
C &&GILGID2     FORMAT (A,3(1X,I3))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTCOL ( NINT(4.05*IVGACL(1,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(2,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(3,ICOL+1)) )

C &&GILGID      WRITE(CHARTC,3)'^^CH TEXT',IX,IY,'''',
C &&GILGID     1 TEXT(1:LEN(TEXT)),''''
C &&GILGID3     FORMAT(A,1X,2(I4,1X),3A)
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL      CALL FSTEXT( IX, IY, TEXT(1:LEN(TEXT)) )

      RETURN
      END
 
CODE FOR ZFILEL
      SUBROUTINE ZFILEL (IXC,IYC,IMAJ,IMIN,ICOL)
&DOS\CAMWIN
&&GILGID\CAMCOL
      INTEGER IMAJ,IMIN,ICOL
&DOS      INTEGER*2 IMAJ1,IMIN1,ICOL1,ixc1,iyc1
&DOS      ixc1  = nint(float(ixc)*scale_X)
&DOS      iyc1  = nint(float(iyc)*scale_Y)
&DOS      imaj1 = nint(float(imaj)*scale_X)
&DOS      imin1 = nint(float(imin)*scale_Y)
&DOS      ICOL1 = ICOL
&DOS      CALL FILL_ELLIPSE@( IXC1,IYC1,IMAJ1,IMIN1,ICOL1)

&&GILGID      CHARACTER*80 CHARTC
C &&GILGID      WRITE(CHARTC,2)'^^CH RGB',
C &&GILGID     1 NINT(4.05*IVGACL(1,ICOL+1)),
C &&GILGID     2 NINT(4.05*IVGACL(2,ICOL+1)),
C &&GILGID     3 NINT(4.05*IVGACL(3,ICOL+1))
C &&GILGID2     FORMAT (A,3(1X,I3))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTCOL ( NINT(4.05*IVGACL(1,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(2,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(3,ICOL+1)) )

C &&GILGID      WRITE(CHARTC,3)'^^CH ELLIF',IXC,IYC,IMAJ,IMIN
C &&GILGID3     FORMAT(A,4(1X,I4))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTFEL ( IXC, IYC, IMAJ, IMIN )
            
      RETURN
      END
 
CODE FOR ZGTBUT
      SUBROUTINE ZGTBUT (N,IB)
      INTEGER IB,N
&DOS      INTEGER*2 IBB,NN
&DOS      CALL GET_MOUSE_BUTTON_PRESS_COUNT(N,IB)
#DOS      CALL ZMORE('Error: ZGTBUT called',0)
      RETURN
      END

 
CODE FOR ZPLINE
      SUBROUTINE ZPLINE (IX,IY,N,ICOL)
      INTEGER IX(N),IY(N),ICOL
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

&DOS\CAMWIN
&DOS      INTEGER*2 ICOL1

C &&GILGID      CHARACTER*80 CHARTC
&&GILGID      INTEGER IPTS(2000)    

      IF (N.GT.1000) N = 1000

      ICOL1 = MIN ( ICOL, 15 )

      DO 10 I = 1 , N

&DOS        ixx2(i) = nint(float(ix(i))*scale_X)
&DOS        iyy2(i) = nint(float(iy(i))*scale_Y)
&&GILGID        IPTS(I*2 - 1) = IX(I)
&&GILGID        IPTS(I*2    ) = IY(I)

10    CONTINUE

&DOS      ICOL1 = ICOL
&DOS      CALL POLYLINE@(IXX2,IYY2,N,ICOL1)

C &&GILGID      WRITE(CHARTC,2)'^^CH RGB',
C &&GILGID     1 NINT(4.05*IVGACL(1,ICOL+1)),
C &&GILGID     2 NINT(4.05*IVGACL(2,ICOL+1)),
C &&GILGID     3 NINT(4.05*IVGACL(3,ICOL+1))
C &&GILGID2     FORMAT (A,3(1X,I3))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTCOL ( NINT(4.05*IVGACL(1,ICOL1+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(2,ICOL1+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(3,ICOL1+1)) )

C &&GILGID      WRITE(CHARTC,3)'^^CH FPOLYE',N,ID
C &&GILGID3     FORMAT(A,2(1X,I6))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTEPO ( N, IPTS )

      RETURN
      END
 
CODE FOR ZVGAEL
      SUBROUTINE ZVGAEL (IXC,IYC,IMAJ,IMIN,ICOL)
      INTEGER IMAJ,IMIN,ICOL
&DOS      INTEGER*2 IMAJ1,IMIN1,ICOL1,ixc1,iyc1
&DOS\CAMWIN
&&GILGID\CAMCOL
&DOS      ixc1  = nint(float(ixc)*scale_X)
&DOS      iyc1  = nint(float(iyc)*scale_Y)
&DOS      imaj1 = nint(float(imaj)*scale_X)
&DOS      imin1 = nint(float(imin)*scale_X)
&DOS      ICOL1 = ICOL
&DOS      CALL ELLIPSE@( IXC1,IYC1,IMAJ1,IMIN1,ICOL1)

&&GILGID      CHARACTER*80 CHARTC
C &&GILGID      WRITE(CHARTC,2)'^^CH RGB',
C &&GILGID     1 NINT(4.05*IVGACL(1,ICOL+1)),
C &&GILGID     2 NINT(4.05*IVGACL(2,ICOL+1)),
C &&GILGID     3 NINT(4.05*IVGACL(3,ICOL+1))
C &&GILGID2     FORMAT (A,3(1X,I3))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTCOL ( NINT(4.05*IVGACL(1,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(2,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(3,ICOL+1)) )

C &&GILGID      WRITE(CHARTC,3)'^^CH ELLIE',IXC,IYC,IMAJ,IMIN
C &&GILGID3     FORMAT(A,4(1X,I4))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTEEL ( IXC, IYC, IMAJ, IMIN )

      RETURN
      END
 
 
CODE FOR ZRTSBL
      SUBROUTINE ZRTSBL (IX,IY,IBUFF,IFLAG,ERROR)
&DOS\CAMWIN
      INTEGER IX,IY
&DOS      INTEGER*2 IXX,IYY
      INTEGER IFLAG,ERROR
      INTEGER IBUFF
&DOS      ixx = nint(float(ix)*scale_X)
&DOS      iyy = nint(float(iy)*scale_Y)
&DOS      CALL RESTORE_SCREEN_BLOCK@(IXX,IYY,IBUFF,IFLAG,ERROR)
      RETURN
      END
 
CODE FOR ZBEEP
      SUBROUTINE ZBEEP
&DOS      CALL BEEP@
      RETURN
      END
 
 
CODE FOR ZGTMPS
      SUBROUTINE ZGTMPS (IMX,IMY)
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

&DOS\CAMWIN
      INTEGER IMX,IMY
C cljf
C      INTEGER*2 IMMX,IMMY,BUTTON_STATUS
C&DOS      call get_mouse_position (immx,immy)
C&DOS      imx = nint(float(immx)/scale_X)
C&DOS      imy = nint(float(immy)/scale_Y)
      CALL ZMORE('Error: ZGTMPS called',0)
      RETURN
      END
 
CODE FOR ZCOLCH
      SUBROUTINE ZCOLCH (IREG,IR,IG,IB)
      INTEGER IREG,IR,IG,IB
&DOS      INTEGER*2 IRREG,IRR,IGG,IBB
&DOS      IRREG = IREG
&DOS      IRR = IR
&DOS      IGG = IG
&DOS      IBB = IB
&DOS      CALL SET_VIDEO_DAC@(IRREG,IRR,IGG,IBB)
&DOS      CALL SET_PALETTE@(IRREG,IRREG)
      RETURN
      END
 
CODE FOR ZUPCAS
      SUBROUTINE ZUPCAS (CTEXT)
      CHARACTER*(*) CTEXT
      CHARACTER*160 CTEXT1
      NALEN = MIN(LEN(CTEXT),160)
      CALL XCCUPC(CTEXT(1:NALEN),CTEXT1(1:NALEN))
      CTEXT=CTEXT1(1:NALEN)
      RETURN
      END
 
 
CODE FOR ZISSUE
      SUBROUTINE ZISSUE (CTEXT,IFAIL)
      CHARACTER*(*) CTEXT
      INTEGER*2 IFF
cdjw call CRYSTALS detach subroutine
CVAX      INCLUDE '($LIBDEF)'
CVAX      I = LIB$SPAWN (CTEXT)
CDOS      CALL CISSUE(CTEXT,IFF)
      call xdetch(ctext)
      iff = 0
      IFAIL = IFF
      RETURN
      END
 
 
CODE FOR ZGTKEY
      SUBROUTINE ZGTKEY (KK)
      INTEGER KK
&DOS      INTEGER*2 KKK,get_wkey@
&DOS      kkk=0
&DOS      kkk=get_wkey@()
&DOS      KK = KKK
#DOS      CALL ZMORE('Error: ZGTKEY called',0)
      RETURN
      END
 
 
CODE FOR ZPRNT
      SUBROUTINE ZPRNT (CTEXT)
C THIS PRINTS OUT ON THE SCREEN WITHOUT PUTTING A RETURN AT THE END
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      CHARACTER*(*) CTEXT
CVAX      WRITE (IGOUT,'(A,$)') CTEXT
&DOS      CALL COUA@(CTEXT)
      RETURN
      END
 
CODE FOR ZGTKY1
      SUBROUTINE ZGTKY1 (KK)
      INTEGER KK
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

&DOS      integer*2 kkk,get_wkey1@
&DOS      kkk=0
&DOS      kkk = get_wkey1@()
&DOS      KK = KKK
CDJWNOV98
&DOS      IF (KK .EQ. ICRET) CALL ZMORE1(' ',0)
#DOS      KK = 0
#DOS      CALL ZMORE('Error ZGTKY1 called',0)
      END
 
 
CODE FOR ZINCH
      SUBROUTINE ZINCH (CL)
\CAMPAR
\CAMBLK
      CHARACTER*(ICLEN) CL
      CL = CHRBUF(1:ICLEN)
      RETURN
      END
 
 
CODE FOR LFILES
      LOGICAL FUNCTION LFILES (ITYPIN,FILEN,ID)
C THIS ROUTINE HANDLES THE FILE OPEN/CLOSE STATEMENTS
C VARIABLES :
C ITYPIN =  0 Close file
C          1+ these specify the different types of file opening
C NOTE THAT THE EXISTENCE OF THE FILE AND ITS FORMAT SHOULD
C ALREADY HAVE BEEN CHECKED BEFORE CALLING THIS ROUTINE.
C ID         This is the unit number of the device
C NEGATIVE NUMBERS ARE RELATED TO THE ENVIRONMENT VARIABLE
CNOV98 CRCAMER.
C CRYSDIR.
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      CHARACTER*(*) FILEN
      CHARACTER*80 FILENM
      LOGICAL LOPEN
      LFILES = .TRUE.
      ITYPE = ITYPIN
      FILENM = FILEN
C FILE OPEN
      IF (ITYPE.LT.0) THEN
        CALL ZFPATH (FILENM)
        ITYPE = -ITYPE
      ENDIF
10    CONTINUE
      IF (ITYPE.EQ.1) THEN
C WE NEED TO CHECK WHETHER THE FILE EXISTS ALREADY
        OPEN (UNIT=ID,FILE=FILENM,
#DOS     1         STATUS = 'OLD' ,
&DOS     1         STATUS ='READONLY' ,
&VAX     1         SHARED ,
&VAX     1         READONLY ,
&PPC     1         READONLY ,
&&DVFGID     1         READONLY ,
     1 ERR=999)
      ELSE IF (ITYPE.EQ.2) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='UNKNOWN',
     + ERR=999)
        REWIND ID
      ELSE IF (ITYPE.EQ.3) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='UNKNOWN',FORM='UNFORMATTED'
     + ,ERR=999)
      ELSE IF (ITYPE.EQ.4) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='OLD',FORM='UNFORMATTED',
     +  ERR=999)
      ELSE IF (ITYPE.EQ.5) THEN
       OPEN (UNIT=ID, FILE=FILENM, STATUS='NEW')
CVAX      OPEN (UNIT=ID, FILE=FILENM, STATUS='NEW',
CVAX     + CARRIAGECONTROL='LIST')
      ELSE IF (ITYPE.EQ.6) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='OLD',FORM='FORMATTED',
     c ACCESS='DIRECT',RECL=80,ERR=999)
      ELSE IF (ITYPE.EQ.7) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='NEW',FORM='FORMATTED',
     c ACCESS='DIRECT',RECL=80)
      ELSE IF (ITYPE.EQ.8) THEN
        OPEN (UNIT=ID,STATUS='SCRATCH',ACCESS='DIRECT',
     + FORM='UNFORMATTED',RECL=160,ERR=999)
      ELSE IF (ITYPE.EQ.9) THEN
        OPEN (UNIT=ID, STATUS='SCRATCH', ACCESS='SEQUENTIAL',
     + FORM='FORMATTED',ERR=999)
      ELSE IF (ITYPE.EQ.0) THEN
        CLOSE(ID)
      ENDIF
      RETURN
999   CONTINUE
C ERROR - IS THE FILE ALREADY OPEN?
      INQUIRE (UNIT=ID,OPENED=LOPEN)
      IF (LOPEN) THEN
        CLOSE(ID)
        GOTO 10
      ENDIF
      CALL ZMORE ('Error opening file '// FILENM, 0)
      CALL ZMORE1 ('Error opening file '// FILENM, 0)
      LFILES = .FALSE.
      END
 
 
CODE FOR ZFPATH
      SUBROUTINE ZFPATH (CFNAME)
      CHARACTER*(*) CFNAME
      CHARACTER*80 CNPATH
      INTEGER LENNAM
C THIS ROUTINE CALLS THE CRYSTALS ROUTINE FOR FILENAME DETERMINATION
C WHICH IS IN DUPLICAT.FOR
CNOV98      CNPATH = 'CRCAMER:'//CFNAME
      CNPATH = 'CRYSDIR:'//CFNAME
      CALL MTRNLG (CNPATH,'OLD',LENNAM)
      CFNAME = CNPATH
      RETURN
      END
 
CODE FOR ZPOLGN
      SUBROUTINE ZPOLGN ( IX,IY,N,ICOL)
      INTEGER IX(N),IY(N),ICOL
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

&DOS\CAMWIN
&DOS      INTEGER*2 ICOL2,HANDLE,ERROR
C &&GILGID      CHARACTER*80 CHARTC
&&GILGID      INTEGER IPTS(2000)    

&DOS      ICOL2 = ICOL

&GIL      WRITE(6,*) 'ZPOLGN, N: ', N

&GIL      WRITE(6,*) 'ZPOLGN2, N: ', N

      DO 10 I = 1 , N
&DOS        ixx2(i) = nint(float(ix(i))*scale_X)
&DOS        iyy2(i) = nint(float(iy(i))*scale_Y)
&&GILGID        IPTS(I*2 - 1) = IX(I)
&&GILGID        IPTS(I*2    ) = IY(I)
10    CONTINUE

&GIL      WRITE(6,*) 'ZPOLGN3, N: ', N

&DOS      CALL CREATE_POLYGON@(IXX2,IYY2,N,HANDLE,ERROR)
&DOS      CALL FILL_POLYGON@(HANDLE,ICOL2,ERROR)
&DOS      CALL DELETE_POLYGON_DEFINITION@(HANDLE,ERROR)

C &&GILGID      WRITE(CHARTC,2)'^^CH RGB',
C &&GILGID     1 NINT(4.05*IVGACL(1,ICOL+1)),
C &&GILGID     2 NINT(4.05*IVGACL(2,ICOL+1)),
C &&GILGID     3 NINT(4.05*IVGACL(3,ICOL+1))
C &&GILGID2     FORMAT (A,3(1X,I3))
C &&GILGID      CALL ZMORE(CHARTC,0)

&&GIDGIL              CALL FSTCOL ( NINT(4.05*IVGACL(1,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(2,ICOL+1)),
&&GIDGIL     1                      NINT(4.05*IVGACL(3,ICOL+1)) )

C &&GILGID      WRITE(CHARTC,3)'^^CH FPOLYF',N,ID
C &&GILGID3     FORMAT(A,2(1X,I6))
C &&GILGID      CALL ZMORE(CHARTC,0)

&GIL      WRITE(6,*) 'ZPOLGN4, N: ', N

&&GIDGIL              CALL FSTFPO ( N, IPTS )

      RETURN
      END



CODE FOR ZGTARA
C THIS SUBROUTINE GETS THE POLYGONAL AREA FOR THE INCLUDE/EXCLUDE
C COMMANDS
      SUBROUTINE ZGTARA (IX,IY,N,IPPOS)
&DOS\CAMWIN
&DOS      INTEGER IX(N),IY(N)
&DOS      INTEGER*4 IXX,IYY,IXPOS,IYPOS,IXOLD,IYOLD,IXINIT,IYINIT
&DOS      INTEGER*4 IB
&DOS      LOGICAL LCROSS
&DOS      INTEGER IPPOS
&DOS      IPPOS = -1
&DOS
&DOS      icol = 14
&DOS      call SetGraphicsCursor(2)
&DOS      call graphics_write_mode@(3)
&DOS
&DOSC NOW BEGIN TO LOOP
&DOS      IXOLD = -1
&DOS      IYOLD = -1
&DOS      IXINIT = -1
&DOS      IYINIT = -1
&DOS      LCROSS = .TRUE.
&DOS      IPPOS = 0
&DOS30    CONTINUE
&DOS
&DOSC cljf
C Check for keypresses
&DOS      call zgtky1(kk)
&DOS
C Check for mouse action
&DOS      IB = KMSGET(JX,JY,JF)
&DOS      JX = JX * SCALE_X
&DOS      JY = JY * SCALE_Y
C Case: Right mouse-click or return key pressed.
&DOS      IF (((IB.EQ.0).and.(JF.LT.0)).or. KK.EQ.13) then
C     Delete the polygon
&DOS        IF (IXOLD.NE.-1) THEN
&DOS          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
&DOS        ENDIF
&DOS        IF (IPPOS.GT.1) THEN
&DOS          DO 80 I = IPPOS-1, 1, -1
&DOS            IXOLD = IX(I)
&DOS            IYOLD = IY(I)
&DOS            IXPOS = IX(I+1)
&DOS            IYPOS = IY(I+1)
&DOS            CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
&DOS80        CONTINUE
&DOS        ENDIF
&DOS        IPPOS = 0
&DOS        call SetGraphicsCursor(1)
&DOS        call graphics_write_mode@(1)
&DOS        call zmore1(' ',0)
&DOS        return
&DOS      ENDIF

C Case: Left mouse-click.
&DOS      IF ((IB.EQ.0).AND.(JF.GT.0)) THEN
&DOS        IXPOS = JX
&DOS        IYPOS = JY
C     Store current pivot point in IXOLD,IYOLD
&DOS        IXOLD = IXPOS
&DOS        IYOLD = IYPOS
C     Case: Initial point.
&DOS        IF (IXINIT.EQ.-1) THEN
&DOS          IXINIT = IXPOS
&DOS          IYINIT = IYPOS
&DOS        ENDIF
C     Add point to list
&DOS        IPPOS = IPPOS + 1
&DOS        IX(IPPOS) = IXPOS
&DOS        IY(IPPOS) = IYPOS
C     Check for click on initial point
&DOS        IF (.NOT.LCROSS) THEN
C     Set the first and last points equal
&DOS          IX(IPPOS) = IX(1)
&DOS          IY(IPPOS) = IY(1)
&DOS          call SetGraphicsCursor(1)
C     Scale the values (window version)
&DOS          do i=1,ippos
&DOS             ix(i)=nint(float(ix(i))/scale_X)
&DOS             iy(i)=nint(float(iy(i))/scale_Y)
&DOS          enddo
&DOS          call zmore1(' ',0)
&DOS          call graphics_write_mode@(1)
&DOS          RETURN
&DOS        ENDIF

C     Case: No mouse click, initial point set already.
&DOS      ELSE IF (IXOLD.NE.-1) THEN
&DOS        IXX = JX
&DOS        IYY = JY
C        The mouse has moved
&DOS        IF (ABS(IXX-IXPOS).NE.0 .OR. ABS(IYY-IYPOS).NE.0) THEN
&DOS          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
C          Update the mouse position variables
&DOS          IXPOS = IXX
&DOS          IYPOS = IYY
&DOS          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
&DOS        ENDIF
&DOSC DO WE NEED TO CHANGE THE CURSOR ?
&DOS        IF (ABS(IXX-IXINIT).LT.4.AND.ABS(IYY-IYINIT).LT.4) THEN
&DOS          IF (LCROSS) THEN
&DOS            call SetGraphicsCursor(3)
&DOS            LCROSS = .FALSE.
&DOS          ENDIF
&DOS        ELSE IF (.NOT.LCROSS) THEN
&DOS            call SetGraphicsCursor(2)
&DOS            LCROSS = .TRUE.
&DOS        ENDIF
&DOS      ENDIF
&DOS      GOTO 30

&&GILGID      INTEGER IX(N),IY(N)
&&GILGID      INTEGER IXPOS,IYPOS
&&GILGID      INTEGER IPPOS
&&GILGID      CHARACTER CLINE*80
&&GILGID      IUNIT = 5
&&GILGID      IPPOS = 0
&&GILGID      CALL ZMORE('^^CO SET _CAMERONVIEW GETAREA=YES',0)
&&GILGID100   CONTINUE   ! NOW BEGIN TO LOOP
&&GILGID      ISTAT = KRDLIN ( IUNIT, CLINE, LENUSE )
&&GILGID      IF (CLINE(1:6).NE.'LCLICK') THEN
&&GILGID            IF (CLINE(1:6).EQ.'CLOSED') THEN  !Closed the polygon.
&&GILGID              IPPOS = IPPOS + 1
&&GILGID              IX(IPPOS) = IX(1)
&&GILGID              IY(IPPOS) = IY(1)
&&GILGID              RETURN
&&GILGID            ELSE               !Cancelled the polygon.
&&GILGID              CALL ZMORE('^^CO SET _CAMERONVIEW GETAREA=NO',0)
&&GILGID              IPPOS = 0
&&GILGID              RETURN
&&GILGID            ENDIF
&&GILGID      ELSE                   !Get some coordinates.
&&GILGID            READ (CLINE(7:),*)IXPOS, IYPOS
&&GILGID            IPPOS = IPPOS + 1
&&GILGID            IX(IPPOS) = IXPOS
&&GILGID            IY(IPPOS) = IYPOS
&&GILGID      ENDIF
&&GILGID      GOTO 100
      END

&&GILGID      SUBROUTINE FSTLIN(IX1, IY1, IX2, IY2)
&GID      INTERFACE
&GID          SUBROUTINE FASTLINE (JX1, JY1, JX2, JY2)
&GID          !DEC$ ATTRIBUTES C :: fastline
&GID          !DEC$ ATTRIBUTES VALUE :: JX1
&GID          !DEC$ ATTRIBUTES VALUE :: JY1
&GID          !DEC$ ATTRIBUTES VALUE :: JX2
&GID          !DEC$ ATTRIBUTES VALUE :: JY2
&GID          INTEGER JX1, JY1, JX2, JY2
&GID          END SUBROUTINE FASTLINE
&GID      END INTERFACE
&&GILGID      INTEGER IX1, IX2, IY1, IY2
&GIL      CALL FASTLINE(%VAL(IX1), %VAL(IY1), %VAL(IX2), %VAL(IY2))
&GID      CALL FASTLINE(IX1, IY1, IX2, IY2)
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTFEL(IX, IY, IW, IH)
&GID      INTERFACE
&GID          SUBROUTINE FASTFELLI (JX, JY, JW, JH)
&GID          !DEC$ ATTRIBUTES C :: fastfelli
&GID          !DEC$ ATTRIBUTES VALUE :: JX
&GID          !DEC$ ATTRIBUTES VALUE :: JY
&GID          !DEC$ ATTRIBUTES VALUE :: JW
&GID          !DEC$ ATTRIBUTES VALUE :: JH
&GID          INTEGER JX, JY, JW, JH
&GID          END SUBROUTINE FASTFELLI
&GID      END INTERFACE
&&GILGID      INTEGER IX, IY, IW, IH
&GIL      CALL FASTFELLI(%VAL(IX), %VAL(IY), %VAL(IW), %VAL(IH))
&GID      CALL FASTFELLI(IX, IY, IW, IH)
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTEEL(IX, IY, IW, IH)
&GID      INTERFACE
&GID          SUBROUTINE FASTEELLI (JX, JY, JW, JH)
&GID          !DEC$ ATTRIBUTES C :: fasteelli
&GID          !DEC$ ATTRIBUTES VALUE :: JX
&GID          !DEC$ ATTRIBUTES VALUE :: JY
&GID          !DEC$ ATTRIBUTES VALUE :: JW
&GID          !DEC$ ATTRIBUTES VALUE :: JH
&GID          INTEGER JX, JY, JW, JH
&GID          END SUBROUTINE FASTEELLI
&GID      END INTERFACE
&&GILGID      INTEGER IX, IY, IW, IH
&GID      CALL FASTEELLI(IX, IY, IW, IH)
&GIL      CALL FASTEELLI(%VAL(IX), %VAL(IY), %VAL(IW), %VAL(IH))
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTFPO(NV, IPTS)
&GID      INTERFACE
&GID          SUBROUTINE FASTFPOLY (NV, IPTS)
&GID          !DEC$ ATTRIBUTES C :: fastfpoly
&GID          !DEC$ ATTRIBUTES VALUE :: NV
&GID          !DEC$ ATTRIBUTES REFERENCE :: IPTS
&GID          INTEGER NV, IPTS(2000)
&GID          END SUBROUTINE FASTFPOLY
&GID      END INTERFACE
&&GILGID      INTEGER NV, IPTS(2000)
&GID      CALL FASTFPOLY(NV, IPTS)
&GIL      CALL FASTFPOLY(%VAL(NV), IPTS)
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTEPO(NV, IPTS)
&GID      INTERFACE
&GID          SUBROUTINE FASTEPOLY (NV, IPTS)
&GID          !DEC$ ATTRIBUTES C :: fastepoly
&GID          !DEC$ ATTRIBUTES VALUE :: NV
&GID          !DEC$ ATTRIBUTES REFERENCE :: IPTS
&GID          INTEGER NV, IPTS(2000)
&GID          END SUBROUTINE FASTEPOLY
&GID      END INTERFACE
&&GILGID      INTEGER NV, IPTS(2000)
&GIL      CALL FASTEPOLY(%VAL(NV), IPTS)
&GID      CALL FASTEPOLY(NV, IPTS)
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTEXT(IX, IY, CTEXT)
&GID      INTERFACE
&GID          SUBROUTINE FASTTEXT (JX, JY, CALINE)
&GID          !DEC$ ATTRIBUTES C :: fasttext
&GID          !DEC$ ATTRIBUTES VALUE :: JX
&GID          !DEC$ ATTRIBUTES VALUE :: JY
&GID          !DEC$ ATTRIBUTES REFERENCE :: CALINE
&GID          INTEGER JX,JY
&GID          CHARACTER CALINE
&GID          END SUBROUTINE FASTTEXT
&GID      END INTERFACE
&&GILGID      INTEGER IX, IY
&&GILGID      CHARACTER*(*) CTEXT
&&GILGID      CHARACTER*80  NTEXT
&&GILGID      NTEXT = CTEXT
&GIL      CALL FASTTEXT(%VAL(IX), %VAL(IY), NTEXT)    
&GID      CALL FASTTEXT(IX, IY, NTEXT)    
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTCOL(IR, IG, IB)
&GID      INTERFACE
&GID          SUBROUTINE FASTCOLOUR ( JR, JG, JB )
&GID          !DEC$ ATTRIBUTES C :: fastcolour
&GID          !DEC$ ATTRIBUTES VALUE :: JR
&GID          !DEC$ ATTRIBUTES VALUE :: JG
&GID          !DEC$ ATTRIBUTES VALUE :: JB
&GID          INTEGER JR, JG, JB
&GID          END SUBROUTINE FASTCOLOUR
&GID      END INTERFACE
&&GILGID      INTEGER IR, IG, IB
&GIL      CALL FASTCOLOUR(%VAL(IR), %VAL(IG), %VAL(IB))
&GID      CALL FASTCOLOUR(IR, IG, IB)
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTCLR()
&GID      INTERFACE
&GID          SUBROUTINE FASTCLEAR ()
&GID          !DEC$ ATTRIBUTES C :: fastclear
&GID          END SUBROUTINE FASTCLEAR
&GID      END INTERFACE
&&GILGID      CALL FASTCLEAR()
&&GILGID      RETURN
&&GILGID      END

&&GILGID      SUBROUTINE FSTSHW()
&GID      INTERFACE
&GID          SUBROUTINE FASTSHOW ()
C Suits you.
&GID          !DEC$ ATTRIBUTES C :: fastshow
&GID          END SUBROUTINE FASTSHOW
&GID      END INTERFACE
&&GILGID      CALL FASTSHOW()
&&GILGID      RETURN
&&GILGID      END


      SUBROUTINE ZMORE1(text,iarg)
C ---- updates text message in status bar - iarg is not used but kept
C      for compatibility with CAMERON function ZMORE
&DOS\CAMWIN
#GIL      character*(*) text
&GIL      character*70 text
      CHARACTER*80 ntext
C DOS VERSION NO LONGER HAS STATUS LINE. (SPACE SAVER)
C&DOS      Status$Text=text
C&DOS      call window_update@(Status$Text)
&&GILGID      CALL XCTRIM(TEXT,ITL)
&&GILGID      IF ( ITL .LE. 2 ) RETURN
&&GILGID      ITL = MIN ( ITL, 70 )
&&GILGID      CALL ZMORE('^^WI SET PROGOUTPUT TEXT=',0)
&&GILGID      CALL ZMORE('^^WI '''//TEXT(1:ITL)//'''',0)
&&GILGID      CALL ZMORE('^^CR',0)
      end

