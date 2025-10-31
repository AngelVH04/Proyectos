
;---------------------------------Inicio de macros-----------------------------------------------

limpant    macro                  ;Inicia macro para limpiar pantalla
           mov ah,0fh             ;Funcion 0F (lee modo de video)
           int 10h                ;de la INT 10H a AH.
           mov ah,0h              ;Funcion 0 (selecciona modo de video) de la INT 10H a AH
           int 10h                ;las 4 instrucciones limpian la pantalla.
           endm                   ;Termina macro para limpiar pantalla
 
imprimir   macro mensaje          ;Inicia macro instruccion para imprimir 
                                  ;cadena de caracteres en pantalla
           mov dx,offset mensaje  ;asigna el OFFSET mesnaje a DX (DS:DX)
           mov ah,09h             ;Funcion 09 (mensaje en pantalla) de la INT 21H a AH
           int 21h                ;muestra mensaje en pantalla
           endm                   ;Termina macro para cadena de caracteres en pantalla

Sico       macro                  ;Inicia macro para guardar caracter con eco
	       mov AH,01H             ;Funcion 01 (lee el teclado con eco) de la INT 21H a AH	
	       int 21H                ;guarda caracter ascii leido desde el teclado mostrando eco
           endm                   ;Termina macro para guardar caracter con eco

Noco       macro                  ;Inicia macro para guardar caracter sin eco
	       mov	AH,07H	          ;Funcion 07 (lee el teclado sin eco) de la INT 21H a AH	
	       int	21h               ;guarda caracter ascii leido desde el teclado sin mostrar eco
           endm                   ;Termina macro para guardar caracter sin eco

ImpCaract  macro                  ;Inicia macro para imprimir un solo caracter en pantalla
	       mov AH,02H             ;Funcion 02 (desplegar dato en pantalla) de la INT 21H a AH
  	       int 21H                ;de la INT 21H a AH
           endm                   ;Termina macro para imprimir un solo caracter en pantalla


MenuReg    macro                  ;Inicia macro para regresar al menu principal       
           CMP AL, 1h             ;Compara si lo que esta en AL es igual a 1h (opcion 1 regresar al menu)
           JE  callmenu           ;Si es igual, salta a la etiqueta callmenu
           CMP AL, 2h             ;Compara si lo que esta en AL es igual a 2h (opcion 2 NO regresar al menu)
           JE  FIN                ;Si es igual, salta a la etiqueta FIN y sale del programa
           endm                   ;Termina macro para regresar al menu principal 


;-------------------------Macros de la multiplicacion-------------------------------------------------
pedirM macro                      ;Macro para solicitar dos numeros y enmascararlos
            imprimir Numero1      ;Imprime mensaje para ingresar el primer numero 
            piddatoAM             ;Macro para guardar el primer numero ingresado

            imprimir Numero2      ;Imprime mensaje para ingresar el segundo numero 
            piddatoBM             ;Macro para guardar el segundo numero ingresado 
            
            enmascm               ;Macro para enmascarar A y B
endm                              ;Fin del macro

scand       MACRO                 ;inicia macro scand (escanea el dato)      
            mov AH, 01            ;con la funcion 01 de la INT 21h 
            int 21h               ;espera a que se pulse una tecla y la escribe en la pantalla
endm                              ;Fin de macro

piddatoAM    MACRO                ;Macro ingresa dato A de la multiplicacion 
    
            rR                    ;Macro que Restituye registros
            rV                    ;Macro que Restituye variables  
            
enteroAM:                         ;Inicia enteroAM
            scand                 ;llama la macro scand
            cmp AL, 2Eh           ;Compara AL con 2EH(punto decimal)            
            je  decimal1AM        ;Si hay punto, salta a decimal1AM 
            
            cmp AL, 2Dh           ;Compara AL con 2DH (signo negativo)
            je  sigAM             ;Si hay signo, salta a sigAM
            
            cmp AL, 0Dh           ;Compara AL con 0DH (si hay Enter)
            je  unidAM            ;Si es igual o hay Enter, salta a unidAM
            
            push AX               ;Mete el valor a la pila
            
            inc CX                ;Incrementa (CX+1)
            
            jmp enteroAM          ;Salta a enteroAM
            
decimal1AM:                       ;Inicia decimal1AM
            scand                 ;Macro scand
            
            cmp AL, 0Dh           ;Compara AL con 0DH (si hay Enter)
            je  unidAM            ;Si es igual o hay Enter, salta a unidAM
                       
            cmp DL, 01            ;Verifica contador
            je  decimal2AM        ;Si DL = 01, salta a decimal2AM
            
            mov bajo1A, AL        ;AL --> bajo1A
            inc DL                ;Incrementa contador DL            
            jmp decimal1AM        ;Salta a decimal1AM

decimal2AM:                       ;Inicia decimal12AM
            
            mov bajo2A, AL        ;AL --> bajo2A
            jmp unidAM            ;Salta a unidAM

sigAM:                            ;Inicia sigAM
            inc signoA            ;signoAM a 1 para determinar el valor como negativo
            jmp enteroAM          ;Salta a enteroAM
            

unidAM:                           ;Inicia unidAM
            cmp CX, 0             ;Verifica CX
            je  pfinAM            ;Si CX = 0, salta a pfinAM
            
            pop DX                ;Valor en pila a DX
            mov alto2A, DL        ;DL --> alto2A
            
            dec CX                ;decrementa (CX-1)
            
            cmp CX, 0             ;Verifica CX
            je  pfinAM            ;Si CX = 0, salta a pfinAM
            
            pop DX                ;Valor en pila a DX
            mov alto1A, DL        ;DL --> alto1A
            
pfinAM:                           ;Inicia pfinAM
            rR                    ;Restituye registros
endm                              ;Fin macro PedirM



piddatoBM    MACRO                ;Macro para dato BM 
            rR                    ;Restituye registros
            
enteroBM:                         ;Inicia enteroBM
            scand                 ;Macro scand
            cmp AL, 2Eh           ;Compara AL con 2EH(punto decimal)            
            je  decimal1BM        ;Si hay punto, salta a decimal1BM 
            
            cmp AL, 2Dh           ;Compara AL con 2DH (signo negativo)
            je  sigBM             ;Si hay signo, salta a sigBM
            cmp AL, 0Dh           ;Compara AL con 2DH (si hay Enter)
            je  unidBM            ;Si es igual o hay Enter, salta a unidBM
            
            push AX               ;Mete el valor a la pila
            
            inc CX                ;Incrementa contador CX
            
            jmp enteroBM          ;Salta a enteroBM
            
decimal1BM:                       ;Inicia decimal1BM
            scand                 ;Macro scand
            
            cmp AL, 0Dh           ;Compara si hay Enter
            je  unidBM            ;Si hay Enter, salta a unidBM
            
            cmp DL, 01            ;Verifica contador
            je  decimal2BM        ;Si DL = 01, salta a decimal2BM
            
            mov bajo1B, AL        ;AL --> bajo1B
            inc DL                ;Incrementa contador DL            
            jmp decimal1BM        ;Salta a decimal1BM

decimal2BM:                       ;Inicia decimal2BM
            mov bajo2B, AL        ;AL --> bajo2B
            jmp unidBM            ;Salta a unidBM

sigBM:                            ;Inicia sigBM
            inc signoB            ;SignoB a 1 para determinar el valor como negativo
            jmp enteroBM          ;Salta a enteroBM
            
unidBM:                           ;Inicia unidBM
            cmp CX, 0             ;Verifica CX
            je  pfinBM            ;Si CX = 0, salta a pfinBM
            
            pop DX                ;Valor en pila a DX
            mov alto2B, DL        ;DL --> alto2B
            
            dec CX                ;decrementa contador CX
            
            cmp CX, 0             ;Verifica CX
            je  pfinBM            ;Si CX = 0, salta a pfinBM
            
            pop DX                ;Valor en pila a DX
            mov alto1B, DL        ;DL --> alto1B
            
