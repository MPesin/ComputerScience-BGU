
_find:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	printf(1,"\t-size (+/-)n - Match only files/dirs/links with size bigger/smaller/equal to n.\n");
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	8b 51 04             	mov    0x4(%ecx),%edx
  
  if (argc < 2){
  19:	83 f8 01             	cmp    $0x1,%eax
	printf(1,"\t-size (+/-)n - Match only files/dirs/links with size bigger/smaller/equal to n.\n");
}

int
main(int argc, char *argv[])
{
  1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  
  if (argc < 2){
  22:	0f 8e e0 01 00 00    	jle    208 <main+0x208>
    printf(1,"find: Not enough arguments (path is required)\n");
    exit();
  }
  
  if (argc == 2 && strcmp(argv[1],"-help") == 0){
  28:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  2c:	0f 84 e9 01 00 00    	je     21b <main+0x21b>
    printusage();
    exit();
  }

  char* path = argv[1];
  32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  35:	bb 02 00 00 00       	mov    $0x2,%ebx
  3a:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  41:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  48:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  4f:	c7 45 d4 ca 0f 00 00 	movl   $0xfca,-0x2c(%ebp)
  56:	c7 45 d8 ca 0f 00 00 	movl   $0xfca,-0x28(%ebp)
  5d:	8b 40 04             	mov    0x4(%eax),%eax
  60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  67:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  6a:	eb 13                	jmp    7f <main+0x7f>
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (strcmp(argv[i],"-help") == 0){
	printusage();
        exit();
    }
    else if (strcmp(argv[i],"-follow") == 0){
        deref = 1;
  70:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  int len = 0;
  
  int i;

  /* Parsing arguments */
  for(i=2; i<argc; i++){
  77:	83 c3 01             	add    $0x1,%ebx
  7a:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
  7d:	7e 71                	jle    f0 <main+0xf0>
    if (strcmp(argv[i],"-help") == 0){
  7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  82:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
  89:	83 ec 08             	sub    $0x8,%esp
  8c:	68 5e 10 00 00       	push   $0x105e
  91:	8d 34 38             	lea    (%eax,%edi,1),%esi
  94:	ff 36                	pushl  (%esi)
  96:	e8 55 08 00 00       	call   8f0 <strcmp>
  9b:	83 c4 10             	add    $0x10,%esp
  9e:	85 c0                	test   %eax,%eax
  a0:	0f 84 44 01 00 00    	je     1ea <main+0x1ea>
	printusage();
        exit();
    }
    else if (strcmp(argv[i],"-follow") == 0){
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	68 64 10 00 00       	push   $0x1064
  ae:	ff 36                	pushl  (%esi)
  b0:	e8 3b 08 00 00       	call   8f0 <strcmp>
  b5:	83 c4 10             	add    $0x10,%esp
  b8:	85 c0                	test   %eax,%eax
  ba:	74 b4                	je     70 <main+0x70>
        deref = 1;
    }
    else if (strcmp(argv[i],"-name") == 0){
  bc:	83 ec 08             	sub    $0x8,%esp
  bf:	68 6c 10 00 00       	push   $0x106c
  c4:	ff 36                	pushl  (%esi)
  c6:	e8 25 08 00 00       	call   8f0 <strcmp>
  cb:	83 c4 10             	add    $0x10,%esp
  ce:	85 c0                	test   %eax,%eax
  d0:	75 46                	jne    118 <main+0x118>
        i = i + 1;
  d2:	83 c3 01             	add    $0x1,%ebx
        if (i >= argc){
  d5:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
  d8:	0f 8e 8e 01 00 00    	jle    26c <main+0x26c>
            printf(1,"Wrong usage. Name not specified after -name\n");
            exit();
        }
        name = argv[i];
  de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  int len = 0;
  
  int i;

  /* Parsing arguments */
  for(i=2; i<argc; i++){
  e1:	83 c3 01             	add    $0x1,%ebx
  e4:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
        i = i + 1;
        if (i >= argc){
            printf(1,"Wrong usage. Name not specified after -name\n");
            exit();
        }
        name = argv[i];
  e7:	8b 44 38 04          	mov    0x4(%eax,%edi,1),%eax
  eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int len = 0;
  
  int i;

  /* Parsing arguments */
  for(i=2; i<argc; i++){
  ee:	7f 8f                	jg     7f <main+0x7f>
        }
        
    }
  }

  find(path, deref, name, type, min_size, max_size, exact_size);
  f0:	50                   	push   %eax
  f1:	ff 75 cc             	pushl  -0x34(%ebp)
  f4:	ff 75 c8             	pushl  -0x38(%ebp)
  f7:	ff 75 d0             	pushl  -0x30(%ebp)
  fa:	ff 75 d4             	pushl  -0x2c(%ebp)
  fd:	ff 75 d8             	pushl  -0x28(%ebp)
 100:	ff 75 dc             	pushl  -0x24(%ebp)
 103:	ff 75 c4             	pushl  -0x3c(%ebp)
 106:	e8 e5 02 00 00       	call   3f0 <find>
  exit();
 10b:	83 c4 20             	add    $0x20,%esp
 10e:	e8 ef 09 00 00       	call   b02 <exit>
 113:	90                   	nop
 114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            printf(1,"Wrong usage. Name not specified after -name\n");
            exit();
        }
        name = argv[i];
    }
    else if (strcmp(argv[i],"-type") == 0){
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	68 72 10 00 00       	push   $0x1072
 120:	ff 36                	pushl  (%esi)
 122:	e8 c9 07 00 00       	call   8f0 <strcmp>
 127:	83 c4 10             	add    $0x10,%esp
 12a:	85 c0                	test   %eax,%eax
 12c:	75 1b                	jne    149 <main+0x149>
        i = i + 1;
 12e:	83 c3 01             	add    $0x1,%ebx
        if (i >= argc){
 131:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
 134:	0f 8e 45 01 00 00    	jle    27f <main+0x27f>
            printf(1,"Wrong usage. Type not specified after -type\n");
            exit();
        }
        type = argv[i];
 13a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 13d:	8b 44 38 04          	mov    0x4(%eax,%edi,1),%eax
 141:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 144:	e9 2e ff ff ff       	jmp    77 <main+0x77>
    }
    else if (strcmp(argv[i],"-size") == 0){
 149:	51                   	push   %ecx
 14a:	51                   	push   %ecx
 14b:	68 78 10 00 00       	push   $0x1078
 150:	ff 36                	pushl  (%esi)
 152:	e8 99 07 00 00       	call   8f0 <strcmp>
 157:	83 c4 10             	add    $0x10,%esp
 15a:	85 c0                	test   %eax,%eax
 15c:	0f 85 15 ff ff ff    	jne    77 <main+0x77>
        i = i + 1;
 162:	83 c3 01             	add    $0x1,%ebx
        if (i >= argc){
 165:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
 168:	0f 8e 24 01 00 00    	jle    292 <main+0x292>
            printf(1,"Wrong usage. Size not specified after -size\n");
            exit();
        }
        len = strlen(argv[i]);
 16e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 171:	83 ec 0c             	sub    $0xc,%esp
 174:	8d 7c 38 04          	lea    0x4(%eax,%edi,1),%edi
 178:	ff 37                	pushl  (%edi)
 17a:	e8 c1 07 00 00       	call   940 <strlen>
        if (argv[i][0] != '+' && argv[i][0] != '-'){
 17f:	8b 17                	mov    (%edi),%edx
        i = i + 1;
        if (i >= argc){
            printf(1,"Wrong usage. Size not specified after -size\n");
            exit();
        }
        len = strlen(argv[i]);
 181:	89 c6                	mov    %eax,%esi
        if (argv[i][0] != '+' && argv[i][0] != '-'){
 183:	83 c4 10             	add    $0x10,%esp
 186:	0f b6 02             	movzbl (%edx),%eax
 189:	83 e8 2b             	sub    $0x2b,%eax
 18c:	a8 fd                	test   $0xfd,%al
 18e:	75 64                	jne    1f4 <main+0x1f4>
            exact_size = atoi(argv[i]);
        }else{
            char num[len];
 190:	8d 46 0f             	lea    0xf(%esi),%eax
            exit();
        }
        len = strlen(argv[i]);
        if (argv[i][0] != '+' && argv[i][0] != '-'){
            exact_size = atoi(argv[i]);
        }else{
 193:	89 65 c0             	mov    %esp,-0x40(%ebp)
            char num[len];
 196:	83 e0 f0             	and    $0xfffffff0,%eax
 199:	29 c4                	sub    %eax,%esp
            int j;
            for (j=1;j<len;j++)
 19b:	83 fe 01             	cmp    $0x1,%esi
 19e:	b8 01 00 00 00       	mov    $0x1,%eax
        }
        len = strlen(argv[i]);
        if (argv[i][0] != '+' && argv[i][0] != '-'){
            exact_size = atoi(argv[i]);
        }else{
            char num[len];
 1a3:	89 e1                	mov    %esp,%ecx
            int j;
            for (j=1;j<len;j++)
 1a5:	7e 1b                	jle    1c2 <main+0x1c2>
 1a7:	89 5d bc             	mov    %ebx,-0x44(%ebp)
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                num[j-1] = argv[i][j];
 1b0:	0f b6 1c 02          	movzbl (%edx,%eax,1),%ebx
 1b4:	88 5c 01 ff          	mov    %bl,-0x1(%ecx,%eax,1)
        if (argv[i][0] != '+' && argv[i][0] != '-'){
            exact_size = atoi(argv[i]);
        }else{
            char num[len];
            int j;
            for (j=1;j<len;j++)
 1b8:	83 c0 01             	add    $0x1,%eax
 1bb:	39 c6                	cmp    %eax,%esi
 1bd:	75 f1                	jne    1b0 <main+0x1b0>
 1bf:	8b 5d bc             	mov    -0x44(%ebp),%ebx
                num[j-1] = argv[i][j];
            num[len] = '\0';
            len = atoi(num);
 1c2:	83 ec 0c             	sub    $0xc,%esp
        }else{
            char num[len];
            int j;
            for (j=1;j<len;j++)
                num[j-1] = argv[i][j];
            num[len] = '\0';
 1c5:	c6 04 31 00          	movb   $0x0,(%ecx,%esi,1)
            len = atoi(num);
 1c9:	51                   	push   %ecx
 1ca:	e8 c1 08 00 00       	call   a90 <atoi>
            if (argv[i][0] == '+'){
 1cf:	8b 17                	mov    (%edi),%edx
 1d1:	83 c4 10             	add    $0x10,%esp
 1d4:	80 3a 2b             	cmpb   $0x2b,(%edx)
 1d7:	74 06                	je     1df <main+0x1df>
                min_size = len;
            }
            else{
                max_size = len;
 1d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
            int j;
            for (j=1;j<len;j++)
                num[j-1] = argv[i][j];
            num[len] = '\0';
            len = atoi(num);
            if (argv[i][0] == '+'){
 1dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
 1df:	89 45 d0             	mov    %eax,-0x30(%ebp)
 1e2:	8b 65 c0             	mov    -0x40(%ebp),%esp
 1e5:	e9 8d fe ff ff       	jmp    77 <main+0x77>
    printf(1,"find: Not enough arguments (path is required)\n");
    exit();
  }
  
  if (argc == 2 && strcmp(argv[1],"-help") == 0){
    printusage();
 1ea:	e8 11 06 00 00       	call   800 <printusage>
    exit();
 1ef:	e8 0e 09 00 00       	call   b02 <exit>
            printf(1,"Wrong usage. Size not specified after -size\n");
            exit();
        }
        len = strlen(argv[i]);
        if (argv[i][0] != '+' && argv[i][0] != '-'){
            exact_size = atoi(argv[i]);
 1f4:	83 ec 0c             	sub    $0xc,%esp
 1f7:	52                   	push   %edx
 1f8:	e8 93 08 00 00       	call   a90 <atoi>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 cc             	mov    %eax,-0x34(%ebp)
 203:	e9 6f fe ff ff       	jmp    77 <main+0x77>
int
main(int argc, char *argv[])
{
  
  if (argc < 2){
    printf(1,"find: Not enough arguments (path is required)\n");
 208:	50                   	push   %eax
 209:	50                   	push   %eax
 20a:	68 e0 11 00 00       	push   $0x11e0
 20f:	6a 01                	push   $0x1
 211:	e8 5a 0a 00 00       	call   c70 <printf>
    exit();
 216:	e8 e7 08 00 00       	call   b02 <exit>
  }
  
  if (argc == 2 && strcmp(argv[1],"-help") == 0){
 21b:	57                   	push   %edi
 21c:	57                   	push   %edi
 21d:	68 5e 10 00 00       	push   $0x105e
 222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 225:	ff 70 04             	pushl  0x4(%eax)
 228:	e8 c3 06 00 00       	call   8f0 <strcmp>
 22d:	83 c4 10             	add    $0x10,%esp
 230:	85 c0                	test   %eax,%eax
 232:	74 b6                	je     1ea <main+0x1ea>
    printusage();
    exit();
  }

  char* path = argv[1];
 234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  int deref = 0;
  char* name = "*";
  char* type = "*";
  int min_size = -1;
  int max_size = -1;
  int exact_size = -1;
 237:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  /* Default values */
  int deref = 0;
  char* name = "*";
  char* type = "*";
  int min_size = -1;
  int max_size = -1;
 23e:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  
  /* Default values */
  int deref = 0;
  char* name = "*";
  char* type = "*";
  int min_size = -1;
 245:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  char* path = argv[1];
  
  /* Default values */
  int deref = 0;
  char* name = "*";
  char* type = "*";
 24c:	c7 45 d4 ca 0f 00 00 	movl   $0xfca,-0x2c(%ebp)

  char* path = argv[1];
  
  /* Default values */
  int deref = 0;
  char* name = "*";
 253:	c7 45 d8 ca 0f 00 00 	movl   $0xfca,-0x28(%ebp)
  if (argc == 2 && strcmp(argv[1],"-help") == 0){
    printusage();
    exit();
  }

  char* path = argv[1];
 25a:	8b 40 04             	mov    0x4(%eax),%eax
  
  /* Default values */
  int deref = 0;
 25d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if (argc == 2 && strcmp(argv[1],"-help") == 0){
    printusage();
    exit();
  }

  char* path = argv[1];
 264:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 267:	e9 84 fe ff ff       	jmp    f0 <main+0xf0>
        deref = 1;
    }
    else if (strcmp(argv[i],"-name") == 0){
        i = i + 1;
        if (i >= argc){
            printf(1,"Wrong usage. Name not specified after -name\n");
 26c:	56                   	push   %esi
 26d:	56                   	push   %esi
 26e:	68 10 12 00 00       	push   $0x1210
 273:	6a 01                	push   $0x1
 275:	e8 f6 09 00 00       	call   c70 <printf>
            exit();
 27a:	e8 83 08 00 00       	call   b02 <exit>
        name = argv[i];
    }
    else if (strcmp(argv[i],"-type") == 0){
        i = i + 1;
        if (i >= argc){
            printf(1,"Wrong usage. Type not specified after -type\n");
 27f:	53                   	push   %ebx
 280:	53                   	push   %ebx
 281:	68 40 12 00 00       	push   $0x1240
 286:	6a 01                	push   $0x1
 288:	e8 e3 09 00 00       	call   c70 <printf>
            exit();
 28d:	e8 70 08 00 00       	call   b02 <exit>
        type = argv[i];
    }
    else if (strcmp(argv[i],"-size") == 0){
        i = i + 1;
        if (i >= argc){
            printf(1,"Wrong usage. Size not specified after -size\n");
 292:	52                   	push   %edx
 293:	52                   	push   %edx
 294:	68 70 12 00 00       	push   $0x1270
 299:	6a 01                	push   $0x1
 29b:	e8 d0 09 00 00       	call   c70 <printf>
            exit();
 2a0:	e8 5d 08 00 00       	call   b02 <exit>
 2a5:	66 90                	xchg   %ax,%ax
 2a7:	66 90                	xchg   %ax,%ax
 2a9:	66 90                	xchg   %ax,%ax
 2ab:	66 90                	xchg   %ax,%ax
 2ad:	66 90                	xchg   %ax,%ax
 2af:	90                   	nop

000002b0 <fmtname>:
#include "fs.h"
#include "fcntl.h"

char*
fmtname(char *path)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	56                   	push   %esi
 2b4:	53                   	push   %ebx
 2b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 2b8:	83 ec 0c             	sub    $0xc,%esp
 2bb:	53                   	push   %ebx
 2bc:	e8 7f 06 00 00       	call   940 <strlen>
 2c1:	83 c4 10             	add    $0x10,%esp
 2c4:	01 d8                	add    %ebx,%eax
 2c6:	73 0f                	jae    2d7 <fmtname+0x27>
 2c8:	eb 12                	jmp    2dc <fmtname+0x2c>
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2d0:	83 e8 01             	sub    $0x1,%eax
 2d3:	39 c3                	cmp    %eax,%ebx
 2d5:	77 05                	ja     2dc <fmtname+0x2c>
 2d7:	80 38 2f             	cmpb   $0x2f,(%eax)
 2da:	75 f4                	jne    2d0 <fmtname+0x20>
    ;
  p++;
 2dc:	8d 58 01             	lea    0x1(%eax),%ebx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
 2df:	83 ec 0c             	sub    $0xc,%esp
 2e2:	53                   	push   %ebx
 2e3:	e8 58 06 00 00       	call   940 <strlen>
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	83 f8 0d             	cmp    $0xd,%eax
 2ee:	77 4a                	ja     33a <fmtname+0x8a>
    return p;
  memmove(buf, p, strlen(p));
 2f0:	83 ec 0c             	sub    $0xc,%esp
 2f3:	53                   	push   %ebx
 2f4:	e8 47 06 00 00       	call   940 <strlen>
 2f9:	83 c4 0c             	add    $0xc,%esp
 2fc:	50                   	push   %eax
 2fd:	53                   	push   %ebx
 2fe:	68 1c 16 00 00       	push   $0x161c
 303:	e8 c8 07 00 00       	call   ad0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 308:	89 1c 24             	mov    %ebx,(%esp)
 30b:	e8 30 06 00 00       	call   940 <strlen>
 310:	89 1c 24             	mov    %ebx,(%esp)
 313:	89 c6                	mov    %eax,%esi
  return buf;
 315:	bb 1c 16 00 00       	mov    $0x161c,%ebx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 31a:	e8 21 06 00 00       	call   940 <strlen>
 31f:	ba 0e 00 00 00       	mov    $0xe,%edx
 324:	83 c4 0c             	add    $0xc,%esp
 327:	05 1c 16 00 00       	add    $0x161c,%eax
 32c:	29 f2                	sub    %esi,%edx
 32e:	52                   	push   %edx
 32f:	6a 20                	push   $0x20
 331:	50                   	push   %eax
 332:	e8 39 06 00 00       	call   970 <memset>
  return buf;
 337:	83 c4 10             	add    $0x10,%esp
}
 33a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 33d:	89 d8                	mov    %ebx,%eax
 33f:	5b                   	pop    %ebx
 340:	5e                   	pop    %esi
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <basename>:

char* basename(char *path)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	56                   	push   %esi
 354:	53                   	push   %ebx
 355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 358:	83 ec 0c             	sub    $0xc,%esp
 35b:	53                   	push   %ebx
 35c:	e8 df 05 00 00       	call   940 <strlen>
 361:	83 c4 10             	add    $0x10,%esp
 364:	01 d8                	add    %ebx,%eax
 366:	73 0f                	jae    377 <basename+0x27>
 368:	eb 12                	jmp    37c <basename+0x2c>
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 370:	83 e8 01             	sub    $0x1,%eax
 373:	39 c3                	cmp    %eax,%ebx
 375:	77 05                	ja     37c <basename+0x2c>
 377:	80 38 2f             	cmpb   $0x2f,(%eax)
 37a:	75 f4                	jne    370 <basename+0x20>
    ;
  p++;
 37c:	8d 58 01             	lea    0x1(%eax),%ebx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
 37f:	83 ec 0c             	sub    $0xc,%esp
 382:	53                   	push   %ebx
 383:	e8 b8 05 00 00       	call   940 <strlen>
 388:	83 c4 10             	add    $0x10,%esp
 38b:	83 f8 0d             	cmp    $0xd,%eax
 38e:	77 4a                	ja     3da <basename+0x8a>
    return p;
  memmove(buf, p, strlen(p));
 390:	83 ec 0c             	sub    $0xc,%esp
 393:	53                   	push   %ebx
 394:	e8 a7 05 00 00       	call   940 <strlen>
 399:	83 c4 0c             	add    $0xc,%esp
 39c:	50                   	push   %eax
 39d:	53                   	push   %ebx
 39e:	68 0c 16 00 00       	push   $0x160c
 3a3:	e8 28 07 00 00       	call   ad0 <memmove>
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
 3a8:	89 1c 24             	mov    %ebx,(%esp)
 3ab:	e8 90 05 00 00       	call   940 <strlen>
 3b0:	89 1c 24             	mov    %ebx,(%esp)
 3b3:	89 c6                	mov    %eax,%esi
  return buf;
 3b5:	bb 0c 16 00 00       	mov    $0x160c,%ebx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
 3ba:	e8 81 05 00 00       	call   940 <strlen>
 3bf:	ba 0e 00 00 00       	mov    $0xe,%edx
 3c4:	83 c4 0c             	add    $0xc,%esp
 3c7:	05 0c 16 00 00       	add    $0x160c,%eax
 3cc:	29 f2                	sub    %esi,%edx
 3ce:	52                   	push   %edx
 3cf:	6a 00                	push   $0x0
 3d1:	50                   	push   %eax
 3d2:	e8 99 05 00 00       	call   970 <memset>
  return buf;
 3d7:	83 c4 10             	add    $0x10,%esp
}
 3da:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3dd:	89 d8                	mov    %ebx,%eax
 3df:	5b                   	pop    %ebx
 3e0:	5e                   	pop    %esi
 3e1:	5d                   	pop    %ebp
 3e2:	c3                   	ret    
 3e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <find>:

void find(char* path, int deref, char* name, char* type, int min_size, int max_size, int exact_size){
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	81 ec 4c 02 00 00    	sub    $0x24c,%esp
    struct dirent de;
    struct stat st;
    char* basenamed;
    char buf[512], *p;
    
    if (deref){
 3fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
  return buf;
}

void find(char* path, int deref, char* name, char* type, int min_size, int max_size, int exact_size){
 3ff:	8b 75 08             	mov    0x8(%ebp),%esi
    struct dirent de;
    struct stat st;
    char* basenamed;
    char buf[512], *p;
    
    if (deref){
 402:	85 c0                	test   %eax,%eax
 404:	74 7a                	je     480 <find+0x90>
        fd = open(path, 0);
 406:	83 ec 08             	sub    $0x8,%esp
 409:	6a 00                	push   $0x0
 40b:	56                   	push   %esi
 40c:	e8 31 07 00 00       	call   b42 <open>
 411:	89 c3                	mov    %eax,%ebx
 413:	83 c4 10             	add    $0x10,%esp
    }else{
        fd = open(path, O_NODEREF);
    }
    
    if (fd < 0){
 416:	85 db                	test   %ebx,%ebx
 418:	78 7a                	js     494 <find+0xa4>
        printf(2, "find: cannot open path: %s\n", path);
        return;
    }
    
    if(fstat(fd, &st) < 0){
 41a:	8d 85 d4 fd ff ff    	lea    -0x22c(%ebp),%eax
 420:	83 ec 08             	sub    $0x8,%esp
 423:	50                   	push   %eax
 424:	53                   	push   %ebx
 425:	e8 30 07 00 00       	call   b5a <fstat>
 42a:	83 c4 10             	add    $0x10,%esp
 42d:	85 c0                	test   %eax,%eax
 42f:	0f 88 a3 02 00 00    	js     6d8 <find+0x2e8>
        printf(2, "find: cannot stat path: %s\n", path);
        close(fd);
        return;
    }
    
    basenamed = basename(path);
 435:	83 ec 0c             	sub    $0xc,%esp
 438:	56                   	push   %esi
 439:	e8 12 ff ff ff       	call   350 <basename>
 43e:	89 c7                	mov    %eax,%edi
    
    switch(st.type){
 440:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 447:	83 c4 10             	add    $0x10,%esp
 44a:	66 83 f8 02          	cmp    $0x2,%ax
 44e:	74 60                	je     4b0 <find+0xc0>
 450:	66 83 f8 04          	cmp    $0x4,%ax
 454:	0f 84 a6 02 00 00    	je     700 <find+0x310>
 45a:	66 83 f8 01          	cmp    $0x1,%ax
 45e:	0f 84 ec 00 00 00    	je     550 <find+0x160>
              find(buf, deref, name, type, min_size, max_size, exact_size);
            }
            break;
    }
    
    close(fd);
 464:	83 ec 0c             	sub    $0xc,%esp
 467:	53                   	push   %ebx
 468:	e8 bd 06 00 00       	call   b2a <close>
 46d:	83 c4 10             	add    $0x10,%esp
    
}
 470:	8d 65 f4             	lea    -0xc(%ebp),%esp
 473:	5b                   	pop    %ebx
 474:	5e                   	pop    %esi
 475:	5f                   	pop    %edi
 476:	5d                   	pop    %ebp
 477:	c3                   	ret    
 478:	90                   	nop
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    char buf[512], *p;
    
    if (deref){
        fd = open(path, 0);
    }else{
        fd = open(path, O_NODEREF);
 480:	83 ec 08             	sub    $0x8,%esp
 483:	6a 04                	push   $0x4
 485:	56                   	push   %esi
 486:	e8 b7 06 00 00       	call   b42 <open>
 48b:	89 c3                	mov    %eax,%ebx
 48d:	83 c4 10             	add    $0x10,%esp
    }
    
    if (fd < 0){
 490:	85 db                	test   %ebx,%ebx
 492:	79 86                	jns    41a <find+0x2a>
        printf(2, "find: cannot open path: %s\n", path);
 494:	83 ec 04             	sub    $0x4,%esp
 497:	56                   	push   %esi
 498:	68 90 0f 00 00       	push   $0xf90
 49d:	6a 02                	push   $0x2
 49f:	e8 cc 07 00 00       	call   c70 <printf>
        return;
 4a4:	83 c4 10             	add    $0x10,%esp
            break;
    }
    
    close(fd);
    
}
 4a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4aa:	5b                   	pop    %ebx
 4ab:	5e                   	pop    %esi
 4ac:	5f                   	pop    %edi
 4ad:	5d                   	pop    %ebp
 4ae:	c3                   	ret    
 4af:	90                   	nop
                && (exact_size == -1 || exact_size == st.size)){
                    printf(1,"FOUND Link: %s\n",path);
                }
            break;
        case T_FILE:
            if ((strcmp(type,"f") == 0 || strcmp(type,"*") == 0)
 4b0:	83 ec 08             	sub    $0x8,%esp
 4b3:	68 dc 0f 00 00       	push   $0xfdc
 4b8:	ff 75 14             	pushl  0x14(%ebp)
 4bb:	e8 30 04 00 00       	call   8f0 <strcmp>
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	85 c0                	test   %eax,%eax
 4c5:	74 17                	je     4de <find+0xee>
 4c7:	83 ec 08             	sub    $0x8,%esp
 4ca:	68 ca 0f 00 00       	push   $0xfca
 4cf:	ff 75 14             	pushl  0x14(%ebp)
 4d2:	e8 19 04 00 00       	call   8f0 <strcmp>
 4d7:	83 c4 10             	add    $0x10,%esp
 4da:	85 c0                	test   %eax,%eax
 4dc:	75 86                	jne    464 <find+0x74>
                && (strcmp(name,"*") == 0 || strcmp(name,basenamed) == 0) 
 4de:	83 ec 08             	sub    $0x8,%esp
 4e1:	68 ca 0f 00 00       	push   $0xfca
 4e6:	ff 75 10             	pushl  0x10(%ebp)
 4e9:	e8 02 04 00 00       	call   8f0 <strcmp>
 4ee:	83 c4 10             	add    $0x10,%esp
 4f1:	85 c0                	test   %eax,%eax
 4f3:	0f 85 a7 02 00 00    	jne    7a0 <find+0x3b0>
                && (min_size == -1 || st.size > min_size) 
 4f9:	83 7d 18 ff          	cmpl   $0xffffffff,0x18(%ebp)
 4fd:	74 0f                	je     50e <find+0x11e>
 4ff:	8b 45 18             	mov    0x18(%ebp),%eax
 502:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 508:	0f 86 56 ff ff ff    	jbe    464 <find+0x74>
                && (max_size == -1 || st.size < max_size) 
 50e:	83 7d 1c ff          	cmpl   $0xffffffff,0x1c(%ebp)
 512:	74 0f                	je     523 <find+0x133>
 514:	8b 45 1c             	mov    0x1c(%ebp),%eax
 517:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 51d:	0f 83 41 ff ff ff    	jae    464 <find+0x74>
                && (exact_size == -1 || exact_size == st.size)){
 523:	83 7d 20 ff          	cmpl   $0xffffffff,0x20(%ebp)
 527:	74 0f                	je     538 <find+0x148>
 529:	8b 45 20             	mov    0x20(%ebp),%eax
 52c:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 532:	0f 85 2c ff ff ff    	jne    464 <find+0x74>
                    printf(1,"FOUND File: %s\n",path);
 538:	83 ec 04             	sub    $0x4,%esp
 53b:	56                   	push   %esi
 53c:	68 de 0f 00 00       	push   $0xfde
 541:	6a 01                	push   $0x1
 543:	e8 28 07 00 00       	call   c70 <printf>
 548:	83 c4 10             	add    $0x10,%esp
 54b:	e9 14 ff ff ff       	jmp    464 <find+0x74>
                }
            break;
            
        case T_DIR:
            if ((strcmp(type,"d") == 0 || strcmp(type,"*") == 0)
 550:	83 ec 08             	sub    $0x8,%esp
 553:	68 ee 0f 00 00       	push   $0xfee
 558:	ff 75 14             	pushl  0x14(%ebp)
 55b:	e8 90 03 00 00       	call   8f0 <strcmp>
 560:	83 c4 10             	add    $0x10,%esp
 563:	85 c0                	test   %eax,%eax
 565:	74 17                	je     57e <find+0x18e>
 567:	83 ec 08             	sub    $0x8,%esp
 56a:	68 ca 0f 00 00       	push   $0xfca
 56f:	ff 75 14             	pushl  0x14(%ebp)
 572:	e8 79 03 00 00       	call   8f0 <strcmp>
 577:	83 c4 10             	add    $0x10,%esp
 57a:	85 c0                	test   %eax,%eax
 57c:	75 34                	jne    5b2 <find+0x1c2>
                && (strcmp(name,"*") == 0 || strcmp(name,basenamed) == 0) 
 57e:	83 ec 08             	sub    $0x8,%esp
 581:	68 ca 0f 00 00       	push   $0xfca
 586:	ff 75 10             	pushl  0x10(%ebp)
 589:	e8 62 03 00 00       	call   8f0 <strcmp>
 58e:	83 c4 10             	add    $0x10,%esp
 591:	85 c0                	test   %eax,%eax
 593:	0f 85 47 02 00 00    	jne    7e0 <find+0x3f0>
                && (min_size == -1 || st.size > min_size) 
 599:	83 7d 18 ff          	cmpl   $0xffffffff,0x18(%ebp)
 59d:	0f 84 ed 00 00 00    	je     690 <find+0x2a0>
 5a3:	8b 45 18             	mov    0x18(%ebp),%eax
 5a6:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 5ac:	0f 87 de 00 00 00    	ja     690 <find+0x2a0>
                && (max_size == -1 || st.size < max_size) 
                && (exact_size == -1 || exact_size == st.size)){
                    printf(1,"FOUND Directory: %s\n",path);
            }
            strcpy(buf, path);
 5b2:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 5b8:	83 ec 08             	sub    $0x8,%esp
 5bb:	56                   	push   %esi
 5bc:	8d b5 c4 fd ff ff    	lea    -0x23c(%ebp),%esi
 5c2:	57                   	push   %edi
 5c3:	e8 f8 02 00 00       	call   8c0 <strcpy>
            p = buf+strlen(buf);
 5c8:	89 3c 24             	mov    %edi,(%esp)
 5cb:	e8 70 03 00 00       	call   940 <strlen>
 5d0:	8d 14 07             	lea    (%edi,%eax,1),%edx
            *p++ = '/';
 5d3:	8d 44 07 01          	lea    0x1(%edi,%eax,1),%eax
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
 5d7:	83 c4 10             	add    $0x10,%esp
                && (max_size == -1 || st.size < max_size) 
                && (exact_size == -1 || exact_size == st.size)){
                    printf(1,"FOUND Directory: %s\n",path);
            }
            strcpy(buf, path);
            p = buf+strlen(buf);
 5da:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
            *p++ = '/';
 5e0:	89 85 b0 fd ff ff    	mov    %eax,-0x250(%ebp)
 5e6:	c6 02 2f             	movb   $0x2f,(%edx)
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	6a 10                	push   $0x10
 5f5:	56                   	push   %esi
 5f6:	53                   	push   %ebx
 5f7:	e8 1e 05 00 00       	call   b1a <read>
 5fc:	83 c4 10             	add    $0x10,%esp
 5ff:	83 f8 10             	cmp    $0x10,%eax
 602:	0f 85 5c fe ff ff    	jne    464 <find+0x74>
              if(de.inum == 0 || strcmp(de.name,".")==0 || strcmp(de.name,"..")==0)
 608:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 60f:	00 
 610:	74 de                	je     5f0 <find+0x200>
 612:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 618:	83 ec 08             	sub    $0x8,%esp
 61b:	68 06 10 00 00       	push   $0x1006
 620:	50                   	push   %eax
 621:	e8 ca 02 00 00       	call   8f0 <strcmp>
 626:	83 c4 10             	add    $0x10,%esp
 629:	85 c0                	test   %eax,%eax
 62b:	74 c3                	je     5f0 <find+0x200>
 62d:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 633:	83 ec 08             	sub    $0x8,%esp
 636:	68 05 10 00 00       	push   $0x1005
 63b:	50                   	push   %eax
 63c:	e8 af 02 00 00       	call   8f0 <strcmp>
 641:	83 c4 10             	add    $0x10,%esp
 644:	85 c0                	test   %eax,%eax
 646:	74 a8                	je     5f0 <find+0x200>
                continue;
              memmove(p, de.name, DIRSIZ);
 648:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 64e:	83 ec 04             	sub    $0x4,%esp
 651:	6a 0e                	push   $0xe
 653:	50                   	push   %eax
 654:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 65a:	e8 71 04 00 00       	call   ad0 <memmove>
              p[DIRSIZ] = 0;
 65f:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax

              //printf(1,"DEBUG: Calling find with path: %s\n",buf);
              find(buf, deref, name, type, min_size, max_size, exact_size);
 665:	83 c4 0c             	add    $0xc,%esp
            *p++ = '/';
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
              if(de.inum == 0 || strcmp(de.name,".")==0 || strcmp(de.name,"..")==0)
                continue;
              memmove(p, de.name, DIRSIZ);
              p[DIRSIZ] = 0;
 668:	c6 40 0f 00          	movb   $0x0,0xf(%eax)

              //printf(1,"DEBUG: Calling find with path: %s\n",buf);
              find(buf, deref, name, type, min_size, max_size, exact_size);
 66c:	ff 75 20             	pushl  0x20(%ebp)
 66f:	ff 75 1c             	pushl  0x1c(%ebp)
 672:	ff 75 18             	pushl  0x18(%ebp)
 675:	ff 75 14             	pushl  0x14(%ebp)
 678:	ff 75 10             	pushl  0x10(%ebp)
 67b:	ff 75 0c             	pushl  0xc(%ebp)
 67e:	57                   	push   %edi
 67f:	e8 6c fd ff ff       	call   3f0 <find>
 684:	83 c4 20             	add    $0x20,%esp
 687:	e9 64 ff ff ff       	jmp    5f0 <find+0x200>
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            
        case T_DIR:
            if ((strcmp(type,"d") == 0 || strcmp(type,"*") == 0)
                && (strcmp(name,"*") == 0 || strcmp(name,basenamed) == 0) 
                && (min_size == -1 || st.size > min_size) 
                && (max_size == -1 || st.size < max_size) 
 690:	83 7d 1c ff          	cmpl   $0xffffffff,0x1c(%ebp)
 694:	74 0f                	je     6a5 <find+0x2b5>
 696:	8b 45 1c             	mov    0x1c(%ebp),%eax
 699:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 69f:	0f 83 0d ff ff ff    	jae    5b2 <find+0x1c2>
                && (exact_size == -1 || exact_size == st.size)){
 6a5:	83 7d 20 ff          	cmpl   $0xffffffff,0x20(%ebp)
 6a9:	74 0f                	je     6ba <find+0x2ca>
 6ab:	8b 45 20             	mov    0x20(%ebp),%eax
 6ae:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 6b4:	0f 85 f8 fe ff ff    	jne    5b2 <find+0x1c2>
                    printf(1,"FOUND Directory: %s\n",path);
 6ba:	83 ec 04             	sub    $0x4,%esp
 6bd:	56                   	push   %esi
 6be:	68 f0 0f 00 00       	push   $0xff0
 6c3:	6a 01                	push   $0x1
 6c5:	e8 a6 05 00 00       	call   c70 <printf>
 6ca:	83 c4 10             	add    $0x10,%esp
 6cd:	e9 e0 fe ff ff       	jmp    5b2 <find+0x1c2>
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(2, "find: cannot open path: %s\n", path);
        return;
    }
    
    if(fstat(fd, &st) < 0){
        printf(2, "find: cannot stat path: %s\n", path);
 6d8:	83 ec 04             	sub    $0x4,%esp
 6db:	56                   	push   %esi
 6dc:	68 ac 0f 00 00       	push   $0xfac
 6e1:	6a 02                	push   $0x2
 6e3:	e8 88 05 00 00       	call   c70 <printf>
        close(fd);
 6e8:	89 1c 24             	mov    %ebx,(%esp)
 6eb:	e8 3a 04 00 00       	call   b2a <close>
        return;
 6f0:	83 c4 10             	add    $0x10,%esp
            break;
    }
    
    close(fd);
    
}
 6f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f6:	5b                   	pop    %ebx
 6f7:	5e                   	pop    %esi
 6f8:	5f                   	pop    %edi
 6f9:	5d                   	pop    %ebp
 6fa:	c3                   	ret    
 6fb:	90                   	nop
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    basenamed = basename(path);
    
    switch(st.type){
        
        case T_SYMLINK:
            if ((strcmp(type,"s") == 0 || strcmp(type,"*") == 0)
 700:	83 ec 08             	sub    $0x8,%esp
 703:	68 c8 0f 00 00       	push   $0xfc8
 708:	ff 75 14             	pushl  0x14(%ebp)
 70b:	e8 e0 01 00 00       	call   8f0 <strcmp>
 710:	83 c4 10             	add    $0x10,%esp
 713:	85 c0                	test   %eax,%eax
 715:	74 1b                	je     732 <find+0x342>
 717:	83 ec 08             	sub    $0x8,%esp
 71a:	68 ca 0f 00 00       	push   $0xfca
 71f:	ff 75 14             	pushl  0x14(%ebp)
 722:	e8 c9 01 00 00       	call   8f0 <strcmp>
 727:	83 c4 10             	add    $0x10,%esp
 72a:	85 c0                	test   %eax,%eax
 72c:	0f 85 32 fd ff ff    	jne    464 <find+0x74>
                && (strcmp(name,"*") == 0 || strcmp(name,basenamed) == 0) 
 732:	83 ec 08             	sub    $0x8,%esp
 735:	68 ca 0f 00 00       	push   $0xfca
 73a:	ff 75 10             	pushl  0x10(%ebp)
 73d:	e8 ae 01 00 00       	call   8f0 <strcmp>
 742:	83 c4 10             	add    $0x10,%esp
 745:	85 c0                	test   %eax,%eax
 747:	75 77                	jne    7c0 <find+0x3d0>
                && (min_size == -1 || st.size > min_size) 
 749:	83 7d 18 ff          	cmpl   $0xffffffff,0x18(%ebp)
 74d:	74 0f                	je     75e <find+0x36e>
 74f:	8b 45 18             	mov    0x18(%ebp),%eax
 752:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 758:	0f 86 06 fd ff ff    	jbe    464 <find+0x74>
                && (max_size == -1 || st.size < max_size) 
 75e:	83 7d 1c ff          	cmpl   $0xffffffff,0x1c(%ebp)
 762:	74 0f                	je     773 <find+0x383>
 764:	8b 45 1c             	mov    0x1c(%ebp),%eax
 767:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 76d:	0f 83 f1 fc ff ff    	jae    464 <find+0x74>
                && (exact_size == -1 || exact_size == st.size)){
 773:	83 7d 20 ff          	cmpl   $0xffffffff,0x20(%ebp)
 777:	74 0f                	je     788 <find+0x398>
 779:	8b 45 20             	mov    0x20(%ebp),%eax
 77c:	39 85 e4 fd ff ff    	cmp    %eax,-0x21c(%ebp)
 782:	0f 85 dc fc ff ff    	jne    464 <find+0x74>
                    printf(1,"FOUND Link: %s\n",path);
 788:	83 ec 04             	sub    $0x4,%esp
 78b:	56                   	push   %esi
 78c:	68 cc 0f 00 00       	push   $0xfcc
 791:	6a 01                	push   $0x1
 793:	e8 d8 04 00 00       	call   c70 <printf>
 798:	83 c4 10             	add    $0x10,%esp
 79b:	e9 c4 fc ff ff       	jmp    464 <find+0x74>
                }
            break;
        case T_FILE:
            if ((strcmp(type,"f") == 0 || strcmp(type,"*") == 0)
                && (strcmp(name,"*") == 0 || strcmp(name,basenamed) == 0) 
 7a0:	83 ec 08             	sub    $0x8,%esp
 7a3:	57                   	push   %edi
 7a4:	ff 75 10             	pushl  0x10(%ebp)
 7a7:	e8 44 01 00 00       	call   8f0 <strcmp>
 7ac:	83 c4 10             	add    $0x10,%esp
 7af:	85 c0                	test   %eax,%eax
 7b1:	0f 84 42 fd ff ff    	je     4f9 <find+0x109>
 7b7:	e9 a8 fc ff ff       	jmp    464 <find+0x74>
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    
    switch(st.type){
        
        case T_SYMLINK:
            if ((strcmp(type,"s") == 0 || strcmp(type,"*") == 0)
                && (strcmp(name,"*") == 0 || strcmp(name,basenamed) == 0) 
 7c0:	83 ec 08             	sub    $0x8,%esp
 7c3:	57                   	push   %edi
 7c4:	ff 75 10             	pushl  0x10(%ebp)
 7c7:	e8 24 01 00 00       	call   8f0 <strcmp>
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	85 c0                	test   %eax,%eax
 7d1:	0f 84 72 ff ff ff    	je     749 <find+0x359>
 7d7:	e9 88 fc ff ff       	jmp    464 <find+0x74>
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                }
            break;
            
        case T_DIR:
            if ((strcmp(type,"d") == 0 || strcmp(type,"*") == 0)
                && (strcmp(name,"*") == 0 || strcmp(name,basenamed) == 0) 
 7e0:	83 ec 08             	sub    $0x8,%esp
 7e3:	57                   	push   %edi
 7e4:	ff 75 10             	pushl  0x10(%ebp)
 7e7:	e8 04 01 00 00       	call   8f0 <strcmp>
 7ec:	83 c4 10             	add    $0x10,%esp
 7ef:	85 c0                	test   %eax,%eax
 7f1:	0f 84 a2 fd ff ff    	je     599 <find+0x1a9>
 7f7:	e9 b6 fd ff ff       	jmp    5b2 <find+0x1c2>
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000800 <printusage>:
    
}

void
printusage()
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	83 ec 10             	sub    $0x10,%esp
	printf(1,"Usage: find <PATH> [OPTIONS] [PREDICATORS]\n");
 806:	68 80 10 00 00       	push   $0x1080
 80b:	6a 01                	push   $0x1
 80d:	e8 5e 04 00 00       	call   c70 <printf>
	printf(1,"PATH - Path to start search from.\n");
 812:	58                   	pop    %eax
 813:	5a                   	pop    %edx
 814:	68 ac 10 00 00       	push   $0x10ac
 819:	6a 01                	push   $0x1
 81b:	e8 50 04 00 00       	call   c70 <printf>
	printf(1,"OPTIONS:\n");
 820:	59                   	pop    %ecx
 821:	58                   	pop    %eax
 822:	68 08 10 00 00       	push   $0x1008
 827:	6a 01                	push   $0x1
 829:	e8 42 04 00 00       	call   c70 <printf>
	printf(1,"\t-follow - Dereference symbolic links.\n");
 82e:	58                   	pop    %eax
 82f:	5a                   	pop    %edx
 830:	68 d0 10 00 00       	push   $0x10d0
 835:	6a 01                	push   $0x1
 837:	e8 34 04 00 00       	call   c70 <printf>
	printf(1,"\t-help - Show usage.\n");
 83c:	59                   	pop    %ecx
 83d:	58                   	pop    %eax
 83e:	68 12 10 00 00       	push   $0x1012
 843:	6a 01                	push   $0x1
 845:	e8 26 04 00 00       	call   c70 <printf>
	printf(1,"PREDICATORS:\n");
 84a:	58                   	pop    %eax
 84b:	5a                   	pop    %edx
 84c:	68 28 10 00 00       	push   $0x1028
 851:	6a 01                	push   $0x1
 853:	e8 18 04 00 00       	call   c70 <printf>
	printf(1,"\t-type <type>\n");
 858:	59                   	pop    %ecx
 859:	58                   	pop    %eax
 85a:	68 36 10 00 00       	push   $0x1036
 85f:	6a 01                	push   $0x1
 861:	e8 0a 04 00 00       	call   c70 <printf>
	printf(1,"\t\td - Match only directories.\n");
 866:	58                   	pop    %eax
 867:	5a                   	pop    %edx
 868:	68 f8 10 00 00       	push   $0x10f8
 86d:	6a 01                	push   $0x1
 86f:	e8 fc 03 00 00       	call   c70 <printf>
	printf(1,"\t\tf - Match only files.\n");
 874:	59                   	pop    %ecx
 875:	58                   	pop    %eax
 876:	68 45 10 00 00       	push   $0x1045
 87b:	6a 01                	push   $0x1
 87d:	e8 ee 03 00 00       	call   c70 <printf>
	printf(1,"\t\ts - Match only symbolic links.\n");
 882:	58                   	pop    %eax
 883:	5a                   	pop    %edx
 884:	68 18 11 00 00       	push   $0x1118
 889:	6a 01                	push   $0x1
 88b:	e8 e0 03 00 00       	call   c70 <printf>
	printf(1,"\t-name <filename> - Match only files/dirs/links with name equal to <filename>.\n");
 890:	59                   	pop    %ecx
 891:	58                   	pop    %eax
 892:	68 3c 11 00 00       	push   $0x113c
 897:	6a 01                	push   $0x1
 899:	e8 d2 03 00 00       	call   c70 <printf>
	printf(1,"\t-size (+/-)n - Match only files/dirs/links with size bigger/smaller/equal to n.\n");
 89e:	58                   	pop    %eax
 89f:	5a                   	pop    %edx
 8a0:	68 8c 11 00 00       	push   $0x118c
 8a5:	6a 01                	push   $0x1
 8a7:	e8 c4 03 00 00       	call   c70 <printf>
}
 8ac:	83 c4 10             	add    $0x10,%esp
 8af:	c9                   	leave  
 8b0:	c3                   	ret    
 8b1:	66 90                	xchg   %ax,%ax
 8b3:	66 90                	xchg   %ax,%ax
 8b5:	66 90                	xchg   %ax,%ax
 8b7:	66 90                	xchg   %ax,%ax
 8b9:	66 90                	xchg   %ax,%ax
 8bb:	66 90                	xchg   %ax,%ax
 8bd:	66 90                	xchg   %ax,%ax
 8bf:	90                   	nop

000008c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	53                   	push   %ebx
 8c4:	8b 45 08             	mov    0x8(%ebp),%eax
 8c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 8ca:	89 c2                	mov    %eax,%edx
 8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8d0:	83 c1 01             	add    $0x1,%ecx
 8d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 8d7:	83 c2 01             	add    $0x1,%edx
 8da:	84 db                	test   %bl,%bl
 8dc:	88 5a ff             	mov    %bl,-0x1(%edx)
 8df:	75 ef                	jne    8d0 <strcpy+0x10>
    ;
  return os;
}
 8e1:	5b                   	pop    %ebx
 8e2:	5d                   	pop    %ebp
 8e3:	c3                   	ret    
 8e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000008f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	56                   	push   %esi
 8f4:	53                   	push   %ebx
 8f5:	8b 55 08             	mov    0x8(%ebp),%edx
 8f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 8fb:	0f b6 02             	movzbl (%edx),%eax
 8fe:	0f b6 19             	movzbl (%ecx),%ebx
 901:	84 c0                	test   %al,%al
 903:	75 1e                	jne    923 <strcmp+0x33>
 905:	eb 29                	jmp    930 <strcmp+0x40>
 907:	89 f6                	mov    %esi,%esi
 909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 910:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 913:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 916:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 919:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 91d:	84 c0                	test   %al,%al
 91f:	74 0f                	je     930 <strcmp+0x40>
 921:	89 f1                	mov    %esi,%ecx
 923:	38 d8                	cmp    %bl,%al
 925:	74 e9                	je     910 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 927:	29 d8                	sub    %ebx,%eax
}
 929:	5b                   	pop    %ebx
 92a:	5e                   	pop    %esi
 92b:	5d                   	pop    %ebp
 92c:	c3                   	ret    
 92d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 930:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 932:	29 d8                	sub    %ebx,%eax
}
 934:	5b                   	pop    %ebx
 935:	5e                   	pop    %esi
 936:	5d                   	pop    %ebp
 937:	c3                   	ret    
 938:	90                   	nop
 939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000940 <strlen>:

uint
strlen(char *s)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 946:	80 39 00             	cmpb   $0x0,(%ecx)
 949:	74 12                	je     95d <strlen+0x1d>
 94b:	31 d2                	xor    %edx,%edx
 94d:	8d 76 00             	lea    0x0(%esi),%esi
 950:	83 c2 01             	add    $0x1,%edx
 953:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 957:	89 d0                	mov    %edx,%eax
 959:	75 f5                	jne    950 <strlen+0x10>
    ;
  return n;
}
 95b:	5d                   	pop    %ebp
 95c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 95d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 95f:	5d                   	pop    %ebp
 960:	c3                   	ret    
 961:	eb 0d                	jmp    970 <memset>
 963:	90                   	nop
 964:	90                   	nop
 965:	90                   	nop
 966:	90                   	nop
 967:	90                   	nop
 968:	90                   	nop
 969:	90                   	nop
 96a:	90                   	nop
 96b:	90                   	nop
 96c:	90                   	nop
 96d:	90                   	nop
 96e:	90                   	nop
 96f:	90                   	nop

00000970 <memset>:

void*
memset(void *dst, int c, uint n)
{
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	57                   	push   %edi
 974:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 977:	8b 4d 10             	mov    0x10(%ebp),%ecx
 97a:	8b 45 0c             	mov    0xc(%ebp),%eax
 97d:	89 d7                	mov    %edx,%edi
 97f:	fc                   	cld    
 980:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 982:	89 d0                	mov    %edx,%eax
 984:	5f                   	pop    %edi
 985:	5d                   	pop    %ebp
 986:	c3                   	ret    
 987:	89 f6                	mov    %esi,%esi
 989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000990 <strchr>:

char*
strchr(const char *s, char c)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	53                   	push   %ebx
 994:	8b 45 08             	mov    0x8(%ebp),%eax
 997:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 99a:	0f b6 10             	movzbl (%eax),%edx
 99d:	84 d2                	test   %dl,%dl
 99f:	74 1d                	je     9be <strchr+0x2e>
    if(*s == c)
 9a1:	38 d3                	cmp    %dl,%bl
 9a3:	89 d9                	mov    %ebx,%ecx
 9a5:	75 0d                	jne    9b4 <strchr+0x24>
 9a7:	eb 17                	jmp    9c0 <strchr+0x30>
 9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9b0:	38 ca                	cmp    %cl,%dl
 9b2:	74 0c                	je     9c0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 9b4:	83 c0 01             	add    $0x1,%eax
 9b7:	0f b6 10             	movzbl (%eax),%edx
 9ba:	84 d2                	test   %dl,%dl
 9bc:	75 f2                	jne    9b0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 9be:	31 c0                	xor    %eax,%eax
}
 9c0:	5b                   	pop    %ebx
 9c1:	5d                   	pop    %ebp
 9c2:	c3                   	ret    
 9c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009d0 <gets>:

char*
gets(char *buf, int max)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	57                   	push   %edi
 9d4:	56                   	push   %esi
 9d5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 9d6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 9d8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 9db:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 9de:	eb 29                	jmp    a09 <gets+0x39>
    cc = read(0, &c, 1);
 9e0:	83 ec 04             	sub    $0x4,%esp
 9e3:	6a 01                	push   $0x1
 9e5:	57                   	push   %edi
 9e6:	6a 00                	push   $0x0
 9e8:	e8 2d 01 00 00       	call   b1a <read>
    if(cc < 1)
 9ed:	83 c4 10             	add    $0x10,%esp
 9f0:	85 c0                	test   %eax,%eax
 9f2:	7e 1d                	jle    a11 <gets+0x41>
      break;
    buf[i++] = c;
 9f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 9f8:	8b 55 08             	mov    0x8(%ebp),%edx
 9fb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 9fd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 9ff:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 a03:	74 1b                	je     a20 <gets+0x50>
 a05:	3c 0d                	cmp    $0xd,%al
 a07:	74 17                	je     a20 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a09:	8d 5e 01             	lea    0x1(%esi),%ebx
 a0c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 a0f:	7c cf                	jl     9e0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 a11:	8b 45 08             	mov    0x8(%ebp),%eax
 a14:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a1b:	5b                   	pop    %ebx
 a1c:	5e                   	pop    %esi
 a1d:	5f                   	pop    %edi
 a1e:	5d                   	pop    %ebp
 a1f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 a20:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a23:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 a25:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a2c:	5b                   	pop    %ebx
 a2d:	5e                   	pop    %esi
 a2e:	5f                   	pop    %edi
 a2f:	5d                   	pop    %ebp
 a30:	c3                   	ret    
 a31:	eb 0d                	jmp    a40 <stat>
 a33:	90                   	nop
 a34:	90                   	nop
 a35:	90                   	nop
 a36:	90                   	nop
 a37:	90                   	nop
 a38:	90                   	nop
 a39:	90                   	nop
 a3a:	90                   	nop
 a3b:	90                   	nop
 a3c:	90                   	nop
 a3d:	90                   	nop
 a3e:	90                   	nop
 a3f:	90                   	nop

00000a40 <stat>:

int
stat(char *n, struct stat *st)
{
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	56                   	push   %esi
 a44:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a45:	83 ec 08             	sub    $0x8,%esp
 a48:	6a 00                	push   $0x0
 a4a:	ff 75 08             	pushl  0x8(%ebp)
 a4d:	e8 f0 00 00 00       	call   b42 <open>
  if(fd < 0)
 a52:	83 c4 10             	add    $0x10,%esp
 a55:	85 c0                	test   %eax,%eax
 a57:	78 27                	js     a80 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 a59:	83 ec 08             	sub    $0x8,%esp
 a5c:	ff 75 0c             	pushl  0xc(%ebp)
 a5f:	89 c3                	mov    %eax,%ebx
 a61:	50                   	push   %eax
 a62:	e8 f3 00 00 00       	call   b5a <fstat>
 a67:	89 c6                	mov    %eax,%esi
  close(fd);
 a69:	89 1c 24             	mov    %ebx,(%esp)
 a6c:	e8 b9 00 00 00       	call   b2a <close>
  return r;
 a71:	83 c4 10             	add    $0x10,%esp
 a74:	89 f0                	mov    %esi,%eax
}
 a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
 a79:	5b                   	pop    %ebx
 a7a:	5e                   	pop    %esi
 a7b:	5d                   	pop    %ebp
 a7c:	c3                   	ret    
 a7d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a85:	eb ef                	jmp    a76 <stat+0x36>
 a87:	89 f6                	mov    %esi,%esi
 a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a90 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	53                   	push   %ebx
 a94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 a97:	0f be 11             	movsbl (%ecx),%edx
 a9a:	8d 42 d0             	lea    -0x30(%edx),%eax
 a9d:	3c 09                	cmp    $0x9,%al
 a9f:	b8 00 00 00 00       	mov    $0x0,%eax
 aa4:	77 1f                	ja     ac5 <atoi+0x35>
 aa6:	8d 76 00             	lea    0x0(%esi),%esi
 aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 ab0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 ab3:	83 c1 01             	add    $0x1,%ecx
 ab6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 aba:	0f be 11             	movsbl (%ecx),%edx
 abd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 ac0:	80 fb 09             	cmp    $0x9,%bl
 ac3:	76 eb                	jbe    ab0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 ac5:	5b                   	pop    %ebx
 ac6:	5d                   	pop    %ebp
 ac7:	c3                   	ret    
 ac8:	90                   	nop
 ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000ad0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 ad0:	55                   	push   %ebp
 ad1:	89 e5                	mov    %esp,%ebp
 ad3:	56                   	push   %esi
 ad4:	53                   	push   %ebx
 ad5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 adb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 ade:	85 db                	test   %ebx,%ebx
 ae0:	7e 14                	jle    af6 <memmove+0x26>
 ae2:	31 d2                	xor    %edx,%edx
 ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 ae8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 aec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 aef:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 af2:	39 da                	cmp    %ebx,%edx
 af4:	75 f2                	jne    ae8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 af6:	5b                   	pop    %ebx
 af7:	5e                   	pop    %esi
 af8:	5d                   	pop    %ebp
 af9:	c3                   	ret    

00000afa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 afa:	b8 01 00 00 00       	mov    $0x1,%eax
 aff:	cd 40                	int    $0x40
 b01:	c3                   	ret    

00000b02 <exit>:
SYSCALL(exit)
 b02:	b8 02 00 00 00       	mov    $0x2,%eax
 b07:	cd 40                	int    $0x40
 b09:	c3                   	ret    

00000b0a <wait>:
SYSCALL(wait)
 b0a:	b8 03 00 00 00       	mov    $0x3,%eax
 b0f:	cd 40                	int    $0x40
 b11:	c3                   	ret    

00000b12 <pipe>:
SYSCALL(pipe)
 b12:	b8 04 00 00 00       	mov    $0x4,%eax
 b17:	cd 40                	int    $0x40
 b19:	c3                   	ret    

00000b1a <read>:
SYSCALL(read)
 b1a:	b8 05 00 00 00       	mov    $0x5,%eax
 b1f:	cd 40                	int    $0x40
 b21:	c3                   	ret    

00000b22 <write>:
SYSCALL(write)
 b22:	b8 10 00 00 00       	mov    $0x10,%eax
 b27:	cd 40                	int    $0x40
 b29:	c3                   	ret    

00000b2a <close>:
SYSCALL(close)
 b2a:	b8 15 00 00 00       	mov    $0x15,%eax
 b2f:	cd 40                	int    $0x40
 b31:	c3                   	ret    

00000b32 <kill>:
SYSCALL(kill)
 b32:	b8 06 00 00 00       	mov    $0x6,%eax
 b37:	cd 40                	int    $0x40
 b39:	c3                   	ret    

00000b3a <exec>:
SYSCALL(exec)
 b3a:	b8 07 00 00 00       	mov    $0x7,%eax
 b3f:	cd 40                	int    $0x40
 b41:	c3                   	ret    

00000b42 <open>:
SYSCALL(open)
 b42:	b8 0f 00 00 00       	mov    $0xf,%eax
 b47:	cd 40                	int    $0x40
 b49:	c3                   	ret    

00000b4a <mknod>:
SYSCALL(mknod)
 b4a:	b8 11 00 00 00       	mov    $0x11,%eax
 b4f:	cd 40                	int    $0x40
 b51:	c3                   	ret    

00000b52 <unlink>:
SYSCALL(unlink)
 b52:	b8 12 00 00 00       	mov    $0x12,%eax
 b57:	cd 40                	int    $0x40
 b59:	c3                   	ret    

00000b5a <fstat>:
SYSCALL(fstat)
 b5a:	b8 08 00 00 00       	mov    $0x8,%eax
 b5f:	cd 40                	int    $0x40
 b61:	c3                   	ret    

00000b62 <link>:
SYSCALL(link)
 b62:	b8 13 00 00 00       	mov    $0x13,%eax
 b67:	cd 40                	int    $0x40
 b69:	c3                   	ret    

00000b6a <mkdir>:
SYSCALL(mkdir)
 b6a:	b8 14 00 00 00       	mov    $0x14,%eax
 b6f:	cd 40                	int    $0x40
 b71:	c3                   	ret    

00000b72 <chdir>:
SYSCALL(chdir)
 b72:	b8 09 00 00 00       	mov    $0x9,%eax
 b77:	cd 40                	int    $0x40
 b79:	c3                   	ret    

00000b7a <dup>:
SYSCALL(dup)
 b7a:	b8 0a 00 00 00       	mov    $0xa,%eax
 b7f:	cd 40                	int    $0x40
 b81:	c3                   	ret    

00000b82 <getpid>:
SYSCALL(getpid)
 b82:	b8 0b 00 00 00       	mov    $0xb,%eax
 b87:	cd 40                	int    $0x40
 b89:	c3                   	ret    

00000b8a <sbrk>:
SYSCALL(sbrk)
 b8a:	b8 0c 00 00 00       	mov    $0xc,%eax
 b8f:	cd 40                	int    $0x40
 b91:	c3                   	ret    

00000b92 <sleep>:
SYSCALL(sleep)
 b92:	b8 0d 00 00 00       	mov    $0xd,%eax
 b97:	cd 40                	int    $0x40
 b99:	c3                   	ret    

00000b9a <uptime>:
SYSCALL(uptime)
 b9a:	b8 0e 00 00 00       	mov    $0xe,%eax
 b9f:	cd 40                	int    $0x40
 ba1:	c3                   	ret    

00000ba2 <symlink>:
SYSCALL(symlink)
 ba2:	b8 16 00 00 00       	mov    $0x16,%eax
 ba7:	cd 40                	int    $0x40
 ba9:	c3                   	ret    

00000baa <readlink>:
SYSCALL(readlink)
 baa:	b8 17 00 00 00       	mov    $0x17,%eax
 baf:	cd 40                	int    $0x40
 bb1:	c3                   	ret    

00000bb2 <ftag>:
SYSCALL(ftag)
 bb2:	b8 18 00 00 00       	mov    $0x18,%eax
 bb7:	cd 40                	int    $0x40
 bb9:	c3                   	ret    

00000bba <funtag>:
SYSCALL(funtag)
 bba:	b8 19 00 00 00       	mov    $0x19,%eax
 bbf:	cd 40                	int    $0x40
 bc1:	c3                   	ret    

00000bc2 <gettag>:
SYSCALL(gettag)
 bc2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 bc7:	cd 40                	int    $0x40
 bc9:	c3                   	ret    
 bca:	66 90                	xchg   %ax,%ax
 bcc:	66 90                	xchg   %ax,%ax
 bce:	66 90                	xchg   %ax,%ax

00000bd0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 bd0:	55                   	push   %ebp
 bd1:	89 e5                	mov    %esp,%ebp
 bd3:	57                   	push   %edi
 bd4:	56                   	push   %esi
 bd5:	53                   	push   %ebx
 bd6:	89 c6                	mov    %eax,%esi
 bd8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 bdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 bde:	85 db                	test   %ebx,%ebx
 be0:	74 7e                	je     c60 <printint+0x90>
 be2:	89 d0                	mov    %edx,%eax
 be4:	c1 e8 1f             	shr    $0x1f,%eax
 be7:	84 c0                	test   %al,%al
 be9:	74 75                	je     c60 <printint+0x90>
    neg = 1;
    x = -xx;
 beb:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 bed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 bf4:	f7 d8                	neg    %eax
 bf6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 bf9:	31 ff                	xor    %edi,%edi
 bfb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 bfe:	89 ce                	mov    %ecx,%esi
 c00:	eb 08                	jmp    c0a <printint+0x3a>
 c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 c08:	89 cf                	mov    %ecx,%edi
 c0a:	31 d2                	xor    %edx,%edx
 c0c:	8d 4f 01             	lea    0x1(%edi),%ecx
 c0f:	f7 f6                	div    %esi
 c11:	0f b6 92 a8 12 00 00 	movzbl 0x12a8(%edx),%edx
  }while((x /= base) != 0);
 c18:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 c1a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 c1d:	75 e9                	jne    c08 <printint+0x38>
  if(neg)
 c1f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 c22:	8b 75 c0             	mov    -0x40(%ebp),%esi
 c25:	85 c0                	test   %eax,%eax
 c27:	74 08                	je     c31 <printint+0x61>
    buf[i++] = '-';
 c29:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 c2e:	8d 4f 02             	lea    0x2(%edi),%ecx
 c31:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 c35:	8d 76 00             	lea    0x0(%esi),%esi
 c38:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c3b:	83 ec 04             	sub    $0x4,%esp
 c3e:	83 ef 01             	sub    $0x1,%edi
 c41:	6a 01                	push   $0x1
 c43:	53                   	push   %ebx
 c44:	56                   	push   %esi
 c45:	88 45 d7             	mov    %al,-0x29(%ebp)
 c48:	e8 d5 fe ff ff       	call   b22 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 c4d:	83 c4 10             	add    $0x10,%esp
 c50:	39 df                	cmp    %ebx,%edi
 c52:	75 e4                	jne    c38 <printint+0x68>
    putc(fd, buf[i]);
}
 c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c57:	5b                   	pop    %ebx
 c58:	5e                   	pop    %esi
 c59:	5f                   	pop    %edi
 c5a:	5d                   	pop    %ebp
 c5b:	c3                   	ret    
 c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 c60:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 c62:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 c69:	eb 8b                	jmp    bf6 <printint+0x26>
 c6b:	90                   	nop
 c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c70 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c70:	55                   	push   %ebp
 c71:	89 e5                	mov    %esp,%ebp
 c73:	57                   	push   %edi
 c74:	56                   	push   %esi
 c75:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c76:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c79:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c7c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c7f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c82:	89 45 d0             	mov    %eax,-0x30(%ebp)
 c85:	0f b6 1e             	movzbl (%esi),%ebx
 c88:	83 c6 01             	add    $0x1,%esi
 c8b:	84 db                	test   %bl,%bl
 c8d:	0f 84 b0 00 00 00    	je     d43 <printf+0xd3>
 c93:	31 d2                	xor    %edx,%edx
 c95:	eb 39                	jmp    cd0 <printf+0x60>
 c97:	89 f6                	mov    %esi,%esi
 c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 ca0:	83 f8 25             	cmp    $0x25,%eax
 ca3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 ca6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 cab:	74 18                	je     cc5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 cad:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 cb0:	83 ec 04             	sub    $0x4,%esp
 cb3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 cb6:	6a 01                	push   $0x1
 cb8:	50                   	push   %eax
 cb9:	57                   	push   %edi
 cba:	e8 63 fe ff ff       	call   b22 <write>
 cbf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 cc2:	83 c4 10             	add    $0x10,%esp
 cc5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 cc8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 ccc:	84 db                	test   %bl,%bl
 cce:	74 73                	je     d43 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 cd0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 cd2:	0f be cb             	movsbl %bl,%ecx
 cd5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 cd8:	74 c6                	je     ca0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 cda:	83 fa 25             	cmp    $0x25,%edx
 cdd:	75 e6                	jne    cc5 <printf+0x55>
      if(c == 'd'){
 cdf:	83 f8 64             	cmp    $0x64,%eax
 ce2:	0f 84 f8 00 00 00    	je     de0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 ce8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 cee:	83 f9 70             	cmp    $0x70,%ecx
 cf1:	74 5d                	je     d50 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 cf3:	83 f8 73             	cmp    $0x73,%eax
 cf6:	0f 84 84 00 00 00    	je     d80 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 cfc:	83 f8 63             	cmp    $0x63,%eax
 cff:	0f 84 ea 00 00 00    	je     def <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 d05:	83 f8 25             	cmp    $0x25,%eax
 d08:	0f 84 c2 00 00 00    	je     dd0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d0e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 d11:	83 ec 04             	sub    $0x4,%esp
 d14:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 d18:	6a 01                	push   $0x1
 d1a:	50                   	push   %eax
 d1b:	57                   	push   %edi
 d1c:	e8 01 fe ff ff       	call   b22 <write>
 d21:	83 c4 0c             	add    $0xc,%esp
 d24:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 d27:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 d2a:	6a 01                	push   $0x1
 d2c:	50                   	push   %eax
 d2d:	57                   	push   %edi
 d2e:	83 c6 01             	add    $0x1,%esi
 d31:	e8 ec fd ff ff       	call   b22 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 d36:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d3a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d3d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 d3f:	84 db                	test   %bl,%bl
 d41:	75 8d                	jne    cd0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
 d46:	5b                   	pop    %ebx
 d47:	5e                   	pop    %esi
 d48:	5f                   	pop    %edi
 d49:	5d                   	pop    %ebp
 d4a:	c3                   	ret    
 d4b:	90                   	nop
 d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 d50:	83 ec 0c             	sub    $0xc,%esp
 d53:	b9 10 00 00 00       	mov    $0x10,%ecx
 d58:	6a 00                	push   $0x0
 d5a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 d5d:	89 f8                	mov    %edi,%eax
 d5f:	8b 13                	mov    (%ebx),%edx
 d61:	e8 6a fe ff ff       	call   bd0 <printint>
        ap++;
 d66:	89 d8                	mov    %ebx,%eax
 d68:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d6b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 d6d:	83 c0 04             	add    $0x4,%eax
 d70:	89 45 d0             	mov    %eax,-0x30(%ebp)
 d73:	e9 4d ff ff ff       	jmp    cc5 <printf+0x55>
 d78:	90                   	nop
 d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 d80:	8b 45 d0             	mov    -0x30(%ebp),%eax
 d83:	8b 18                	mov    (%eax),%ebx
        ap++;
 d85:	83 c0 04             	add    $0x4,%eax
 d88:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 d8b:	b8 a0 12 00 00       	mov    $0x12a0,%eax
 d90:	85 db                	test   %ebx,%ebx
 d92:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 d95:	0f b6 03             	movzbl (%ebx),%eax
 d98:	84 c0                	test   %al,%al
 d9a:	74 23                	je     dbf <printf+0x14f>
 d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 da0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 da3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 da6:	83 ec 04             	sub    $0x4,%esp
 da9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 dab:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 dae:	50                   	push   %eax
 daf:	57                   	push   %edi
 db0:	e8 6d fd ff ff       	call   b22 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 db5:	0f b6 03             	movzbl (%ebx),%eax
 db8:	83 c4 10             	add    $0x10,%esp
 dbb:	84 c0                	test   %al,%al
 dbd:	75 e1                	jne    da0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 dbf:	31 d2                	xor    %edx,%edx
 dc1:	e9 ff fe ff ff       	jmp    cc5 <printf+0x55>
 dc6:	8d 76 00             	lea    0x0(%esi),%esi
 dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 dd0:	83 ec 04             	sub    $0x4,%esp
 dd3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 dd6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 dd9:	6a 01                	push   $0x1
 ddb:	e9 4c ff ff ff       	jmp    d2c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 de0:	83 ec 0c             	sub    $0xc,%esp
 de3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 de8:	6a 01                	push   $0x1
 dea:	e9 6b ff ff ff       	jmp    d5a <printf+0xea>
 def:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 df2:	83 ec 04             	sub    $0x4,%esp
 df5:	8b 03                	mov    (%ebx),%eax
 df7:	6a 01                	push   $0x1
 df9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 dfc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 dff:	50                   	push   %eax
 e00:	57                   	push   %edi
 e01:	e8 1c fd ff ff       	call   b22 <write>
 e06:	e9 5b ff ff ff       	jmp    d66 <printf+0xf6>
 e0b:	66 90                	xchg   %ax,%ax
 e0d:	66 90                	xchg   %ax,%ax
 e0f:	90                   	nop

00000e10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e10:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e11:	a1 2c 16 00 00       	mov    0x162c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 e16:	89 e5                	mov    %esp,%ebp
 e18:	57                   	push   %edi
 e19:	56                   	push   %esi
 e1a:	53                   	push   %ebx
 e1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e1e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e20:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e23:	39 c8                	cmp    %ecx,%eax
 e25:	73 19                	jae    e40 <free+0x30>
 e27:	89 f6                	mov    %esi,%esi
 e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 e30:	39 d1                	cmp    %edx,%ecx
 e32:	72 1c                	jb     e50 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e34:	39 d0                	cmp    %edx,%eax
 e36:	73 18                	jae    e50 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 e38:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e3a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e3c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e3e:	72 f0                	jb     e30 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e40:	39 d0                	cmp    %edx,%eax
 e42:	72 f4                	jb     e38 <free+0x28>
 e44:	39 d1                	cmp    %edx,%ecx
 e46:	73 f0                	jae    e38 <free+0x28>
 e48:	90                   	nop
 e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 e50:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e53:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 e56:	39 d7                	cmp    %edx,%edi
 e58:	74 19                	je     e73 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 e5a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 e5d:	8b 50 04             	mov    0x4(%eax),%edx
 e60:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e63:	39 f1                	cmp    %esi,%ecx
 e65:	74 23                	je     e8a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 e67:	89 08                	mov    %ecx,(%eax)
  freep = p;
 e69:	a3 2c 16 00 00       	mov    %eax,0x162c
}
 e6e:	5b                   	pop    %ebx
 e6f:	5e                   	pop    %esi
 e70:	5f                   	pop    %edi
 e71:	5d                   	pop    %ebp
 e72:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 e73:	03 72 04             	add    0x4(%edx),%esi
 e76:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 e79:	8b 10                	mov    (%eax),%edx
 e7b:	8b 12                	mov    (%edx),%edx
 e7d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 e80:	8b 50 04             	mov    0x4(%eax),%edx
 e83:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e86:	39 f1                	cmp    %esi,%ecx
 e88:	75 dd                	jne    e67 <free+0x57>
    p->s.size += bp->s.size;
 e8a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 e8d:	a3 2c 16 00 00       	mov    %eax,0x162c
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 e92:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 e95:	8b 53 f8             	mov    -0x8(%ebx),%edx
 e98:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 e9a:	5b                   	pop    %ebx
 e9b:	5e                   	pop    %esi
 e9c:	5f                   	pop    %edi
 e9d:	5d                   	pop    %ebp
 e9e:	c3                   	ret    
 e9f:	90                   	nop

00000ea0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ea0:	55                   	push   %ebp
 ea1:	89 e5                	mov    %esp,%ebp
 ea3:	57                   	push   %edi
 ea4:	56                   	push   %esi
 ea5:	53                   	push   %ebx
 ea6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 eac:	8b 15 2c 16 00 00    	mov    0x162c,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 eb2:	8d 78 07             	lea    0x7(%eax),%edi
 eb5:	c1 ef 03             	shr    $0x3,%edi
 eb8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 ebb:	85 d2                	test   %edx,%edx
 ebd:	0f 84 a3 00 00 00    	je     f66 <malloc+0xc6>
 ec3:	8b 02                	mov    (%edx),%eax
 ec5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 ec8:	39 cf                	cmp    %ecx,%edi
 eca:	76 74                	jbe    f40 <malloc+0xa0>
 ecc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 ed2:	be 00 10 00 00       	mov    $0x1000,%esi
 ed7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 ede:	0f 43 f7             	cmovae %edi,%esi
 ee1:	ba 00 80 00 00       	mov    $0x8000,%edx
 ee6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 eec:	0f 46 da             	cmovbe %edx,%ebx
 eef:	eb 10                	jmp    f01 <malloc+0x61>
 ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ef8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 efa:	8b 48 04             	mov    0x4(%eax),%ecx
 efd:	39 cf                	cmp    %ecx,%edi
 eff:	76 3f                	jbe    f40 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 f01:	39 05 2c 16 00 00    	cmp    %eax,0x162c
 f07:	89 c2                	mov    %eax,%edx
 f09:	75 ed                	jne    ef8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 f0b:	83 ec 0c             	sub    $0xc,%esp
 f0e:	53                   	push   %ebx
 f0f:	e8 76 fc ff ff       	call   b8a <sbrk>
  if(p == (char*)-1)
 f14:	83 c4 10             	add    $0x10,%esp
 f17:	83 f8 ff             	cmp    $0xffffffff,%eax
 f1a:	74 1c                	je     f38 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 f1c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 f1f:	83 ec 0c             	sub    $0xc,%esp
 f22:	83 c0 08             	add    $0x8,%eax
 f25:	50                   	push   %eax
 f26:	e8 e5 fe ff ff       	call   e10 <free>
  return freep;
 f2b:	8b 15 2c 16 00 00    	mov    0x162c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 f31:	83 c4 10             	add    $0x10,%esp
 f34:	85 d2                	test   %edx,%edx
 f36:	75 c0                	jne    ef8 <malloc+0x58>
        return 0;
 f38:	31 c0                	xor    %eax,%eax
 f3a:	eb 1c                	jmp    f58 <malloc+0xb8>
 f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 f40:	39 cf                	cmp    %ecx,%edi
 f42:	74 1c                	je     f60 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 f44:	29 f9                	sub    %edi,%ecx
 f46:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 f49:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 f4c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 f4f:	89 15 2c 16 00 00    	mov    %edx,0x162c
      return (void*)(p + 1);
 f55:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
 f5b:	5b                   	pop    %ebx
 f5c:	5e                   	pop    %esi
 f5d:	5f                   	pop    %edi
 f5e:	5d                   	pop    %ebp
 f5f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 f60:	8b 08                	mov    (%eax),%ecx
 f62:	89 0a                	mov    %ecx,(%edx)
 f64:	eb e9                	jmp    f4f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 f66:	c7 05 2c 16 00 00 30 	movl   $0x1630,0x162c
 f6d:	16 00 00 
 f70:	c7 05 30 16 00 00 30 	movl   $0x1630,0x1630
 f77:	16 00 00 
    base.s.size = 0;
 f7a:	b8 30 16 00 00       	mov    $0x1630,%eax
 f7f:	c7 05 34 16 00 00 00 	movl   $0x0,0x1634
 f86:	00 00 00 
 f89:	e9 3e ff ff ff       	jmp    ecc <malloc+0x2c>
