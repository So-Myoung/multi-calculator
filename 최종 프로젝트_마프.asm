
;60181867 김소명 
;최종 프로젝트_ calculator
;---------------------------------------------
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

org 100h
jmp start
;msg 문구 설정
introduce db "-------------------------------------------------------------------",0Dh,0Ah
          db "-             60181867 kim so myoung  [final project]             -",0Dh,0Ah
          db "-------------------------------------------------------------------",0Dh,0Ah
          db "-                      name : multi calculator                     -",0Dh,0Ah
          db "-                 copyright owner : kim so myoung                  -",0Dh,0Ah
          db "-------------------------------------------------------------------",0Dh,0Ah
          db "-------------------------------------------------------------------",0Dh,0Ah
          db "                                                                   ",0Dh,0Ah,'$' ;문자열 끝 $(달러)
num1_input db 0Dh,0Ah, 'first number: $'
operator_input db "operator : +(plus) -(minus) *(multi) /(div) ^(pow) !(fact) s(sigma) d(dup): $"
num2_input db "second number: $"
result db  0dh,0ah , 'result : $' 
exit_program db  0dh,0ah ,'exit this program.. press any key!', 0Dh,0Ah, '$'
wrong_operator db  "wrong operator", 0Dh,0Ah , '$'
remainder db  " , something $"

;변수선언      
opr db '0' ;operator = 연산기호이므로 문자로 받아야해서 '0'
num1 dw 0
num2 dw 0

start:
;introduce string 출력
mov dx, offset introduce
mov ah, 9 
int 21h ;dos function call ->12a9

;num1_input string 출력
lea dx, num1_input ;lea=주소저장, num1_input의 주소를 dx로 옮김
mov ah, 09h    
int 21h  
call scan_num
mov num1, ax ;사용자에게 입력받은 숫자 num1에 저장
putc 0Dh
putc 0Ah
;operator_input string 출력
lea dx, operator_input
mov ah, 09h    
int 21h  
mov ah, 1 ;character(operator) 입력
int 21h
mov opr, al ;사용자에게 입력받은 문자 opr에 저장
putc 0Dh
putc 0Ah 
    
;num2의 입력과 상관없이 연산기호를 입력하면 결과가 나오는 연산    
cmp opr, '!' ;opr이 !이면 
je do_fact ;jump equal->do_fact로 점프    
cmp opr, 'd' ;opr이 d이면
je do_dup ;jump equal->do_dup로 점프
cmp opr, 'q' ;opr이 q이면    
je exit ;jump equal->exit로 점프    
       
;num2_input string 출력
lea dx, num2_input
mov ah, 09h 
int 21h  
call scan_num
mov num2, ax ;사용자에게 입력받은 숫자를 num2에 저장

;result string 출력
lea dx, result
mov ah, 09h      
int 21h  
      
;num1 opr num2 = result 연산
cmp opr, '+' ;opr이 +이면    
je do_plus   ;jump equal->do_plus로 점프
cmp opr, '-' ;opr이 -이면
je do_minus  ;jump equal->do_minus로 점프                                            
cmp opr, '*' ;opr이 *이면
je do_multi   ;jump equal->do_multi로 점프
cmp opr, '/' ;opr이 /이면
je do_div    ;jump equal->do_div로 점프
cmp opr, '^' ;opr이 ^이면 
je do_pow    ;jump equal->do_pow로 점프
cmp opr, 's' ;opr이 s이면
je do_sigma ;jump equal->do_sigma로 점프

;exit_program string 출력 
exit:
lea dx, exit_program
mov ah, 09h
int 21h  
mov ah, 0 ;get keyboard
int 16h ;keyboard function call
ret 

;연산과정
;덧셈
do_plus:
mov ax, num1
add ax, num2 ;ax=num1+num2
call num_print ;print ax
jmp exit ;exit로 점프
 
;뺄셈
do_minus:
mov ax, num1
sub ax, num2 ;ax=num1-num2
call num_print ;print ax
jmp exit ;exit로 점프

