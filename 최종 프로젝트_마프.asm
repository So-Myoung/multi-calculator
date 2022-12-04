
;60181867 ��Ҹ� 
;���� ������Ʈ_ calculator
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
;msg ���� ����
introduce db "-------------------------------------------------------------------",0Dh,0Ah
          db "-             60181867 kim so myoung  [final project]             -",0Dh,0Ah
          db "-------------------------------------------------------------------",0Dh,0Ah
          db "-                      name : multi calculator                     -",0Dh,0Ah
          db "-                 copyright owner : kim so myoung                  -",0Dh,0Ah
          db "-------------------------------------------------------------------",0Dh,0Ah
          db "-------------------------------------------------------------------",0Dh,0Ah
          db "                                                                   ",0Dh,0Ah,'$' ;���ڿ� �� $(�޷�)
num1_input db 0Dh,0Ah, 'first number: $'
operator_input db "operator : +(plus) -(minus) *(multi) /(div) ^(pow) !(fact) s(sigma) d(dup): $"
num2_input db "second number: $"
result db  0dh,0ah , 'result : $' 
exit_program db  0dh,0ah ,'exit this program.. press any key!', 0Dh,0Ah, '$'
wrong_operator db  "wrong operator", 0Dh,0Ah , '$'
remainder db  " , something $"

;��������      
opr db '0' ;operator = �����ȣ�̹Ƿ� ���ڷ� �޾ƾ��ؼ� '0'
num1 dw 0
num2 dw 0

start:
;introduce string ���
mov dx, offset introduce
mov ah, 9 
int 21h ;dos function call ->12a9

;num1_input string ���
lea dx, num1_input ;lea=�ּ�����, num1_input�� �ּҸ� dx�� �ű�
mov ah, 09h    
int 21h  
call scan_num
mov num1, ax ;����ڿ��� �Է¹��� ���� num1�� ����
putc 0Dh
putc 0Ah
;operator_input string ���
lea dx, operator_input
mov ah, 09h    
int 21h  
mov ah, 1 ;character(operator) �Է�
int 21h
mov opr, al ;����ڿ��� �Է¹��� ���� opr�� ����
putc 0Dh
putc 0Ah 
    
;num2�� �Է°� ������� �����ȣ�� �Է��ϸ� ����� ������ ����    
cmp opr, '!' ;opr�� !�̸� 
je do_fact ;jump equal->do_fact�� ����    
cmp opr, 'd' ;opr�� d�̸�
je do_dup ;jump equal->do_dup�� ����
cmp opr, 'q' ;opr�� q�̸�    
je exit ;jump equal->exit�� ����    
       
;num2_input string ���
lea dx, num2_input
mov ah, 09h 
int 21h  
call scan_num
mov num2, ax ;����ڿ��� �Է¹��� ���ڸ� num2�� ����

;result string ���
lea dx, result
mov ah, 09h      
int 21h  
      
;num1 opr num2 = result ����
cmp opr, '+' ;opr�� +�̸�    
je do_plus   ;jump equal->do_plus�� ����
cmp opr, '-' ;opr�� -�̸�
je do_minus  ;jump equal->do_minus�� ����                                            
cmp opr, '*' ;opr�� *�̸�
je do_multi   ;jump equal->do_multi�� ����
cmp opr, '/' ;opr�� /�̸�
je do_div    ;jump equal->do_div�� ����
cmp opr, '^' ;opr�� ^�̸� 
je do_pow    ;jump equal->do_pow�� ����
cmp opr, 's' ;opr�� s�̸�
je do_sigma ;jump equal->do_sigma�� ����

;exit_program string ��� 
exit:
lea dx, exit_program
mov ah, 09h
int 21h  
mov ah, 0 ;get keyboard
int 16h ;keyboard function call
ret 

;�������
;����
do_plus:
mov ax, num1
add ax, num2 ;ax=num1+num2
call num_print ;print ax
jmp exit ;exit�� ����
 
;����
do_minus:
mov ax, num1
sub ax, num2 ;ax=num1-num2
call num_print ;print ax
jmp exit ;exit�� ����

;����
do_multi:
mov ax, num1
imul num2 ;(dxax)=ax*num2 
call num_print ;print ax
jmp exit ;exit�� ����

