LDFLAGS = -m elf_i386 -lc -dynamic-linker /lib/ld-linux.so.2 -z execstack
ASFLAGS = --32 -g
OBJECT = stack_smashing.o 
SOURCE = stack_smashing.s 
stack_smashing.out: $(OBJECT) 
	ld $(LDFLAGS) $(OBJECT) -o $@
stack_smashing.o: $(SOURCE)
	as $(ASFLAGS) $(SOURCE) -o $@
clean:
	rm *.o *.out
