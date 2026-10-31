#!/bin/bash

# Creamos la carpeta donde se guardará la sincronización.
mkdir -p /bacjosedavids/espejo

# Con -a conserva permisos, fechas, propietarios y enlaces. -v muestra qué se transfiere. --delete elimina del espejo lo que ya no existe en el origen.
rsync -av --delete /home/josedavids/ /bacjosedavids/espejo/
