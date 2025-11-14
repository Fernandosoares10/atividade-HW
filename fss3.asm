# ==========================================
# Q1.asm - Conversões de base 10
# Autor: Fernando Silva
# email: fss3@cesar.school
# data/hora 14/11/25 19:15
# ==========================================

.data
prompt: .asciiz "\nDigite um número decimal: "
binMsg: .asciiz "\nBase 2: "
octMsg: .asciiz "\nBase 8: "
hexMsg: .asciiz "\nBase 16: "
bcdMsg: .asciiz "\nCódigo BCD: "
newline: .asciiz "\n"

.text
main:
    
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0       

    
    li $v0, 4
    la $a0, binMsg
    syscall
    move $a0, $t0
    jal decToBin

   
    li $v0, 4
    la $a0, octMsg
    syscall
    move $a0, $t0
    jal decToOct

   
    li $v0, 4
    la $a0, hexMsg
    syscall
    move $a0, $t0
    jal decToHex

    
    li $v0, 4
    la $a0, bcdMsg
    syscall
    move $a0, $t0
    jal decToBCD

    li $v0, 10
    syscall


decToBin:
    move $t1, $a0
    li $t2, 0
    li $t3, 1

    li $v0, 4
    la $a0, newline
    syscall

bin_loop:
    beqz $t1, bin_end
    andi $t4, $t1, 1
    addi $t4, $t4, 48
    li $v0, 11
    move $a0, $t4
    syscall
    srl $t1, $t1, 1
    j bin_loop

bin_end:
    jr $ra


decToOct:
    move $t1, $a0
    li $t2, 8
    li $v0, 4
    la $a0, newline
    syscall
oct_loop:
    beqz $t1, oct_end
    div $t1, $t2
    mfhi $t4
    addi $t4, $t4, 48
    li $v0, 11
    move $a0, $t4
    syscall
    mflo $t1
    j oct_loop
oct_end:
    jr $ra


decToHex:
    move $t1, $a0
    li $t2, 16
    li $v0, 4
    la $a0, newline
    syscall
hex_loop:
    beqz $t1, hex_end
    div $t1, $t2
    mfhi $t4
    blt $t4, 10, hex_digit
    addi $t4, $t4, 55
    j hex_print
hex_digit:
    addi $t4, $t4, 48
hex_print:
    li $v0, 11
    move $a0, $t4
    syscall
    mflo $t1
    j hex_loop
hex_end:
    jr $ra


decToBCD:
    move $t1, $a0
    li $v0, 4
    la $a0, newline
    syscall
bcd_loop:
    beqz $t1, bcd_end
    div $t1, 10
    mfhi $t4
    li $v0, 1
    move $a0, $t4
    syscall
    mflo $t1
    j bcd_loop
bcd_end:
    jr $ra

# ==========================================
# Q2.asm - Conversão para complemento de 2
# ==========================================

.data
prompt: .asciiz "\nDigite um número decimal (positivo ou negativo): "
msg: .asciiz "\nRepresentação em 16 bits (complemento de 2): "
newline: .asciiz "\n"

.text
main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    li $v0, 4
    la $a0, msg
    syscall

    # Se for negativo, faz complemento de 2
    bltz $t0, neg
    move $t1, $t0
    j show

neg:
    not $t1, $t0
    addi $t1, $t1, 1

show:
    li $t2, 15  # 16 bits
print_loop:
    bltz $t2, end
    srlv $t3, $t1, $t2
    andi $t3, $t3, 1
    addi $t3, $t3, 48
    li $v0, 11
    move $a0, $t3
    syscall
    addi $t2, $t2, -1
    j print_loop
end:
    li $v0, 10
    syscall

# ==========================================
# CalculadoraProgramador.asm
# Converte decimal para bases, complemento de 2,
# e ponto flutuante (float e double)
# ==========================================

.data
menu: .asciiz "\n=== CALCULADORA PROGRAMADOR ===\n1) Bases\n2) Complemento de 2\n3) Float e Double\nEscolha: "
newline: .asciiz "\n"
.text
main:
    li $v0, 4
    la $a0, menu
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    beq $t0, 1, bases
    beq $t0, 2, complemento
    beq $t0, 3, floatconv
    j fim

bases: 
    jal decToBases
    j fim
complemento:
    jal complemento2
    j fim
floatconv:
    jal pontoFlutuante
    j fim
fim:
    li $v0, 10
    syscall

