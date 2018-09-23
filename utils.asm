



reset_selection_position:
  ld a, 0
  ld (selection_x), a
  ld (selection_y), a
  ld (selection_index), a
  ret 

draw_arrow_down:  
  ld hl, arrow_down
  ld a, (selection_x)
  add a, 1
  ld c, a; set number column as selection_x + 1
  ld a, (selection_y)
  add a, 4
  ld b, a; set number row as selection_y + 4
  call draw_4x4_sprite
  ret

draw_arrow_up:  
  ld hl, arrow_up
  ld a, (selection_x)
  add a, 1
  ld c, a; set number column as selection_x + 1
  ld a, (selection_y)
  add a, 4
  ld b, a; set number row as selection_y + 4
  call draw_4x4_sprite
  ret  

draw_arrow_right:
  ld hl, arrow_right
  ld a, (selection_x)
  add a, 4
  ld c, a; set number column as selection_x + 4
  ld a, (selection_y)
  add a, 1
  ld b, a; set number row as selection_y + 1
  call draw_4x4_sprite
  ret

draw_arrow_left:
  ld hl, arrow_left
  ld a, (selection_x)
  add a, 4
  ld c, a; set number column as selection_x + 4
  ld a, (selection_y)
  add a, 1
  ld b, a; set number row as selection_y + 1
  call draw_4x4_sprite
  ret  

switch_number: ; reads selected numer from user_selection, inreases selection or reset back to 0
  call current_user_selection ; get current user selection

  cp 0
  push af
  call z, draw_1
  pop af
  cp 1
  push af
  call z, draw_2
  pop af
  cp 2
  push af
  call z, draw_3
  pop af
  cp 3
  push af
  call z, draw_4
  pop af
  cp 4
  call z, draw_empty

  ret
  
  

draw_empty:
  ; prepare attributes for user (blue ink)
  ; TODO clear sprite

  ld a, (selection_y) ; selection row
  inc a
  ld b, a
  ld a, (selection_x) ; slection column
  inc a
  ld c, a

  call find_attr_row

  ld a, 57; white paper, blue ink
  ex de, hl
  ld (hl), a
  inc hl
  ld (hl), a; x +1
  ld de, 31
  add hl, de
  ld (hl), a; y +1
  inc hl
  ld (hl), a; x +1; y +1

  ; draw empty number
  ld hl, empty_number
  call draw_number

  ; store 0
  ld b, 0
  call update_selection_number

  ret


draw_1:
  call check_position
  cp a, 0
  ret nz ; return if position isn't free

  ld hl, numbers
  call draw_number

  ; store 1
  ld b, 1
  call update_selection_number

  ret

draw_2:
  call check_position
  cp a, 0
  ret nz ; return if position isn't free

  ld hl, numbers
  ld de, 32
  add hl, de  
  call draw_number

  ; store 2
  ld b, 2
  call update_selection_number

  ret

draw_3:
  call check_position
  cp a, 0
  ret nz ; return if position isn't free

  ld hl, numbers
  ld de, 64
  add hl, de  
  call draw_number

  ; store 3
  ld b, 3
  call update_selection_number

  ret

draw_4:
  call check_position
  cp a, 0
  ret nz ; return if position isn't free

  ld hl, numbers
  ld de, 96
  add hl, de  
  call draw_number

  ; store 4
  ld b, 4
  call update_selection_number

  ret   


check_position:
  ld a, (user_enabled)
  cp a, 0
  ret z; return if user not enabled

  ld hl, levels
  ld a, (selection_index)
  ld d, 0
  ld e, a
  add hl, de
  ld a, (hl)
  and 7
  ret

current_user_selection: ; read current selected number and returns in register a
  ld hl, user_selection
  ld a, (selection_index)
  ld d, 0
  ld e, a
  add hl, de
  ld a, (hl)
  ret   

update_selection_number: ; write number stored in b into current user_selection
  ; TODO write current number into user_selection array

  ld hl, user_selection
  ld a, (selection_index)
  ld d, 0
  ld e, a
  add hl, de
  ld a, b ; number to write
  ld (hl), a

  ret  

draw_number: ; draw number inside selected box,  number sprite in hl
  ld a, (selection_x)
  inc a
  ld c, a; set number column as selection_x + 1
  ld a, (selection_y)
  inc a
  ld b, a; set number row as selection_y + 1
  
  call draw_4x4_sprite

  call sound_effect1 ; make some noise

  ; reset key
  ld a, 0
  ld (LAST_KEY), a

  ret
   

