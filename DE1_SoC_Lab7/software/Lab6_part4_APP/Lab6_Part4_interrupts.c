#include "io.h"
#include <stdlib.h>
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

// point to base addresses 
volatile unsigned char *pushButtonBase_ptr = (unsigned char *) PUSHBUTTON1_BASE;
volatile unsigned char *ledsBase_ptr       = (unsigned char *) LEDS_BASE;
volatile unsigned char *ramBase_char_ptr   = (unsigned char *) RAMINFR_BE_0_BASE;
volatile unsigned short *ramBase_short_ptr = (unsigned short *) RAMINFR_BE_0_BASE;
volatile unsigned int *ramBase_int_ptr     = (unsigned int *) RAMINFR_BE_0_BASE;

static unsigned char done_flag = 0;
static unsigned char break_flag = 0;

void push_isr(void *context)
/*****************************************************************************/
/* Interrupt Service Routine                                                 */
/*   Determines what caused the interrupt and calls the appropriate          */
/*  subroutine.                                                              */
/*                                                                           */
/*****************************************************************************/
{
	*(pushButtonBase_ptr + 12) = 0x0;
	//Mask logic for setting flags
	if (0 == *pushButtonBase_ptr) {
	   if (1 == done_flag){
          *ledsBase_ptr = 0xCC;
          printf("RAM TEST DONE\n");
          while(1);
	   }

    }
	return;

	//set flag that button was pressed
    //clear interrupt IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PUSHBUTTONS_BASE, 0);
}

int byte_ram_test(unsigned int addr, unsigned char write_data) {
	if (addr == 0){
		*ledsBase_ptr = 0x00;
	}
   *(ramBase_char_ptr + addr) = write_data;
   
   if(write_data != *(ramBase_char_ptr + addr)) {
      *ledsBase_ptr = 0xFF;
      printf("ERROR: Address: 0x%08x Read: 0x%02x Expected: 0x%02x\n", (ramBase_char_ptr + addr), *(ramBase_char_ptr + addr), write_data);
   }
   return(0);
}

int short_ram_test(unsigned int addr, unsigned short write_data) {
	if (addr == 0){
		*ledsBase_ptr = 0x00;
	}
   *(ramBase_short_ptr + addr) = write_data;
   
   if(write_data != *(ramBase_short_ptr + addr)) {
      *ledsBase_ptr = 0xFF;
      printf("ERROR: Address: 0x%08x Read: 0x%04x Expected: 0x%04x\n", (ramBase_short_ptr + addr), *(ramBase_short_ptr + addr), write_data);
   }
   return(0);
}

int int_ram_test(unsigned int addr, unsigned int write_data) {
	if (addr == 0){
		*ledsBase_ptr = 0x00;
	}
   *(ramBase_int_ptr + addr) = write_data;
   
   if(write_data != *(ramBase_int_ptr + addr)) {
      *ledsBase_ptr = 0xFF;
      printf("ERROR: Address: 0x%08x Read: 0x%08x Expected: 0x%08x\n", (ramBase_int_ptr + addr), *(ramBase_int_ptr + addr), write_data);
   }
   return(0);
}

int ram_test(unsigned int address, unsigned int testData, unsigned char ramSize) {
unsigned char testDataChar;
unsigned short testDataShort;
   switch (ramSize) {
      case 8:

    	 testDataChar = (unsigned char)testData;

         for(unsigned int i = 0; i <= address; i ++) {
            byte_ram_test(i, testDataChar);
         }
      break;
      
      case 16:
		 testDataShort = (unsigned short)testData;
         for(unsigned int i = 0; i <= (address/2); i ++) {
            short_ram_test(i, testDataShort);
         }
      break;
      
      case 32:
         for(unsigned int i = 0; i <= (address/4); i ++) {
            int_ram_test(i, testData);
         }
      break;
      
      default:
         printf("ERROR: Invalid ramSize\n");
      break;
      
   }
   return(0);
}

int main(void) {
    *(pushButtonBase_ptr + 8) = 0x1;
    *(pushButtonBase_ptr + 12) = 0x0;
    alt_ic_isr_register(PUSHBUTTON1_IRQ_INTERRUPT_CONTROLLER_ID, PUSHBUTTON1_IRQ, push_isr, 0, 0);

    while(1) {
       ram_test(0x3FFF,0x00,8);

       ram_test(0x3FFF,0x1234,16);

       ram_test(0x3FFF,0xABCDEF90,32);
       done_flag = 1;
    }
	return(0);
}
