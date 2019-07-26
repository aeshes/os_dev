                                      
#fasm# 

#make_boot#

org 7c00h
  
  mov ax, [4Eh]  ; read original segment
  mov bx, [4Ch]  ; read original offset
  
  mov [original_vector+2], ax
  mov [original_vector], bx
  
  xor ax, ax
  mov [4Eh], ax
  mov [4Ch], word int13_handler
  
  mov ah, 2
  int 13h
  
  hlt
  
  
int13_handler:
  cmp ah, 2                  ; hook only 2-nd function
  jz handler_logic
  db 0EAh        ; far jmp
original_vector:
  dw 0, 0
  
handler_logic:
  pushf                       ; emulating int instruction
  call far [original_vector]
  jc error
  
  pusha
  pushf
  
  xor al, 90h                 ; simple custom logic
  
  popf
  popa
  
error:
  iret                        ; exit handler