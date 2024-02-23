/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING /
*/
 #include <stdint.h>   /// Declarations of uint_32 and the like /
#include <pic32mx.h>  // //Declarations of system-specific addresses etc /
#include "mipslab.h"  // Declatations for these labs /
#define TM2PERIOD (80000000 / 256) / 10


int mytime = 0x0000;
int timeoutc = 0;


char textstring[] = "text, more text, and even more text!";
int count = 0;


volatile unsigned int *portE;

// / Interrupt Service Routine /
void user_isr( void )
{
  return;
}

// / Lab-specific initialization goes here /
void labinit( void )
{
  portE = (volatile unsigned int*) 0xbf886110;
 

  volatile int *trise = (volatile int*) 0xbf88610;
  *trise =   *trise & 0xff00;
  TRISD = 0x0fe0;

  PR2 = TM2PERIOD; 
  T2CONSET = 0x70; //sätter prescale 1:256
  TMR2 = 0; //sätter timer 0
  T2CONSET = 0x8000; 

  return;
}


/* This function is called repetitively from the main program */
void labwork( void )
{
  int knappr;
  int latch;


    knappr = getbtns();
    latch = getsw();

    if(knappr == 1)
    {
      mytime = mytime & 0xff0f;
      mytime = (latch << 4) | mytime;
    }

    if(knappr == 2)
    {
      mytime = mytime & 0xf0ff;
     mytime = (latch << 8) | mytime; 
    }
     if(knappr == 4)
     {
     mytime = mytime & 0x0fff;
     mytime = (latch << 12) | mytime; 
     }

  if(IFS(0) & 0x100)
    {
      timeoutc++;
      IFSCLR(0) = 0x100; //clear flaggan
    }

  if(timeoutc == 10) //updateras en gång varje sekund
  {
  //delay( 1000 );
    tick( &mytime );
    time2string( textstring, mytime );
    display_string( 3, textstring );
    display_update();


   display_image(96, icon);

    count++;
    *portE = count;
    timeoutc = 0;
  }

}
//kolla enhetshanteraren för usb porta