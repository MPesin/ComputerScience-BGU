int open(char *name, int flags);
int close(int fd);
int read(int fd, char *buf, int size);
int write(int fd, char *buf, int size);
int strlen(char *s);

#define EUSAGE	"usage: lwc [filename]\n"
#define EARGC	"error: wrong number of arguments\n"
#define ENOFILE "error: cannot open file\n"

#define BUFSIZE 512 
char buffer[BUFSIZE];

#define WIDTH 64


/* print a string on stdout */
void print(char *s);

/* convert unsigned int to string */
char *utoa(int);

int main(int argc, char **argv) {
	int inp;
	int len;
	char *b, *c;
	int nlines = 0, nwords = 0, nchars = 0, in_word = 0;

	switch(--argc) {
	case 0: /* read from stdin by default*/ 
		inp = 0;
		break;
	case 1:
		if((inp = open(argv[1],0))==-1) {
			write(2, ENOFILE, strlen(ENOFILE));
			goto USAGE;
		}
		break;
	default:
		write(2, EARGC, strlen(EARGC));
		goto USAGE;
	}

	c = "\n"+1;
	while((len=read(inp, buffer, BUFSIZE))) {
		c = (b = buffer) + len;
		while(b!=c) {
			switch(*(b++)) {
			case '\n':  
				++nlines;
			case ' ': case '\t':
				in_word = 0;
				break;
			default:
				if(!in_word)
					++nwords;
				in_word = 1;
				break;
			}
			++nchars;
		}
	}
	if(*(c-1)!='\n') /* unterminated last line */
		++nlines;

	if(inp)               /* close descriptor if opened by the program */
		close(inp);

	print(utoa(nlines)); print(" lines\n");
	print(utoa(nwords)); print(" words\n");
	print(utoa(nchars)); print(" chars\n");

	return 0;

 USAGE:
	write(2, EUSAGE, strlen(EUSAGE));
	return 1;
}


void print(char *s) {
	write(1, s, strlen(s));
}

#define UTOA_BUFLEN 16
#define DIGITS "0123456789"

char *utoa(int i) {
	static char a[UTOA_BUFLEN], *b;
	a[UTOA_BUFLEN-1] = 0;
	b = a+UTOA_BUFLEN-1;
	if(i)
		while(i) {
			*(--b) = DIGITS[i%10];
			i/=10;
		}
	else
		*(--b) = '0';

	return b;
}
		
