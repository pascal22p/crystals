      program combine
c----- convert the PLATON squeezed outout to CRYSTALS format
      character *80 cline
      integer intype !< 1 for *.fab, 0 for other
      
      in1 = 10
      in2 = 11
      iout1 = 12
      intype = 0
      
      open(in1,file='PLATON6',status='old')
      open(in2,file='platon_sq.fab',status='old',err=40)
      intype=1
      GOTO 70
40    CONTINUE
      open(in2,file='platon_sqd.hkl',status='old',err=50)
      GOTO 70
50    CONTINUE
      open(in2,file='platon-sr.hkl',status='old',err=60)
      GOTO 70
60    CONTINUE
      open(in2,file='platon.hkp',status='old',err=250)
70    CONTINUE
      open(iout1,file='LIST6.ABC',status='unknown')
      do  i=1,3
        read(in1,'(a)') cline
      enddo 
      read(in1,'(a)') cline
      ln = 6
      i = index(cline,'6')
      if (i.eq.0) then
            i = index(cline,'7')
            if (i .ne. 0) ln = 7
      endif
      do  i=5,10
        read(in1,'(a)') cline
      enddo 
c
1001  FORMAT('#LIST  ', i4/
     * 'READ NCOEF = 11, TYPE = FIX, UNIT = DATA' ,
     1 ', CHECK=NO L30=NO ARC=NO'/
     2 'INPUT H K L /FO/ SIGMA(/FO/) /FC/ PHASE'
     4 ,' SQRTW JCODE A-PART B-PART' /
     3 ,'FORMAT (3F4.0, F10.2, F8.2, F10.2, F8.4, G12.5, F10.5'
     * ,'/2F8.2)'/
     * ,'STORE NCOEF=10'/
     * ,'OUTPUT INDICES /FO/    SQRTW   /FC/    BATCH/PHASE'/  
     * ,'CONTINUE RATIO/JCODE  SIGMA(/FO/)   CORRECTIONS  '
     * ,'A-PART B-PART'
     5 / 'END')
      write(iout1,1001) ln

      n6 = 0
      np = 0

100   continue
        if (intype==0) then ! Other filetype (old)
          read(in2,'(3i4,68x,i8,2f8.2)',err=200,end=200)
     1      ih,ik,il,ic,a,b                             !read from hkp
        else ! new fab file
          read(in2,'(3i5,2f10.2)',err=200,end=200)
     1      ih,ik,il,a,b                             !read from fab
        end if
110     continue
          read(in1,'(a)',end=200) cline               !read from our L6
          read(cline,'(3i4)') jh,jk,jl
          if ( jh.eq.-512) goto 200
          n6 = n6 + 1
          if((ih.ne.jh).or.(ik.ne.jk).or.(il.ne.jl)) then
            if (intype==0) then ! Other filetype (old)
              write(6,'(3I4,A)')jh,jk,jl,' not found in HKP file'
            else
              write(6,'(3I4,A)')jh,jk,jl,' not found in .fab file'
            end if
            goto 110
          end if
          np = np + 1
          write(iout1,'(a)') cline
          write(iout1,'(2f8.2)')a,b
      goto 100
200   continue
      write(iout1,'(I4/)')-512
      write(6,'(A,I6,A,I6,A)')
     1 'Finished. Of ',N6,' reflections passed to Platon, ',NP,
     1 ' were passed back. '
      stop
220   continue
      rewind(iout1)
      write(iout1,'(A)') 'Index mismatch - processing aborted'
      write(6,'(A)')
     1 'Index mismatch - processing aborted. '
      stop
250   continue
      rewind(iout1)
      write(iout1,'(A,A)')
     1  'Could not open platon_sqd.hkl, platon-sr.hkl, ',
     2  'platon.hkp or platon_sq.fab'
      write(6,'(A,A)')
     1 'Cannot open platon_sqd.hkl,platon-sr.hkl, platon.hkp ',
     2 'or platon_sq.fab.'

      end


