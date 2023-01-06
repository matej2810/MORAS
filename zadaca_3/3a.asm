@R0
D = M

@baza
M = D

@temp
M = D

@temp2
M = 0

@R1
M = M - 1

$WHILE(R1)

@R1
M = M - 1

$WHILE(R0)
@R0
M = M - 1
$SUM(temp2, temp, temp2)
$END

@temp2
D = M

@temp
M = D

@temp2
M = 0

@baza
D = M

@R0
M = D

$END

@temp
D = M

@2
M = D

(END)
@END
0;JMP
