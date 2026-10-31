#!/bin/bash

# Crearemos la variable que almacenará la copia total en la carpeta especificada por el ejercicio.
destino="/bacjosedavids"

# Con el tar realizamos la compresión de la copia de seguridad, en este caso tendrá como fecha el mes completo (%B) y año completo (%Y)
tar -czf "$destino/CopTot-$(date +%B-%Y).tar.gz" /home 2>/dev/null

# Con el siguiente touch actualizamos la marca que usa la diferencial para cuando este se ejecute solo haga una copia de lo modificado a partir de la fecha de la copia total.
touch "$destino/.ultima_total"