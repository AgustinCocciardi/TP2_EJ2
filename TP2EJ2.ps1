<# 
.SYNOPSIS
El script recibe un directorio con archivos de log, los cuales deberá procesar. Cada archivo de log contiene registros de llamadas.


.DESCRIPTION
Para ejecutar el Script se debe enviar una ruta valida con el path de los archivos de log (Anteponiendo -Path). 

El script procesará los archivos de log de llamadas y mostrará por pantalla:
    1) Promedio de tiempo de llamadas por día
    2) Promedio de tiempo y cantidad por usuario por día
    3) Los 3 usuarios con más llamadas en la semana
    4) Cuantas llamadas no superan la media de tiempo por día, y el usuario con más llamadas por debajo de la media en la semana

Paramentros a enviar:
--------------------

-Path path_directorio

El path del directorio puede ser una ruta tanto absoluta como relativa.

.NOTES
INTEGRANTES - TP2 - Ejercicio 6
 * Agustin Cocciardi - 40231779
#>

Param( 
    [Parameter(Mandatory=$true)][string] $Path
)

$ruta = Test-Path $Path
if($ruta -ne $true)
	{Write-Host "El path de los archivos de log no es válido."
	 exit 1;
    }

$archivos = Get-ChildItem "$Path" -Filter "*.log"
if($archivos.Length -eq 0){
    Write-Output "El path que pasó por parámetro no contiene archivos"
}

