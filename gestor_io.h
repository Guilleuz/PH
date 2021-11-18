#ifndef __GESTOR_IO_H__
#define __GESTOR_IO_H__


void GPIO_iniciar(void);
int GPIO_leer(int bit_inicial, int num_bits);
void GPIO_escribir(int bit_inicial, int num_bits, int valor);
void GPIO_marcar_entrada(int bit_inicial, int num_bits);
void GPIO_marcar_salida(int bit_inicial, int num_bits);

#endif 
