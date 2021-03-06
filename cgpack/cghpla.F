*
* $Id$
*
* $Log: cghpla.F,v $
* Revision 1.1.1.1  2002/06/16 15:17:54  hristov
* Separate distribution  of Geant3
*
* Revision 1.1.1.1  1999/05/18 15:55:04  fca
* AliRoot sources
*
* Revision 1.1.1.1  1995/10/24 10:19:44  cernlib
* Geant
*
*
#include "geant321/pilot.h"
*CMZ :  3.21/02 29/03/94  15.41.31  by  S.Giani
*FCA :          05/01/99  09:39:51  by  Federico Carminati
*               Converted the routine to double precision and added
*               protections against divide by 0
*-- Author :
      SUBROUTINE CGHPLA(IFACE,XYZ,ABCD)
************************************************************************
*                                                                      *
*     Name: CGHPLA                                                     *
*     Author: E. Chernyaev                       Date:    08.08.88     *
*                                                Revised:              *
*                                                                      *
*     Function: Compute face plane equation coefficients:              *
*                    Ax + By + Cz + D = 0                              *
*                                                                      *
*     References: none                                                 *
*                                                                      *
*     Input: IFACE(*) - face                                           *
*            XYZ(3,*) - node coordinates                               *
*                                                                      *
*     Output: ABCD(4) - plane equation coefficients                    *
*                                                                      *
*     Errors: none                                                     *
*                                                                      *
************************************************************************
#if defined(CERNLIB_DOUBLE)
      IMPLICIT        DOUBLE PRECISION (A-H,O-Z)
#endif
      PARAMETER       (ONE=1,HALF=ONE/2,SMALL=1D-12)
      DIMENSION       GRAV(3)
      REAL            XYZ(3,*),ABCD(4)
*SG
      INTEGER         IFACE(*)
*SG
*-
      NEDGE = IFACE(1)
      A      = 0
      B      = 0
      C      = 0
      GRAV(1)= 0
      GRAV(2)= 0
      GRAV(3)= 0
      JF     = 2
      DO 100 NE=1,NEDGE
        N1     = IFACE(JF)
        N2     = IFACE(JF+1)
        JF     = JF + 2
        A      = A + XYZ(2,N1)*XYZ(3,N2) - XYZ(2,N2)*XYZ(3,N1)
        B      = B + XYZ(3,N1)*XYZ(1,N2) - XYZ(3,N2)*XYZ(1,N1)
        C      = C + XYZ(1,N1)*XYZ(2,N2) - XYZ(1,N2)*XYZ(2,N1)
        GRAV(1)= GRAV(1) + XYZ(1,N1) + XYZ(1,N2)
        GRAV(2)= GRAV(2) + XYZ(2,N1) + XYZ(2,N2)
        GRAV(3)= GRAV(3) + XYZ(3,N1) + XYZ(3,N2)
  100   CONTINUE
      HNGRAV = HALF/NEDGE
      GRAV(1)= GRAV(1) * HNGRAV
      GRAV(2)= GRAV(2) * HNGRAV
      GRAV(3)= GRAV(3) * HNGRAV
      IF (ABS(A) .LT. SMALL) A=0
      IF (ABS(B) .LT. SMALL) B=0
      IF (ABS(C) .LT. SMALL) C=0
      AREAI  = ONE/MAX(SQRT(A*A + B*B + C*C),SMALL)
      ABCD(1)= A * AREAI
      ABCD(2)= B * AREAI
      ABCD(3)= C * AREAI
      ABCD(4)=-(A*GRAV(1) + B*GRAV(2) + C*GRAV(3)) * AREAI
      END
