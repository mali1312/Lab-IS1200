 /* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

#define TRISD		PIC32_R (0x860C0) /* Port D: mask of inputs */

int mytime = 0x5957;
int led_value = 0; // Global variable to keep track of the ticks
int timeoutcount = 0; // Global variable to count the number of ISR invocations
int prime = 1234567;


char textstring[] = "text, more text, and even more text!";


/* Interrupt Service Routine */
void user_isr( void )
{
 // Check if the Timer 2 interrupt flag is set
  if (IFS(0) & 0x100) {
    // Acknowledge the Timer 2 interrupt
    // by clearing its interrupt flag
    IFSCLR(0) = 0x100;

    // Increment the timeoutcount annd check if it reached 10
    if (++timeoutcount >= 10) {
      // Reset the counter
      timeoutcount = 0;
    

    time2string( textstring, mytime );
    display_string( 3, textstring );
    display_update();
    tick( &mytime );
  }
 }
}

/* Lab-specific initialization goes here */
void labinit( void )
{
	
  volatile unsigned int *trise = (volatile unsigned int *) 0xbf886100;
 	 *trise &= 0xff00; 
    volatile unsigned int *porte = (volatile unsigned int *) 0xbf886110;
  *porte = 0; // Initialize PORTE to 0 to turn off all LEDs
  // Set bits 11 through 5 of Port D as inputs
  TRISD = 0x0fe0; 


  T2CON = 0x0; // Stop the timer and clear the control register
  TMR2 = 0x0; // Clear the timer register
  PR2 = 31249; // Load the period register with the value for 100ms timeout
  T2CONSET = 0x70; // Set the prescaler to 1:256 (assuming PBCLK is 80MHz)
  IFSCLR(0) = 0x100; // Clear the Timer 2 interrupt flag
  T2CONSET = 0x8000; // Start Timer 2

      // Pointer to IEC(0) and IPC(2)
    volatile unsigned int *IEC0 = (volatile unsigned int *) 0xbf881060;
    volatile unsigned int *IPC2 = (volatile unsigned int *) 0xbf8810b0;
    
    // pointer to IPC(1)
    volatile unsigned int *IPC1 = (volatile unsigned int *) 0xbf8810a0;
    
    

    // Enable Timer 2 interrupt in IEC(0)
    *IEC0 = 0x100 ; // Assuming Timer 2 interrupt is the 8th bit
    *IEC0 |= (1 << 25) //enable int1 interrupt 
    // Set priority level for Timer 2 in IPC(2)
    // Assuming priority bits are bits 2-4, set them to a desired level, e.g., level 4
    *IPC2 |= (4 << 2); // Set priority level 4
    *IPC1 |= (4 << 24)


    // Enable global interrupts
    // Call the assembly function to execute 'ei' instruction
    enable_interrupt();
}

/* This function is called repetitively from the main program */
void labwork( void )
{
prime = nextprime( prime );
 display_string( 0, itoaconv( prime ) );
 display_update();
}