move_right:
  ; check right limit (18)
  ld a, (selection_x)
  cp a, 18
  ret z

  call reset_selection; reset selection by setting black ink color for current box
  
  call move_selection_right; move selection right

  ; draw new seleciton with red ink color
    ld a, 58
  ld (selection_attr), a
  call draw_selection

  ; reset key
  ld a, 0
  ld (LAST_KEY), a
  ret

move_selection_right:
  ld a, (selection_x)
  add a, 6
  ld (selection_x), a
  ; move selection index +1
  ld a, (selection_index)
  inc a
  ld (selection_index), a
  ret

move_left:
  ; check left limit (0)
  ld a, (selection_x)
  cp a, 0
  ret z

  call reset_selection; reset selection by setting black ink color for current box

  call move_selection_left ; move selection left

  ; draw new selection with red ink color
  ld a, 58
  ld (selection_attr), a

  call draw_selection

  ; reset key
  ld a, 0
  ld (LAST_KEY), a
  ret 

move_selection_left:
  ld a, (selection_x)
  ld b, 6
  sub b
  ld (selection_x), a
  ; move selection index -1
  ld a, (selection_index)
  dec a
  ld (selection_index), a
  ret

move_down:
  ; check bottom limit (18)
  ld a, (selection_y)
  cp a, 18
  ret z

  call reset_selection; reset selection by setting black ink color for current box
  
  call move_selection_down ; move selection down
 
  ; draw new seleciton with red ink color
    ld a, 58
  ld (selection_attr), a
  call draw_selection

  ; reset key
  ld a, 0
  ld (LAST_KEY), a
  ret 

move_selection_down:
  ld a, (selection_y)
  add a, 6
  ld (selection_y), a
  ; move selection index +4
  ld a, (selection_index)
  add a, 4
  ld (selection_index), a
  ret

move_up:
  ; check upper limit (0)
  ld a, (selection_y)
  cp a, 0
  ret z

  call reset_selection; reset selection by setting black ink color for current box

  call move_selection_up ; move selection up
  

  ; draw new seleciton with red ink color
  ld a, 58
  ld (selection_attr), a

  call draw_selection

  ; reset key
  ld a, 0
  ld (LAST_KEY), a
  ret

move_selection_up:
  ld a, (selection_y)
  ld b, 6
  sub b
  ld (selection_y), a
  ; move selection index -4
  ld a, (selection_index)
  ld b, 4
  sub b
  ld (selection_index), a
  ret  

reset_selection:
  ld a, 56
  ld (selection_attr), a
  call draw_selection
  ret  

draw_selection:  ;draw selection row: selection_y,  column: selection_x  

  ld a, (selection_y) ; selection row
  ld b, a
  ld a, (selection_x) ; slection column
  ld c, a

  call find_attr_row

  ex de, hl
    
  ; top selection
  call h_selection

  ld de, 32 - 4
  add hl, de
  
  ; middle selection
  call v_selection 

  ; bottom selection
  call h_selection

  ret

v_selection: 
  ld a, (selection_attr)
  ld b, 2
v_selection_loop:
  ld (hl), a
  ld de, 3
  add hl, de
  ld (hl), a
  ld de, 32 - 3
  add hl, de
  djnz v_selection_loop

  ret

h_selection:
  ld a, (selection_attr)
  ld b, 4 
h_selection_loop:
  ld (hl), a
  inc l
  djnz h_selection_loop  
  ret

draw_grid:
  ld b, 4
grid_loop:  
  push bc

  ld a, 0
  ld (box_x), a
  ld b, 4
row_loop:
  push bc
  ld a, (box_y)
  ld b, a
  ld a, (box_x)  
  ld c, a
  call draw_box

  ld a, (box_x) ; inc x + 6
  add a, 6
  ld (box_x), a

  pop bc
  djnz row_loop

  ld a, (box_y); inc y + 6
  add a, 6
  ld (box_y), a

  pop bc

  djnz grid_loop

  ret

cls:
  call $d6b; CLS
  ret

draw_box: ; draw box in position:  column: c,  row: b 
  call find_video_row
  push bc
  ex de, hl
  ld a, l
  call h_border
  ld l, a
  inc h
  ld b, 7
border_top_loop2:  
  ld (hl), 128
  ld a, l
  inc l
  inc l
  inc l
  ld (hl), 1
  ld l, a
  inc h
  djnz border_top_loop2
  
  ; middle part
  pop bc; middle 1
  inc b
  call find_video_row
  push bc
  ld b, 8
  ex de, hl
  call v_border

  pop bc; middle 2
  inc b
  call find_video_row
  push bc
  ld b, 8
  ex de, hl
  call v_border

  ; bottom part
  pop bc
  inc b
  call find_video_row
  ld b, 7
  ex de, hl
  call v_border
  ; bottom border line
  call h_border
     
  ret

