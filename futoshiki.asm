  org 40000
  call cls ; clear screen
  call draw_grid ; draw grid of 4x4 boxes 

  call load_level

  call reset_selection_position ; reset selection position

  ld a, 1
  ld (user_enabled), a

  call draw_selection ; draw initial selection

game_loop:  
  ld a, (LAST_KEY)
  cp 'p'
  call z, move_right
  cp 'o'
  call z, move_left
  cp 'q'
  call z, move_up
  cp 'a'
  call z, move_down
  cp '1'
  call z, draw_1
  cp '2'
  call z, draw_2
  cp '3'
  call z, draw_3
  cp '4'
  call z, draw_4
  cp '0'
  call z, draw_empty
  cp ' '
  call z, switch_number



  ; check solution
  call check_level
  jr z, level_completed

  jr game_loop

level_completed:
  call sound_effect2  

  ret

include "utils.asm"
include "levels.asm" 
include "sound.asm"

box_x: defb 0
box_y: defb 0   
selection_x: defb 0
selection_y: defb 0
selection_index: defb 0
selection_attr: defb 58
user_selection: defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
user_enabled: defb 0