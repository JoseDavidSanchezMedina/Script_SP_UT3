param(
	[Parameter(Mandatory)][datetime]$inicio,
	[Parameter(Mandatory)][datetime]$fin
)

# Con param hacemos que el usuario indique las fechas para calcular los inicios de sesión de los usuarios.

Write-Host "Consultando inicios de sesión desde $inicio hasta $fin..."

Write-Host " --------------------------------------------------------------------------------";

# Para poder seleccionar los eventos usamos el Get-WinEvent donde filtraremos por su LogName, ID y Fechas. .date.AddDays(1) cuenta el dia completo.

$eventos = Get-WinEvent -FilterHashtable @{
	LogName = 'Security' # Registro de seguridad.
	Id = 4624 # Corresponde a los inicios de sesión exitosos.
	StartTime = $inicio
	EndTime = $fin.Date.AddDays(1)
	}

# Una vez tenemos los eventos guardados en su variable los recorremos con el foreach. Lo siguiente será pasarlo a xml para poder buscar al usuario.
# Convertido ya a xml dentro de este se buscará aquello que sea TartUserName y seleccionamos el texto.
# Por último con un if seleccionamos el usuario y excluimos a SYSTEM y aquellos usuarios que acaben en $ (equipos de dominio o de cuentas de la máquina).

foreach ($evento in $eventos) {

	[xml]$eventoXml = $evento.ToXml()
	$usuario = $eventoXml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text'

	if ($usuario -and $usuario -ne 'SYSTEM' -and -not $usuario.EndsWith('$')) {
		[PSCustomObject]@{
		Fecha = $evento.TimeCreated.ToShortDateString()
		Hora = $evento.TimeCreated.ToLongTimeString()
		Usuario = $usuario
		}
	}
}