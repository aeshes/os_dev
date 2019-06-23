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

loader:
  xor ax, ax  ; Setup registers to ensure they are 0.
  mov ds, ax  ; We have org 0x7C00. All adressed are based from 0x7C00:0.
  mov es, ax  ; Because the data segments are within the same code segment, null them.

  mov si, msg
  call print

  cli
  hlt

times 510 - ($ - $$) db 0
dw 0xAA55
