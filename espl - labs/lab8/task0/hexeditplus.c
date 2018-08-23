#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>


typedef struct{
	char* action;
	void(*f)(char* filename,int size);
}menu;

void loadMenu();
void quit(char* filename, int size);
void loadAddress(int* address,int* length);
void printAddress(char* filename,int size);
void readFromFIle(char* filename,int size);
void locationVal(unsigned int* l ,unsigned int * v);
void fileModify (char* filename, int size);
void getData(char*file,int* s,int* t,int* l);
void fileCopy( char* filename,int size);
void printMenu(char* filename, int size);
void chooseOption(char* filename,int size);
void readFromFIle(char* filename,int size);
int fileno(FILE *stream);


int size = 1;
menu array[5];
FILE* file = NULL;


void loadMenu(){
	array[0].action = "Mem Display";
	array[0].f = printAddress;
	array[1].action = "File Display";
	array[1].f = readFromFIle;
	array[2].action = "File Modify";
	array[2].f = fileModify;
	array[3].action = "Copy From File";
	array[3].f = fileCopy;
	array[4].action = "Quit";
	array[4].f = quit;
}

void quit(char* filename, int size){
	exit(0);
}

void loadAddress(int* address,int* length){
    char i[80];
    printf("Enter Address:");
    while (scanf("%x", address)<=0) {
        printf("wrong Value \n Enter Address:");
        fgets(i,80,stdin);
    }
    printf("Enter length:");
    while (scanf("%d", length)<=0) {
       printf("wrong Value \n Enter length:");
       fgets(i,80,stdin); 
    }  
}

void printAddress(char* filename,int size){
	int address, length, i,j;
	loadAddress(&address,&length);
	unsigned char* raw_buf = (unsigned char*)malloc(size*sizeof(char));
	raw_buf = (unsigned char*)address;
	for(i=0;i<length;i++){
		for(j=size-1;j>=0;j--){
			printf("%02X",raw_buf[j]);
		}
		raw_buf += size;
		printf(" ");
	}
	printf("\n");
}

void readFromFIle(char* filename,int size){
	int address, length,i,j;
	unsigned char* raw_buf = (unsigned char*)malloc(size*sizeof(char));
	loadAddress(&address,&length);
	file = fopen(filename,"r+");
	if(file == NULL){
			perror("no such file!");
			exit(EXIT_FAILURE);
		}
	lseek(fileno(file),address,SEEK_SET);
	for(i=0;i<length;i++){
		read(fileno(file),raw_buf,size);
		for(j=0;j<size;j++){
		printf("%02X",raw_buf[j]);
	}
		raw_buf += size;
		printf(" ");
	}
	printf("\n");
}

 void locationVal(unsigned int* l ,unsigned int * v){
   char sentence[100];
   printf("Please enter <location> <val>:\n");
   fflush(stdin);
   fgets(sentence,100,stdin);
   fgets(sentence,100,stdin);

   sscanf(sentence,"%x %x",l,v);
    
 }

 void fileModify (char* filename,int size) {
    unsigned int location;
    unsigned int val;
   locationVal(&location,&val);
    file = fopen(filename, "r+");
    if (file==NULL) {
        printf("Problem with file!");
        return;
    }
    if (fseek(file,location,SEEK_SET)!=-1) {
        if (fwrite(&val,1,size,file)==0) {
            printf("Problem writing!");
            }
    }
    else {
        printf("Location problem!");
    }
    fclose(file);
    printf("\n");
}

void getData(char*file,int* s,int* t,int* l){
  printf("Please enter: source-file,s-location,t-location,length (separated by an ENTER)\n");
  while (scanf("%79s %x %x %d",file, s, t, l)<4) {
     printf("wrong Values \n  Please enter: source-file,s-location,t-location,length (separated by an ENTER)\n");
     fgets(file,79,stdin); 
}
}
void fileCopy( char* filename, int size) {
    char* ofile = (char*)malloc(80);
    int slocation,tlocation,length;
    getData(ofile,&slocation,&tlocation,&length);

    file = fopen(filename, "r+");
    if (file==NULL) {
        printf("Problem with file!");
        return;
    }
    FILE* iopen = fopen(ofile, "r");
    if (iopen==NULL) {
        printf("Problem with file!");
        return;
    }

    char buf;
    int i;

    if (fseek(file,tlocation,SEEK_SET)==-1 || fseek(iopen,slocation,SEEK_SET)==-1) {
        printf("Location problem!");
        exit(-1);
    }
    for (i=0;i<length;i++) {
        if (fread(&buf,1,size,iopen)<1) {
            printf("Problem writing!");
            break;
        }
        if (fwrite(&buf,1,size,file)<1) {
            puts("Problem reading!");
            break;
        }
    }
    free(ofile);
    fclose(iopen);
    fclose(file);
    printf("\n");
}

void printMenu(char* filename, int size){
	int i;
	for(i=0;i<5;i++){
		printf("%d-%s\n",i+1,array[i].action);
	}
}

void chooseOption(char* filename,int size){
	int i;
	scanf("%d",&i);
	array[i-1].f(filename,size);
}

int main(int argc,char** argv){
	char* filename;

	if(argc < 2){
		perror("missing arguments");
		exit(EXIT_FAILURE);
	}else if(argc < 3){
		file = fopen(argv[1],"r+");
		if(file == NULL){
			perror("no such file!");
			exit(EXIT_FAILURE);
		}
		filename = argv[1];
	}else{
		file = fopen(argv[1],"r+");
		if(file == NULL){
			perror("no such file!");
			exit(EXIT_FAILURE);
		}
		filename = argv[1];
		if(strcmp(argv[2],"2") || strcmp(argv[2],"4")){
			size = atoi(argv[2]);
		}
	}

	loadMenu();
	while(1){
	printf("File: %s, choose action:\n",filename);
	printMenu(filename,size);
	chooseOption(filename,size);
	}
	return 0;
}