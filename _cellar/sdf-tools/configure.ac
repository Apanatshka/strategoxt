AC_PREREQ([2.60])
AC_INIT([sdf-tools],[1.8],[users@strategoxt.org])
AC_CONFIG_AUX_DIR([../config])
AM_INIT_AUTOMAKE

XT_INTERNAL_USE_XT_PACKAGES
XT_TERM_DEFINE

AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LIBTOOL

AC_CONFIG_FILES([
  Makefile

  lib/Makefile

  analyse/Makefile
  analyse/parse-unit/Makefile
  analyse/parse-unit/syn/Makefile
  analyse/parse-unit/sig/Makefile
  analyse/parse-unit/tests/Makefile

  trans/Makefile

  tests/Makefile
  tests/parenthesize/Makefile

  src/Makefile 
  src/templates/Makefile
  src/templates/data/Makefile
  src/sdf-cons/Makefile
  src/sdf-cons/data/Makefile
  src/sdf-label/Makefile
  src/sdf-bracket/Makefile
  src/sdf-bracket/data/Makefile
])
AC_OUTPUT