pfinBM:                           ;Inicia pfinBM
            rR                    ;Restituye registros
endm                              ;Fin de macro piddatoBM 

;--------------------------------Fin macros de pedir multiplicacion------------------------------


enmascm     MACRO                 ;Macro para ajuste ASCII
                                  ;
                                  ;   X X X X X X X X
                                  ;   0 0 1 1 0 0 0 0
                                  ;  -----------------      
            or alto1A, 30h        ;operacion or Alto1A con 0 y lo pasa a ascii 
            or alto2A, 30h        ;operacion or Alto2A con 0 y lo pasa a ascii 
            or bajo1A, 30h        ;operacion or Bajo1A con 0 y lo pasa a ascii 
            or bajo2A, 30h        ;operacion or Bajo2A con 0 y lo pasa a ascii 
            
            or alto1B, 30h        ;operacion or Alto1B con 0 y lo pasa a ascii 
            or alto2B, 30h        ;operacion or Alto2B con 0 y lo pasa a ascii 
            or bajo1B, 30h        ;operacion or Bajo1B con 0 y lo pasa a ascii 
            or bajo2B, 30h        ;operacion or Bajo2B con 0 y lo pasa a ascii 
ENDM                              ;Fin macro 


multiplicar MACRO MNA,MNB         ;Macro instruccion para mutiplicar
                                        
            mov ah,00             ;Restituye AH
            mov Al, MNA           ;Asigna MNA a AL
            sub AL, 30h           ;Rsta 30h a AL 
            mov CH, MNB           ;Asigna MNB en CH
            sub CH, 30h           ;Resta 30h a CH
            mul CH                ;Multiplica (CH x AL)
            aam                   ;Desempaca/Ajusta
            mov acarreo,ah        ;Guarda acarreo                                        
ENDM                              ;Fin macro

ajustemul   MACRO  V1, V2         ;Macro instruccion para acarreo 
            
            add al, V1            ;V1 + AL (v1 = resultado mul)
            add V2,ah             ;V2 + AH (v2 = resultado sigmul)
            mov ah, 00            ;Restituye AH
            aam                   ;Desempaca/Ajusta
            mov V1, al            ;Al --> V1
            add V2, ah            ;AH --> V2
ENDM                              ;Fin de macro

sumamulc    MACRO SMCA,SMCB       ;Macro instruccion para sumar resultados
    
            mov ah,0              ;Restituye AH
            mov al,SMCA           ;Asigna SMCA a AL
            add al,SMCB           ;SMCB + SMCA
            aam                   ;Desempaca/Ajusta, resultado
            mov dl,ah             ;Asigna AH a DL
            mov ah, 00            ;Restituye AH            
ENDM                              ;Fin de la macro



rR       MACRO                    ;Macro que restituye AX, BX, CX y DX
	        sub AX, AX            ;Restituye AX
	        sub BX, BX            ;Restituye BX
            sub CX, CX            ;Restituye CX
            sub DX, DX            ;Restituye DX
endm                              ;Fin de macro

rV       MACRO                    ;Macro que restituye todas las variables 
                                        
                                  ;Variables de A
            mov alto1A, 0         ;Restituye alto1A
            mov alto2A, 0         ;Restituye alto2A
            mov bajo1A, 0         ;Restituye bajo1A
            mov bajo2A, 0         ;Restituye bajo2A
            mov signoA, 0         ;restituye signoA 
            
                                  ;Variables de B
            mov alto1B, 0         ;Restituye alto1B
            mov alto2B, 0         ;Restituye alto2B
            mov bajo1B, 0         ;Restituye bajo1B
            mov bajo2B, 0         ;Restituye bajo2B
            mov signoB, 0         ;Restituye signoB
            mov acarreo,0         ;Restituye acarreo 
            
             
            mov a,0               ; Restituye a 0
            mov b,0               ; Restituye a 0
            mov c,0               ; Restituye a 0
            mov d,0               ; Restituye a 0
            mov e,0               ; Restituye a 0
            mov f,0               ; Restituye a 0
            mov g,0               ; Restituye a 0
            mov h,0               ; Restituye a 0
            mov i,0               ; Restituye a 0
            mov j,0               ; Restituye a 0
            mov k,0               ; Restituye a 0
            mov l,0               ; Restituye a 0
            mov m,0               ; Restituye a 0
            mov n,0               ; Restituye a 0
            mov o,0               ; Restituye a 0
            mov p,0               ; Restituye a 0
            mov q,0               ; Restituye a 0
            mov r,0               ; Restituye a 0
            mov s,0               ; Restituye a 0
            mov t,0               ; Restituye a 0
            mov auxiliar,0        ; Restituye a 0  
                       
endm                              ;Fin de macro

 
;------------------------------FIN DE LAS MACROS DE MULT 'PEDIR DATOS'---------------------------------------------
;---------------------------------Fin de todas las macros---------------------------------------------------       

       .MODEL SMALL               ;Define modelo de memoria 
       
       .STACK                     ;Define area de pila
       
       .DATA                      ;Define area de datos
                  

MPrinc   DB 09, 'MENU', 13, 10, 'Calculadora de: +,-,*,/', 13, 10,;Se define la variable Mprinc con el texto del menu principal
         DB 13, 10, '1) Suma', 13, 10,                            ;Continua el mensaje con salto (13) y retorno de carro (10)
         DB '2) Resta', 13, 10,                                   ;Continua el mensaje con salto (13) y retorno de carro (10)
         DB '3) Multiplicacion', 13, 10,                          ;Continua el mensaje con salto (13) y retorno de carro (10)
         DB '4) Division',13,10,                                  ;Continua el mensaje con salto (13) y retorno de carro (10)
         DB 13, 10, 168, 'Que operacion desea hacer?: $'          ;Continua el mensaje con signo de interrogacion (168) y fin de cadena ('$')

Numero1  DB 13, 10,10, 'Ingrese el primer numero: $', 13, 10      ;Se define la variable "Numero1" con el mensaje para ingresar el primer numero

Numero2  DB 13, 10, 'Ingrese el segundo numero: $', 13, 10        ;Se define la variable "Numero2" con el mensaje para ingresar el segundo numero

Res      DB 13,10, 10, 'Resultado = $', 13, 10                    ;Se define la variable "Res" con el mensaje para mostrar el resultado

Regreso  DB 13,10,10, 168, 'Desea continuar?', 13, 10             ;Se define la variable "Regreso" con el mensaje para preguntar si desea continuar
         DB 13, 10, '1.Si  2.No :$', 13, 10                       ;Continua el mensaje con opciones para continuar o no

Sum4     DB '1. Suma $', 13, 10                                   ;Se define la variable "Sum4" con el mensaje para la opcion de suma

Rest4    DB '2. Resta $', 13, 10                                  ;Se define la variable "Rest4" con el mensaje para la opcion de resta

Multi    DB '3. Multiplicacion $', 13, 10                         ;Se define la variable "Multi" con el mensaje para la opcion de multiplicacion

Divis    DB '4. Division$',13,10                                  ;Se define la variable "Divis" con el mensaje para la opcion de division

indeter  DB 'ERROR. DIVISION NO VALIDA$'                          ;Se define la variable "indeter" con el mensaje de error para division no valida

nega     DB '-$'                                                  ;Se define la variable "nega" (Representacion de negativo)
punt     DB '.$'                                                  ;Se define la variable "punt" (Representacion del punto)
 
;-----------------------------------------Variables-----------------------------------------------

                                                          
V1         dw 0                      ;Se define la variable "V1"
V2         dw 0                      ;Se define la variable "V2"
diezveces  dw 10                     ;Se define la variable "diezveces" inicializado en 10

