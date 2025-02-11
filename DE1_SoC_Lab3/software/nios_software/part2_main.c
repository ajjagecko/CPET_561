#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

// point to base addresses for SWs and LEDs

volatile unsigned char *switchesBase_ptr   = (unsigned char *) SWITCHES_BASE;
volatile unsigned char *pushButtonBase_ptr = (unsigned char *) PUSHBUTTONS_BASE;
volatile unsigned char *timer_ptr            = (unsigned char *) TIMER_0_BASE;
unsigned char *ledsBase_ptr                = (unsigned char *) LEDS_BASE;
unsigned char *hexBase_ptr                 = (unsigned char *) HEX0_BASE;
static unsigned char pushFlag;

void push_isr(void *context)
/*****************************************************************************/
/* Interrupt Service Routine                                                 */
/*   Determines what caused the interrupt and calls the appropriate          */
/*  subroutine.                                                              */
/*                                                                           */
/*****************************************************************************/
{
    //clear interrupt IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PUSHBUTTONS_BASE, 0);
	*(pushButtonBase_ptr + 12) = 0x0;
	
	//set flag that button was pressed
    pushFlag = 1;
    
    return;
}

void timer_isr(void *context)
/*****************************************************************************/
/* Interrupt Service Routine                                                 */
/*   Determines what caused the interrupt and calls the appropriate          */
/*  subroutine.                                                              */
/*                                                                           */
/*****************************************************************************/
{
    //clear interrupt IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PUSHBUTTONS_BASE, 0);
	*(timer_ptr) = 0x0;

	//set flag that button was pressed
	*ledsBase_ptr = ~ *ledsBase_ptr;

    return;
}

int main(void)
{
	unsigned char hex_values[10] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, 0x27};
	unsigned char hex_cntr = 0x00;

   //IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PUSHBUTTONS_BASE, 0x2);
   *(pushButtonBase_ptr + 8) = 0x2;

   //IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PUSHBUTTONS_BASE, 0x0);
   *(pushButtonBase_ptr + 12) = 0x0;

   alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID, PUSHBUTTONS_IRQ, push_isr, 0, 0);
   alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ,timer_isr,0,0);

   while(1) {
	   
	  *(hexBase_ptr) = hex_values[hex_cntr];
	  if (1 == pushFlag) {
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
		  
		  pushFlag = 0;
	  }
   }
}
