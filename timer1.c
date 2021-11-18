#include "timer1.h"
#include <LPC210X.H>                            // LPC21XX Peripheral Registers

// Cuenta en microsegundos

static volatile unsigned int timer1_int_count;

void timer1_ISR (void) __irq;

void temporizador_iniciar(void) {
	T1MR0 = 11999;                // Interrumpe cada 0,001ms = 12.000 - 1 counts
  T1MCR = 3;                     // Generates an interrupt and resets the count when the value of MR0 is reached
  // configuration of the IRQ slot number 0 of the VIC for Timer 0 Interrupt
	VICVectAddr1 = (unsigned long)timer1_ISR;          // set interrupt vector in 0
  // 0x20 bit 5 enables vectored IRQs. 
	// 5 is the number of the interrupt assigned. Number 5 is the Timer 1 (see table 40 of the LPC2105 user manual  
	VICVectCntl1 = 0x20 | 5;                   
  VICIntEnable = VICIntEnable | 0x00000020;                  // Enable Timer1 Interrupt
}

void timer1_ISR (void) __irq {
    timer1_int_count++;
    T1IR = 1;                              // Clear interrupt flag
    VICVectAddr = 0;   										 // Acknowledge Interrupt
}

void temporizador_empezar(void) {
    T1TCR = 1;         // Timer1 Enable
    timer1_int_count = 0;	
}

int temporizador_leer(void) {
    return timer1_int_count;
}

void temporizador_parar(void) {
    T1TCR = 3;  // Reinicia el contador
    T1TCR = 0;  // Para el reloj
}