alto1A      db 00                    ;Variable "alto1A"incializado en 00 (Decenas de A)
alto2A      db 00                    ;Variable "alto2A"incializado en 00 (Unidades de A)
bajo1A      db 00                    ;Variable "bajo1A"incializado en 00 (Decimas de A) 
bajo2A      db 00                    ;Variable "bajo2A"incializado en 00 (Centesimas de A)
signoA      db 00                    ;Variable "signoA"incializado en 00 (Signo para A) 
              
                                     ;Variables para numero B                                        
alto1B      db 00                    ;Variable "alto1B"incializado en 00 (Decenas de B)
alto2B      db 00                    ;Variable "alto2B"incializado en 00 (Unidades de B)
bajo1B      db 00                    ;Variable "bajo1B"incializado en 00 (Decimas de B) 
bajo2B      db 00                    ;Variable "bajo2B"incializado en 00 (Centesimas de B)
signoB      db 00                    ;Variable "signoB"incializado en 00 (Signo para B) 

acarreo     db 00                    ;Variable para acarreo incializado en 00

a           db 00                    ;Variable "a" inicializado en 00 nos ayudan para la suma de la multiplicacion  
b           db 00                    ;Variable "b" inicializado en 00 nos ayudan para la suma de la multiplicacion
c           db 00                    ;Variable "c" inicializado en 00 nos ayudan para la suma de la multiplicacion 
d           db 00                    ;Variable "d" inicializado en 00 nos ayudan para la suma de la multiplicacion 
e           db 00                    ;Variable "e" inicializado en 00 nos ayudan para la suma de la multiplicacion 
f           db 00                    ;Variable "f" inicializado en 00 nos ayudan para la suma de la multiplicacion 
g           db 00                    ;Variable "g" inicializado en 00 nos ayudan para la suma de la multiplicacion 
h           db 00                    ;Variable "h" inicializado en 00 nos ayudan para la suma de la multiplicacion 
i           db 00                    ;Variable "i" inicializado en 00 nos ayudan para la suma de la multiplicacion 
j           db 00                    ;Variable "j" inicializado en 00 nos ayudan para la suma de la multiplicacion 
k           db 00                    ;Variable "k" inicializado en 00 nos ayudan para la suma de la multiplicacion 
l           db 00                    ;Variable "l" inicializado en 00 nos ayudan para la suma de la multiplicacion 
m           db 00                    ;Variable "m" inicializado en 00 nos ayudan para la suma de la multiplicacion 
n           db 00                    ;Variable "n" inicializado en 00 nos ayudan para la suma de la multiplicacion 
o           db 00                    ;Variable "o" inicializado en 00 nos ayudan para la suma de la multiplicacion 
p           db 00                    ;Variable "p" inicializado en 00 nos ayudan para la suma de la multiplicacion 
q           db 00                    ;Variable "q" inicializado en 00 nos ayudan para la suma de la multiplicacion 
r           db 00                    ;Variable "r" inicializado en 00 nos ayudan para la suma de la multiplicacion 
s           db 00                    ;Variable "s" inicializado en 00 nos ayudan para la suma de la multiplicacion 
t           db 00                    ;Variable "t" inicializado en 00 nos ayudan para la suma de la multiplicacion 
auxiliar    db 00                    ;Variable "auxiliar" inicializado en 00 nos ayudan para la suma de la multiplicacion 


       .CODE                         ;Define area de codigo
     
;--------------------------------Direccionamiento de datos----------------------------------------                 

begin   proc far                     ;Inicio del procedimiento "begin"
        MOV AX,@DATA                 ;Asigna la direccion de datos a AX
        MOV DS,AX                    ;Asigna Ax a DS

;-------------------------------------Menu-------------------------------------------------------

callmenu:                            ;Etiqueta "callmenu" 
        limpant                      ;Macro limpia pantalla
        call MostMen                 ;Llama al proceso "MostMenu"
        Sico                        ;Invoca al macro "Sico"
        
opcion1:                             ;Etiqueta "opcion1"
        cmp AL, '1'                  ;Compara AL con '1'
        jne opcion2                  ;Si no es igual, salta a la etiqueta "opcion2" 
        limpant                      ;Macro limpia pantalla
        call SumProc                 ;Si es igual, llama al proceso "SumProc"
        jmp callmenu                 ;Salta a la etiqueta "callmenu" si no es igual 
                                     ;a '1', '2', '3', '4' 

opcion2:                             ;Etiqueta "opcion2"      
        cmp AL, '2'                  ;Compara AL con '2'
        jne opcion3                  ;Si no es igual, salta a la etiqueta "opcion3"
        limpant                      ;Macro limpia pantalla
        call RestProc                ;Si es igual, llama al proceso "RestProc"
        jmp callmenu                 ;Salta a la etiqueta "callmenu" si no es igual
                                     ;a '1', '2', '3','4'
        
opcion3:                             ;Etiqueta "opcion3"
        cmp AL, '3'                  ;Compara AL con '3'
        jne opcion4                  ;Salta a la etiqueta "callmenu" si no es igual
                                     ;a '1', '2', '3','4'        
        limpant                      ;Macro limpia pantalla
        call MULT                    ;Si es igual, llama al proceso "MULT"
        
opcion4:                             ;Etiqueta "opcion4"
        cmp AL, '4'                  ;Compara AL con '4'
        jne callmenu                 ;Si no es igual, salta a la etiqueta "callmenu"
        
        limpant                      ;Macro limpia pantalla
        call DIVI                    ;Si es igual, llama al proceso "DIVI"
                         
begin endp                           ;Termina la ejecucion del programa

   
Regre proc                           ;Inicia el procedimiento "Regre"
         imprimir regreso            ;Invoca al macro "imprimir" y envia 
                                     ;como argumento a "regreso"
         ret                         ;Regresa a la etiqueta que lo llamo
         limpant                     ;Llama al macro "limpant"
         
Regre endp                           ;Fin del procedimiento "Regre"

MostMen proc                         ;Inicia el proceso "MostMen"
        imprimir Mprinc              ;Invoca al macro "imprimir" y envia 
                                     ;como argumento a "Mprinc"	    
        ret                          ;Regresa a la etiqueta que lo llamo
        limpant                      ;Invoca al macro "limpant" (limpia pantalla)
	    
MostMen endp                         ;Termina el proceso "MostMen"

;-----------------------------------------/|Suma|\------------------------------------------------
Suma:                                ;Inicio de la etiqueta "Suma"
 
SumProc proc                         ;Inicio del procedimiento "SumProc"
        limpant                      ;Invoca a la macro "limpia pantalla"
        imprimir Sum4                ;Invoca a la macro "imprimir" y envia como argumento "Sum4"
        call ingreNum                ;llama al proceso "ingreNum"
        
        mov ax,V1                    ;Asigna "V1" a ax
        add ax,V2                    ;Asigna "V2" a ax
        
        push ax                      ;Guarda ax en la pila
        imprimir Res                 ;Llama a la macro "imprimir" y envia como argumento "Res"
        pop ax                       ;Guarda ax en la pila
        call intPCarC                ;llama al proceso "intPCarC" 
        
        imprimir regreso             ;Invoca a la macro "imprimir" y envia como argumento "regreso"
        call DEContinuar             ;llama al proceso "DEContinuar"
        ret                          ;Regresa a la etiqueta que lo llamo
        
Sumproc endp                         ;Termina proceso "Sumproc"

;----------------------------------------./|Resta|\------------------------------------------------
Resta:                               ; Inicio de la etiqueta "Resta"
RestProc proc                        ; Inicia el proceso "RestProc"
    imprimir Rest4                   ; Invoca al macro "imprimir" y envia como argumento a "Rest4"
  
    call ingreNum                    ; Llama al proceso "ingreNum" para ingresar un numero

    mov ax, V1                       ; Asigna el valor de "V1" al registro AX
    
    JNS SinMenos                     ; Si AX no es negativo, salta a la etiqueta "SinMenos"
    neg V2                           ; Si AX es negativo, convierte V2 a su valor negativo
    SinMenos:                        ; Etiqueta para continuar si AX no era negativo
    
    sub ax, V2                       ; Realiza la resta: AX = AX - V2
    
    mov cx, ax                       ; Mueve el resultado de la resta a CX para preservarlo
    
    push ax                          ; Guarda el resultado en la pila para usarlo despues
    imprimir Res                     ; Invoca al macro "imprimir" y envia como argumento a "Res"
   
    pop ax                           ; Recupera el valor original de AX de la pila
    
    call intPCarC                    ; Llama al proceso "intPCarC" para imprimir el caracter resultante
    
    imprimir regreso                 ; Invoca al macro "imprimir" y envia como argumento a "regreso"
    
    call DEContinuar                 ; Llama al proceso "DEContinuar"
    
    ret                              ; Regresa al proceso que lo llamo
