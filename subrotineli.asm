
.MODEL SMALL
.STACK 64
;-------------
.DATA
;This code draws NxM grids.
Message db 'Welcome to the Grid Program','$'
Message3 db 0ah,0dh,'Please wait patiently while I draw your grid. Thank you.','$'
prompt1 db 0ah,0dh, 'Please press any key to start the choosing inputs!','$'     
Message1 db 0ah,0dh,'Please enter number of rows:','$'
newline db 13,10,'$'
Message2 db 0ah,0dh,'Please enter number of columns:','$'     
;0ah and 0dh are ASCII codes for carriage return and line feed
;Gap is the distance between column and row
;inputr and inputc are lines which will be drawn
;value holds how many lines to draw
inputr db ?
inputc db ?
value db ?
gap db ?
;-------------
.CODE
MAIN PROC FAR 
    mov ax,@DATA
    mov ds,ax
   
    call ShowMessage    
    call cursor2
    call ShowMessage2 
    
    call takeinput1
    call takeinput2
    
    call drawcolumn
    call drawrow
MAIN ENDP    
          
ShowMessage proc
    lea dx,Message
    mov ah,09
    mov si,offset Message
    int 21h 
    
    lea dx,Message3 
    mov ah,09
    mov dx,offset Message3
    int 21h
    
    mov ah,09
    mov dx,offset prompt1
    int 21h
    mov ah,07
    int 21h 
    
    lea dx,newline
    Mov ah,09
    Mov Dx,offset Message1
    int 21H 
       
ShowMessage endp 



takeinput1 PROC
    
    again_sec1:
    mov ah,01
    int 21h
    sub al,30h
    cmp al,0      ;control for 0, it does not except 0 and waits for taking input different from 0
    jle again_sec1;this does not except negative integers
    cmp al,63h    ;control for 99
    jg again_sec1 ;this does not except greater than 99
    mov inputc,al
         
takeinput1 ENDP

ShowMessage2 PROC
    lea dx,newline
    mov ah,09
    mov Dx,offset Message2
    int 21h    
ShowMessage2 ENDP

takeinput2 proc
    again_sec2:
    mov ah,01
    int 21h
    sub al,30h
    cmp al,0 
    jle again_sec2 
    cmp al,63h
    jg again_sec2 
    mov inputr,al  
takeinput2 endp 
 
drawrow proc
call clear
call set       ;set the graphic mode
mov dx,60 
mov al,inputc

startstaterow: 
mov value,al
mov al,inputr
mov gap,al
sub gap,1 
positionh2:
mov cx,120 ;this coordinates for row's width
mov ax,60   ; row's width will be increased
mul gap     
add ax,cx 
mov bx,ax   
   
paintrow2:;that section for drawing and painting
mov ah,0ch 
mov al,06h 
int 10h              
inc cx
cmp cx,bx
jne paintrow2 

countrow2:
dec value
mov ax,60
add dx,ax
cmp value,0
jne positionh2 


drawrow endp

drawcolumn proc  
mov cx,120   ;coordinate
mov al,inputr
startstatecolumn:
mov value,al
mov al,inputc
mov gap,al
sub gap,1
 
positionv2: 
mov dx,60 
mov ax,60 
mul gap     
add ax,dx  
mov bx,ax  
   
paintcolumn2: 
mov ah,0ch 
mov al,05h 
int 10h              
inc dx
cmp dx,bx
jne paintcolumn2 

countcolumn2:
dec value
mov ax,60
add cx,ax
cmp value,0   
jne positionv2
call gobackdos
                    
drawcolumn endp                      
clear proc ;clear screen
mov ax,0600h 
mov bh,07 
mov cx,0000 
mov dx,184fh 
int 10h 
ret
clear endp 

set proc  ; set screen 12h in graphical mode        
mov ax, 12h
int 10h 
ret
set endp 
cursor2 proc  ;set cursor position
mov ah,02
mov bh,00
mov dl,10
mov dh,1eh
int 10h
ret
cursor2 endp 

gobackdos proc ;exit the system
mov ah,4ch
int 21h
ret
gobackdos endp    