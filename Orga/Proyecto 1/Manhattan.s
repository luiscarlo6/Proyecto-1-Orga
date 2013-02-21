# Manhattan.s: Programa que realiza la tarea del proyecto con los datos 
#              ya en memoria
# Autor:Luiscarlo Rivera
#
#Planificacion de Registros:
#
#$t3 numero de iteraciones para reducir los clusters
#$t4 contador del ciclo para reducir clusters

.data 

n:        .word 7
m:        .word 2
k:        .word 5
matriz:   .word 0, 391, 50, 171, 27, 48, 229, 0, 0, 365, 220, 374, 359, 162, 0, 0, 0, 195, 77, 98, 233, 0, 0, 0, 0, 154, 139, 58, 0, 0, 0, 0, 0, 21, 212, 0, 0, 0, 0, 0, 0, 197, 0, 0, 0, 0, 0, 0, 0
datos:    .word 12, 281, 150, 28, 50, 293, 25, 123, 7, 259, 4, 241, 35, 75
imin:     .word 0
jmin:     .word 0
maxint:   .word 2147483647
linea:    .asciiz "\n"
espacio:  .asciiz "    "

.text

main:
        lw $t0 n                #cargo n en $t0
        lw $t1 k                #cargo k en $t2
        
        sub $s0,$t0,$t1         #numero de iteraciones = n-k
        move $s1, $zero         #contador=0 ciclo reduccion de clusters
loopred:                        #inicio ciclo de reduccion de clusters
        lw $t5, maxint          #asigno el maximo entero representable
        la $t6, matriz          #cargo la direccion de inicio de la matriz
        
        li $t7, 0               #contador en 0 (i=0)
        lw $t9, n               #guardo n en $t9
        lw $t0, n               #cargo n en $t0
        subu $t9, $t9, 1        #resto 1 a n para que no itere en la ultima fila
matmin1:                        #comienzo ciclo de buscarminimo en la matriz
        addi $t8, $t7, 1        #inicio contador ciclo anidado (j=i+1)
        
matmin2:
        mul $t1, $t0, $t7       #NumCol*i en $t1
        mul $t1, $t1, 4         #(NumCol*i)*4 en $t1        
        la $t2, matriz          #guardo la direccion de la matriz en $t2        
        add $t1, $t1, $t2       #(NumCol*i)*4 + matriz en $t1        
        mul $t2, $t8, 4         #j*4 en $t2        
        add $t1, $t1, $t2       #(NumCol*i)*4 + matriz + j*4 en $t1
                                #esta es la direccion de matriz[i][j]
        
        lw $t2, 0($t1)          #guardo matriz[i][j] en $t2
        
        bgt $t2, $t5, sumaj     #si matriz[i][j]>minimo salta al contador
        move $t5, $t2           #si no, guardo matriz[i][j] en $t5
        sw $t7, imin            #guardo i actual en imin
        sw $t8, jmin            #guardo j actual en jmin
        
sumaj:  addi $t8, $t8, 1        #j=j+1
        blt $t8, $t0, matmin2   #condicion ciclo anidado(j<n)
        
        addi $t7, $t7, 1        #i=i+1
        blt $t7, $t9, matmin1   #condicion ciclo de buscarminimo(i<n-k)
                                #fin buscarminimo en la matriz
                            
        lw $t0, imin            #cargo el imin, que es la pos de uno de los
                                #clusters a unir en la matriz de datos
        mul $t0, $t0, 4         #multiplico imin por 4 (mover una palabra)
        lw $t1, m               #cargo m en $t1
        mul $t0, $t0, $t1       #multiplico (imin*4) por m para desplazarme
                                #una fila
        la $t1, datos($t0)      #sumo la direccion de datos con $t0, obtengo
                                #la direccion de la fila "imin"
                                
        lw $t0, jmin            #repito el mismo proceso para obtener la
        mul $t0, $t0, 4         #direccion de la fila "jmin"
        lw $t2, m
        mul $t0, $t0, $t2
        la $t2, datos($t0)
                            
                            
        lw $t7, m               #cargo m en $t7
        li $t8, 0               #inicializo contador (i=0)
cntrd:  
        lw $t5, 0($t1)          #cargo el parametro de la fila "imin"
        lw $t6, 0($t2)          #cargo el parametro de la fila "jmin"
        add $t5, $t5, $t6       #sumo los parametros
        li $t6, 2               #cargo 2 en $t6
        div $t5, $t6            #divido la suma de parametros entre 2
        mflo $t5                #muevo el cociente de la division a t5
        
        sw $t5, 0($t1)          #guardo en la direccion "imin" el centroide
        
        addi $t1, $t1, 4        #desplazo una palabra
        addi $t2, $t2, 4        #desplazo una palabra
        
        addi $t8, $t8, 1        #contador (i=i+1)
        blt $t8, $t7, cntrd     #si i<m
                                #fin calcular nuevos centroides

                                #inicio reduccion  matriz de datos
        
        

        lw $t7, jmin            #cargo la pos de la columna no necsaria de la matriz de datos
        addi $t7, $t7, 1        #sumo 1 para comenzar desde el siguiente
        lw $t8, n               #cargo n para que las iteraciones sean n-jmin
