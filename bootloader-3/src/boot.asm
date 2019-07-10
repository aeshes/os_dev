org 0x7C00

bits 16

start: jmp loader
  ; OEM parameter block
  times (0Bh - $ + start) DB 0

  bpbBytesPerSector:      DW 512
  bpbSectorsPerCluster:   DB 1
  bpbReservedSectors:     DW 1
  bpbNumberOfFATs:        DB 2
  bpbRootEntries:         DW 224
  bpbTotalSectors:        DW 2880
  bpbMedia:               DB 0xF0
  bpbSectorsPerFAT:       DW 9
  bpbSectorsPerTrack:     DW 18
  bpbHeadsPerCylinder:    DW 2
  bpbHiddenSectors:       DD 0
  bpbTotalSectorsBig:     DD 0
  bsDriveNumber:          DB 0
  bsUnused:               DB 0
  bsExtBootSignature:     DB 0x29
  bsSerialNumber:         DD 0xa0a1a2a3
  bsVolumeLabel:          DB "MOS FLOPPY "
  bsFileSystem:           DB "FAT12   "

msg db "Welcome to my Operating System!", 0

; Prints a string
; DS:SI - 0-terminated string
print:
  lodsb
  or al, al     ; al - current character
  jz print_done ; null-terminator found
  mov ah, 0x0E
  int 10h
  jmp print
print_done:
  ret

; -------------------------
; bootloader  entry point
; -------------------------
loader:
reset:
  mov ah, 0 ; reset floppy disk function
  mov dl, 0 ; drive 0 is floppy drive
  int 0x13  ; reset disk
  jc reset  ; if error, try to reset again

  mov ax, 0x1000 ; read sector into address 0x1000:0
  mov es, ax     ; set segment 0x1000
  xor bx, bx     ; set offset to 0

  mov ah, 0x02   ; read floppy sector function
  mov al, 1      ; read 1 sector
  mov ch, 1      ; track 1, because we reading the second sector
  mov cl, 2      ; sector to read (the second sector)
  mov dh, 0      ; head number
  mov dl, 0      ; drive number (drive 0 is floppy)
  int 0x13       ; read the sector

  jmp 0x1000:0   ; jump to execute the sector

times 510 - ($ - $$) db 0
dw 0xAA55

; ----------------------------------------
; end of sector 1, beggining of sector 2
; ----------------------------------------

;org 0x1000

  cli
  hlt