;������
do_div:
mov dx, 0
mov ax, num1
idiv num2  ; ax=(dxax)/num2
cmp dx, 0 
jnz remain ;remain�� 0�� �ƴϸ� ����, remain�� 0�̸� �������� �ʰ� �� ���
call num_print   
jmp exit ;exit�� ����
remain:
call num_print
lea dx, remainder
mov ah, 09h ;remainder string ���(������ ����)
int 21h  
jmp exit
         
;���丮��         
do_fact:
lea dx, result
mov ah, 09h      
int 21h
mov cx, num1 ;cx=num1
mov ax, 1 ;1�� �ʱ�ȭ
mov bx, 1 ;1���� num1���� 1�� ���ϸ鼭 ����
cal:
mul bx ;bx*ax
inc bx ;bx=bx+1
loop cal ;cx�� 0�̸� loop���� ����
call num_print  
jmp exit ;exit�� ����         
           
;����
do_pow:
mov ax, num1 ;ax�� ���� num1 �Է�
mov cx, num2 ;cx�� ������ num2 �Է�
dec cx ;cx�� 0�϶� ���� �ݺ� �ϹǷ� cx-1 -> cx�� 1�϶� ���� �ݺ�
pow:
mul num1 ;num1*num1
loop pow 
call num_print  
jmp exit ;exit�� ����    
   
;�ñ׸�
do_sigma:
mov bx,num1
mov ax,bx ;ax=num1�� �����
mov cx,num2 ;cx=num2
sub cx,bx ;cx-bx=num2-num1, count ������ ��
sigma:
inc bx ;bx=bx+1 
add ax, bx ;ax+bx
loop sigma;
call num_print
jmp exit ;exit�� ����    

;����(dup)    
do_dup:
lea dx, result ;lea=�ּҰ� ����, result�� �ּҰ� dx�� �����
mov ah, 09h ;string ���   
int 21h  
mov ax,num1 ;ax=num1
call num_print
jmp exit ;exit�� ���� 

;num�� scan�ϴ� ���α׷�
scan_num proc near ;cs:ip���� ���� cs�� �ִ� ���α׷��� ó��, intra segment 
    jmp num_scan ;num_scan���� ���� 
    data_buf label byte ;102h
    max_size db 10 ;102h ���� �ּҸ� ������.
    buf_count db 0 
    buf_area db 10 dup(20h) 
    result_output db 5 dup(20h)
    end db '$'
    ten dw 10 ;db�� ������ ����, dw=2byte
num_scan:
    mov ah,0ah ;string input
    mov dx, offset data_buf
    int 21h ;dos function call ->12a9
    mov bl,buf_count ;�� ���ڰ� �ԷµǾ����� Ȯ��
    mov bh, 0 
    dec bx 
    mov si, offset buf_area ;���ڰ� �� ���� �Ҵ�
    sub di,di ;�ʱ�ȭ
    mov cx,1
atoh: ;ascii -> hexa(16����)
    ;65535����    
    mov al,[si+bx] ;al=35
    and al,0fh ;al=05                             
    sub ah,ah ;ah=0
    mul cx ;ax=5*1
    add di,ax ;di=5
    mov ax,cx ;cx�� 10�� ���ϱ� ���� ax�� �ű�
    mul ten ;ax=1*10
    mov cx,ax ;cx=10
    dec bx ;bx=3
    jns atoh ;cx�� ������ �ƴϸ� atoh�� ����
    mov ax,di ;�ٲ� �ƽ�Ű ���� ax�� �ű�    
scan_num endp
ret     

;num�� print�ϴ� ���α׷�
num_print proc near ;cs:ip���� ���� cs�� �ִ� ���α׷��� ó��, intra segment
    mov si, offset result_output
    add si, 4 
htod: ;hexa -> decimal(16�ܼ� -> 10����) 
    sub dx,dx ;dx �ʱ�ȭ
    div ten ;ten���� ����
    or dl,30h ;�ƽ�Ű�� ��ȯ
    mov [si],dl
    dec si ;si-1
    cmp ax,0 ;ax=0�� �Ǹ� loop�� ����
    ja htod
    mov ah,09h ;string ���
    mov dx,offset result_output
    int 21h
num_print endp
ret
