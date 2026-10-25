# Variable que guardará lo que escriba el usuario. Se inicia vacía para que el bucle inicie al menos una vez.
$opcion = ''

# Obtenemos la lista de registros y lo almacenamos dentro de la variable logs con Get-WinEvent -ListLog *. 
# Los filtramos para que aparezcan los que tengan algún registro Y usaremos solo los principales del sistema con -notlike '*/*' (si no habrán mas de 100)
# Con @( ) nos aseguramos de que sea siempre una lista.

$logs = @(Get-WinEvent -ListLog * | Where-Object { $_.RecordCount -gt 0 -and $_.LogName -notlike '*/*' } | Sort-Object LogName)

# Comenzamos con el bucle do-while
do {
    Write-Host " MENÚ "
  
# Con el for recorremos el recuento de logs para la numeración del menú.
# Los {} son huecos que luego -f rellena y ponemos ($i +1) para dejar el 0 libre para poder salir del menú. Luego con el .LogName rellenamos con el nombre del log.

    for ($i = 0; $i -lt $logs.Count; $i++) {
        Write-Host ("{0}. {1}" -f ($i + 1), $logs[$i].LogName)
    }

    Write-Host "0. Salir"

    # Pedimos la opción al usuario
    $opcion = Read-Host "Elige una opción"

# Creamos un if para que el usuario pueda salir si pulsa 0.

    if ($opcion -eq '0') {
        Write-Host "Saliendo..."
    }


# Si el usuario continua pasará al ifelse. 
# Si el usuario escribe un número que no corresponda o una letra con el -in y el 1..$logs.Count (crea la lista) dará lugar directamente al else (Opción no válida) esto se debe a que el -in comprueba si lo que escribe el usuario está en la lista.


    elseif ($opcion -in 1..$logs.Count) {

# Restamos 1 para volver de la numeración del menú (empieza en 1) a la posición real en la lista (empieza en 0). Esto lo que hace es que en lugar de empezar por el segundo log comience por el primero sin afectar al 0 que es la opción para salir.

        $seleccionado = $logs[[int]$opcion - 1]
        $nombreLog = $seleccionado.LogName
        $total = $seleccionado.RecordCount

# Mostramos cuántos eventos tiene el registro elegido
        Write-Host "Eventos en '$($seleccionado.LogName)': $total"
        Write-Host "--------------------------------------------------"


# Obtenemos los eventos y mostramos los 12 últimos eventos (los más recientes primero). Luego seleccionamos el tiempo, id, el nombre del nivel de evento (información, advertencia..) y ajustamos el tamaño según lo que nos de, si no lo usamos es posible que no nos muestre información aunque haya eventos.

        Get-WinEvent -LogName $nombreLog -MaxEvents 12 | Select-Object TimeCreated, Id, LevelDisplayName, Message | Format-Table -AutoSize

# Creamos un pause para que el usuario decida cuando continuar.
        Pause
    }

# Para los valores no válidos.

    else {
        Write-Host "Opción no válida."
    }

} while ($opcion -ne '0')   # Repite el menú mientras la opción no sea 0 (salir)