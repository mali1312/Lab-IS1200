#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"


int getsw( void )
{
  int tillbax = (PORTD >> 8) & 0x000f;

  return tillbax;
}



int getbtns(void)
{
  int knappr = (PORTD>>5) & 0x000f;

  return knappr;
}