RestProc endp                        ; Termina el proceso "RestProc"

;------------------------------------/|Multiplicacion|\--------------------------------------------

MULT proc                            ;Inicio del procedimiento MULT
        limpant                      ;Limpia pantalla
        imprimir Multi               ;Invoca al macro "imprimir" y envia 
                                     ;como argumento a "Multi"          
        
        pedirM                       ;Llama a la macro pedirM y pide los 2 datos
        enmascm                      ;Llama a la macro para ajuste ASCII
        imprimir Res                 ;Invoca al macro "imprimir" y envia 
                                     ;como argumento a "Res"  
        jmp mu                       ;Salta a mu 
                                        
MULT endp                            ;Fin del procedimiento MULT  
 
MAneg:                               ;Inicio de la etiqueta "MAneg"
        
        cmp signoB, 01               ;Verifica si signoB es negativo 
        je  cont                     ;Si lo es, salta a cont  
        
        jmp Mresulneg                ;Si NO es negativo, salta a Mresulneg  
        
Mresulneg:                           ;Inicio de la etiqueta "Mresulneg"

        imprimir nega                ;Invoca al macro "imprimir" y envia 
                                     ;como argumento a "nega"
        jmp cont                     ;Salta a cont   


mu:                                  ;Inicio de la etiqueta "mu"  

        multiplicar bajo2a, bajo2b   ;Multiplica bajo2a por bajo2b
        mov e, al                    ;Mueve el resultado bajo a e
        add d, ah                    ;Suma el resultado alto a d
        				
        multiplicar bajo1a, bajo2b   ;Multiplica bajo1a por bajo2b
        ajustemul d, c               ;Ajusta el resultado y suma a d y c
        
        multiplicar alto2a, bajo2b   ;Multiplica alto2a por bajo2b
        ajustemul c, b               ;Ajusta el resultado y suma a c y b
 					
        multiplicar alto1a, bajo2b   ;Multiplica alto1a por bajo2b
        ajustemul b, a               ;Ajusta el resultado y suma a b y a
					
        multiplicar bajo2a, bajo1b   ;Multiplica bajo2a por bajo1b
        mov j, al                    ;Mueve el resultado bajo a j
        add i, ah                    ;Suma el resultado alto a i
        
        multiplicar bajo1a, bajo1b   ;Multiplica bajo1a por bajo1b
        ajustemul i, h               ;Ajusta el resultado y suma a i y h
					
        multiplicar alto2a, bajo1b   ;Multiplica alto2a por bajo1b
        ajustemul h, g               ;Ajusta el resultado y suma a h y g
					
        multiplicar alto1a, bajo1b   ;Multiplica alto1a por bajo1b
        ajustemul g, f               ;Ajusta el resultado y suma a g y f
					
        multiplicar bajo2a, alto2b   ;Multiplica bajo2a por alto2b
        mov o, al                    ;Mueve el resultado bajo a o
        add n, ah                    ;Suma el resultado alto a n
        
        multiplicar bajo1a, alto2b   ;Multiplica bajo1a por alto2b
        ajustemul n, m               ;Ajusta el resultado y suma a n y m
					
        multiplicar alto2a, alto2b   ;Multiplica alto2a por alto2b
        ajustemul m, l               ;Ajusta el resultado y suma a m y l
					
        multiplicar alto1a, alto2b   ;Multiplica alto1a por alto2b
        ajustemul l, k               ;Ajusta el resultado y suma a l y k
					                          
        multiplicar bajo2a, alto1b   ;Multiplica bajo2a por alto1b
        mov t, al                    ;Mueve el resultado bajo a t
        add s, ah                    ;Suma el resultado alto a s
        
        multiplicar bajo1a, alto1b   ;Multiplica bajo1a por alto1b
        ajustemul s, r               ;Ajusta el resultado y suma a s y r
					              
        multiplicar alto2a, alto1b   ;Multiplica alto2a por alto1b
        ajustemul r, q               ;Ajusta el resultado y suma a r y q
					
        multiplicar alto1a, alto1b   ;Multiplica alto1a por alto1b
        ajustemul q, p               ;Ajusta el resultado y suma a q y p
            				
        mov ah, 00                   ;Limpia ah
        mov Al, E                    ;Mueve E a Al
        push AX                      ;Empuja AX a la pila
            				
        sumamulc D, J                ;Suma con acarreo D y J
        push AX                      ;Empuja AX a la pila
        add c, dl                    ;Suma dl a c
        mov cl, c                    ;Mueve c a cl
        add i, cl                    ;Suma cl a i
        
        sumamulc i, o                ;Suma con acarreo i y o
        push ax                      ;Empuja ax a la pila
        add b, dl                    ;Suma dl a b
        mov cl, b                    ;Mueve b a cl
        add h, cl                    ;Suma cl a h
        mov cl, h                    ;Mueve h a cl
        add n, cl                    ;Suma cl a n
        
        sumamulc n, t                ;Suma con acarreo n y t
        push ax                      ;Empuja ax a la pila
        add a, dl                    ;Suma dl a a
        mov cl, a                    ;Mueve a a cl
        add g, cl                    ;Suma cl a g
        mov cl, g                    ;Mueve g a cl
        add m, cl                    ;Suma cl a m
        
        sumamulc m, s                ;Suma con acarreo m y s
        push ax                      ;Empuja ax a la pila
        add f, dl                    ;Suma dl a f
        mov cl, f                    ;Mueve f a cl
        add l, cl                    ;Suma cl a l
        
        sumamulc l, r                ;Suma con acarreo l y r
        push ax                      ;Empuja ax a la pila
        add k, dl                    ;Suma dl a k
        
        sumamulc k, q                ;Suma con acarreo k y q
        push ax                      ;Empuja ax a la pila
        add p, dl                    ;Suma dl a p
        mov ah, 00                   ;Limpia ah
        mov al, p                    ;Mueve p a al
        push ax                      ;Empuja ax a la pila
        
        pop dx                       ;Saca dx de la pila
        pop dx                       ;Saca dx de la pila
     
        pop dx                       ;Saca el dato de la pila y mueve a dx                             
        mov ax,dx                    ;Mueve dx a ax
        
        cmp dx, 0000                 ;Compara dx con 0000
        je d2                        ;Si es igual,salta a d2
        
        push ax                      ;Si no mete ax a la pila
        
        jmp Cer                      ;Salta a la etiqueta Cer
                
d2:                                  ;Etiqueta d2
        pop dx                       ;Saca el dato de la pila y mueve a dx 
        mov bx,dx                    ;Mueve dx a bx
        cmp dx,0000                  ;Compara dx con 0000
        je d3                        ;Si es igual,salta a d3
        
        push bx                      ;Si no mete bx a la pila
        push ax                      ;Mete ax a la pila
        
        jmp Cer                      ;Salta a la etiqueta Cer
        
d3:                                  ;Etiqueta d3
        pop dx                       ;Saca el dato de la pila y mueve a dx 
        mov cx,dx                    ;Mueve dx a cx
        cmp dx,0000                  ;Compara dx con 0000
        je d4                        ;Si es igual,salta a d4
        
        push cx                      ;Si no mete cx a la pila
        push bx                      ;Mete bx a la pila
        push ax                      ;Mete ax a la pila
        jmp Cer                      ;Salta a la etiqueta Cer

