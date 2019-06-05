.data
str: .ascii "AAAA AAAA AAAA AAAA AAAA\0"
str_len: .long . - str
num: .long 1234
scanf_f: .ascii "%d/0"

.text
.global _start
_start:
	push $str
	call generic_function
	push $0
	call exit

generic_function:
	push %ebp
	movl %esp, %ebp

	leal -4(%ebp), %eax
	push %eax
	push $scanf_f
	call scanf
	movl %ebp, %esp
	pop %ebp
	ret

.type hello_world, @function
hello_world:
	push %ebp
	movl %esp, %ebp
	subl $16, %esp
	push %ecx
	push %edx

	movl 8(%ebp), %eax  
	movl $0, %ecx
loop:

	incl %ecx
	cmp str_len, %ecx
	jne loop

	pop %edx
	pop %ecx
	movl %ebp, %esp
	pop %ebp
	
	ret