foreach ($archivo in $archivos) {
    Write-Host $archivo.Name
    Write-Host
    $contenido = Get-Content $archivo | Sort-Object 
    #Write-Output $contenido
    #exit 5
    if($contenido.Length -eq 0){
        Write-Host "El archivo " $archivo.Name " esta vacío y no se puede procesar"
        Write-Host

        Write-Host "[*****************************************************************************************************************]"
    }
    else{
        #Arrays para resolver el promedio diario
        $Dias = @()
        $DuracionXDia = @{}
        $LlamadasPorDia = @{}

        #Arrays para resolver a los usuarios con más llamadas por semana
        $Usuarios = @()
        $LlamadasPorSemana = @{}
        $masLlamadasPorSemana = @()

        #Arrays (y variables) para resolver cantidad de llamadas y promedio por dia por usuario
        $diaActual = 0
        $LlamadasUsuarioPorDia1 = @{}
        $LlamadasUsuarioPorDia2 = @{}
        $LlamadasUsuarioPorDia3 = @{}
        $LlamadasUsuarioPorDia4 = @{}
        $LlamadasUsuarioPorDia5 = @{}
        $LlamadasUsuarioPorDia6 = @{}
        $LlamadasUsuarioPorDia7 = @{}
        $DuracionUsuarioPorDia1 = @{}
        $DuracionUsuarioPorDia2 = @{}
        $DuracionUsuarioPorDia3 = @{}
        $DuracionUsuarioPorDia4 = @{}
        $DuracionUsuarioPorDia5 = @{}
        $DuracionUsuarioPorDia6 = @{}
        $DuracionUsuarioPorDia7 = @{}

        #Arrays (y variables) para resolver cuantas llamadas no superan la media de tiempo por día
        $DuracionLlamadasDia1 = @()
        $DuracionLlamadasDia2 = @()
        $DuracionLlamadasDia3 = @()
        $DuracionLlamadasDia4 = @()
        $DuracionLlamadasDia5 = @()
        $DuracionLlamadasDia6 = @()
        $DuracionLlamadasDia7 = @()

        #Arrays para resolver cual fue el usuario que hizo más llamadas que no superan la media por semana
        $LlamadasHechasPorUsuario = @{}
        $CantidadLlamadasQueNoSuperanLaMediaSemanal = @{}

        $a = 0
        $inicio = $a
        $final = $contenido.Length
        $contadorDias = 0

        $procesados = 1
        $llamadaIniciada = 0

        while($procesados -eq 1){
            if($llamadaIniciada -eq 0){
                $llamadaIniciada = 1

                $empieza = $inicio
                $termina = $final

                while($empieza -lt $termina){
                    if($contenido[$empieza] -ne 0){
                        $registro = $contenido[$empieza].Split(' ')
                        $dia = $registro[0]
                        $hora = $registro[1]
                        $usuario = $registro[3]
                        $contenido[$empieza] = 0
                        $empieza=$termina
                    }
                    else{
                        $empieza+=1
                    }
                }

                $diaAgregado = 1
                foreach($item in $Dias){
                    if($dia -eq $item){
                        $diaAgregado = 0
                    }
                }

                if($diaAgregado -eq 1){
                    $Dias += $dia
                    $DuracionXDia[$dia] = 0
                    $LlamadasPorDia[$dia] = 0
                    $diaActual+=1
                }

                $tiempo = $hora.Split(':')
                if($tiempo[0] -eq "00"){
                    $tiempo[0]=0
                }elseif($tiempo[0] -eq "01"){
                    $tiempo[0]=1
                }elseif($tiempo[0] -eq "02"){
                    $tiempo[0]=2
                }elseif($tiempo[0] -eq "03"){
                    $tiempo[0]=3
                }elseif($tiempo[0] -eq "04"){
                    $tiempo[0]=4
                }elseif($tiempo[0] -eq "05"){
                    $tiempo[0]=5
                }elseif($tiempo[0] -eq "06"){
                    $tiempo[0]=6
                }elseif($tiempo[0] -eq "07"){
                    $tiempo[0]=7
                }elseif($tiempo[0] -eq "08"){
                    $tiempo[0]=8
                }elseif($tiempo[0] -eq "09"){
                    $tiempo[0]=9
                }

                if($tiempo[1] -eq "00"){
                    $tiempo[1]=0
                }elseif($tiempo[1] -eq "01"){
                    $tiempo[1]=1
                }elseif($tiempo[1] -eq "02"){
                    $tiempo[1]=2
                }elseif($tiempo[1] -eq "03"){
                    $tiempo[1]=3
                }elseif($tiempo[1] -eq "04"){
                    $tiempo[1]=4
                }elseif($tiempo[1] -eq "05"){
                    $tiempo[1]=5
                }elseif($tiempo[1] -eq "06"){
                    $tiempo[1]=6
                }elseif($tiempo[1] -eq "07"){
                    $tiempo[1]=7
                }elseif($tiempo[1] -eq "08"){
                    $tiempo[1]=8
                }elseif($tiempo[1] -eq "09"){
                    $tiempo[1]=9
                }

                if($tiempo[2] -eq "00"){
                    $tiempo[2]=0
                }elseif($tiempo[2] -eq "01"){
                    $tiempo[2]=1
                }elseif($tiempo[2] -eq "02"){
                    $tiempo[2]=2
                }elseif($tiempo[2] -eq "03"){
                    $tiempo[2]=3
                }elseif($tiempo[2] -eq "04"){
                    $tiempo[2]=4
                }elseif($tiempo[2] -eq "05"){
                    $tiempo[2]=5
                }elseif($tiempo[2] -eq "06"){
                    $tiempo[2]=6
                }elseif($tiempo[2] -eq "07"){
                    $tiempo[2]=7
                }elseif($tiempo[2] -eq "08"){
                    $tiempo[2]=8
                }elseif($tiempo[2] -eq "09"){
                    $tiempo[2]=9
                }

                $hour = $tiempo[0] -as [Int]
                $minute = $tiempo[1] -as [Int]
                $second = $tiempo[2] -as [Int]

                $duracion = ($hour*3600)+($minute*60)+($second)
                $dur=0-$duracion
                $DuracionXDia[$dia]-=$duracion
                $duracionParcial = 0-$duracion

                #Write-Host "Usuarios Hasta ahora:"
                foreach($item in $Usuarios){
                    #Write-Host $item
                    #sleep 1
                }

                $usuarioAgregado=1
                foreach($item in $Usuarios){
                    if($item -eq $usuario){
                        $usuarioAgregado=0
                    }
                }
                if($usuarioAgregado -eq 1){
                    $Usuarios += $usuario
                    $LlamadasPorSemana[$usuario]=0
                    $LlamadasUsuarioPorDia1[$usuario]=0
                    $LlamadasUsuarioPorDia2[$usuario]=0
                    $LlamadasUsuarioPorDia3[$usuario]=0
                    $LlamadasUsuarioPorDia4[$usuario]=0
                    $LlamadasUsuarioPorDia5[$usuario]=0
                    $LlamadasUsuarioPorDia6[$usuario]=0
                    $LlamadasUsuarioPorDia7[$usuario]=0
                    $DuracionUsuarioPorDia1[$usuario]=0
                    $DuracionUsuarioPorDia2[$usuario]=0
                    $DuracionUsuarioPorDia3[$usuario]=0
                    $DuracionUsuarioPorDia4[$usuario]=0
                    $DuracionUsuarioPorDia5[$usuario]=0
                    $DuracionUsuarioPorDia6[$usuario]=0
                    $DuracionUsuarioPorDia7[$usuario]=0
                    $LlamadasHechasPorUsuario[$usuario]=""
                    $CantidadLlamadasQueNoSuperanLaMediaSemanal[$usuario]=0
                }

                if($diaActual -eq 1){
                    $DuracionUsuarioPorDia1[$usuario]-=$duracion
                    #$DuracionLlamadasDia1[$cantidadLlamadasDia1]=0-$duracion
                }
                elseif($diaActual -eq 2){
                    $DuracionUsuarioPorDia2[$usuario]-=$duracion
                    #$DuracionLlamadasDia2[$cantidadLlamadasDia2]=0-$duracion
                }
                elseif($diaActual -eq 3){
                    $DuracionUsuarioPorDia3[$usuario]-=$duracion
                    #$DuracionLlamadasDia3[$cantidadLlamadasDia3]=0-$duracion
                }
                elseif($diaActual -eq 4){
                    $DuracionUsuarioPorDia4[$usuario]-=$duracion
                    #$DuracionLlamadasDia4[$cantidadLlamadasDia4]=0-$duracion
                }
                elseif($diaActual -eq 5){
                    $DuracionUsuarioPorDia5[$usuario]-=$duracion
                    #$DuracionLlamadasDia5[$cantidadLlamadasDia5]=0-$duracion
                }
                elseif($diaActual -eq 6){
                    $DuracionUsuarioPorDia6[$usuario]-=$duracion
                    #$DuracionLlamadasDia6[$cantidadLlamadasDia6]=0-$duracion
                }
                else{
                    $DuracionUsuarioPorDia7[$usuario]-=$duracion
                    #$DuracionLlamadasDia7[$cantidadLlamadasDia7]=0-$duracion
                }

            }

            if($llamadaIniciada -eq 1){
                #Write-Host "Buscando fin de llamada"
                #sleep 1
                $llamadaIniciada = 0

                $empieza = $inicio
                $termina = $final

                while($empieza -lt $termina){
                    #Write-Host $contenido[$empieza]
                    #sleep 1
                    if($contenido[$empieza] -ne 0){
                        $registro = $contenido[$empieza].Split(' ')
                        $nuevoUser = $registro[3]
                        #Write-Host "Tome usuario " $nuevoUser
                        #sleep 1
                        if($nuevoUser -eq $usuario){
                            #Write-Host "Me lo quedo"
                            $contenido[$empieza]=0
                            $empieza=$termina
                            $nuevoDia = $registro[0]
                            $nuevaHora = $registro[1]
                            $tiempo = $nuevaHora.Split(':')
                            if($tiempo[0] -eq "00"){
                                $tiempo[0]=0
                            }elseif($tiempo[0] -eq "01"){
                                $tiempo[0]=1
                            }elseif($tiempo[0] -eq "02"){
                                $tiempo[0]=2
                            }elseif($tiempo[0] -eq "03"){
                                $tiempo[0]=3
                            }elseif($tiempo[0] -eq "04"){
                                $tiempo[0]=4
                            }elseif($tiempo[0] -eq "05"){
                                $tiempo[0]=5
                            }elseif($tiempo[0] -eq "06"){
                                $tiempo[0]=6
                            }elseif($tiempo[0] -eq "07"){
                                $tiempo[0]=7
                            }elseif($tiempo[0] -eq "08"){
                                $tiempo[0]=8
                            }elseif($tiempo[0] -eq "09"){
                                $tiempo[0]=9
                            }
            
                            if($tiempo[1] -eq "00"){
                                $tiempo[1]=0
                            }elseif($tiempo[1] -eq "01"){
                                $tiempo[1]=1
                            }elseif($tiempo[1] -eq "02"){
                                $tiempo[1]=2
                            }elseif($tiempo[1] -eq "03"){
                                $tiempo[1]=3
                            }elseif($tiempo[1] -eq "04"){
                                $tiempo[1]=4
                            }elseif($tiempo[1] -eq "05"){
                                $tiempo[1]=5
                            }elseif($tiempo[1] -eq "06"){
                                $tiempo[1]=6
                            }elseif($tiempo[1] -eq "07"){
                                $tiempo[1]=7
                            }elseif($tiempo[1] -eq "08"){
                                $tiempo[1]=8
                            }elseif($tiempo[1] -eq "09"){
                                $tiempo[1]=9
                            }
            
                            if($tiempo[2] -eq "00"){
                                $tiempo[2]=0
                            }elseif($tiempo[2] -eq "01"){
                                $tiempo[2]=1
                            }elseif($tiempo[2] -eq "02"){
                                $tiempo[2]=2
                            }elseif($tiempo[2] -eq "03"){
                                $tiempo[2]=3
                            }elseif($tiempo[2] -eq "04"){
                                $tiempo[2]=4
                            }elseif($tiempo[2] -eq "05"){
                                $tiempo[2]=5
                            }elseif($tiempo[2] -eq "06"){
                                $tiempo[2]=6
                            }elseif($tiempo[2] -eq "07"){
                                $tiempo[2]=7
                            }elseif($tiempo[2] -eq "08"){
                                $tiempo[2]=8
                            }elseif($tiempo[2] -eq "09"){
                                $tiempo[2]=9
                            }

                            $hour = $tiempo[0] -as [Int]
                            $minute = $tiempo[1] -as [Int]
                            $second = $tiempo[2] -as [Int]
                            $duracion=($hour*3600)+($minute*60)+($second)
                            $DuracionXDia[$dia]+=$duracion
                            $LlamadasPorDia[$dia]+=1
                            $LlamadasPorSemana[$nuevoUser]+=1
                            $duracionParcial+=$duracion
                            $LlamadasHechasPorUsuario[$usuario]+="$duracionParcial,"
                            if($diaActual -eq 1){
                                $LlamadasUsuarioPorDia1[$nuevoUser]+=1
                                $DuracionUsuarioPorDia1[$nuevoUser]+=$duracion
                                $dur+=$duracion
                                $DuracionLlamadasDia1 += $dur
                                #$DuracionLlamadasDia1[$cantidadLlamadasDia1]+=$duracion
                                #$cantidadLlamadasDia1+=1
                            }
                            elseif($diaActual -eq 2){
                                $LlamadasUsuarioPorDia2[$nuevoUser]+=1
                                $DuracionUsuarioPorDia2[$nuevoUser]+=$duracion
                                $dur+=$duracion
                                $DuracionLlamadasDia2 += $dur
                            }
                            elseif($diaActual -eq 3){
                                $LlamadasUsuarioPorDia3[$nuevoUser]+=1
                                $DuracionUsuarioPorDia3[$nuevoUser]+=$duracion
                                $dur+=$duracion
                                $DuracionLlamadasDia3 += $dur
                            }
                            elseif($diaActual -eq 4){
                                $LlamadasUsuarioPorDia4[$nuevoUser]+=1
                                $DuracionUsuarioPorDia4[$nuevoUser]+=$duracion
                                $dur+=$duracion
                                $DuracionLlamadasDia4 += $dur
                            }
                            elseif($diaActual -eq 5){
                                $LlamadasUsuarioPorDia5[$nuevoUser]+=1
                                $DuracionUsuarioPorDia5[$nuevoUser]+=$duracion
                                $dur+=$duracion
                                $DuracionLlamadasDia5 += $dur
                            }
                            elseif($diaActual -eq 6){
                                $LlamadasUsuarioPorDia6[$nuevoUser]+=1
                                $DuracionUsuarioPorDia6[$nuevoUser]+=$duracion
                                $dur+=$duracion
                                $DuracionLlamadasDia6 += $dur
                            }
                            else{
                                $LlamadasUsuarioPorDia7[$nuevoUser]+=1
                                $DuracionUsuarioPorDia7[$nuevoUser]+=$duracion
                                $dur+=$duracion
                                $DuracionLlamadasDia7 += $dur
                            }
                        }
                        else{
                            $empieza+=1
                            #Write-Host "No me lo quedo"
                            #sleep 1
                        }
                    }
                    else{
                        $empieza+=1
                    }
                }

                $empieza=$inicio
                $termina=$final
                $procesados=0
                #Write-Host "Me fijo si termine de procesar"
                #sleep 1
                while($empieza -lt $termina){
                    if($contenido[$empieza] -ne 0){
                        $procesados=1
                        $empieza=$termina
                    }
                    else{
                        $empieza++
                    }
                }

            }
        }
        #Write-Host "Termine de procesar"
        #sleep 1

        for($i=0; $i -lt 3; $i++){
            $mayor=0
            foreach($user in $Usuarios){
                if($LlamadasPorSemana[$user] -gt $mayor){
                    $mayor=$LlamadasPorSemana[$user]
                    $userMayor=$user
                }
            }
            $masLlamadasPorSemana+=$userMayor
            $LlamadasPorSemana[$userMayor]=0
        }

        Write-Host "Duracion promedio de llamadas por dia"
        foreach($dia in $Dias){
            $promedioDiario=($DuracionXDia[$dia]/$LlamadasPorDia[$dia])
            Write-Host "El promedio diario en el día " $dia " es: " $promedioDiario
        }

        Write-Host

        Write-Host "Cantidad y promedio por usuario por dia"
        foreach($users in $Usuarios){
            if($diaActual -ge 1){
                $diAct=0
                if($LlamadasUsuarioPorDia1[$users] -ne 0){
                    $average= $DuracionUsuarioPorDia1[$users]/$LlamadasUsuarioPorDia1[$users]
                    Write-Host $users " cantidad de llamadas " $LlamadasUsuarioPorDia1[$users] ". Promedio " $average ". Dia " $Dias[$diAct]
                }
                else{
                    Write-Host "El usuario " $users " no hizo llamadas en el dia " $Dias[$diAct]
                }
            }
            if($diaActual -ge 2){
                $diAct=1
                if($LlamadasUsuarioPorDia2[$users] -ne 0){
                    $average= $DuracionUsuarioPorDia2[$users]/$LlamadasUsuarioPorDia2[$users]
                    Write-Host $users " cantidad de llamadas " $LlamadasUsuarioPorDia2[$users] ". Promedio " $average ". Dia " $Dias[$diAct]
                }
                else{
                    Write-Host "El usuario " $users " no hizo llamadas en el dia " $Dias[$diAct]
                }
            }
            if($diaActual -ge 3){
                $diAct=2
                if($LlamadasUsuarioPorDia3[$users] -ne 0){
                    $average= $DuracionUsuarioPorDia3[$users]/$LlamadasUsuarioPorDia3[$users]
                    Write-Host $users " cantidad de llamadas " $LlamadasUsuarioPorDia3[$users] ". Promedio " $average ". Dia " $Dias[$diAct]
                }
                else{
                    Write-Host "El usuario " $users " no hizo llamadas en el dia " $Dias[$diAct]
                }
            }
            if($diaActual -ge 4){
                $diAct=3
                if($LlamadasUsuarioPorDia4[$users] -ne 0){
                    $average= $DuracionUsuarioPorDia4[$users]/$LlamadasUsuarioPorDia4[$users]
                    Write-Host $users " cantidad de llamadas " $LlamadasUsuarioPorDia4[$users] ". Promedio " $average ". Dia " $Dias[$diAct]
                }
                else{
                    Write-Host "El usuario " $users " no hizo llamadas en el dia " $Dias[$diAct]
                }
            }
            if($diaActual -ge 5){
                $diAct=4
                if($LlamadasUsuarioPorDia5[$users] -ne 0){
                    $average= $DuracionUsuarioPorDia5[$users]/$LlamadasUsuarioPorDia5[$users]
                    Write-Host $users " cantidad de llamadas " $LlamadasUsuarioPorDia5[$users] ". Promedio " $average ". Dia " $Dias[$diAct]
                }
                else{
                    Write-Host "El usuario " $users " no hizo llamadas en el dia " $Dias[$diAct]
                }
            }
            if($diaActual -ge 6){
                $diAct=5
                if($LlamadasUsuarioPorDia6[$users] -ne 0){
                    $average= $DuracionUsuarioPorDia6[$users]/$LlamadasUsuarioPorDia6[$users]
                    Write-Host $users " cantidad de llamadas " $LlamadasUsuarioPorDia6[$users] ". Promedio " $average ". Dia " $Dias[$diAct]
                }
                else{
                    Write-Host "El usuario " $users " no hizo llamadas en el dia " $Dias[$diAct]
                }
            }
            if($diaActual -ge 7){
                $diAct=6
                if($LlamadasUsuarioPorDia7[$users] -ne 0){
                    $average= $DuracionUsuarioPorDia7[$users]/$LlamadasUsuarioPorDia7[$users]
                    Write-Host $users " cantidad de llamadas " $LlamadasUsuarioPorDia7[$users] ". Promedio " $average ". Dia " $Dias[$diAct]
                }
                else{
                    Write-Host "El usuario " $users " no hizo llamadas en el dia " $Dias[$diAct]
                }
            }
        }

        Write-Host

        Write-Host "Los 3 usuarios con mas llamadas por semana"
        foreach($usuar in $MasLlamadasPorSemana){
            Write-Host $usuar
        }

        Write-Host

        Write-Host "Cantidad de llamadas que no superan la media de tiempo por día"
        $diaEnElQueEstoyActualmente=1
        foreach($day in $Dias){
            $numeroTotalDeLlamadas=0
            if($diaEnElQueEstoyActualmente -eq 1){
                $promedioDiario=$DuracionXDia[$day]/$LlamadasPorDia[$day]
                foreach($call in $DuracionLlamadasDia1){
                    if($call -lt $promedioDiario){
                        $numeroTotalDeLlamadas+=1
                    }
                }
                Write-Host "En el dia " $day " se hicieron " $numeroTotalDeLlamadas " llamadas que no superan el promedio diario"
            }
            if($diaEnElQueEstoyActualmente -eq 2){
                $promedioDiario=$DuracionXDia[$day]/$LlamadasPorDia[$day]
                foreach($call in $DuracionLlamadasDia2){
                    if($call -lt $promedioDiario){
                        $numeroTotalDeLlamadas+=1
                    }
                }
                Write-Host "En el dia " $day " se hicieron " $numeroTotalDeLlamadas " llamadas que no superan el promedio diario"
            }
            if($diaEnElQueEstoyActualmente -eq 3){
                $promedioDiario=$DuracionXDia[$day]/$LlamadasPorDia[$day]
                foreach($call in $DuracionLlamadasDia3){
                    if($call -lt $promedioDiario){
                        $numeroTotalDeLlamadas+=1
                    }
                }
                Write-Host "En el dia " $day " se hicieron " $numeroTotalDeLlamadas " llamadas que no superan el promedio diario"
            }
            if($diaEnElQueEstoyActualmente -eq 4){
                $promedioDiario=$DuracionXDia[$day]/$LlamadasPorDia[$day]
                foreach($call in $DuracionLlamadasDia4){
                    if($call -lt $promedioDiario){
                        $numeroTotalDeLlamadas+=1
                    }
                }
                Write-Host "En el dia " $day " se hicieron " $numeroTotalDeLlamadas " llamadas que no superan el promedio diario"
            }
            if($diaEnElQueEstoyActualmente -eq 5){
                $promedioDiario=$DuracionXDia[$day]/$LlamadasPorDia[$day]
                foreach($call in $DuracionLlamadasDia5){
                    if($call -lt $promedioDiario){
                        $numeroTotalDeLlamadas+=1
                    }
                }
                Write-Host "En el dia " $day " se hicieron " $numeroTotalDeLlamadas " llamadas que no superan el promedio diario"
            }
            if($diaEnElQueEstoyActualmente -eq 6){
                $promedioDiario=$DuracionXDia[$day]/$LlamadasPorDia[$day]
                foreach($call in $DuracionLlamadasDia6){
                    if($call -lt $promedioDiario){
                        $numeroTotalDeLlamadas+=1
                    }
                }
                Write-Host "En el dia " $day " se hicieron " $numeroTotalDeLlamadas " llamadas que no superan el promedio diario"
            }
            if($diaEnElQueEstoyActualmente -eq 7){
                $promedioDiario=$DuracionXDia[$day]/$LlamadasPorDia[$day]
                foreach($call in $DuracionLlamadasDia7){
                    if($call -lt $promedioDiario){
                        $numeroTotalDeLlamadas+=1
                    }
                }
                Write-Host "En el dia " $day " se hicieron " $numeroTotalDeLlamadas " llamadas que no superan el promedio diario"
            }
            $diaEnElQueEstoyActualmente+=1
        }

        $diasEnQueSeHicieronLlamadas=0
        foreach($users in $Usuarios){
            $linea=$LlamadasHechasPorUsuario[$users]
            $nuevaLinea= $linea -replace ".$"
            $LlamadasHechasPorUsuario[$users]= $nuevaLinea
        }

        $mediaSemanal=0
        foreach($dia in $Dias){
            $promedioDiario= $DuracionXDia[$dia]/$LlamadasPorDia[$dia]
            $mediaSemanal+=$promedioDiario
            $diasEnQueSeHicieronLlamadas+=1
        }

        $mediaSemanal/=$diasEnQueSeHicieronLlamadas

        foreach($user in $Usuarios){
            $llamadasAProcesar = $LlamadasHechasPorUsuario[$user].Split(',')
            for($i=0; $i -lt $llamadasAProcesar.Length ; $i++){
                $durLlamada = $llamadasAProcesar[$i] -as [Int]
                if($durLlamada -lt $mediaSemanal){
                    $CantidadLlamadasQueNoSuperanLaMediaSemanal[$user]+=1
                }
            }
        }

        $mayor=0
        $usuarioMayor=""
        foreach($user in $Usuarios){
            if($CantidadLlamadasQueNoSuperanLaMediaSemanal[$user] -gt $mayor){
                $mayor=$CantidadLlamadasQueNoSuperanLaMediaSemanal[$user]
                $usuarioMayor=$user
            }
        }

        Write-Host 
        Write-Host "El usuario que más llamadas hizo debajo de la media semanal es: " $usuarioMayor
        Write-Host

        Write-Host "[*****************************************************************************************************************]"

        Remove-Variable hour
        Remove-Variable minute
        Remove-Variable second
        Remove-Variable duracion
        Remove-Variable dia
        Remove-Variable hora
        Remove-Variable usuario
        Remove-Variable usuarioAgregado
        Remove-Variable llamadaIniciada
        Remove-Variable mayor
        Remove-Variable usuar
        Remove-Variable inicio
        Remove-Variable final
        Remove-Variable empieza
        Remove-Variable termina
        Remove-Variable DuracionXDia
        Remove-Variable Usuarios
        Remove-Variable LlamadasPorDia
        Remove-Variable masLlamadasPorSemana
        Remove-Variable procesados
        Remove-Variable archivo
        Remove-Variable diaActual
        Remove-Variable DuracionUsuarioPorDia1
        Remove-Variable DuracionUsuarioPorDia2
        Remove-Variable DuracionUsuarioPorDia3
        Remove-Variable DuracionUsuarioPorDia4
        Remove-Variable DuracionUsuarioPorDia5
        Remove-Variable DuracionUsuarioPorDia6
        Remove-Variable DuracionUsuarioPorDia7
        Remove-Variable LlamadasUsuarioPorDia1
        Remove-Variable LlamadasUsuarioPorDia2
        Remove-Variable LlamadasUsuarioPorDia3
        Remove-Variable LlamadasUsuarioPorDia4
        Remove-Variable LlamadasUsuarioPorDia5
        Remove-Variable LlamadasUsuarioPorDia6
        Remove-Variable LlamadasUsuarioPorDia7
        Remove-Variable users
        Remove-Variable diAct
        Remove-Variable DuracionLlamadasDia1
        Remove-Variable DuracionLlamadasDia2
        Remove-Variable DuracionLlamadasDia3
        Remove-Variable DuracionLlamadasDia4
        Remove-Variable DuracionLlamadasDia5
        Remove-Variable DuracionLlamadasDia6
        Remove-Variable DuracionLlamadasDia7
        Remove-Variable diaEnElQueEstoyActualmente
        Remove-Variable numeroTotalDeLlamadas
        Remove-Variable LlamadasHechasPorUsuario
        Remove-Variable duracionParcial
        Remove-Variable diasEnQueSeHicieronLlamadas
        Remove-Variable mediaSemanal
        Remove-Variable llamadasAProcesar

    }
}