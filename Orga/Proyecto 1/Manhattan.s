# Manhattan.s: Programa que realiza la tarea del proyecto con los datos 
#              ya en memoria
# Autor:Luiscarlo Rivera
#
#Planificacion de Registros:
#
#$t3 numero de iteraciones para reducir los clusters
#$t4 contador del ciclo para reducir clusters
#$t7 contador para ciclo 1 de buscarminimo en la matriz
#$t8 contador para ciclo 2 de buscarminimo en la matriz
#$t9 maximo numero de iteraciones para el ciclo 2 de buscar minimo

.data 

n:        .word 7
m:        .word 2
k:        .word 4
matriz:   .word 0, 391, 50, 171, 27, 48, 229, 0, 0, 365, 220, 374, 359, 162, 0, 0, 0, 195, 77, 98, 233, 0, 0, 0, 0, 154, 139, 58, 0, 0, 0, 0, 0, 21, 212, 0, 0, 0, 0, 0, 0, 197, 0, 0, 0, 0, 0, 0, 0
datos:    .word 12, 281, 150, 28, 50, 293, 25, 123, 7, 259, 4, 241, 45, 75
maxint:   .word 2147483647
imin:        .word 0
jmin:        .word 0

.text

main:
        lw $t0 n                #cargo n en $t0
        lw $t1 k                #cargo k en $t2
        
        sub $t3,$t0,$t1         #numero de iteraciones = n-k
        li $t4,0                #contador=0 ciclo reduccion de clusters
loopred:                        #inicio ciclo de reduccion de clusters
        lw $t5, maxint          #asigno al minimo el maximo entero representable
        
        la $t6, matriz          #cargo la direccion de inicio de la matriz
        
                                #comienzo de buscarminimo en la matriz
        li $t7, 0               #contador en 0 (i)
mini1:
        addi $t8, $t7, 1        #inicio contador ciclo anidado (j)
        move $t9, $t0           #guardo n en $t9
        subu $t9, $t9, 1        #resto 1 a n para que no itere en la ultima fila
mini2:
        
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
        blt $t8, $t0, mini2     #condicion ciclo anidado(j)
        
        addi $t7, $t7, 1        #i=i+1        
        blt $t7, $t9, mini1     #condicion ciclo de buscarminimo(i)
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
                            
                            
        lw $t7, m
        li $t8, 0
cntrd:  
        lw $t5, 0($t1)          #cargo el primer parametro de la fila "imin"
        lw $t6, 0($t2)          #cargo el primer parametro de la fila "jmin"
        add $t5, $t5, $t6       #sumo los parametros
        li $t6, 2               #cargo 2 en $t6
        div $t5, $t6            #divido la suma de parametros entre 2
        mflo $t5                #muevo el cociente de la division a t5
        
        sw $t5, 0($t1)          #guardo en la direccion "imin" el centroide
        
        addi $t1, $t1, 4        #desplazo una palabra
        addi $t2, $t2, 4        #desplazo una palabra
        
        addi $t8, $t8, 1
        blt $t8, $t7, cntrd
                                #fin calcular nuevos centroides
        
        addi $t4, $t4, 1
        blt $t4, $t3, loopred
                                #Fin Ciclo de reduccion de clusters
        move $a0, $t5
        li $v0, 1
        syscall
        

fin:    li $v0, 10              #Finalizo el programa
        syscall