@i
    M = 0

@128
    D = A
    @n
        M = D

@SCREEN
    D = A
    @address
        M = D

@1100
    D = A
    @address
        M = M + D


(KATETA1START)
    @i
        D = M
        @n
            D = M - D
            @KATETA1END
                D ; JLT

    @0
        D = !A

    @32767
        D = D - A

    @address
        A = M
        M = D
    
    @i
        M = M + 1

    @32
        D = A
        @address
            M = M + D
    
    @KATETA1START
        0 ; JMP

(KATETA1END)

@32
    D = A
    @address
        M = M - D


@i
    M = 0

@8
    D = A
    @n
        M = D


(KATETA2START)
    @i
        D = M
        @n
            D = M - D
            @KATETA2END
                D ; JLE

    @address
        A = M + 1
        M = -1

    @i
        M = M + 1

    @address
        M = M + 1
        @KATETA2START
            0 ; JMP

(KATETA2END)



@i
    M = 0

@j
    M = 0

@128
    D = A
    @n
        M = D

@br
    M = 1

@1100
    D = A
    @SCREEN
        D = D + A
        @address
            M = D + 1

(HIPOTENUZASTART)
    @j
        D = M
        @n
            D = M - D
            @HIPOTENUZAEND
                D ; JEQ

    @16
        D = A
        @i
            D = D - M
            @RESET
                D ; JLE

    @br
        D = M
        M = D + M

    @address
        A = M
        M = D

    @32
        D = A
        @address
            M = M + D

    @i
        M = M + 1
    @j
        M = M + 1

    @HIPOTENUZASTART
        0 ; JMP

(HIPOTENUZAEND)
@END
    0 ; JMP


(RESET)
    @br
        M = 1
    @i
        M = 0
    @address
        M = M + 1
        @HIPOTENUZASTART
            0 ; JMP



(END)
@END
0;JMP

