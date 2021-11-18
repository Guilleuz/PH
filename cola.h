#ifndef __COLA_H__
#define __COLA_H__

#include <stdint.h>
#include "eventos.h"

struct Evento {
    evento_identificador ID;
    uint32_t datosAux;
    uint32_t timestamp;
};

// Guarda un nuevo evento
void cola_guardar_eventos(uint8_t ID_evento, uint32_t auxData);

// Devuelve 0 si no hay nuevos eventos por leer, 1 en caso contrario
int cola_hay_nuevos(void);

// Pre: cola_hay_nuevos() == 1
// Post: Devuelve el evento más antiguo sin leer
struct Evento cola_ultimo_evento(void);

#endif
