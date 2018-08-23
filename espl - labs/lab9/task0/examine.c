#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "elf.h"

int firstMagicNumbers(Elf32_Ehdr *header)
{
  if (header->e_ident[1] == 'E' &&
      header->e_ident[2] == 'L' &&
      header->e_ident[3] == 'F' &&
      header->e_ident[4] == ELFCLASS32)
    printf("first magic numbers are: %c %c %c\n", header->e_ident[1], header->e_ident[2], header->e_ident[3]);
  else
    return 0;
  return 1;
}

void entryPoint(Elf32_Ehdr *header)
{
  printf("Entry point is: 0x%x\n", header->e_entry);  
}

int dataEncoding(Elf32_Ehdr *header)
{
  if (header->e_ident[5] == 0)
    return 0;
  if (header->e_ident[5] == 1)
    printf("Data encoding: 2's complement, little endian\n");  
  if (header->e_ident[5] == 2)
    printf("Data encoding: 2's complement, big endian\n");  
  return 1;
}

void printInfo(Elf32_Ehdr *header)
{
  printf("Offset Section Header: %x\n", header->e_shoff);
  printf("Number of Section Headers: %x\n", header->e_shnum);
  printf("Size of each Sections: %x\n", header->e_shentsize);
  printf("Header File Offset: %x\n", header->e_phoff);
  printf("Number of program header entries: %x\n", header->e_phnum);
  printf("Size of program header entry: %x\n", header->e_phentsize);
}

int main(int argc, char **argv) 
{
  int fd;
  void *map_start; 
  struct stat fd_stat; 
  Elf32_Ehdr *header; 
  
  if( (fd = open(argv[1], O_RDWR)) < 0 ) {
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

  if (firstMagicNumbers(header))
  {
    entryPoint(header);

    if (!dataEncoding(header))
    {
      perror("Invalid data encoding");
      exit(-1);
    }

    printInfo(header);
  } 
  else 
  {
    perror("Not ELF file!");
    exit(-1);
  }
  
  munmap(map_start, fd_stat.st_size);
  
  return 0;
}


