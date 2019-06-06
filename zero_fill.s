###########
# CONSTANTS
###########
SYS_EXIT = 1
SYS_READ = 3
SYS_WRITE = 4
STD_IN = 0
STD_OUT = 1
SYS_INT = 0x80

.data
row: .long 0
col: .long 0
.bss
# long array[40][60]
.lcomm array, 40*60*4
.equ j, 40
.equ i, 60

# number of clocks to fill array[j][i]
.lcomm fill_rows_elapsed_time, 8
.lcomm fill_cols_elapsed_time, 8

.text
.global _start
_start:
	# fill_cols_elapsed_time <- rdtsc
	rdtsc
	movl %eax, fill_cols_elapsed_time
	mov $fill_cols_elapsed_time, %ecx
	movl %edx, 4(%ecx) 

	call fill_cols

	# fill_cols_elapsed_time = rdtsc - fill_cols_elapsed_time
	rdtsc
	subl fill_cols_elapsed_time, %eax
	movl %eax, fill_cols_elapsed_time
	movl $fill_cols_elapsed_time, %ecx
	subl 4(%ecx), %edx
	movl %edx, 4(%ecx)

	# fill_rows_elapsed_time <= rdtsc
	rdtsc
	movl %eax, fill_rows_elapsed_time
	mov $fill_rows_elapsed_time, %ecx
	movl %edx, 4(%ecx) 

	call fill_rows

	# fill_rows_elapsed_time = rdtsc - fill_rows_elapsed_time
	rdtsc
	subl fill_rows_elapsed_time, %eax
	movl %eax, fill_rows_elapsed_time
	movl $fill_rows_elapsed_time, %ecx
	subl 4(%ecx), %edx
	movl %edx, 4(%ecx)

	# exit
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $SYS_INT


fill_rows:
	# for row 0 to 40
	#	for col 0 to 60
	# 		array[row][col] = 0
	movl $0, col # col
	movl $0, row # row
fr_next_row:
	movl row, %eax
	movl $i, %edx
	mull %edx
	movl $4, %edx
	mull %edx
fr_next_col:
	movl col, %ecx
	movl $2, array(%eax, %ecx, 4)
	incl col
	incl %ecx
	cmpl $i, %ecx 
	jne fr_next_col

	movl $0, col
	incl row
	movl row, %eax
	cmp $j, %eax
	jne fr_next_row

	movl $0, row

	ret


fill_cols:
	# for col 0 to 60 
	#	for row 0 to 40
	#		array[row][col] = 0
	movl $0, col # col
	movl $0, row # row


fc_next_col:
	movl col, %ecx
fc_next_row:
	movl row, %eax
	movl $i, %edx
	mull %edx
	movl $4, %edx
	mull %edx
	movl $1, array(%eax, %ecx, 4)
	incl row
	movl row, %eax
	cmpl $j, %eax #check if column has been filled
	jne fc_next_row

# next column
	movl $0, row
	incl col
	incl %ecx
	cmp $i, %ecx
	jne fc_next_col
	
	movl $0, col
	ret
