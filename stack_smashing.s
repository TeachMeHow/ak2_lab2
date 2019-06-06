.data
scanf_f: .ascii "%s/0"
.text
.global _start
_start:
	call generic_function
	push $0
	call exit

generic_function:
	push %ebp
	movl %esp, %ebp
# local char[] variable
	subl $80, %esp
# read from stdin to local string
	leal -80(%ebp), %eax
	push %eax
# in ANSI C, usage of gets() also works, among others
	push $scanf_f
	call scanf

	movl %ebp, %esp
	pop %ebp
# if return address is overwritten, it should point to
# addres of local string, which is a shellcode
	ret