d4:                                  ;Etiqueta d4
        pop dx                       ;Sacael dato de la pila y mueve a dx 
        cmp dx,0000                  ;Compara dx con 0000
        je impcer                    ;Si es igual,salta a impcer
        
        push dx                      ;Si no mete dx a la pila
        push cx                      ;Mete cx a la pila
        push bx                      ;Mete bx a la pila
        push ax                      ;Mete ax a la pila
        
        jmp Cer                      ;Salta a la etiqueta Cer

impcer:                              ; Etiqueta impcer
        add dl, 30h                	 ; Convierte DL a caracter ASCII
        mov ah, 02                 	 ; Con la funcion 02 de la
        int 21h                    	 ; Interrupcion 21h imprime el caracter
        
        rV                           ; Restituye variables
        rR                           ; Restituye registros
        imprimir regreso             ; Invoca al macro "imprimir" y envia 
                                     ; como argumento a "Regreso"

        jmp DEContinuar              ; Salta a la etiqueta DEContinuar
                
        
Cer:                                 ;Etiqueta Cer
        cmp signoA, 01               ;Verifica si signoA es negativo
        je MAneg                     ;Si lo es, salta a MAneg      
        
        cmp signoB, 01               ;Verifica si signoB es negativo
        je Mresulneg                 ;Si lo es, salta a Mresulneg
        

cont:                                ;Inicia etiqueta cont
        pop dx                       ;Saca dx de la pila
        mov ax, dx                   ;Mueve dx a ax
        cmp ax, 0000                 ;Compara ax con 0000
        je saltom                    ;Si es igual, salta a saltom
        push ax                      ;Empuja ax a la pila
       
sufinpm:                             ;Etiqueta "sufinpm"
        pop dx                     	 ;Saca el valor de la pila en DX
        add dl, 30h                	 ;Convierte DL a caracter ASCII
        mov ah, 02                 	 ;Con la funcion 02 de la
        int 21h                    	 ;Interrupcion 21h imprime el caracter

saltom:                              ;Etiqueta "saltom"
        pop dx                     	 ;Desapila el valor en DX
        add dl, 30h                	 ;Convierte DL a caracter ASCII
        mov ah, 02                 	 ;Con la funcion 02 de la
        int 21h                    	 ;Interrupcion 21h imprime el caracter
    
        pop dx			             ;Desapila el valor en DX
        mov ax, dx		             ;Mueve el valor de DX a AX

        pop dx			             ;Desapila el valor en DX
        mov bx, dx  	             ;Mueve el valor de DX a BX

        cmp ax, 0000	             ;Compara AX con 0
        je dec2m		             ;Si AX es 0, salta a 'dec2m'
        ja sufipm		             ;Si AX es mayor a 0, salta a 'sufinpm'

dec2m:                               ;Etiqueta "dec2m"
        cmp bx, 0000	             ;Compara BX con 0
        je skip_decimal	             ;Si BX es 0, salta a 'skip_decimal'

        mov cx, 02                   ;Mueve el valor 2 a CX

sufipm:                              ;Etiqueta "sufipm"
        push bx                      ;Apila el valor de BX
        push ax                      ;Apila el valor de AX
        imprimir punt                ;Invoca al macro "imprimir" y envia
                                     ;como argumento a "punt"
                                   
        pop dx                       ;Desapila el valor en DX
        add dl, 30h                  ;Convierte DL a caracter ASCII
        mov ah, 02                 	 ;Con la funcion 02 de la
        int 21h                      ;Interrupcion 21h imprime el caracter

        cmp bx, 0000                 ;Compara BX con 0
        je skip_decimal              ;Si BX es 0, salta a 'skip_decimal'

        pop dx                       ;Desapila el valor en DX
        add dl, 30h                  ;Convierte DL a carácter ASCII
        mov ah, 02                   ;Con la funcion 02 de la
        int 21h                      ;Interrupcion 21h imprime el caracter

        rV                           ;Restituye variables
        rR                           ;Restituye registros
        imprimir regreso             ;Invoca al macro "imprimir" y envia 
                                     ;como argumento a "Regreso"

        jmp DEContinuar              ;Salta a la etiqueta DEContinuar

skip_decimal:                        ;Etiqueta para saltar la impresion de decimales

        rV                           ;Restituye variables
        rR                           ;Restituye registros
        imprimir regreso             ;Invoca al macro "imprimir" y envia
                                     ;como argumento a "Regreso"
        jmp DEContinuar              ;Salta a la etiqueta DEContinuar
                                                                                  
;---------------------------Fin de la multiplicacion------------------------------------                                                                              
;------------------------------Division-------------------------------------------------

DIVI proc                            ;Inicia proceso "DIVI"
	    imprimir Divis               ;Invoca al macro "Imprimir" y envia 
	                                 ;como argumento a "Divis"

	    call IngreNum                ;Llama al proceso "IngreNum"   
	    
	    test V2,0FFFFh               ;Compara number2 con FFFFh
	    jnz  noZeroDiv               ;Si no es cero salta a noZeroDiv
	    imprimir Res                 ;Invoca al macro "imprimir" y envia 
	                                 ;como argumento a "Res"
	    imprimir indeter             ;Invoca al macro "imprimir" y envia 
	                                 ;como argumento a "Indeter"
	    
	    imprimir regreso             ;Invoca al macro "imprimir" y envia 
	                                 ;como argumento a "regreso"
	                                 
	    jmp DEContinuar              ;Salta a la etiqueta DEContinuar
	    limpant                      ;Invoca al macro "limpant"
	    ret                          ;Regresa a la etiqueta que lo llamo

noZeroDiv:                           ;Etiqueta "noZeroDiv"

        mov ax,V1                    ;Copia el contenido de V1 a ax
        cwd                          ;Extiende ax en dx
        idiv V2                      ;Divide dx:ax por el contenido de V2
        push ax                      ;Guarda ax en pila
        mov ax,dx                    ;Copia a dx en ax
        imul diezveces               ;Multiplica ax por 10
        cwd                          ;Extiende ax a dx
      
        idiv V2                      ;Divide ax por el contenido de V2
        push ax                      ;Guarda ax en pila
        mov ax,dx                    ;Copia dx en ax
        imul diezveces               ;Multiplica ax por 10
        cwd                          ;Extiende ax a dx
      
        idiv V2                      ;divide ax por elcontenido de V2
        push ax                      ;Guarda ax en pila
        mov ax,dx                    ;Mueve el contenido de ax en dx
        imul diezveces               ;Multiplica ax por 10
        cwd                          ;Extiende ax a dx


        mov cx,0                     ;Limpia cx

        pop ax                       ;Recupera de la pila ax
        add cx,ax                    ;Suma ax a cx

        pop ax                       ;Recupera de la pila ax
        imul diezveces               ;Multiplica por 10 ax
        add cx,ax                    ;Suma ax a cx

        pop ax                       ;Recupera de la pila ax
        imul diezveces               ;Multiplica por 10 ax
        imul diezveces               ;Multiplica por 10 ax
        add cx,ax                    ;Sima ax a cx

        mov ax,cx                    ;Copia a cx en ax
       

        push ax                      ;Guarda ax en pila
        imprimir Res                 ;Invoca al macro "imprimir" y envia como 
                                     ;argumento a "Res"
        pop ax                       ;Recupera de la pila ax

        call intPCarCDI              ;Llama al proceso "intPCaraCDI"

        imprimir regreso             ;Invoca al macro "imprimir" y envia
                                     ;como argumento a "Regreso"
        jmp DEContinuar              ;Salta a la etiqueta DEContinuar
	    
	    ret	                         ;Regresa a la etiqueta que lo llamo
	
DIVI endp                            ;Termina proceso "DIVI"      

;---------------------------Fin de la division ------------------------------------

