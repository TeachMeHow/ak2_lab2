.text
hello_world:
	push %ebp
	movl %esp, %ebp
	xorl %eax, %eax
	xorl %ebx, %ebx
	xorl %edx, %edx
	movb $4, %al
	movb $1, %bl
	movl $str, %ecx
	movb $5, %dl
	int $0x80
	movl %ebp, %esp
	pop %ebp
str: .ascii "Hello"
	ret

