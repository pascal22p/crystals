////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.7  2001/06/17 14:46:47  richard
//   CxDestroyWindow function.
//   Size wx buttons so the match MFC buttons.
//
//   Revision 1.6  2001/03/08 16:44:07  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxButton_H__
#define     __CxButton_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef __POWERPC__
class LStdButton;
#endif

#ifdef __MOTO__
#include    <LStdControl.h>
#endif

#ifdef __BOTHWX__
#include <wx/button.h>
#include <wx/event.h>
#define BASEBUTTON wxButton
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEBUTTON CButton
#endif

class CrButton;
class CxGrid;
//End of user code.

class CxButton : public BASEBUTTON
{
// The interface exposed to the CrClass
    public:
        void Disable(Boolean disabled);
        void Focus();
        // methods
        static CxButton *   CreateCxButton( CrButton * container, CxGrid * guiParent );
        CxButton(CrButton* container);
        ~CxButton();
        void CxDestroyWindow();
        void    SetText( char * text );
        void    SetLength( CcString ltext );
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int AddButton( void ) { mButtonCount++; return mButtonCount; };
        static void RemoveButton( void ) { mButtonCount--; };
        void    BroadcastValueMessage( void );
        void SetDef();

        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int mButtonCount;
        bool m_lengthStringUsed;
        CcString m_lengthString;
//      LDefaultOutline * mOutlineWidget;


// Private machine specific parts:
#ifdef __CR_WIN__
        afx_msg void ButtonClicked();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
            void ButtonClicked();
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
