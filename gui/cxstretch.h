////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $

#ifndef     __CxStretch_H__
#define     __CxStretch_H__
#include    "crguielement.h"

#ifdef __BOTHWX__
#include <wx/window.h>
#define BASESTRETCH wxWindow
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASESTRETCH CWnd
#endif

class CrStretch;
class CxGrid;
//End of user code.

class CxStretch : public BASESTRETCH
{
    public:
        // methods
        static CxStretch * CreateCxStretch( CrStretch * container, CxGrid * guiParent );
        CxStretch( CrStretch * container );
        ~CxStretch();
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();

        // attributes
        CrGUIElement *  ptr_to_crObject;

    protected:
        // attributes
        static int  mStretchCount;
};
#endif