IngreNum proc                        ;Inicia proceso "ingreNum" 
        
        
	    imprimir Numero1             ;Invoca al macro "imprimir" y envia 
	                                 ;como argumento a "Numero1"
        call ConDigit                ;Llama al proceso "ConDigit"

        call paraInt                 ;Llama al proceso "paraInt"
        mov V1,ax                    ;Asigna el valor de "AX" a V1
              
        push bx                      ;mete el valor bx a la pila

	    imprimir Numero2             ;Invoca al macro "imprimir" y envia como argumento a "Numero2"
        call Condigit                ;Llama al proceso "Condigit"
              
        pop dx                       ;saca el valor de la pila y lo pone en dx
        cmp bh,dh                    ;compara bh con dh
        jg  primero                  ;Salta si es mayor a dh
        mov bh,dh                    ;mueve el contenido de dh al registro bh
        
primero:                             ;Etiqueta "primero"
              
        call paraInt                 ;Llama al proceso "paraInt"
        mov V2,ax                    ;Asigna el valor de "AX" a V2
        ret                          ;Regresa al proceso que lo llamo

ingreNum endp                        ;Termina proceso "ingreNum"

paraInt proc                         ;Inicia proceso "paraInt"
        mov ax,0                     ;Limpia ax
        mov dx,0                     ;Limpia dx
        
        mov dl,ch                    ;Copia ch a dl
        
        shr dl,4                     ;Mueve los bits de dl 4 a la derecha
        add ax,dx                    ;Suma dx a ax
        
        mul diezveces                ;Multiplica por 10 ax
        mov dl,ch                    ;Copia ch a dl
        
        shl dl,4                     ;Mueve los bits de dl 4 a la izquierda
        shr dl,4                     ;Mueve los bits de dl 4 a la derecha
        
        add ax,dx                    ;Suma dx a ax
        
        mul diezveces                ;Multiplica por 10 ax
        
        mov dl,cl                    ;Copia cl a dl
        
        shr dl,4                     ;Mueve los bits de dl 4 a la derecha
        
        add ax,dx                    ;Suma dx a ax
        
        mul DiezVeces                ;Multiplica por 10 ax
        
        mov dl,cl                    ;Copia cl a dl
       
        shl dl,4                     ;Mueve los bits de dl 4 a la izquierda
        shr dl,4                     ;Mueve los bits de dl 4 a la derecha
        
        add ax,dx                    ;Suma dx a ax
        test bl,1                    ;Comprueba bl con 1
        jz paraIntEnd                ;Si es zero salta a toIntEnd
        not ax                       ;Niega a ax
        add ax,1                     ;Suma 1 a ax

paraintEnd:                          ;Etiqueta "paraintEnd"
    
        ret                          ;Regresa a la etiqueta que lo llamo

ParaInt endp                         ;Termina proceso "ParaInt"


intPCarC proc                        ;Inicia proceso "intPCaraC"
  
        cmp ax,0                     ;Compara con 0 ax,
        jg  noNegat                  ;Si es mayor salta a noNegat
        jz  noNegat                  ;Si es cero, salta a noNegat
        not ax                       ;Complemento de ax
        
        add ax,1                     ;Suma 1 a ax
        
        push ax                      ;Guarda ax en la pila
        
        mov dl,'-'                   ;Mueve el caracter '-' a dl
        
        ImpCaract                    ;Invoca al macro "ImpCaract"
        
        pop ax                       ;Saca ax de la pila
        
        jmp  Brango                  ;Si es mayor, el rango esta bien
                                                              
        ret                          ;Regresa al proceso que le llamo

noNegat:                             ;Etiqueta "noNegat"

        cmp ax,10000                 ;Compara ax con 10000
        jl  BRango                   ;Si es menor esta en el rango,
                               
        ret                          ;Regresa al proceso que le llamo
        
Brango:                              ;Etiqueta "BRango"

        mov cx,4                     ;Mueve 4 a cx
  
convertir:                           ;Etiqueta "convertir" 
        mov dx, 0                    ;Limpia dx
        div diezveces                ;divide ax entre 10
        or dl,030h                   ;Convierte dl en ascii agregando 30h 
        push dx                      ;Guarda dx en la pila
        loop convertir               ;Salta a convertir si cx no es cero
  
                                     ;Primer caracter puede ser cero , ese no se imprime
        pop dx                       ;Restaura el primer caracter
        cmp dl,030h                  ;Compara con 30h
        je  Pcero                    ;Si es igual, salta a Pcero
        ImpCaract                    ;Invoca al macro "ImpCaract"

Pcero:                               ;Etiqueta "Pcero"
                                     ;segundo caracter
        pop dx                       ;Saca de la pila el segundo caracter
        ImpCaract                    ;Invoca al macro "ImpCaract"

        mov cl,bh                    ;Mueve cl a bh
        test cl,0ffh                 ;Comprueba cl con 0ffh
        jz  noDecimal                ;Si es cero no hay decimales
        
        pop dx                       ;Saca el valor de la pila
        cmp dx, '0'                  ;compara dx con 0
        je SinPunto                  ;Si es igual salta a la etiqueta "SinPunto"
        push dx                      ;Mete el valor dx a la pila
        
        mov dl,'.'                   ;Mueve el caracter '.' a dl
        Impcaract                    ;Invoca al macro "Impcaract"
        jmp decimalPrint             ;salta a la etiqueta decimalPrint

SecDec:                              ;Etiqueta "SecDec"
        mov dl,'.'                   ;Mueve el caracter '.' a dl
        ImpCaract                    ;Invoca al macro "ImpCaract"
        mov dl, '0'                  ;Mueve el caracter '0' a dl
        ImpCaract                    ;Invoca al macro "ImpCaract"
        pop dx                       ;Saca el valor de la pila a dx
        ImpCaract                    ;Invoca al macro "ImpCaract"
        jmp noDecimal                ;Salta a noDecimal
         
SinPunto:                            ;Etiqueta "SinPunto"
        pop dx                       ;Saca el valor de la pila y lo mete a dx
        cmp dx, '0'                  ;Compara dx con el caracter '0'
        je noDecimal                 ;Si es igual salta a noDecimal
        push dx                      ;Si no es igual mete el valor dx a la pila
        
        jmp SecDec                   ;Salta a SecDec


decimalPrint:                        ;Etiqueta "decimalPrint"
        pop dx                       ;Saca de la pila dx
        
        cmp cx, 0                    ;Compara Cx con '0'
        jl Termina                   ;Si es menor salta a "Termina"
        
SegDec:                              ;Etiqueta "SegDec"
        
        cmp dx, '0'                  ;Compara Dx con '0'
        je DecCero                   ;Si es igual salta a DecCero
        ImpCaract                    ;Si no entonces Invoca al macro "ImpCaract" 
        
        jcxz Termina                 ;Si CX=0 entonces salta a Termina 
        
        
DecCero:                             ;Etiqueta "DecCero"
        cmp cx, 2                    ;Compara Cx con 2
        jg Termina                   ;Si es mayor salta a la etiqueta 'Termina'
        loop  decimalPrint           ;Hace un loop e Imprime hasta que cx sea 0 
        cmp cx, 0                    ;Compara Cx con 0
        je Termina                   ;Si es igual salta a termina
                    
        pop dx                       ;Saca el valor de la pila y lo mete en dx 
        cmp dx, '0'                  ;Compara Dx con 0
        JGE SegDec                   ;Si es mayor o igual entonces salta a la etiqueta 'SegDec'
        
        cmp dx, '9'                  ;Si no entonces compara Dx con '9'
        JLE SegDec                   ;Si es menor o igual entonces salta a la etiqueta 'SegDec'
        
        push dx                      ;Mete el valor de Dx a la pila
        
        mov cx, 0                    ;Mueve 0 al registro CX 
        
       
