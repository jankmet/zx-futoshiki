

load_level:
  call reset_selection_position
  ld hl, levels ; load level 1
  ld b, 4 ; for rows
load_rows_loop:
  push bc

  ; reset x selection
  ld a, 0
  ld (selection_x), a

  ld b, 4 ; for columns
load_cols_loop:
  push bc 



  push hl
  call load_box
  pop hl
  inc hl

  call move_selection_right
  
  pop bc
  djnz load_cols_loop

  call move_selection_down

  ; fix selection_index
  ld a, (selection_index)
  sub a, 4
  ld (selection_index), a

  pop bc
  djnz load_rows_loop  

  ret


load_box: ; load and display box information stored in adress hl
  ld a, (hl)
  push af
  and 7; take number information

  cp 0
  push af
  call z, draw_empty
  pop af
  cp 1
  push af
  call z, draw_1
  pop af
  cp 2
  push af
  call z, draw_2
  pop af
  cp 3
  push af
  call z, draw_3
  pop af
  cp 4
  call z, draw_4


  pop af  ; load info byte again 

  ; arrows
  bit 4, a ; compare right arrow bit
  push af
  call nz, draw_arrow_right
  pop af
  bit 5, a; compare left arrow bit
  push af
  call nz, draw_arrow_left
  pop af
  bit 6, a; compare down arrow bit
  push af
  call nz, draw_arrow_down
  pop af
  bit 7, a; compare up arrow bit
  call nz, draw_arrow_up

  ret

check_level: ; check if user selection array matched solved level
  
  ld b, 16; check all 16 numbers
  ld de, 0; array index
check_loop:  
  ld hl, levels_solutions
  add hl, de
  ld a, (hl)
  ld hl, user_selection
  add hl, de
  ld c, (hl)
  cp c
  ret nz

  inc de

  djnz check_loop

  ret


levels: 
  ; level 1
  defb 64, 0, 0, 64, 0, 0, 0, 0, 19, 0, 32, 0, 0, 0, 32, 0


levels_solutions:
  ; level 1 solution
  defb 4, 1, 3, 2,  2, 3, 4, 1,  3, 2, 1, 4,  1, 4, 2, 3