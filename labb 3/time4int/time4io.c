#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

int getsw(void) {
    // Read the PORTD register and isolate bits 11 through 8
    int switches = (PORTD >> 8) & 0x000F;
    // The four least significant bits of 'switches' now represent the states of SW4 to SW1
    return switches;
}

int getbtns(void) {
    // Shift PORTD right by 5 and mask with 0x7 to get BTN2, BTN3, and BTN4
    int buttons = (PORTD >> 5) & 0x0007;
    return buttons;
}