Termina:                             ;Etiqueta "Termina"
noDecimal:                           ;Etiqueta "noDecimal"
        mov cl,2                     ;Mueve 2 a cl
        sub cl,bh                    ;Resta bh a cl
        
        imprimir regreso             ;Invoca al macro "imprimir" y envia
                                     ;como argumento a "regreso"
        call DEcontinuar             ;Llama al proceso Decontinuar
        ret                          ;Retorna al proceso que le llamo
                            
intPCarC endp                        ;Termina proceso "intPCarC"


intPCarCDI proc                      ;Inicia proceso "intPCaraCDI"
  
        cmp ax,0                     ;Compara con 0 ax,
        jg  noNegatD                 ;Si es mayor salta a noNegatD
        jz  noNegatD                 ;Si es cero, salta a noNegatD
        not ax                       ;Complemento de ax
        
        add ax,1                     ;Suma 1 a ax
        
        push ax                      ;Guarda ax en la pila
        
        mov dl,'-'                   ;Mueve el caracter '-' a dl
        
        ImpCaract                    ;Invoca al macro "ImpCaract"
        
        pop ax                       ;Saca ax de la pila
        
        jmp  BrangoD                 ;Si es mayor, el rango esta bien
                                                              
        ret                          ;Regresa al proceso que le llamo

noNegatD:                            ;Etiqueta "noNegatD"

        cmp ax,10000                 ;Compara ax con 10000
        jl  BRangoD                  ;Si es menor esta en el rango,
                               
        ret                          ;Regresa al proceso que le llamo
        
BrangoD:                             ;Etiqueta "BRangoD"

        mov cx,4                     ;Mueve 4 a cx
  
convertirD:                          ;Etiqueta "convertirD" 
        mov dx, 0                    ;Limpia dx
        div diezveces                ;divide ax entre 10
        or dl,030h                   ;Convierte dl en ascii agregando 30h 
        push dx                      ;Guarda dx en la pila
        loop convertirD              ;Salta a convertirD si cx no es cero
  
                                     ;Primer caracter puede ser cero , ese no se imprime
        pop dx                       ;Restaura el primer caracter
        cmp dl,030h                  ;Compara con 30h
        je  PceroD                   ;Si es igual, salta a PceroD
        ImpCaract                    ;Invoca al macro "ImpCaract"

PceroD:                              ;Etiqueta "PceroD"
                                     ;segundo caracter
        pop dx                       ;Saca de la pila el segundo caracter
        ImpCaract                    ;Invoca al macro "ImpCaract"

        pop dx                       ;Saca el valor de la pila
        cmp dx, '0'                  ;compara dx con 0
        je SinPuntoD                 ;Si es igual salta a la etiqueta "SinPuntoD"
        push dx                      ;Mete el valor dx a la pila
        
        mov dl,'.'                   ;Mueve el caracter '.' a dl
        Impcaract                    ;Invoca al macro "Impcaract"
        jmp decimalPrintD            ;salta a la etiqueta decimalPrintD

SecDecD:                             ;Etiqueta "SecDecD"
        mov dl,'.'                   ;Mueve el caracter '.' a dl
        ImpCaract                    ;Invoca al macro "ImpCaract"
        mov dl, '0'                  ;Mueve el caracter '0' a dl
        ImpCaract                    ;Invoca al macro "ImpCaract"
        pop dx                       ;Saca el valor de la pila a dx
        ImpCaract                    ;Invoca al macro "ImpCaract"
        jmp noDecimalD               ;Salta a noDecimalD
         
SinPuntoD:                           ;Etiqueta "SinPuntoD"
        pop dx                       ;Saca el valor de la pila y lo mete a dx
        cmp dx, '0'                  ;Compara dx con el caracter '0'
        je noDecimalD                ;Si es igual salta a noDecimalD
        push dx                      ;Si no es igual mete el valor dx a la pila
        
        jmp SecDecD                  ;Salta a SecDecD
        

decimalPrintD:                       ;Etiqueta "decimalPrintD"
        pop dx                       ;Saca de la pila dx
        ImpCaract                    ;Si no entonces Invoca al macro "ImpCaract"
                
SegDecD:                             ;Etiqueta "SegDecD"
        pop dx
        cmp dx, '0'                  ;Compara Dx con '0'
        je TerminaD                  ;Si es igual salta a TerminaD
        ImpCaract                    ;Si no entonces Invoca al macro "ImpCaract" 
        
        jmp TerminaD                 ;Salta a TerminaD 
        
        
DecCeroD:                            ;Etiqueta "DecCeroD"
        cmp cx, 2                    ;Compara Cx con 2
        jg TerminaD                   ;Si es mayor salta a la etiqueta 'TerminaD'
        loop  decimalPrintD          ;Hace un loop e Imprime hasta que cx sea 0 
        cmp cx, 0                    ;Compara Cx con 0
        je TerminaD                  ;Si es igual salta a terminaD
                    
        pop dx                       ;Saca el valor de la pila y lo mete en dx 
        cmp dx, '0'                  ;Compara Dx con 0
        JGE SegDecD                  ;Si es mayor o igual entonces salta a la etiqueta 'SegDecD'
        
        cmp dx, '9'                  ;Si no entonces compara Dx con '9'
        JLE SegDecD                  ;Si es menor o igual entonces salta a la etiqueta 'SegDecD'
        
        push dx                      ;Mete el valor de Dx a la pila
        
        mov cx, 0                    ;Mueve 0 al registro CX 
        
       
TerminaD:                            ;Etiqueta "TerminaD"
noDecimalD:                          ;Etiqueta "noDecimalD"
        mov cl,2                     ;Mueve 2 a cl
        sub cl,bh                    ;Resta bh a cl
        
        imprimir regreso             ;Invoca al macro "imprimir" y envia
                                     ;como argumento a "regreso"
        call DEcontinuar             ;Llama al proceso Decontinuar
        ret                          ;Retorna al proceso que le llamo
                            
intPCarCDI endp                      ;Termina proceso "intPCarCDI"


ConDigit proc near                   ;Inicio del procedimiento ConDigit
        mov bx, 0                    ;Inicializa BX en 0
        mov cx, 0                    ;Inicializa CX en 0

Estado_inicial:                      ;Etiqueta Estado_inicial
        Noco                         ;Desactiva el eco del teclado
        cmp al, 0Dh                  ;Compara AL con 'Enter' (0Dh)
        jne negat1                   ;Si no es 'Enter', salta a negat1
        ret                          ;Si es 'Enter', retorna

negat1:                              ;Etiqueta negat1
        cmp al, '-'                  ;Compara AL con '-'
        je negativo                  ;Si es '-', salta a negativo
        cmp al, '.'                  ;Compara AL con '.'
        je puntojmp                  ;Si es '.', salta a puntojmp
        cmp al, '0'                  ;Compara AL con '0'
        jl Estado_inicial            ;Si es menor que '0', salta a Estado_inicial
        cmp al, '9'                  ;Compara AL con '9'
        jg Estado_inicial            ;Si es mayor que '9', salta a Estado_inicial
        jmp entero                   ;Salta a entero

Entero:                              ;Etiqueta Entero
        mov dl, al                   ;Copia AL en DL
        ImpCaract                    ;Imprime el caracter en DL
        shl ch, 4                    ;Desplaza CH a la izquierda 4 bits
        sub al, 30h                  ;Convierte el caracter ASCII a valor numerico
        add ch, al                   ;Suma el valor numerico a CH
        test ch, 0F0h                ;Verifica si el bit alto de CH esta encendido
        jz cons_entero               ;Si no, salta a cons_entero
        jmp FEntero                  ;Si si, salta a FEntero

Cons_entero:                         ;Etiqueta Cons_entero
        Noco                         ;Desactiva el eco del teclado
        cmp al, 0Dh                  ;Compara AL con 'Enter' (0Dh)
        jne negat3                   ;Si no es 'Enter', salta a negat3
        ret                          ;;Retorna al proceso que le llamo
        
