                                      
#fasm# 

#make_boot#

org 7c00h


  xor ax,  ax
  mov bx, int_proc
  xor si, si
  mov [si+2], ax
  mov [si+0], bx
  int 0
  hlt


int_proc:
  mov si, msg
  call print
  iret 
  
print:
  lodsb
  or al, al     ; al - current character
  jz print_done ; null-terminator found
  mov ah, 0x0E
  int 10h
  jmp print
print_done:
  ret

msg db "Fuck!", 0Ah, 0Dh, 0