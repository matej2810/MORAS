// ram[5] = ram[0], trenutni max 
// kroz loop prodemo od 0 do 4 
// adresa iplusjedan je i+1 adresa 
// uzmemo vrj koja je na toj adresi i usporedujemo s trenutnim max koji se nalazi na ram[5]
// napravimo provjeru tako da oduzmemo RAM[i] i RAM[5]
// ako dobijemo negativan broj, onda se ram[5] ne mijenja
// inace RAM[5] = RAM[i], skocimo na max 
//  zamjenimo ih i returnamo se nazad u petlju 
// proces se nastavlja sve do kraja
@i
M = 0

@i
D = M

@iplusjedan
M = D + 1

@R0
D = M

@R5
M = D

(LOOP_START)
  @i
  D = M
  @4
  D = D - A
  @LOOP_END
  D; JGE
  
  @iplusjedan
  D = M
  A = D 
  D = M
  
  @R5
  D = D - M
  @Max
  D; JGT
  (Return)
  
  @i 
  M = M + 1
  @iplusjedan
  M = M + 1
  @LOOP_START
  0; JMP
(LOOP_END)
(END)
@END
0;JMP

(Max)
@iplusjedan
D = M
A = D
D = M
@R5
M = D
@Return
0; JMP