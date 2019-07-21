#fasm# 

#make_boot#

org 7c00h
  
  ; calculate interrupt offset
  lea si, [10h*4] 
  
  ; save segment in ax, offset in bx
  mov ax, [si+2]
  mov bx, [si]  
  
  ; save original interrupt vector
  mov [original_vector+3], ax
  mov [original_vector+1], bx
  
  ; set hook
  xor ax, ax
  mov bx, int10_handler
  mov [si+2], ax
  mov [si+0], bx
  
  ; use interrupt inside of 'print'
  mov si,  tst
  call print
  
  hlt

int10_handler:
  call beep
original_vector:
  jmp far 0000:0000 
  
print:
  lodsb
  or al, al     ; al - current character
  jz print_done ; null-terminator found
  mov ah, 0x0E
  int 10h
  jmp print
print_done:
  ret 
  
beep:
  push ax
  push bx
  
  mov al, 182
  out 43h, al
  mov ax, 2280
  
  out 42h, al
  mov al, ah
  out 42h, al
  in al, 61h
  
  or al, 00000011b
  out 61h, al
  mov bx, 4
  
  pop bx
  pop ax
  
  ret

msg db "Fuck!", 0Ah, 0Dh, 0
tst db "Test!", 0Ah, 0Dh, 0