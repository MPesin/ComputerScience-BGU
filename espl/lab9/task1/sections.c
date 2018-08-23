#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include "elf.h"

int checkELF32(Elf32_Ehdr *header)
{
	if (header->e_ident[1] == 'E' &&
	      header->e_ident[2] == 'L' &&
	      header->e_ident[3] == 'F' &&
	      header->e_ident[4] == ELFCLASS32)
		return 1;
	return 0;
}

void printFlagG(Elf32_Ehdr *header){
	printf("There are %i sections\n", header->e_shnum);
}

void checkFlagG(char **argv, Elf32_Ehdr *header){
	int exist = 0, cmp;
	while (*argv != '\0') {
		if ((cmp = strcmp(*argv, "-g")) == 0)
			exist = 1;
		argv++;
	}
	if (exist)
		printFlagG(header);
}

void printSectionTable(Elf32_Shdr *section, int total, char * index){
	int i;
	/*printf("index\tName\tAddress\t  offset  size\n");*/
	printf("%-5s %-15s%-10s%-10s%-10s\n", "Index", "Name", "Address", "Offset", "Size");
	for (i=0; i<total; ++i){
		char * name = &index[section[i].sh_name];
		printf("[%02i] %-15s%-10.08x%-10.06x%-10.06d\n", i, name, 
									section[i].sh_addr,
									section[i].sh_offset,
									section[i].sh_size);

	}
}

char *getFileName(char **argv){
	int i = 1,cmp;
	argv++;
	while (*argv != '\0') {
		if (!((cmp = strcmp(*argv, "-g")) == 0))
			return *argv;
		argv++;
		i++;
	}
	return NULL;
}

int main(int argc, char **argv) 
{
  int fd;
  void *map_start; 
  struct stat fd_stat; 
  Elf32_Ehdr *header; 
  
  char *fileName = getFileName(argv);

  if( fileName == NULL || ((fd = open(fileName, O_RDWR)) < 0 )) {
     perror("error in open");
     exit(-1);
  }

  if( fstat(fd, &fd_stat) != 0 ) {
     perror("stat failed");
     exit(-1);
  }

  if ((map_start = mmap(0, fd_stat.st_size, PROT_READ | PROT_WRITE , MAP_SHARED, fd, 0)) < 0 ) {
     perror("mmap failed");
     exit(-1);
  }

  header = (Elf32_Ehdr *) map_start;
  Elf32_Shdr *section = (Elf32_Shdr *) (((char *) header) + header->e_shoff);

  if (!checkELF32(header)){
    perror("Not ELF32");
    exit(-1);
  }

  int section_headers = header->e_shnum;

  checkFlagG(argv, header);
  char *index = (char *)header + section[header->e_shstrndx].sh_offset;
  printSectionTable(section, section_headers, index);

  return 0;
}