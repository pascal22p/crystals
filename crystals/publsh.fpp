CODE FOR PUBLSH
      SUBROUTINE PUBLSH
      CALL XSYSDC(-1,1)
      CALL XPUBL
      RETURN
      END
C
CODE FOR XPUBL
      SUBROUTINE XPUBL
C--MAIN ROUTINE TO CONTROL PUBLICATION LISTINGS
C
C--
\XERVAL
C
C--LOAD THE NEXT '#INSTRUCTION'
1000  CONTINUE
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM)1100,1100,1200
1100  CONTINUE
      RETURN
C--BRANCH ON THE TYPE OF OPERATION
1200  CONTINUE
C
C  REFLECTIONS  PARAMETERS  SUMMARY  GENERALEDIT  CIFOUT
C
      GO TO ( 2100, 2200, 2300, 2400, 2600, 1500 ) , NUM
1500  CONTINUE
      CALL XERHND ( IERPRG )
C
C--'#REFLECTIONS' INSTRUCTION
2100  CONTINUE
      CALL SPRT6P
      GOTO 1000
C
C--'#PARAMETERS' INSTRUCTION
2200  CONTINUE
      CALL SPRT5P
      GOTO 1000
C
2300  CONTINUE
C
C -- 'SUMMARY'
C
      CALL XSMMRY
      GO TO 1000
C
2400  CONTINUE
C
C -- 'GENERALEDIT'
C
      CALL XGENED
      GO TO 1000
2600  CONTINUE
C----- CIFOUT CIF OUTPUT
      CALL XCIFX
      GO TO 1000
C
      END
C
