sound_effect1: ; short peep sound
  ld hl, 510
  ld de, 5
  call BEEPER ; ROM beeper routine

  ret

sound_effect2: ; pitch bend effect
  ld hl, 500
  ld b, 100
  ld de, 1
s_loop:
  push bc
  push hl
  ld de, 1
  call BEEPER
  pop hl
  inc hl
  pop bc
  djnz s_loop

  ret  


BEEPER equ 949  