;곱셈
do_multi:
mov ax, num1
imul num2 ;(dxax)=ax*num2 
call num_print ;print ax
jmp exit ;exit로 점프

;나눗셈
do_div:
mov dx, 0
mov ax, num1
idiv num2  ; ax=(dxax)/num2
cmp dx, 0 
jnz remain ;remain이 0이 아니면 점프, remain이 0이면 점프하지 않고 몫만 출력
call num_print   
jmp exit ;exit로 점프
remain:
call num_print
lea dx, remainder
mov ah, 09h ;remainder string 출력(나머지 존재)
int 21h  
jmp exit
         
;팩토리얼         
do_fact:
lea dx, result
mov ah, 09h      
int 21h
mov cx, num1 ;cx=num1
mov ax, 1 ;1로 초기화
mov bx, 1 ;1부터 num1까지 1씩 더하면서 연산
cal:
mul bx ;bx*ax
inc bx ;bx=bx+1
loop cal ;cx가 0이면 loop문을 나감
call num_print  
jmp exit ;exit로 점프         
           
;지수
do_pow:
mov ax, num1 ;ax에 밑인 num1 입력
mov cx, num2 ;cx에 지수인 num2 입력
dec cx ;cx가 0일때 까지 반복 하므로 cx-1 -> cx가 1일때 까지 반복
pow:
mul num1 ;num1*num1
loop pow 
call num_print  
jmp exit ;exit로 점프    
   
;시그마
do_sigma:
mov bx,num1
mov ax,bx ;ax=num1이 저장됨
mov cx,num2 ;cx=num2
sub cx,bx ;cx-bx=num2-num1, count 역할을 함
sigma:
inc bx ;bx=bx+1 
add ax, bx ;ax+bx
loop sigma;
call num_print
jmp exit ;exit로 점프    

;복사(dup)    
do_dup:
lea dx, result ;lea=주소가 저장, result의 주소가 dx에 저장됨
mov ah, 09h ;string 출력   
int 21h  
mov ax,num1 ;ax=num1
call num_print
jmp exit ;exit로 점프 

;num을 scan하는 프로그램
scan_num proc near ;cs:ip에서 같은 cs에 있는 프로그램을 처리, intra segment 
    jmp num_scan ;num_scan으로 점프 
    data_buf label byte ;102h
    max_size db 10 ;102h 같은 주소를 공유함.
    buf_count db 0 
    buf_area db 10 dup(20h) 
    result_output db 5 dup(20h)
    end db '$'
    ten dw 10 ;db로 설정시 오류, dw=2byte
num_scan:
    mov ah,0ah ;string input
    mov dx, offset data_buf
    int 21h ;dos function call ->12a9
    mov bl,buf_count ;몇 글자가 입력되었는지 확인
    mov bh, 0 
    dec bx 
    mov si, offset buf_area ;글자가 들어갈 공간 할당
    sub di,di ;초기화
    mov cx,1
atoh: ;ascii -> hexa(16진수)
    ;65535예시    
    mov al,[si+bx] ;al=35
    and al,0fh ;al=05                             
    sub ah,ah ;ah=0
    mul cx ;ax=5*1
    add di,ax ;di=5
    mov ax,cx ;cx에 10을 곱하기 위해 ax로 옮김
    mul ten ;ax=1*10
    mov cx,ax ;cx=10
    dec bx ;bx=3
    jns atoh ;cx가 음수가 아니면 atoh로 점프
    mov ax,di ;바꾼 아스키 값을 ax로 옮김    
scan_num endp
ret     

;num을 print하는 프로그램
num_print proc near ;cs:ip에서 같은 cs에 있는 프로그램을 처리, intra segment
    mov si, offset result_output
    add si, 4 
htod: ;hexa -> decimal(16잔수 -> 10진수) 
    sub dx,dx ;dx 초기화
    div ten ;ten으로 나눔
    or dl,30h ;아스키로 변환
    mov [si],dl
    dec si ;si-1
    cmp ax,0 ;ax=0이 되면 loop문 나감
    ja htod
    mov ah,09h ;string 출력
    mov dx,offset result_output
    int 21h
num_print endp
ret
