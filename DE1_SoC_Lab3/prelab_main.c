#include "system.h" // includes information about system configuration 

int main(void)
{
   // point to base addresses for SWs and LEDs
   unsigned char *switchesBase_ptr = (unsigned char *) SWITCHES_BASE;
   unsigned char *pushButtonBase_ptr = (unsigned char *) PUSHBUTTONS_BASE;
   unsigned char *ledsBase_ptr     = (unsigned char *) LEDS_BASE;
   unsigned char *hexBase_ptr      = (unsigned char *) HEX0_BASE;
   unsigned char hex_values[10] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, 0x27};
   unsigned char hex_cntr = 0x00;
   unsigned char pushVal;

   while(1) {
	   
	  *(hexBase_ptr) = hex_values[hex_cntr];
	  pushVal = *pushButtonBase_ptr;
	  if (0 == (pushVal & 0x02)) {
		  if(1 == (*(switchesBase_ptr) & 0x01)) {
			  if(0x09 > hex_cntr){
				  hex_cntr= hex_cntr + 1;
			  }
		  }
		  else {
			  if(0x00 < hex_cntr){
				  hex_cntr= hex_cntr - 1;
			  }
		  }
		  while(0 == (pushVal & 0x02)) {
			  pushVal = *pushButtonBase_ptr;
		  }
	  }
   }
}
