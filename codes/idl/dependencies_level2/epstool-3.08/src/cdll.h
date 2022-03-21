/* Copyright (C) 2001-2002 Ghostgum Software Pty Ltd.  All rights reserved.

  This software is provided AS-IS with no warranty, either express or
  implied.

  This software is distributed under licence and may not be copied,
  modified or distributed except as expressly authorised under the terms
  of the licence contained in the file LICENCE in this distribution.

  For more information about licensing, please refer to
  http://www.ghostgum.com.au/ or contact Ghostsgum Software Pty Ltd, 
  218 Gallaghers Rd, Glen Waverley VIC 3150, AUSTRALIA, 
  Fax +61 3 9886 6616.
*/

/* $Id: cdll.h,v 1.2 2002/05/27 09:40:10 ghostgum Exp $ */
/* Platform dependent DLL / shared object loading */

#ifndef CDLL_INCLUDED
#define CDLL_INCLUDED

/* platform dependent */
typedef void * (*dll_proc)(void);
int dll_open(GGMODULE *hmodule, LPCTSTR name, TCHAR *msg, int msglen);
int dll_close(GGMODULE *hmodule);
dll_proc dll_sym(GGMODULE *hmodule, const char *name);

#endif