redatos:
        move $t0, $t7           #busco direccion en datos del cluster jmin+1
        mul $t0, $t0, 4         
        lw $t1, m
        mul $t0, $t0, $t1
        la $t1, datos($t0)
        
        move $t0, $t7           #busco direccion en datos del cluster jmin
        subu $t0, $t0, 1
        mul $t0, $t0, 4         
        lw $t2, m
        mul $t0, $t0, $t2
        la $t2, datos($t0)
        
        lw $t3, m
        li $t4, 0               #contador h = 0
movdato:
        lw $t6, 0($t1)          #cargo el parametro h de la fila "jmin+1"
        
        sw $t6, 0($t2)          #guardo ese parametro en jmin
        
        
        addi $t1, $t1, 4        #desplazo una palabra
        addi $t2, $t2, 4        #desplazo una palabra

        addi, $t4, $t4, 1       #+1 al iterador
        blt $t4, $t3, movdato   #salto al comienzo del ciclo movdato
        
        addi, $t7, $t7, 1       #+1 al iterador
        blt $t7, $t8, redatos   #salto al comienzo del ciclo redatos
        
        lw $t0, n               #cargo n
        subu $t0, $t0, 1        #reduzco n en 1
        sw $t0, n               #escribo el nuevo numero de clusters en n
        
        lw $s2, m
        lw $s3, n
        subu $t7, $s3, 1        #resto 1 a n para que no itere en la ultima fila
        li $t8, 0               #contador = 0
recmat1:
        addi $t9, $t8, 1
recmat2:

        move $t0, $t8           #busco direccion en datos del cluster i
        mul $t0, $t0, 4         
        lw $t1, m
        mul $t0, $t0, $t1
        la $t1, datos($t0)
        
        move $t0, $t9           #busco direccion en datos del cluster j
        mul $t0, $t0, 4         
        lw $t2, m
        mul $t0, $t0, $t2
        la $t2, datos($t0)


        li $t6, 0               #contador = 0
        li $t5, 0               #nueva distancia se guardara en $t5
calcdis:
        
        lw $t3, 0($t1)          #cargo el parametro de la fila "i"
        lw $t4, 0($t2)          #cargo el parametro de la fila "j"
        
        sub $t3, $t3, $t4       #resto los parametros
        
        bgez $t3, noneg         #si no es negativa la resta salta a noneg
        mul $t3, $t3, -1        #si es negativa la resta multiplica por -1
        
noneg:  add $t5, $t5, $t3       #sumo a la nueva distancia lo que llevo
        
        addi $t1, $t1, 4        #incremento una palabra
        addi $t2, $t2, 4        #incremento una palabra
        addi $t6, $t6, 1        #incremento contador
        blt $t6, $s2, calcdis   #si contador<m
        
        
        
        mul $t1, $s3, $t8       #NumCol*i en $t1
        mul $t1, $t1, 4         #(NumCol*i)*4 en $t1
        
        la $t2, matriz          #guardo la direccion de la matriz en $t2
        
        add $t1, $t1, $t2       #(NumCol*i)*4 + matriz en $t1
        
        mul $t2, $t9, 4         #j*4 en $t2
        
        add $t1, $t1, $t2       #(NumCol*i)*4 + matriz + j*4 en $t1
                                #esta es la direccion de matriz[i][j]
        
        
        sw $t5, 0($t1)          #guardo en matriz[i][j] la nueva distancia
        
        addi $t9, $t9, 1        #contador+1
        blt $t9, $s3, recmat2
        
        addi $t8, $t8, 1
        blt $t8, $t7, recmat1   #contador+1
        
        addi $s1, $s1, 1
        blt $s1, $s0, loopred   #contador+1
                                #Fin Ciclo de reduccion de clusters
        
                                #salida de datos
    
        li $s0, 0               #contador 0 para salida de datos
        lw $s1, n
salida:
        
        move $t0, $s0           #cargo el contador
        mul $t0, $t0, 4         #lo multiplico por la longitud de una palabra
        lw $t1, m               #cargo m en $t1
        mul $t0, $t0, $t1       #multiplico (i*4)*m para desplazarme
                                #una fila
        la $t1, datos($t0)      #sumo la direccion de datos con $t0, obtengo
                                #la direccion de la fila "i"
        li $s2, 0
        lw $s3, m
params:                         #itero sobre la direccion de la fila como arreglo
        lw $t2, 0($t1)          #contenido de la pos j de la fila
        
        move $a0, $t2           #imprime la pos j
        li $v0, 1
        syscall
        
        la $a0, espacio         #espacio en blanco
        li $v0, 4
        syscall
        
        addi $t1, $t1, 4        #me desplazo una palabra
        
        addi $s2, $s2, 1
        blt $s2, $s3, params
        
        la $a0, linea           #salto de linea
        li $v0, 4
        syscall
        
        addi $s0, $s0, 1
        blt $s0, $s1, salida

fin:    li $v0, 10              #Finalizo el programa
        syscall