v_border: ; vertical border length is stored in b register
v_loop:
  ld (hl), 128 ; left border
  ld a, l
  inc l
  inc l
  inc l
  ld (hl), 1 ; right border
  ld l, a
  inc h
  djnz v_loop
  ret  

h_border:
  ld b, 4
h_loop:  
  ld (hl), 255
  inc hl
  djnz h_loop
  ret  

draw_4x4_sprite: ; Display 4x4 sprites starting at (b, c) b = row  c = column in this order: top left, bottom left, top right, bottom right, sprite source starteng at hl
  push bc
  call draw_sprite
  pop bc
  inc b
  push bc
  call draw_sprite
  pop bc
  dec b
  inc c
  push bc
  call draw_sprite
  pop bc
  inc b
  call draw_sprite 
  
  ret

draw_sprite: ; Display character/sprite hl at (b, c) b = row  c = column
  call find_video_row; find screen address for char
  ld b, 8 ; number of pixel high
char_loop:
  ld a, (hl) ; source graphics
  ex de, hl  ; switch de <-> hl
  ld (hl), a ; transfer to screen  
  ex de, hl  ; switch back
  inc hl     ; next piece of data
  inc d      ; next pixel line
  djnz char_loop
  ret

find_video_row: ; find video memory adress for cell at:  b = row  c = column and store result in de
  ld a, b
  and 24; current row segment (0,1,2)
  or 64 ; 01000000 spectrum video memory start
  ld d, a; high byte is ready
  ld a, b
  and 7;  which row within segment?
  rrca ; rotate to positions 6,7,8  (multiply by 32)
  rrca
  rrca
  add a, c; add column number
  ld e, a; low byte is ready
  ret

find_attr_row: ; find video attributes memory address for cell at: b = row c = column and store result in de
  ld a, b; load row into a
  and 24; current row segment
  rra ; rotate segment number to position 0,1
  rra ;
  rra ;
  or 88; 01011000 
  ld d, a; high byte is ready
  ld a, b; load row again
  and 7;  which row within segment?
  rrca ; rotate to positions 6,7,8  (multiply by 32)
  rrca
  rrca
  add a, c; add column number
  ld e, a; low byte is ready
  ret
 


ATTRS_START EQU $5800
LAST_KEY equ 23560
    

; source: http://prettyuglycode.net/16X16_font.pdf

; custom sprite graphics for 16x16 numbers
numbers: 
  ; number 1
  defb 000,000,003,007,012,000,000,000
  defb 000,000,000,000,000,000,000,001
  defb 096,224,224,096,096,096,096,096
  defb 096,096,096,096,096,096,096,248  
  ; number 2
  defb 000,015,024,000,000,000,000,000
  defb 001,007,028,016,048,048,063,000
  defb 000,240,056,008,008,008,024,112
  defb 192,000,000,000,000,000,252,000  
  ; number 3
  defb 000,000,031,096,000,000,000,031
  defb 000,000,000,000,096,063,000,000
  defb 000,000,224,112,056,056,240,192
  defb 120,028,028,028,120,192,000,000 
  ; number 4
  defb 000,001,003,007,015,030,060,112
  defb 224,255,000,000,000,000,000,000
  defb 000,224,224,224,224,224,224,224
  defb 224,254,224,224,224,000,000,000  

empty_number:
  defb 000,000,000,000,000,000,000,000
  defb 000,000,000,000,000,000,000,000 
  defb 000,000,000,000,000,000,000,000 
  defb 000,000,000,000,000,000,000,000   

arrow_right:
  defb 000,004,002,001,000,000,000,000
  defb 000,000,000,000,000,001,002,004
  defb 000,000,000,000,128,064,032,016
  defb 008,016,032,064,128,000,000,000 

arrow_left:
  defb 000,000,000,000,000,001,002,004
  defb 008,004,002,001,000,000,000,000
  defb 000,016,032,064,128,000,000,000
  defb 000,000,000,000,128,064,032,016  

arrow_down:
  defb 000,000,000,000,064,032,016,008
  defb 004,002,001,000,000,000,000,000
  defb 000,000,000,000,001,002,004,008
  defb 016,032,064,128,000,000,000,000

arrow_up:
  defb 000,000,000,000,001,002,004,008
  defb 016,032,064,128,000,000,000,000
  defb 000,000,000,000,000,128,064,032
  defb 016,008,004,002,000,000,000,000