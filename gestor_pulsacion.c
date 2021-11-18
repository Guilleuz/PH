#include "gestor_pulsacion.h"
#include "cola.h"
#include "eventos.h"
#include "gestor_alarmas.h"
#include <LPC210X.H>

static int nueva_pulsacion_eint1 = 0;
static int nueva_pulsacion_eint2 = 0;

void eint1_ISR (void) __irq {
    VICIntEnable = VICIntEnable & 0xffff7fff; // Deshabilitamos las interrupciones de eint1
    nueva_pulsacion_eint1 = 1;
    EXTINT =  EXTINT | 2;      // clear interrupt flag        
		VICVectAddr = 0;
    cola_guardar_eventos(evento_eint1, 0);
    // set alarma
    uint32_t evento = 0;
    evento = evento_alarma_eint1 << 24;
    evento |= 0x00800064; // Alarma períodica cada 100 ms 
    gestor_set_alarma(evento);
}

void eint2_ISR (void) __irq {
	VICIntEnable = VICIntEnable & 0xfffeffff;  // Deshabilitamos las interrupciones de eint1
    nueva_pulsacion_eint2 = 1;
    EXTINT =  EXTINT | 4;      // clear interrupt flag        
	VICVectAddr = 0;
    cola_guardar_eventos(evento_eint2, 0);
    // set alarma
    
    uint32_t evento = 0;
    evento = evento_alarma_eint2 << 24;
    evento |= 0x00800064; // Alarma períodica cada 100 ms
    gestor_set_alarma(evento);
}

void button_init(void) {
    EXTINT = 6; // Limpia flags de interrupción de eint1 y 2
    PINSEL0 = 0xA0000000;
    PINSEL1 = 0x00000001;
    VICVectAddr2 = (unsigned long)eint1_ISR;
    VICVectAddr3 = (unsigned long)eint2_ISR;
    VICVectCntl2 = 0x20 | 15;
    VICVectCntl3 = 0x20 | 16;                   
    VICIntEnable = VICIntEnable | 0x00018000; // Habilitamos las interrupciones EXTINT 1 y 2
}


/*void actualizar_estado_1(void){
	EXTINT =  EXTINT | 2;        // clear interrupt flag de EINT0     
	if ((EXTINT & 2) == 1){ // si el boton esta pulsado, la instruccion de arriba no hara nada y EXTINT valdra 1. Si el boton no esta pulsado valdra 0
		estado_pulsacion_1 = PULSADO;
	}
	else{
		estado_pulsacion_1 = NO_PULSADO;
		// si no esta pulsado se habilitan las interrupciones (antes ya se ha limpiado el de EXTINT)
		VICIntEnable = VICIntEnable | 0x00004000; // Enable EXTINT0 Interrupt (la interrupcion del boton se deshabilita a si misma, al terminar la pulsacion hay ue volver a habilitarla)
	}
}

void actualizar_estado_2(void){
	EXTINT =  EXTINT | 4;        // clear interrupt flag de EINT0     
	if ((EXTINT & 4) == 1){ // si el boton esta pulsado, la instruccion de arriba no hara nada y EXTINT valdra 1. Si el boton no esta pulsado valdra 0
		estado_pulsacion_1 = PULSADO;
	}
	else{
		estado_pulsacion_1 = NO_PULSADO;
		// si no esta pulsado se habilitan las interrupciones (antes ya se ha limpiado el de EXTINT)
		VICIntEnable = VICIntEnable | 0x00004000; // Enable EXTINT0 Interrupt (la interrupcion del boton se deshabilita a si misma, al terminar la pulsacion hay ue volver a habilitarla)
	}
}
*/
int button_nueva_pulsacion_1(void) {
    return nueva_pulsacion_eint1;
}
    
int button_nueva_pulsacion_2(void) {
    return nueva_pulsacion_eint2;
}

void button_clear_nueva_pulsacion_1(void) {
    nueva_pulsacion_eint1 = 0;
}

void button_clear_nueva_pulsacion_2(void) {
    nueva_pulsacion_eint2 = 0;
}
