#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

// point to base addresses for SWs and LEDs

volatile unsigned char *switchesBase_ptr   = (unsigned char *) SWITCHES_BASE;
volatile unsigned char *pushButtonBase_ptr = (unsigned char *) PUSHBUTTONS_BASE;
volatile unsigned char *servoControllerBase_ptr = (unsigned char *) VHDL_SERVO_CONTROLLER_0_BASE;

unsigned char *hex0Base_ptr                = (unsigned char *) HEX0_BASE;
unsigned char *hex1Base_ptr                = (unsigned char *) HEX1_BASE;
unsigned char *hex2Base_ptr                = (unsigned char *) HEX2_BASE;
unsigned char *hex3Base_ptr                = (unsigned char *) HEX3_BASE;
unsigned char *hex4Base_ptr                = (unsigned char *) HEX4_BASE;

unsigned char min_angle_deg;
unsigned char max_angle_deg;

unsigned long min_angle_cnt;
unsigned long max_angle_cnt;



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
	
	//Mask logic for setting flags
	
	//set flag that button was pressed
    
    return;
}

void servo_isr(void *context)
/*****************************************************************************/
/* Interrupt Service Routine                                                 */
/*   Determines what caused the interrupt and calls the appropriate          */
/*  subroutine.                                                              */
/*                                                                           */
/*****************************************************************************/
{
	*(pushButtonBase_ptr + 12) = 0x0;
	
	servo_flag = 0;
	
	return;
}

int main(void)
{
	unsigned char hex_values[10] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, 0x27};
	unsigned char hex_cntr;
   
   //Push Button ISR set up
   *(pushButtonBase_ptr + 8) = 0xC;
   *(pushButtonBase_ptr + 12) = 0x0;
   alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID, PUSHBUTTONS_IRQ, push_isr, 0, 0);
   
   //Servo Controller ISR set up
   *(servoControllerBase_ptr + 8) = 0x2;
   *(servoControllerBase_ptr + 12) = 0x0;  
   alt_ic_isr_register(VHDL_SERVO_CONTROLLER_0_IRQ_INTERRUPT_CONTROLLER_ID, VHDL_SERVO_CONTROLLER_0_IRQ, servo_isr, 0, 0);
   
   
   while(1) {
   	   
   	  //Update Hex Values
	  
	  if(1 == push3_flag) {
		  min_angle_deg = *(switchesBase_ptr);
		  if (min_angle_deg >= 0x2D) {
		     min_angle_cnt = 0xC350 + (((min_angle_deg - 0x2D))/0x1F4)*0x1F4);
		  }
		  else {
			 min_angle_deg = 0x2D;
		     min_angle_cnt = 0xC350;
		  }
		  
		  //Write to ServoController
		  
		  hex_cntr = min_angle_deg / 0xA;
		  hex4Base_ptr = hex_values[hex_cntr];
		  
		  hex_cntr = min_angle_deg % 0xA;
		  hex3Base_ptr = hex_values[hex_cntr];
		  
		  push3_flag = 0;
	  }
	  
	  if(1 == push2_flag) {
		  max_angle_deg = *(switchesBase_ptr);
		  if (max_angle_deg <= 0x87) {
		     max_angle_cnt = 0x186A0 - (((0x87 - max_angle_deg))/0x1F4)*0x1F4);
		  }
		  else {
			 max_angle_deg = 0x87;
		     max_angle_cnt = 0x186A0;
		  }
		  
		  //Write to ServoController
		  
		  hex_cntr = max_angle_deg / 0x64;
		  hex2Base_ptr = hex_values[hex_cntr];
		  
		  hex_cntr = max_angle_deg / 0xA;
		  hex1Base_ptr = hex_values[hex_cntr];
		  
		  hex_cntr = max_angle_deg % 0xA;
		  hex0Base_ptr = hex_values[hex_cntr];
		  
		  push2_flag = 0;
	  }
	  
	  if(1 == servo_flag) {
		  
		  
		  
	  }