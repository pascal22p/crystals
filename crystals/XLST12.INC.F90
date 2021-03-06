! module version on the INC file with common blocks
! The common blocks are kept inside the module until all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XLST12 INC file
module xlst12_mod

  INTEGER L12, M12, MD12, N12, L12A, M12A, MD12A, N12A
  INTEGER L12B, M12B, MD12B, N12B, L12O, M12O, MD12O, N12O
  INTEGER L12LS, M12LS, MD12LS, N12LS, L12ES, M12ES, MD12ES, N12ES
  INTEGER L12BS, M12BS, MD12BS, N12BS, L12CL, M12CL, MD12CL, N12CL
  INTEGER L12PR, M12PR, MD12PR, N12PR, L12EX, M12EX, MD12EX, N12EX

  COMMON/XLST12/L12, M12, MD12, N12, L12A, M12A, MD12A, N12A, &
    L12B, M12B, MD12B, N12B, L12O, M12O, MD12O, N12O, &
    L12LS, M12LS, MD12LS, N12LS, L12ES, M12ES, MD12ES, N12ES, &
    L12BS, M12BS, MD12BS, N12BS, L12CL, M12CL, MD12CL, N12CL, &
    L12PR, M12PR, MD12PR, N12PR, L12EX, M12EX, MD12EX, N12EX

end module