negat3:                              ;Etiqueta negat3
        cmp al, 08h                  ;Compara AL con 'Backspace' (08h)
        je regreEntero               ;Si es 'Backspace', salta a regreEntero
        cmp al, '.'                  ;Compara AL con '.'
        je punto                     ;Si es '.', salta a punto
        cmp al, '0'                  ;Compara AL con '0'
        jl cons_entero               ;Si es menor que '0', salta a cons_entero
        cmp al, '9'                  ;Compara AL con '9'
        jg cons_entero               ;Si es mayor que '9', salta a cons_entero
        jmp entero                   ;Salta a entero

regreEntero:                         ;Etiqueta regreEntero
        shr ch, 4                    ;Desplaza CH a la derecha 4 bits
        test ch, 00Fh                ;Verifica si los bits bajos de CH son cero
        jnz cons_entero              ;Si no son cero, salta a cons_entero
        test bl, 1                   ;Verifica si el bit bajo de BL esta encendido
        jnz ConsNegat                ;Si si, salta a ConsNegat
        jmp Estado_inicial           ;Si no, salta a Estado_inicial

FEntero:                             ;Etiqueta FEntero
        Noco                         ;Desactiva el eco del teclado
        cmp al, 0Dh                  ;Compara AL con 'Enter' (0Dh)
        jne negat3                   ;Si no es 'Enter', salta a negat3
        ret                          ;;Retorna al proceso que le llamo

puntojmp:                            ;Etiqueta puntojmp
        jmp punto                    ;Salta a punto

negativo:                            ;Etiqueta negativo
        mov dl, al                   ;Copia AL en DL
        ImpCaract                    ;Imprime el caracter en DL
        mov bl, 1                    ;Establece BL en 1 para indicar numero negativo

ConsNegat:                           ;Etiqueta ConsNegat
        Noco                         ;Desactiva el eco del teclado
        cmp al, 0Dh                  ;Compara AL con 'Enter' (0Dh)
        jne negati2                  ;Si no es 'Enter', salta a negati2
        ret                          ;Retorna al proceso que le llamo

negati2:                             ;Etiqueta negati2
        cmp al, 08h                  ;Compara AL con 'Backspace' (08h)
        je RegreNegativ              ;Si es 'Backspace', salta a RegreNegativ
        cmp al, '.'                  ;Compara AL con '.'
        je punto                     ;Si es '.', salta a punto
        cmp al, '0'                  ;Compara AL con '0'
        jl ConsNegat                 ;Si es menor que '0', salta a ConsNegat
        cmp al, '9'                  ;Compara AL con '9'
        jg ConsNegat                 ;Si es mayor que '9', salta a ConsNegat
        jmp entero                   ;Salta a entero

RegreNegativ:                        ;Etiqueta RegreNegativ
        mov bl, 0                    ;Establece BL en 0 para indicar numero no negativo
        jmp Estado_inicial           ;Salta a Estado_inicial

punto:                               ;Etiqueta punto
        mov dl, '.'                  ;Copia '.' en DL
        ImpCaract                    ;Imprime el caracter en DL

Cons_punto:                          ;Etiqueta Cons_punto
        Noco                         ;Desactiva el eco del teclado
        cmp al, 0Dh                  ;Compara AL con 'Enter' (0Dh)
        jne negat4                   ;Si no es 'Enter', salta a negat4
        ret                          ;;Retorna al proceso que le llamo

negat4:                              ;Etiqueta negat4
        cmp al, 08h                  ;Compara AL con 'Backspace' (08h)
        je point_return              ;Si es 'Backspace', salta a point_return
        cmp al, '0'                  ;Compara AL con '0'
        jl cons_punto                ;Si es menor que '0', salta a cons_punto
        cmp al, '9'                  ;Compara AL con '9'
        jg cons_punto                ;Si es mayor que '9', salta a cons_punto
        jmp decimal                  ;Salta a decimal

point_return:                        ;Etiqueta point_return
        test ch, 0FFh                ;Verifica si CH no es cero
        jnz ParaEntero               ;Si no es cero, salta a ParaEntero
        test bl, 1                   ;Verifica si BL tiene su bit mas bajo encendido
        jnz ConsNegat                ;Si es asi, salta a ConsNegat
        jmp Estado_inicial           ;Si no, salta a Estado_inicial

ParaEntero:                          ;Etiqueta ParaEntero
        jmp regreEntero              ;Salta a regreEntero

decimal:                             ;Etiqueta decimal
        mov dl, al                   ;Copia AL en DL
        ImpCaract                    ;Imprime el caracter en DL
        sub al, 30h                  ;Convierte el caracter ASCII a valor numerico
        add cl, al                   ;Suma el valor numerico a CL
        shl cl, 4                    ;Desplaza CL a la izquierda 4 bits
        add bh, 1                    ;Incrementa BH

ConsDecimal:                         ;Etiqueta ConsDecimal
        Noco                         ;Desactiva el eco del teclado
        cmp al, 0Dh                  ;Compara AL con 'Enter' (0Dh)
        jne negati5                  ;Si no es 'Enter', salta a negati5
        ret                          ;;Retorna al proceso que le llamo
                                    
negati5:                             ;Etiqueta negati5
        cmp al, 08h                  ;Compara AL con 'Backspace' (08h)
        je regredecimal              ;Si es 'Backspace', salta a regredecimal
        cmp al, '0'                  ;Compara AL con '0'
        jl ConsDecimal               ;Si es menor que '0', salta a ConsDecimal
        cmp al, '9'                  ;Compara AL con '9'
        jg ConsDecimal               ;Si es mayor que '9', salta a ConsDecimal
        jmp decimal2A                ;Salta a decimal2A
                                   
RegreDecimal:                        ;Etiqueta RegreDecimal
        shl cl, 4                    ;Desplaza CL a la izquierda 4 bits
        sub bh, 1                    ;Decrementa BH
        jmp cons_punto               ;Salta a cons_punto

decimal2A:                           ;Etiqueta decimal2A
        mov dl, al                   ;Copia AL en DL
        ImpCaract                    ;Imprime el caracter en DL
        sub al, 30h                  ;Convierte el caracter ASCII a valor numerico
        add cl, al                   ;Suma el valor numerico a CL
        add bh, 1                    ;Incrementa BH

Cons2Decimal:                        ;Etiqueta Cons2Decimal
        ret                          ;;Retorna al proceso que le llamo
                                  
negat6:                              ;Etiqueta negat6
        cmp al, 08h                  ;Compara AL con 'Backspace' (08h)
        je Regre2Decimal             ;Si es 'Backspace', salta a Regre2Decimal
        jmp Cons2Decimal             ;Salta a Cons2Decimal

Regre2Decimal:                       ;Etiqueta Regre2Decimal
        shr cl, 4                    ;Desplaza CL a la derecha 4 bits
        shl cl, 4                    ;Desplaza CL a la izquierda 4 bits
        sub bh, 1                    ;Decrementa BH
        jmp ConsDecimal              ;Salta a ConsDecimal

condigit endp                        ;Fin del procedimiento ConDigit

DEContinuar proc                     ;Inicio del procedimeinto DEContinuar
        Sico                         ;Activa el eco del teclado
        cmp AL, '1'                  ;Compara AL con '1'
        je continuar                 ;Si es '1', salta a continuar
        cmp AL, '2'                  ;Compara AL con '2'
        je salir                     ;Si es '2', salta a salir
        jmp DEcontinuar              ;Si no es '1' ni '2', vuelve a preguntar

continuar:                           ;Etiqueta continuar
        
        limpant                      ;Limpia pantalla
        jmp callmenu                 ;Salta a callmenu

salir:                               ;Etiqueta salir
        limpant                      ;Limpia pantalla
        jmp FIN                      ;Salta a FIN

        ret                          ;Retorna al proceso que le llamo
DEcontinuar endp                     ;Fin del procedimiento DEContinuar

FIN:                                 ;Etiqueta FIN
        mov AH, 4CH                  ;Termina el programa
        int 21H                      ;Con la Int 21h devuelve el control al DOS
end begin                            ;Fin del programa                    
