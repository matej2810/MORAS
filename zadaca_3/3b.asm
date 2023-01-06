@100
D = A

@A
M = D

@B
M = D + 1 

@0
D = M - 1

@temp
M = D

@temp2
M = D


@END_SWAP
0;JMP
(SWAP)

$SWP(swapA,swapB)

@swapA
D = M

@A
A = M
M = D

@swapB
D = M

@B
A = M
M = D

@HELP_LOOP
0;JMP

(END_SWAP)

@0
M = M - 1 
D = M

$WHILE(temp)

@temp
M = M - 1

$WHILE(0)

    @R0
    M = M - 1

    @A
    A = M
    D = M

    @swapA
    M = D

    @B
    A = M
    D = M

    @swapB
    M = D

    @swapA
    D = M
    @swapB
    D = D - M

    @SWAP
    D;JGT

    (HELP_LOOP)
    @A
    M = M + 1

    @B
    M = M + 1

$END

@100
D = A

@A
M = D

@B
M = D + 1 

@temp2
D = M

@0
M = D

$END
(END)
@END
0;JMP
