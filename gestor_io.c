#include "stdint.h"
#include "gestor_io.h"
#include <LPC210X.H>


void GPIO_iniciar(void) {
    // Inicializamos todos los pines como entrada
    IODIR = 0x00000000;
}

int GPIO_leer(int bit_inicial, int num_bits) {
    /*int i = 1 << bit_inicial;
    int j = 1 << (bit_inicial + num_bits);
    int mascara = 0;
    for (i; i < j; i = i << 1) {
        mascara = mascara | i;
    }
    int res = IOPIN & mascara;
    res = res >> bit_inicial;
    return res;*/
    int mascara = (2 << num_bits) - 1;
    mascara = mascara << bit_inicial;
    int valor = IOPIN & mascara;
    return valor >> num_bits;
}

void GPIO_escribir(int bit_inicial, int num_bits, int valor) {
    /*int i = 1 << bit_inicial;
    int j = 1 << (bit_inicial + num_bits);
    int mascaraSET = 0;
    int mascaraCLR = 0;
    valor = valor << bit_inicial;
    valorNegado = ~valor;
    for (i; i < j; i = i << 1) {
        mascaraSET = mascaraSET | (valor & i);
        mascaraCLR = mascaraCLR | (valorNegado & i);
    }
    IOSET = IOSET | mascaraSET;
    IOCLR = IOCLR | mascaraCLR;
    */
    int mascara = (2 << num_bits) - 1;
    mascara = mascara << bit_inicial;
    int v = valor << bit_inicial;
    int vNegado = ~v & mascara;
    v = mascara & v;
    IOSET = IOSET | v;
    IOCLR = IOCLR | v;
}

void GPIO_marcar_entrada(int bit_inicial, int num_bits) {
    /*int i = 1 << bit_inicial;
    int j = 1 << (bit_inicial + num_bits);
    int mascara = 0xffffffff;
    for (i; i < j; i = i << 1) {
        mascara = mascara ^ i;
    }
    IODIR = IODIR & mascara;
    */
    int mascara = (2 << num_bits) - 1;
    mascara = mascara << bit_inicial;
    mascara = 0xffffffff ^ mascara;
    IODIR = IODIR & mascara;
}

void GPIO_marcar_salida(int bit_inicial, int num_bits) {
    /*
    int i = 1 << bit_inicial;
    int j = 1 << (bit_inicial + num_bits);
    int mascara = 0;
    for (i; i < j; i = i << 1) {
        mascara = mascara | i;
    }
    IODIR = IODIR | mascara;
    */
    int mascara = (2 << num_bits) - 1;
    mascara = mascara << bit_inicial;
    IODIR = IODIR & mascara;
}
