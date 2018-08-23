
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       7:	8b 45 08             	mov    0x8(%ebp),%eax
       a:	89 04 24             	mov    %eax,(%esp)
       d:	e8 dd 03 00 00       	call   3ef <strlen>
      12:	8b 55 08             	mov    0x8(%ebp),%edx
      15:	01 d0                	add    %edx,%eax
      17:	89 45 f4             	mov    %eax,-0xc(%ebp)
      1a:	eb 04                	jmp    20 <fmtname+0x20>
      1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
      20:	8b 45 f4             	mov    -0xc(%ebp),%eax
      23:	3b 45 08             	cmp    0x8(%ebp),%eax
      26:	72 0a                	jb     32 <fmtname+0x32>
      28:	8b 45 f4             	mov    -0xc(%ebp),%eax
      2b:	0f b6 00             	movzbl (%eax),%eax
      2e:	3c 2f                	cmp    $0x2f,%al
      30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
      32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	89 04 24             	mov    %eax,(%esp)
      3c:	e8 ae 03 00 00       	call   3ef <strlen>
      41:	83 f8 0d             	cmp    $0xd,%eax
      44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
      46:	8b 45 f4             	mov    -0xc(%ebp),%eax
      49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	89 04 24             	mov    %eax,(%esp)
      51:	e8 99 03 00 00       	call   3ef <strlen>
      56:	89 44 24 08          	mov    %eax,0x8(%esp)
      5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5d:	89 44 24 04          	mov    %eax,0x4(%esp)
      61:	c7 04 24 a0 16 00 00 	movl   $0x16a0,(%esp)
      68:	e8 11 05 00 00       	call   57e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      70:	89 04 24             	mov    %eax,(%esp)
      73:	e8 77 03 00 00       	call   3ef <strlen>
      78:	ba 0e 00 00 00       	mov    $0xe,%edx
      7d:	89 d3                	mov    %edx,%ebx
      7f:	29 c3                	sub    %eax,%ebx
      81:	8b 45 f4             	mov    -0xc(%ebp),%eax
      84:	89 04 24             	mov    %eax,(%esp)
      87:	e8 63 03 00 00       	call   3ef <strlen>
      8c:	05 a0 16 00 00       	add    $0x16a0,%eax
      91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
      95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
      9c:	00 
      9d:	89 04 24             	mov    %eax,(%esp)
      a0:	e8 71 03 00 00       	call   416 <memset>
  return buf;
      a5:	b8 a0 16 00 00       	mov    $0x16a0,%eax
}
      aa:	83 c4 24             	add    $0x24,%esp
      ad:	5b                   	pop    %ebx
      ae:	5d                   	pop    %ebp
      af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	57                   	push   %edi
      b4:	56                   	push   %esi
      b5:	53                   	push   %ebx
      b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
      bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      c3:	00 
      c4:	8b 45 08             	mov    0x8(%ebp),%eax
      c7:	89 04 24             	mov    %eax,(%esp)
      ca:	e8 4c 05 00 00       	call   61b <open>
      cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
      d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
      d8:	8b 45 08             	mov    0x8(%ebp),%eax
      db:	89 44 24 08          	mov    %eax,0x8(%esp)
      df:	c7 44 24 04 4e 11 00 	movl   $0x114e,0x4(%esp)
      e6:	00 
      e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      ee:	e8 68 06 00 00       	call   75b <printf>
    return;
      f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
      f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
      fe:	89 44 24 04          	mov    %eax,0x4(%esp)
     102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     105:	89 04 24             	mov    %eax,(%esp)
     108:	e8 26 05 00 00       	call   633 <fstat>
     10d:	85 c0                	test   %eax,%eax
     10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
     111:	8b 45 08             	mov    0x8(%ebp),%eax
     114:	89 44 24 08          	mov    %eax,0x8(%esp)
     118:	c7 44 24 04 62 11 00 	movl   $0x1162,0x4(%esp)
     11f:	00 
     120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     127:	e8 2f 06 00 00       	call   75b <printf>
    close(fd);
     12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     12f:	89 04 24             	mov    %eax,(%esp)
     132:	e8 cc 04 00 00       	call   603 <close>
    return;
     137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
  }
  
  switch(st.type){
     13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     143:	98                   	cwtl   
     144:	83 f8 01             	cmp    $0x1,%eax
     147:	74 53                	je     19c <ls+0xec>
     149:	83 f8 02             	cmp    $0x2,%eax
     14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
     152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     165:	0f bf d8             	movswl %ax,%ebx
     168:	8b 45 08             	mov    0x8(%ebp),%eax
     16b:	89 04 24             	mov    %eax,(%esp)
     16e:	e8 8d fe ff ff       	call   0 <fmtname>
     173:	89 7c 24 14          	mov    %edi,0x14(%esp)
     177:	89 74 24 10          	mov    %esi,0x10(%esp)
     17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     17f:	89 44 24 08          	mov    %eax,0x8(%esp)
     183:	c7 44 24 04 76 11 00 	movl   $0x1176,0x4(%esp)
     18a:	00 
     18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     192:	e8 c4 05 00 00       	call   75b <printf>
    break;
     197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     19c:	8b 45 08             	mov    0x8(%ebp),%eax
     19f:	89 04 24             	mov    %eax,(%esp)
     1a2:	e8 48 02 00 00       	call   3ef <strlen>
     1a7:	83 c0 10             	add    $0x10,%eax
     1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
     1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
     1b1:	c7 44 24 04 83 11 00 	movl   $0x1183,0x4(%esp)
     1b8:	00 
     1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1c0:	e8 96 05 00 00       	call   75b <printf>
      break;
     1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
     1ca:	8b 45 08             	mov    0x8(%ebp),%eax
     1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
     1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1d7:	89 04 24             	mov    %eax,(%esp)
     1da:	e8 a1 01 00 00       	call   380 <strcpy>
    p = buf+strlen(buf);
     1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1e5:	89 04 24             	mov    %eax,(%esp)
     1e8:	e8 02 02 00 00       	call   3ef <strlen>
     1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
     1f3:	01 d0                	add    %edx,%eax
     1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
     1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1fb:	8d 50 01             	lea    0x1(%eax),%edx
     1fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
     201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     204:	e9 be 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
     209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
     210:	66 85 c0             	test   %ax,%ax
     213:	75 05                	jne    21a <ls+0x16a>
        continue;
     215:	e9 ad 00 00 00       	jmp    2c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
     21a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
     221:	00 
     222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     228:	83 c0 02             	add    $0x2,%eax
     22b:	89 44 24 04          	mov    %eax,0x4(%esp)
     22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     232:	89 04 24             	mov    %eax,(%esp)
     235:	e8 44 03 00 00       	call   57e <memmove>
      p[DIRSIZ] = 0;
     23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
     23d:	83 c0 0e             	add    $0xe,%eax
     240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
     243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
     249:	89 44 24 04          	mov    %eax,0x4(%esp)
     24d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 88 02 00 00       	call   4e3 <stat>
     25b:	85 c0                	test   %eax,%eax
     25d:	79 20                	jns    27f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
     25f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     265:	89 44 24 08          	mov    %eax,0x8(%esp)
     269:	c7 44 24 04 62 11 00 	movl   $0x1162,0x4(%esp)
     270:	00 
     271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     278:	e8 de 04 00 00       	call   75b <printf>
        continue;
     27d:	eb 48                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
     27f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     28b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
     292:	0f bf d8             	movswl %ax,%ebx
     295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     29b:	89 04 24             	mov    %eax,(%esp)
     29e:	e8 5d fd ff ff       	call   0 <fmtname>
     2a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
     2a7:	89 74 24 10          	mov    %esi,0x10(%esp)
     2ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     2af:	89 44 24 08          	mov    %eax,0x8(%esp)
     2b3:	c7 44 24 04 76 11 00 	movl   $0x1176,0x4(%esp)
     2ba:	00 
     2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c2:	e8 94 04 00 00       	call   75b <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     2ce:	00 
     2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
     2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2dc:	89 04 24             	mov    %eax,(%esp)
     2df:	e8 0f 03 00 00       	call   5f3 <read>
     2e4:	83 f8 10             	cmp    $0x10,%eax
     2e7:	0f 84 1c ff ff ff    	je     209 <ls+0x159>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
     2ed:	90                   	nop
  }
  close(fd);
     2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2f1:	89 04 24             	mov    %eax,(%esp)
     2f4:	e8 0a 03 00 00       	call   603 <close>
}
     2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
     2ff:	5b                   	pop    %ebx
     300:	5e                   	pop    %esi
     301:	5f                   	pop    %edi
     302:	5d                   	pop    %ebp
     303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
     304:	55                   	push   %ebp
     305:	89 e5                	mov    %esp,%ebp
     307:	83 e4 f0             	and    $0xfffffff0,%esp
     30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
     30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     311:	7f 11                	jg     324 <main+0x20>
    ls(".");
     313:	c7 04 24 96 11 00 00 	movl   $0x1196,(%esp)
     31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
     31f:	e8 9f 02 00 00       	call   5c3 <exit>
  }
  for(i=1; i<argc; i++)
     324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
     32b:	00 
     32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
     32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     339:	8b 45 0c             	mov    0xc(%ebp),%eax
     33c:	01 d0                	add    %edx,%eax
     33e:	8b 00                	mov    (%eax),%eax
     340:	89 04 24             	mov    %eax,(%esp)
     343:	e8 68 fd ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
     348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     351:	3b 45 08             	cmp    0x8(%ebp),%eax
     354:	7c d8                	jl     32e <main+0x2a>
    ls(argv[i]);
  exit();
     356:	e8 68 02 00 00       	call   5c3 <exit>

0000035b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     35b:	55                   	push   %ebp
     35c:	89 e5                	mov    %esp,%ebp
     35e:	57                   	push   %edi
     35f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     360:	8b 4d 08             	mov    0x8(%ebp),%ecx
     363:	8b 55 10             	mov    0x10(%ebp),%edx
     366:	8b 45 0c             	mov    0xc(%ebp),%eax
     369:	89 cb                	mov    %ecx,%ebx
     36b:	89 df                	mov    %ebx,%edi
     36d:	89 d1                	mov    %edx,%ecx
     36f:	fc                   	cld    
     370:	f3 aa                	rep stos %al,%es:(%edi)
     372:	89 ca                	mov    %ecx,%edx
     374:	89 fb                	mov    %edi,%ebx
     376:	89 5d 08             	mov    %ebx,0x8(%ebp)
     379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     37c:	5b                   	pop    %ebx
     37d:	5f                   	pop    %edi
     37e:	5d                   	pop    %ebp
     37f:	c3                   	ret    

00000380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     386:	8b 45 08             	mov    0x8(%ebp),%eax
     389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     38c:	90                   	nop
     38d:	8b 45 08             	mov    0x8(%ebp),%eax
     390:	8d 50 01             	lea    0x1(%eax),%edx
     393:	89 55 08             	mov    %edx,0x8(%ebp)
     396:	8b 55 0c             	mov    0xc(%ebp),%edx
     399:	8d 4a 01             	lea    0x1(%edx),%ecx
     39c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     39f:	0f b6 12             	movzbl (%edx),%edx
     3a2:	88 10                	mov    %dl,(%eax)
     3a4:	0f b6 00             	movzbl (%eax),%eax
     3a7:	84 c0                	test   %al,%al
     3a9:	75 e2                	jne    38d <strcpy+0xd>
    ;
  return os;
     3ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3ae:	c9                   	leave  
     3af:	c3                   	ret    

000003b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     3b3:	eb 08                	jmp    3bd <strcmp+0xd>
    p++, q++;
     3b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3b9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     3bd:	8b 45 08             	mov    0x8(%ebp),%eax
     3c0:	0f b6 00             	movzbl (%eax),%eax
     3c3:	84 c0                	test   %al,%al
     3c5:	74 10                	je     3d7 <strcmp+0x27>
     3c7:	8b 45 08             	mov    0x8(%ebp),%eax
     3ca:	0f b6 10             	movzbl (%eax),%edx
     3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
     3d0:	0f b6 00             	movzbl (%eax),%eax
     3d3:	38 c2                	cmp    %al,%dl
     3d5:	74 de                	je     3b5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     3d7:	8b 45 08             	mov    0x8(%ebp),%eax
     3da:	0f b6 00             	movzbl (%eax),%eax
     3dd:	0f b6 d0             	movzbl %al,%edx
     3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e3:	0f b6 00             	movzbl (%eax),%eax
     3e6:	0f b6 c0             	movzbl %al,%eax
     3e9:	29 c2                	sub    %eax,%edx
     3eb:	89 d0                	mov    %edx,%eax
}
     3ed:	5d                   	pop    %ebp
     3ee:	c3                   	ret    

000003ef <strlen>:

uint
strlen(char *s)
{
     3ef:	55                   	push   %ebp
     3f0:	89 e5                	mov    %esp,%ebp
     3f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     3f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     3fc:	eb 04                	jmp    402 <strlen+0x13>
     3fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     402:	8b 55 fc             	mov    -0x4(%ebp),%edx
     405:	8b 45 08             	mov    0x8(%ebp),%eax
     408:	01 d0                	add    %edx,%eax
     40a:	0f b6 00             	movzbl (%eax),%eax
     40d:	84 c0                	test   %al,%al
     40f:	75 ed                	jne    3fe <strlen+0xf>
    ;
  return n;
     411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     414:	c9                   	leave  
     415:	c3                   	ret    

00000416 <memset>:

void*
memset(void *dst, int c, uint n)
{
     416:	55                   	push   %ebp
     417:	89 e5                	mov    %esp,%ebp
     419:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     41c:	8b 45 10             	mov    0x10(%ebp),%eax
     41f:	89 44 24 08          	mov    %eax,0x8(%esp)
     423:	8b 45 0c             	mov    0xc(%ebp),%eax
     426:	89 44 24 04          	mov    %eax,0x4(%esp)
     42a:	8b 45 08             	mov    0x8(%ebp),%eax
     42d:	89 04 24             	mov    %eax,(%esp)
     430:	e8 26 ff ff ff       	call   35b <stosb>
  return dst;
     435:	8b 45 08             	mov    0x8(%ebp),%eax
}
     438:	c9                   	leave  
     439:	c3                   	ret    

0000043a <strchr>:

char*
strchr(const char *s, char c)
{
     43a:	55                   	push   %ebp
     43b:	89 e5                	mov    %esp,%ebp
     43d:	83 ec 04             	sub    $0x4,%esp
     440:	8b 45 0c             	mov    0xc(%ebp),%eax
     443:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     446:	eb 14                	jmp    45c <strchr+0x22>
    if(*s == c)
     448:	8b 45 08             	mov    0x8(%ebp),%eax
     44b:	0f b6 00             	movzbl (%eax),%eax
     44e:	3a 45 fc             	cmp    -0x4(%ebp),%al
     451:	75 05                	jne    458 <strchr+0x1e>
      return (char*)s;
     453:	8b 45 08             	mov    0x8(%ebp),%eax
     456:	eb 13                	jmp    46b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     45c:	8b 45 08             	mov    0x8(%ebp),%eax
     45f:	0f b6 00             	movzbl (%eax),%eax
     462:	84 c0                	test   %al,%al
     464:	75 e2                	jne    448 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     466:	b8 00 00 00 00       	mov    $0x0,%eax
}
     46b:	c9                   	leave  
     46c:	c3                   	ret    

0000046d <gets>:

char*
gets(char *buf, int max)
{
     46d:	55                   	push   %ebp
     46e:	89 e5                	mov    %esp,%ebp
     470:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     47a:	eb 4c                	jmp    4c8 <gets+0x5b>
    cc = read(0, &c, 1);
     47c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     483:	00 
     484:	8d 45 ef             	lea    -0x11(%ebp),%eax
     487:	89 44 24 04          	mov    %eax,0x4(%esp)
     48b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     492:	e8 5c 01 00 00       	call   5f3 <read>
     497:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     49a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     49e:	7f 02                	jg     4a2 <gets+0x35>
      break;
     4a0:	eb 31                	jmp    4d3 <gets+0x66>
    buf[i++] = c;
     4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a5:	8d 50 01             	lea    0x1(%eax),%edx
     4a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
     4ab:	89 c2                	mov    %eax,%edx
     4ad:	8b 45 08             	mov    0x8(%ebp),%eax
     4b0:	01 c2                	add    %eax,%edx
     4b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     4b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4bc:	3c 0a                	cmp    $0xa,%al
     4be:	74 13                	je     4d3 <gets+0x66>
     4c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4c4:	3c 0d                	cmp    $0xd,%al
     4c6:	74 0b                	je     4d3 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4cb:	83 c0 01             	add    $0x1,%eax
     4ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
     4d1:	7c a9                	jl     47c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     4d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4d6:	8b 45 08             	mov    0x8(%ebp),%eax
     4d9:	01 d0                	add    %edx,%eax
     4db:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     4de:	8b 45 08             	mov    0x8(%ebp),%eax
}
     4e1:	c9                   	leave  
     4e2:	c3                   	ret    

000004e3 <stat>:

int
stat(char *n, struct stat *st)
{
     4e3:	55                   	push   %ebp
     4e4:	89 e5                	mov    %esp,%ebp
     4e6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     4e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4f0:	00 
     4f1:	8b 45 08             	mov    0x8(%ebp),%eax
     4f4:	89 04 24             	mov    %eax,(%esp)
     4f7:	e8 1f 01 00 00       	call   61b <open>
     4fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     4ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     503:	79 07                	jns    50c <stat+0x29>
    return -1;
     505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     50a:	eb 23                	jmp    52f <stat+0x4c>
  r = fstat(fd, st);
     50c:	8b 45 0c             	mov    0xc(%ebp),%eax
     50f:	89 44 24 04          	mov    %eax,0x4(%esp)
     513:	8b 45 f4             	mov    -0xc(%ebp),%eax
     516:	89 04 24             	mov    %eax,(%esp)
     519:	e8 15 01 00 00       	call   633 <fstat>
     51e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     521:	8b 45 f4             	mov    -0xc(%ebp),%eax
     524:	89 04 24             	mov    %eax,(%esp)
     527:	e8 d7 00 00 00       	call   603 <close>
  return r;
     52c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     52f:	c9                   	leave  
     530:	c3                   	ret    

00000531 <atoi>:

int
atoi(const char *s)
{
     531:	55                   	push   %ebp
     532:	89 e5                	mov    %esp,%ebp
     534:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     53e:	eb 25                	jmp    565 <atoi+0x34>
    n = n*10 + *s++ - '0';
     540:	8b 55 fc             	mov    -0x4(%ebp),%edx
     543:	89 d0                	mov    %edx,%eax
     545:	c1 e0 02             	shl    $0x2,%eax
     548:	01 d0                	add    %edx,%eax
     54a:	01 c0                	add    %eax,%eax
     54c:	89 c1                	mov    %eax,%ecx
     54e:	8b 45 08             	mov    0x8(%ebp),%eax
     551:	8d 50 01             	lea    0x1(%eax),%edx
     554:	89 55 08             	mov    %edx,0x8(%ebp)
     557:	0f b6 00             	movzbl (%eax),%eax
     55a:	0f be c0             	movsbl %al,%eax
     55d:	01 c8                	add    %ecx,%eax
     55f:	83 e8 30             	sub    $0x30,%eax
     562:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     565:	8b 45 08             	mov    0x8(%ebp),%eax
     568:	0f b6 00             	movzbl (%eax),%eax
     56b:	3c 2f                	cmp    $0x2f,%al
     56d:	7e 0a                	jle    579 <atoi+0x48>
     56f:	8b 45 08             	mov    0x8(%ebp),%eax
     572:	0f b6 00             	movzbl (%eax),%eax
     575:	3c 39                	cmp    $0x39,%al
     577:	7e c7                	jle    540 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     57c:	c9                   	leave  
     57d:	c3                   	ret    

0000057e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     57e:	55                   	push   %ebp
     57f:	89 e5                	mov    %esp,%ebp
     581:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     584:	8b 45 08             	mov    0x8(%ebp),%eax
     587:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     58a:	8b 45 0c             	mov    0xc(%ebp),%eax
     58d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     590:	eb 17                	jmp    5a9 <memmove+0x2b>
    *dst++ = *src++;
     592:	8b 45 fc             	mov    -0x4(%ebp),%eax
     595:	8d 50 01             	lea    0x1(%eax),%edx
     598:	89 55 fc             	mov    %edx,-0x4(%ebp)
     59b:	8b 55 f8             	mov    -0x8(%ebp),%edx
     59e:	8d 4a 01             	lea    0x1(%edx),%ecx
     5a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     5a4:	0f b6 12             	movzbl (%edx),%edx
     5a7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     5a9:	8b 45 10             	mov    0x10(%ebp),%eax
     5ac:	8d 50 ff             	lea    -0x1(%eax),%edx
     5af:	89 55 10             	mov    %edx,0x10(%ebp)
     5b2:	85 c0                	test   %eax,%eax
     5b4:	7f dc                	jg     592 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     5b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     5b9:	c9                   	leave  
     5ba:	c3                   	ret    

000005bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     5bb:	b8 01 00 00 00       	mov    $0x1,%eax
     5c0:	cd 40                	int    $0x40
     5c2:	c3                   	ret    

000005c3 <exit>:
SYSCALL(exit)
     5c3:	b8 02 00 00 00       	mov    $0x2,%eax
     5c8:	cd 40                	int    $0x40
     5ca:	c3                   	ret    

000005cb <wait>:
SYSCALL(wait)
     5cb:	b8 03 00 00 00       	mov    $0x3,%eax
     5d0:	cd 40                	int    $0x40
     5d2:	c3                   	ret    

000005d3 <signal>:
SYSCALL(signal)
     5d3:	b8 18 00 00 00       	mov    $0x18,%eax
     5d8:	cd 40                	int    $0x40
     5da:	c3                   	ret    

000005db <sigsend>:
SYSCALL(sigsend)
     5db:	b8 19 00 00 00       	mov    $0x19,%eax
     5e0:	cd 40                	int    $0x40
     5e2:	c3                   	ret    

000005e3 <alarm>:
SYSCALL(alarm)
     5e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
     5e8:	cd 40                	int    $0x40
     5ea:	c3                   	ret    

000005eb <pipe>:
SYSCALL(pipe)
     5eb:	b8 04 00 00 00       	mov    $0x4,%eax
     5f0:	cd 40                	int    $0x40
     5f2:	c3                   	ret    

000005f3 <read>:
SYSCALL(read)
     5f3:	b8 05 00 00 00       	mov    $0x5,%eax
     5f8:	cd 40                	int    $0x40
     5fa:	c3                   	ret    

000005fb <write>:
SYSCALL(write)
     5fb:	b8 10 00 00 00       	mov    $0x10,%eax
     600:	cd 40                	int    $0x40
     602:	c3                   	ret    

00000603 <close>:
SYSCALL(close)
     603:	b8 15 00 00 00       	mov    $0x15,%eax
     608:	cd 40                	int    $0x40
     60a:	c3                   	ret    

0000060b <kill>:
SYSCALL(kill)
     60b:	b8 06 00 00 00       	mov    $0x6,%eax
     610:	cd 40                	int    $0x40
     612:	c3                   	ret    

00000613 <exec>:
SYSCALL(exec)
     613:	b8 07 00 00 00       	mov    $0x7,%eax
     618:	cd 40                	int    $0x40
     61a:	c3                   	ret    

0000061b <open>:
SYSCALL(open)
     61b:	b8 0f 00 00 00       	mov    $0xf,%eax
     620:	cd 40                	int    $0x40
     622:	c3                   	ret    

00000623 <mknod>:
SYSCALL(mknod)
     623:	b8 11 00 00 00       	mov    $0x11,%eax
     628:	cd 40                	int    $0x40
     62a:	c3                   	ret    

0000062b <unlink>:
SYSCALL(unlink)
     62b:	b8 12 00 00 00       	mov    $0x12,%eax
     630:	cd 40                	int    $0x40
     632:	c3                   	ret    

00000633 <fstat>:
SYSCALL(fstat)
     633:	b8 08 00 00 00       	mov    $0x8,%eax
     638:	cd 40                	int    $0x40
     63a:	c3                   	ret    

0000063b <link>:
SYSCALL(link)
     63b:	b8 13 00 00 00       	mov    $0x13,%eax
     640:	cd 40                	int    $0x40
     642:	c3                   	ret    

00000643 <mkdir>:
SYSCALL(mkdir)
     643:	b8 14 00 00 00       	mov    $0x14,%eax
     648:	cd 40                	int    $0x40
     64a:	c3                   	ret    

0000064b <chdir>:
SYSCALL(chdir)
     64b:	b8 09 00 00 00       	mov    $0x9,%eax
     650:	cd 40                	int    $0x40
     652:	c3                   	ret    

00000653 <dup>:
SYSCALL(dup)
     653:	b8 0a 00 00 00       	mov    $0xa,%eax
     658:	cd 40                	int    $0x40
     65a:	c3                   	ret    

0000065b <getpid>:
SYSCALL(getpid)
     65b:	b8 0b 00 00 00       	mov    $0xb,%eax
     660:	cd 40                	int    $0x40
     662:	c3                   	ret    

00000663 <sbrk>:
SYSCALL(sbrk)
     663:	b8 0c 00 00 00       	mov    $0xc,%eax
     668:	cd 40                	int    $0x40
     66a:	c3                   	ret    

0000066b <sleep>:
SYSCALL(sleep)
     66b:	b8 0d 00 00 00       	mov    $0xd,%eax
     670:	cd 40                	int    $0x40
     672:	c3                   	ret    

00000673 <uptime>:
SYSCALL(uptime)
     673:	b8 0e 00 00 00       	mov    $0xe,%eax
     678:	cd 40                	int    $0x40
     67a:	c3                   	ret    

0000067b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     67b:	55                   	push   %ebp
     67c:	89 e5                	mov    %esp,%ebp
     67e:	83 ec 18             	sub    $0x18,%esp
     681:	8b 45 0c             	mov    0xc(%ebp),%eax
     684:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     687:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     68e:	00 
     68f:	8d 45 f4             	lea    -0xc(%ebp),%eax
     692:	89 44 24 04          	mov    %eax,0x4(%esp)
     696:	8b 45 08             	mov    0x8(%ebp),%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 5a ff ff ff       	call   5fb <write>
}
     6a1:	c9                   	leave  
     6a2:	c3                   	ret    

000006a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     6a3:	55                   	push   %ebp
     6a4:	89 e5                	mov    %esp,%ebp
     6a6:	56                   	push   %esi
     6a7:	53                   	push   %ebx
     6a8:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     6ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     6b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     6b6:	74 17                	je     6cf <printint+0x2c>
     6b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     6bc:	79 11                	jns    6cf <printint+0x2c>
    neg = 1;
     6be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     6c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     6c8:	f7 d8                	neg    %eax
     6ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6cd:	eb 06                	jmp    6d5 <printint+0x32>
  } else {
    x = xx;
     6cf:	8b 45 0c             	mov    0xc(%ebp),%eax
     6d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     6d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     6dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     6df:	8d 41 01             	lea    0x1(%ecx),%eax
     6e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
     6e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6eb:	ba 00 00 00 00       	mov    $0x0,%edx
     6f0:	f7 f3                	div    %ebx
     6f2:	89 d0                	mov    %edx,%eax
     6f4:	0f b6 80 70 16 00 00 	movzbl 0x1670(%eax),%eax
     6fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     6ff:	8b 75 10             	mov    0x10(%ebp),%esi
     702:	8b 45 ec             	mov    -0x14(%ebp),%eax
     705:	ba 00 00 00 00       	mov    $0x0,%edx
     70a:	f7 f6                	div    %esi
     70c:	89 45 ec             	mov    %eax,-0x14(%ebp)
     70f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     713:	75 c7                	jne    6dc <printint+0x39>
  if(neg)
     715:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     719:	74 10                	je     72b <printint+0x88>
    buf[i++] = '-';
     71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     71e:	8d 50 01             	lea    0x1(%eax),%edx
     721:	89 55 f4             	mov    %edx,-0xc(%ebp)
     724:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     729:	eb 1f                	jmp    74a <printint+0xa7>
     72b:	eb 1d                	jmp    74a <printint+0xa7>
    putc(fd, buf[i]);
     72d:	8d 55 dc             	lea    -0x24(%ebp),%edx
     730:	8b 45 f4             	mov    -0xc(%ebp),%eax
     733:	01 d0                	add    %edx,%eax
     735:	0f b6 00             	movzbl (%eax),%eax
     738:	0f be c0             	movsbl %al,%eax
     73b:	89 44 24 04          	mov    %eax,0x4(%esp)
     73f:	8b 45 08             	mov    0x8(%ebp),%eax
     742:	89 04 24             	mov    %eax,(%esp)
     745:	e8 31 ff ff ff       	call   67b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     74a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     74e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     752:	79 d9                	jns    72d <printint+0x8a>
    putc(fd, buf[i]);
}
     754:	83 c4 30             	add    $0x30,%esp
     757:	5b                   	pop    %ebx
     758:	5e                   	pop    %esi
     759:	5d                   	pop    %ebp
     75a:	c3                   	ret    

0000075b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     75b:	55                   	push   %ebp
     75c:	89 e5                	mov    %esp,%ebp
     75e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     761:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     768:	8d 45 0c             	lea    0xc(%ebp),%eax
     76b:	83 c0 04             	add    $0x4,%eax
     76e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     778:	e9 7c 01 00 00       	jmp    8f9 <printf+0x19e>
    c = fmt[i] & 0xff;
     77d:	8b 55 0c             	mov    0xc(%ebp),%edx
     780:	8b 45 f0             	mov    -0x10(%ebp),%eax
     783:	01 d0                	add    %edx,%eax
     785:	0f b6 00             	movzbl (%eax),%eax
     788:	0f be c0             	movsbl %al,%eax
     78b:	25 ff 00 00 00       	and    $0xff,%eax
     790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     793:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     797:	75 2c                	jne    7c5 <printf+0x6a>
      if(c == '%'){
     799:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     79d:	75 0c                	jne    7ab <printf+0x50>
        state = '%';
     79f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     7a6:	e9 4a 01 00 00       	jmp    8f5 <printf+0x19a>
      } else {
        putc(fd, c);
     7ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7ae:	0f be c0             	movsbl %al,%eax
     7b1:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b5:	8b 45 08             	mov    0x8(%ebp),%eax
     7b8:	89 04 24             	mov    %eax,(%esp)
     7bb:	e8 bb fe ff ff       	call   67b <putc>
     7c0:	e9 30 01 00 00       	jmp    8f5 <printf+0x19a>
      }
    } else if(state == '%'){
     7c5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     7c9:	0f 85 26 01 00 00    	jne    8f5 <printf+0x19a>
      if(c == 'd'){
     7cf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     7d3:	75 2d                	jne    802 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     7d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7d8:	8b 00                	mov    (%eax),%eax
     7da:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     7e1:	00 
     7e2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     7e9:	00 
     7ea:	89 44 24 04          	mov    %eax,0x4(%esp)
     7ee:	8b 45 08             	mov    0x8(%ebp),%eax
     7f1:	89 04 24             	mov    %eax,(%esp)
     7f4:	e8 aa fe ff ff       	call   6a3 <printint>
        ap++;
     7f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7fd:	e9 ec 00 00 00       	jmp    8ee <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     802:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     806:	74 06                	je     80e <printf+0xb3>
     808:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     80c:	75 2d                	jne    83b <printf+0xe0>
        printint(fd, *ap, 16, 0);
     80e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     811:	8b 00                	mov    (%eax),%eax
     813:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     81a:	00 
     81b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     822:	00 
     823:	89 44 24 04          	mov    %eax,0x4(%esp)
     827:	8b 45 08             	mov    0x8(%ebp),%eax
     82a:	89 04 24             	mov    %eax,(%esp)
     82d:	e8 71 fe ff ff       	call   6a3 <printint>
        ap++;
     832:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     836:	e9 b3 00 00 00       	jmp    8ee <printf+0x193>
      } else if(c == 's'){
     83b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     83f:	75 45                	jne    886 <printf+0x12b>
        s = (char*)*ap;
     841:	8b 45 e8             	mov    -0x18(%ebp),%eax
     844:	8b 00                	mov    (%eax),%eax
     846:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     849:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     84d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     851:	75 09                	jne    85c <printf+0x101>
          s = "(null)";
     853:	c7 45 f4 98 11 00 00 	movl   $0x1198,-0xc(%ebp)
        while(*s != 0){
     85a:	eb 1e                	jmp    87a <printf+0x11f>
     85c:	eb 1c                	jmp    87a <printf+0x11f>
          putc(fd, *s);
     85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     861:	0f b6 00             	movzbl (%eax),%eax
     864:	0f be c0             	movsbl %al,%eax
     867:	89 44 24 04          	mov    %eax,0x4(%esp)
     86b:	8b 45 08             	mov    0x8(%ebp),%eax
     86e:	89 04 24             	mov    %eax,(%esp)
     871:	e8 05 fe ff ff       	call   67b <putc>
          s++;
     876:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87d:	0f b6 00             	movzbl (%eax),%eax
     880:	84 c0                	test   %al,%al
     882:	75 da                	jne    85e <printf+0x103>
     884:	eb 68                	jmp    8ee <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     886:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     88a:	75 1d                	jne    8a9 <printf+0x14e>
        putc(fd, *ap);
     88c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     88f:	8b 00                	mov    (%eax),%eax
     891:	0f be c0             	movsbl %al,%eax
     894:	89 44 24 04          	mov    %eax,0x4(%esp)
     898:	8b 45 08             	mov    0x8(%ebp),%eax
     89b:	89 04 24             	mov    %eax,(%esp)
     89e:	e8 d8 fd ff ff       	call   67b <putc>
        ap++;
     8a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     8a7:	eb 45                	jmp    8ee <printf+0x193>
      } else if(c == '%'){
     8a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     8ad:	75 17                	jne    8c6 <printf+0x16b>
        putc(fd, c);
     8af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8b2:	0f be c0             	movsbl %al,%eax
     8b5:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b9:	8b 45 08             	mov    0x8(%ebp),%eax
     8bc:	89 04 24             	mov    %eax,(%esp)
     8bf:	e8 b7 fd ff ff       	call   67b <putc>
     8c4:	eb 28                	jmp    8ee <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     8c6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     8cd:	00 
     8ce:	8b 45 08             	mov    0x8(%ebp),%eax
     8d1:	89 04 24             	mov    %eax,(%esp)
     8d4:	e8 a2 fd ff ff       	call   67b <putc>
        putc(fd, c);
     8d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8dc:	0f be c0             	movsbl %al,%eax
     8df:	89 44 24 04          	mov    %eax,0x4(%esp)
     8e3:	8b 45 08             	mov    0x8(%ebp),%eax
     8e6:	89 04 24             	mov    %eax,(%esp)
     8e9:	e8 8d fd ff ff       	call   67b <putc>
      }
      state = 0;
     8ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     8f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     8f9:	8b 55 0c             	mov    0xc(%ebp),%edx
     8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8ff:	01 d0                	add    %edx,%eax
     901:	0f b6 00             	movzbl (%eax),%eax
     904:	84 c0                	test   %al,%al
     906:	0f 85 71 fe ff ff    	jne    77d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     90c:	c9                   	leave  
     90d:	c3                   	ret    

0000090e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     90e:	55                   	push   %ebp
     90f:	89 e5                	mov    %esp,%ebp
     911:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     914:	8b 45 08             	mov    0x8(%ebp),%eax
     917:	83 e8 08             	sub    $0x8,%eax
     91a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     91d:	a1 b8 16 00 00       	mov    0x16b8,%eax
     922:	89 45 fc             	mov    %eax,-0x4(%ebp)
     925:	eb 24                	jmp    94b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     927:	8b 45 fc             	mov    -0x4(%ebp),%eax
     92a:	8b 00                	mov    (%eax),%eax
     92c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     92f:	77 12                	ja     943 <free+0x35>
     931:	8b 45 f8             	mov    -0x8(%ebp),%eax
     934:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     937:	77 24                	ja     95d <free+0x4f>
     939:	8b 45 fc             	mov    -0x4(%ebp),%eax
     93c:	8b 00                	mov    (%eax),%eax
     93e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     941:	77 1a                	ja     95d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     943:	8b 45 fc             	mov    -0x4(%ebp),%eax
     946:	8b 00                	mov    (%eax),%eax
     948:	89 45 fc             	mov    %eax,-0x4(%ebp)
     94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     94e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     951:	76 d4                	jbe    927 <free+0x19>
     953:	8b 45 fc             	mov    -0x4(%ebp),%eax
     956:	8b 00                	mov    (%eax),%eax
     958:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     95b:	76 ca                	jbe    927 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     960:	8b 40 04             	mov    0x4(%eax),%eax
     963:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     96d:	01 c2                	add    %eax,%edx
     96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     972:	8b 00                	mov    (%eax),%eax
     974:	39 c2                	cmp    %eax,%edx
     976:	75 24                	jne    99c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     978:	8b 45 f8             	mov    -0x8(%ebp),%eax
     97b:	8b 50 04             	mov    0x4(%eax),%edx
     97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     981:	8b 00                	mov    (%eax),%eax
     983:	8b 40 04             	mov    0x4(%eax),%eax
     986:	01 c2                	add    %eax,%edx
     988:	8b 45 f8             	mov    -0x8(%ebp),%eax
     98b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     991:	8b 00                	mov    (%eax),%eax
     993:	8b 10                	mov    (%eax),%edx
     995:	8b 45 f8             	mov    -0x8(%ebp),%eax
     998:	89 10                	mov    %edx,(%eax)
     99a:	eb 0a                	jmp    9a6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     99f:	8b 10                	mov    (%eax),%edx
     9a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9a4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     9a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9a9:	8b 40 04             	mov    0x4(%eax),%eax
     9ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     9b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9b6:	01 d0                	add    %edx,%eax
     9b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     9bb:	75 20                	jne    9dd <free+0xcf>
    p->s.size += bp->s.size;
     9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9c0:	8b 50 04             	mov    0x4(%eax),%edx
     9c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9c6:	8b 40 04             	mov    0x4(%eax),%eax
     9c9:	01 c2                	add    %eax,%edx
     9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     9d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9d4:	8b 10                	mov    (%eax),%edx
     9d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9d9:	89 10                	mov    %edx,(%eax)
     9db:	eb 08                	jmp    9e5 <free+0xd7>
  } else
    p->s.ptr = bp;
     9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
     9e3:	89 10                	mov    %edx,(%eax)
  freep = p;
     9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9e8:	a3 b8 16 00 00       	mov    %eax,0x16b8
}
     9ed:	c9                   	leave  
     9ee:	c3                   	ret    

000009ef <morecore>:

static Header*
morecore(uint nu)
{
     9ef:	55                   	push   %ebp
     9f0:	89 e5                	mov    %esp,%ebp
     9f2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     9f5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     9fc:	77 07                	ja     a05 <morecore+0x16>
    nu = 4096;
     9fe:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     a05:	8b 45 08             	mov    0x8(%ebp),%eax
     a08:	c1 e0 03             	shl    $0x3,%eax
     a0b:	89 04 24             	mov    %eax,(%esp)
     a0e:	e8 50 fc ff ff       	call   663 <sbrk>
     a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     a16:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     a1a:	75 07                	jne    a23 <morecore+0x34>
    return 0;
     a1c:	b8 00 00 00 00       	mov    $0x0,%eax
     a21:	eb 22                	jmp    a45 <morecore+0x56>
  hp = (Header*)p;
     a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a2c:	8b 55 08             	mov    0x8(%ebp),%edx
     a2f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a35:	83 c0 08             	add    $0x8,%eax
     a38:	89 04 24             	mov    %eax,(%esp)
     a3b:	e8 ce fe ff ff       	call   90e <free>
  return freep;
     a40:	a1 b8 16 00 00       	mov    0x16b8,%eax
}
     a45:	c9                   	leave  
     a46:	c3                   	ret    

00000a47 <malloc>:

void*
malloc(uint nbytes)
{
     a47:	55                   	push   %ebp
     a48:	89 e5                	mov    %esp,%ebp
     a4a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     a4d:	8b 45 08             	mov    0x8(%ebp),%eax
     a50:	83 c0 07             	add    $0x7,%eax
     a53:	c1 e8 03             	shr    $0x3,%eax
     a56:	83 c0 01             	add    $0x1,%eax
     a59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     a5c:	a1 b8 16 00 00       	mov    0x16b8,%eax
     a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a68:	75 23                	jne    a8d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a6a:	c7 45 f0 b0 16 00 00 	movl   $0x16b0,-0x10(%ebp)
     a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a74:	a3 b8 16 00 00       	mov    %eax,0x16b8
     a79:	a1 b8 16 00 00       	mov    0x16b8,%eax
     a7e:	a3 b0 16 00 00       	mov    %eax,0x16b0
    base.s.size = 0;
     a83:	c7 05 b4 16 00 00 00 	movl   $0x0,0x16b4
     a8a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a90:	8b 00                	mov    (%eax),%eax
     a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a98:	8b 40 04             	mov    0x4(%eax),%eax
     a9b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a9e:	72 4d                	jb     aed <malloc+0xa6>
      if(p->s.size == nunits)
     aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa3:	8b 40 04             	mov    0x4(%eax),%eax
     aa6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     aa9:	75 0c                	jne    ab7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aae:	8b 10                	mov    (%eax),%edx
     ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab3:	89 10                	mov    %edx,(%eax)
     ab5:	eb 26                	jmp    add <malloc+0x96>
      else {
        p->s.size -= nunits;
     ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aba:	8b 40 04             	mov    0x4(%eax),%eax
     abd:	2b 45 ec             	sub    -0x14(%ebp),%eax
     ac0:	89 c2                	mov    %eax,%edx
     ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     acb:	8b 40 04             	mov    0x4(%eax),%eax
     ace:	c1 e0 03             	shl    $0x3,%eax
     ad1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     ada:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     add:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ae0:	a3 b8 16 00 00       	mov    %eax,0x16b8
      return (void*)(p + 1);
     ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ae8:	83 c0 08             	add    $0x8,%eax
     aeb:	eb 38                	jmp    b25 <malloc+0xde>
    }
    if(p == freep)
     aed:	a1 b8 16 00 00       	mov    0x16b8,%eax
     af2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     af5:	75 1b                	jne    b12 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     afa:	89 04 24             	mov    %eax,(%esp)
     afd:	e8 ed fe ff ff       	call   9ef <morecore>
     b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b09:	75 07                	jne    b12 <malloc+0xcb>
        return 0;
     b0b:	b8 00 00 00 00       	mov    $0x0,%eax
     b10:	eb 13                	jmp    b25 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b1b:	8b 00                	mov    (%eax),%eax
     b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     b20:	e9 70 ff ff ff       	jmp    a95 <malloc+0x4e>
}
     b25:	c9                   	leave  
     b26:	c3                   	ret    

00000b27 <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
     b27:	55                   	push   %ebp
     b28:	89 e5                	mov    %esp,%ebp
     b2a:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
     b2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     b34:	eb 17                	jmp    b4d <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
     b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b39:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     b40:	85 c0                	test   %eax,%eax
     b42:	75 05                	jne    b49 <findNextFreeThreadId+0x22>
			return i;
     b44:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b47:	eb 0f                	jmp    b58 <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
     b49:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     b4d:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
     b51:	7e e3                	jle    b36 <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
     b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b58:	c9                   	leave  
     b59:	c3                   	ret    

00000b5a <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
     b5a:	55                   	push   %ebp
     b5b:	89 e5                	mov    %esp,%ebp
     b5d:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
     b60:	a1 c0 17 00 00       	mov    0x17c0,%eax
     b65:	8b 00                	mov    (%eax),%eax
     b67:	8d 50 01             	lea    0x1(%eax),%edx
     b6a:	89 d0                	mov    %edx,%eax
     b6c:	c1 f8 1f             	sar    $0x1f,%eax
     b6f:	c1 e8 1a             	shr    $0x1a,%eax
     b72:	01 c2                	add    %eax,%edx
     b74:	83 e2 3f             	and    $0x3f,%edx
     b77:	29 c2                	sub    %eax,%edx
     b79:	89 d0                	mov    %edx,%eax
     b7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
     b7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b81:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     b88:	8b 40 28             	mov    0x28(%eax),%eax
     b8b:	83 f8 02             	cmp    $0x2,%eax
     b8e:	75 0c                	jne    b9c <findNextRunnableThread+0x42>
			return threadTable.threads[i];
     b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b93:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     b9a:	eb 1c                	jmp    bb8 <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
     b9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b9f:	8d 50 01             	lea    0x1(%eax),%edx
     ba2:	89 d0                	mov    %edx,%eax
     ba4:	c1 f8 1f             	sar    $0x1f,%eax
     ba7:	c1 e8 1a             	shr    $0x1a,%eax
     baa:	01 c2                	add    %eax,%edx
     bac:	83 e2 3f             	and    $0x3f,%edx
     baf:	29 c2                	sub    %eax,%edx
     bb1:	89 d0                	mov    %edx,%eax
     bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
     bb6:	eb c6                	jmp    b7e <findNextRunnableThread+0x24>
}
     bb8:	c9                   	leave  
     bb9:	c3                   	ret    

00000bba <uthread_init>:

void uthread_init(void)
{
     bba:	55                   	push   %ebp
     bbb:	89 e5                	mov    %esp,%ebp
     bbd:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
     bc0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     bc7:	eb 12                	jmp    bdb <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
     bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bcc:	c7 04 85 c0 16 00 00 	movl   $0x0,0x16c0(,%eax,4)
     bd3:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
     bd7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bdb:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
     bdf:	7e e8                	jle    bc9 <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
     be1:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
     be8:	e8 5a fe ff ff       	call   a47 <malloc>
     bed:	a3 c0 16 00 00       	mov    %eax,0x16c0
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
     bf2:	a1 c0 16 00 00       	mov    0x16c0,%eax
     bf7:	89 e2                	mov    %esp,%edx
     bf9:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
     bfc:	a1 c0 16 00 00       	mov    0x16c0,%eax
     c01:	89 ea                	mov    %ebp,%edx
     c03:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
     c06:	a1 c0 16 00 00       	mov    0x16c0,%eax
     c0b:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
     c12:	a1 c0 16 00 00       	mov    0x16c0,%eax
     c17:	a3 c0 17 00 00       	mov    %eax,0x17c0
	threadTable.threadCount = 1;
     c1c:	c7 05 c4 17 00 00 01 	movl   $0x1,0x17c4
     c23:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
     c26:	c7 44 24 04 ff 0d 00 	movl   $0xdff,0x4(%esp)
     c2d:	00 
     c2e:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
     c35:	e8 99 f9 ff ff       	call   5d3 <signal>
	alarm(UTHREAD_QUANTA);
     c3a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     c41:	e8 9d f9 ff ff       	call   5e3 <alarm>
}
     c46:	c9                   	leave  
     c47:	c3                   	ret    

00000c48 <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
     c48:	55                   	push   %ebp
     c49:	89 e5                	mov    %esp,%ebp
     c4b:	53                   	push   %ebx
     c4c:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
     c4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c56:	e8 88 f9 ff ff       	call   5e3 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
     c5b:	e8 c7 fe ff ff       	call   b27 <findNextFreeThreadId>
     c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
     c63:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     c67:	75 0a                	jne    c73 <uthread_create+0x2b>
		return -1;
     c69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c6e:	e9 d6 00 00 00       	jmp    d49 <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
     c73:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
     c7a:	e8 c8 fd ff ff       	call   a47 <malloc>
     c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c82:	89 04 95 c0 16 00 00 	mov    %eax,0x16c0(,%edx,4)
	threadTable.threads[current]->tid = current;
     c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c8c:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c96:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
     c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9b:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     ca2:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
     ca9:	a1 c4 17 00 00       	mov    0x17c4,%eax
     cae:	83 c0 01             	add    $0x1,%eax
     cb1:	a3 c4 17 00 00       	mov    %eax,0x17c4
	threadTable.threads[current]->entry = func;
     cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb9:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     cc0:	8b 55 08             	mov    0x8(%ebp),%edx
     cc3:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
     cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc9:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
     cd3:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
     cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cd9:	8b 1c 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%ebx
     ce0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     ce7:	e8 5b fd ff ff       	call   a47 <malloc>
     cec:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
     cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cf2:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cfc:	8b 14 95 c0 16 00 00 	mov    0x16c0(,%edx,4),%edx
     d03:	8b 52 24             	mov    0x24(%edx),%edx
     d06:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
     d0c:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
     d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d12:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d1c:	8b 14 95 c0 16 00 00 	mov    0x16c0(,%edx,4),%edx
     d23:	8b 52 04             	mov    0x4(%edx),%edx
     d26:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
     d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d2c:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     d33:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
     d3a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     d41:	e8 9d f8 ff ff       	call   5e3 <alarm>
	return current;
     d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d49:	83 c4 24             	add    $0x24,%esp
     d4c:	5b                   	pop    %ebx
     d4d:	5d                   	pop    %ebp
     d4e:	c3                   	ret    

00000d4f <uthread_exit>:

void uthread_exit(void)
{
     d4f:	55                   	push   %ebp
     d50:	89 e5                	mov    %esp,%ebp
     d52:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
     d55:	a1 c0 17 00 00       	mov    0x17c0,%eax
     d5a:	8b 00                	mov    (%eax),%eax
     d5c:	85 c0                	test   %eax,%eax
     d5e:	74 10                	je     d70 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
     d60:	a1 c0 17 00 00       	mov    0x17c0,%eax
     d65:	8b 40 24             	mov    0x24(%eax),%eax
     d68:	89 04 24             	mov    %eax,(%esp)
     d6b:	e8 9e fb ff ff       	call   90e <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
     d70:	a1 c0 17 00 00       	mov    0x17c0,%eax
     d75:	8b 00                	mov    (%eax),%eax
     d77:	c7 04 85 c0 16 00 00 	movl   $0x0,0x16c0(,%eax,4)
     d7e:	00 00 00 00 
	
	free(threadTable.runningThread);
     d82:	a1 c0 17 00 00       	mov    0x17c0,%eax
     d87:	89 04 24             	mov    %eax,(%esp)
     d8a:	e8 7f fb ff ff       	call   90e <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
     d8f:	a1 c4 17 00 00       	mov    0x17c4,%eax
     d94:	83 e8 01             	sub    $0x1,%eax
     d97:	a3 c4 17 00 00       	mov    %eax,0x17c4
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
     d9c:	a1 c4 17 00 00       	mov    0x17c4,%eax
     da1:	85 c0                	test   %eax,%eax
     da3:	75 05                	jne    daa <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
     da5:	e8 19 f8 ff ff       	call   5c3 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
     daa:	e8 ab fd ff ff       	call   b5a <findNextRunnableThread>
     daf:	a3 c0 17 00 00       	mov    %eax,0x17c0
	
	threadTable.runningThread->state = T_RUNNING;
     db4:	a1 c0 17 00 00       	mov    0x17c0,%eax
     db9:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
     dc0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     dc7:	e8 17 f8 ff ff       	call   5e3 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
     dcc:	a1 c0 17 00 00       	mov    0x17c0,%eax
     dd1:	8b 40 04             	mov    0x4(%eax),%eax
     dd4:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
     dd6:	a1 c0 17 00 00       	mov    0x17c0,%eax
     ddb:	8b 40 08             	mov    0x8(%eax),%eax
     dde:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
     de0:	a1 c0 17 00 00       	mov    0x17c0,%eax
     de5:	8b 40 2c             	mov    0x2c(%eax),%eax
     de8:	85 c0                	test   %eax,%eax
     dea:	74 11                	je     dfd <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
     dec:	a1 c0 17 00 00       	mov    0x17c0,%eax
     df1:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
     df8:	e8 8e 00 00 00       	call   e8b <wrapper>
	}
	

}
     dfd:	c9                   	leave  
     dfe:	c3                   	ret    

00000dff <uthread_yield>:

void uthread_yield(void)
{
     dff:	55                   	push   %ebp
     e00:	89 e5                	mov    %esp,%ebp
     e02:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
     e05:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e0a:	89 e2                	mov    %esp,%edx
     e0c:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
     e0f:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e14:	89 ea                	mov    %ebp,%edx
     e16:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
     e19:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e1e:	8b 40 28             	mov    0x28(%eax),%eax
     e21:	83 f8 01             	cmp    $0x1,%eax
     e24:	75 0c                	jne    e32 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
     e26:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e2b:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
     e32:	e8 23 fd ff ff       	call   b5a <findNextRunnableThread>
     e37:	a3 c0 17 00 00       	mov    %eax,0x17c0
	threadTable.runningThread->state = T_RUNNING;
     e3c:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e41:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
     e48:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     e4f:	e8 8f f7 ff ff       	call   5e3 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
     e54:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e59:	8b 40 04             	mov    0x4(%eax),%eax
     e5c:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
     e5e:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e63:	8b 40 08             	mov    0x8(%eax),%eax
     e66:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
     e68:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e6d:	8b 40 2c             	mov    0x2c(%eax),%eax
     e70:	85 c0                	test   %eax,%eax
     e72:	74 14                	je     e88 <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
     e74:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e79:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
     e80:	b8 8b 0e 00 00       	mov    $0xe8b,%eax
     e85:	ff d0                	call   *%eax
		asm("ret");
     e87:	c3                   	ret    
	}
	return;
     e88:	90                   	nop
}
     e89:	c9                   	leave  
     e8a:	c3                   	ret    

00000e8b <wrapper>:

void wrapper(void) {
     e8b:	55                   	push   %ebp
     e8c:	89 e5                	mov    %esp,%ebp
     e8e:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
     e91:	a1 c0 17 00 00       	mov    0x17c0,%eax
     e96:	8b 40 30             	mov    0x30(%eax),%eax
     e99:	8b 15 c0 17 00 00    	mov    0x17c0,%edx
     e9f:	8b 52 34             	mov    0x34(%edx),%edx
     ea2:	89 14 24             	mov    %edx,(%esp)
     ea5:	ff d0                	call   *%eax
	uthread_exit();
     ea7:	e8 a3 fe ff ff       	call   d4f <uthread_exit>
}
     eac:	c9                   	leave  
     ead:	c3                   	ret    

00000eae <uthread_self>:

int uthread_self(void)
{
     eae:	55                   	push   %ebp
     eaf:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
     eb1:	a1 c0 17 00 00       	mov    0x17c0,%eax
     eb6:	8b 00                	mov    (%eax),%eax
}
     eb8:	5d                   	pop    %ebp
     eb9:	c3                   	ret    

00000eba <uthread_join>:

int uthread_join(int tid)
{
     eba:	55                   	push   %ebp
     ebb:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
     ebd:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
     ec1:	7e 07                	jle    eca <uthread_join+0x10>
		return -1;
     ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ec8:	eb 14                	jmp    ede <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
     eca:	90                   	nop
     ecb:	8b 45 08             	mov    0x8(%ebp),%eax
     ece:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     ed5:	85 c0                	test   %eax,%eax
     ed7:	75 f2                	jne    ecb <uthread_join+0x11>
	return 0;
     ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ede:	5d                   	pop    %ebp
     edf:	c3                   	ret    

00000ee0 <uthread_sleep>:

void uthread_sleep(void)
{
     ee0:	55                   	push   %ebp
     ee1:	89 e5                	mov    %esp,%ebp
     ee3:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
     ee6:	a1 c0 17 00 00       	mov    0x17c0,%eax
     eeb:	89 e2                	mov    %esp,%edx
     eed:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
     ef0:	a1 c0 17 00 00       	mov    0x17c0,%eax
     ef5:	89 ea                	mov    %ebp,%edx
     ef7:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
     efa:	a1 c0 17 00 00       	mov    0x17c0,%eax
     eff:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
     f06:	a1 c0 17 00 00       	mov    0x17c0,%eax
     f0b:	8b 00                	mov    (%eax),%eax
     f0d:	89 44 24 08          	mov    %eax,0x8(%esp)
     f11:	c7 44 24 04 9f 11 00 	movl   $0x119f,0x4(%esp)
     f18:	00 
     f19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f20:	e8 36 f8 ff ff       	call   75b <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
     f25:	e8 30 fc ff ff       	call   b5a <findNextRunnableThread>
     f2a:	a3 c0 17 00 00       	mov    %eax,0x17c0
	threadTable.runningThread->state = T_RUNNING;
     f2f:	a1 c0 17 00 00       	mov    0x17c0,%eax
     f34:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
     f3b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     f42:	e8 9c f6 ff ff       	call   5e3 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
     f47:	a1 c0 17 00 00       	mov    0x17c0,%eax
     f4c:	8b 40 08             	mov    0x8(%eax),%eax
     f4f:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
     f51:	a1 c0 17 00 00       	mov    0x17c0,%eax
     f56:	8b 40 04             	mov    0x4(%eax),%eax
     f59:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
     f5b:	a1 c0 17 00 00       	mov    0x17c0,%eax
     f60:	8b 40 2c             	mov    0x2c(%eax),%eax
     f63:	85 c0                	test   %eax,%eax
     f65:	74 14                	je     f7b <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
     f67:	a1 c0 17 00 00       	mov    0x17c0,%eax
     f6c:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
     f73:	b8 8b 0e 00 00       	mov    $0xe8b,%eax
     f78:	ff d0                	call   *%eax
		asm("ret");
     f7a:	c3                   	ret    
	}
	return;	
     f7b:	90                   	nop
}
     f7c:	c9                   	leave  
     f7d:	c3                   	ret    

00000f7e <uthread_wakeup>:
void uthread_wakeup(int tid)
{
     f7e:	55                   	push   %ebp
     f7f:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
     f81:	8b 45 08             	mov    0x8(%ebp),%eax
     f84:	8b 04 85 c0 16 00 00 	mov    0x16c0(,%eax,4),%eax
     f8b:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
     f92:	5d                   	pop    %ebp
     f93:	c3                   	ret    

00000f94 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
     f94:	55                   	push   %ebp
     f95:	89 e5                	mov    %esp,%ebp
     f97:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
     f9a:	c7 44 24 04 ba 11 00 	movl   $0x11ba,0x4(%esp)
     fa1:	00 
     fa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fa9:	e8 ad f7 ff ff       	call   75b <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
     fae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fb5:	eb 26                	jmp    fdd <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
     fb7:	8b 45 08             	mov    0x8(%ebp),%eax
     fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fbd:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     fc1:	89 44 24 08          	mov    %eax,0x8(%esp)
     fc5:	c7 44 24 04 d1 11 00 	movl   $0x11d1,0x4(%esp)
     fcc:	00 
     fcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fd4:	e8 82 f7 ff ff       	call   75b <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
     fd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fdd:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
     fe1:	7e d4                	jle    fb7 <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
     fe3:	c7 44 24 04 d5 11 00 	movl   $0x11d5,0x4(%esp)
     fea:	00 
     feb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff2:	e8 64 f7 ff ff       	call   75b <printf>
}
     ff7:	c9                   	leave  
     ff8:	c3                   	ret    

00000ff9 <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
     ff9:	55                   	push   %ebp
     ffa:	89 e5                	mov    %esp,%ebp
     ffc:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
     fff:	8b 45 08             	mov    0x8(%ebp),%eax
    1002:	8b 55 0c             	mov    0xc(%ebp),%edx
    1005:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
    1007:	8b 45 08             	mov    0x8(%ebp),%eax
    100a:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
    1011:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    1014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    101b:	eb 12                	jmp    102f <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
    101d:	8b 45 08             	mov    0x8(%ebp),%eax
    1020:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1023:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
    102a:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    102b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    102f:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
    1033:	7e e8                	jle    101d <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
    1035:	c9                   	leave  
    1036:	c3                   	ret    

00001037 <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
    1037:	55                   	push   %ebp
    1038:	89 e5                	mov    %esp,%ebp
    103a:	53                   	push   %ebx
    103b:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
    103e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1045:	e8 99 f5 ff ff       	call   5e3 <alarm>
	if (semaphore->value ==0){
    104a:	8b 45 08             	mov    0x8(%ebp),%eax
    104d:	8b 00                	mov    (%eax),%eax
    104f:	85 c0                	test   %eax,%eax
    1051:	75 34                	jne    1087 <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
    1053:	a1 c0 17 00 00       	mov    0x17c0,%eax
    1058:	8b 08                	mov    (%eax),%ecx
    105a:	8b 45 08             	mov    0x8(%ebp),%eax
    105d:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
    1063:	8d 58 01             	lea    0x1(%eax),%ebx
    1066:	8b 55 08             	mov    0x8(%ebp),%edx
    1069:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
    106f:	8b 55 08             	mov    0x8(%ebp),%edx
    1072:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
    1076:	a1 c0 17 00 00       	mov    0x17c0,%eax
    107b:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
    1082:	e8 78 fd ff ff       	call   dff <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
    1087:	a1 c0 17 00 00       	mov    0x17c0,%eax
    108c:	8b 10                	mov    (%eax),%edx
    108e:	8b 45 08             	mov    0x8(%ebp),%eax
    1091:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
    1098:	ff 
	semaphore->value = 0;
    1099:	8b 45 08             	mov    0x8(%ebp),%eax
    109c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
    10a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    10a9:	e8 35 f5 ff ff       	call   5e3 <alarm>
}
    10ae:	83 c4 14             	add    $0x14,%esp
    10b1:	5b                   	pop    %ebx
    10b2:	5d                   	pop    %ebp
    10b3:	c3                   	ret    

000010b4 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
    10b4:	55                   	push   %ebp
    10b5:	89 e5                	mov    %esp,%ebp
    10b7:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
    10ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10c1:	e8 1d f5 ff ff       	call   5e3 <alarm>
	
	if (semaphore->value == 0){
    10c6:	8b 45 08             	mov    0x8(%ebp),%eax
    10c9:	8b 00                	mov    (%eax),%eax
    10cb:	85 c0                	test   %eax,%eax
    10cd:	75 71                	jne    1140 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
    10cf:	8b 45 08             	mov    0x8(%ebp),%eax
    10d2:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
    10d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
    10db:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
    10e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10e9:	eb 35                	jmp    1120 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
    10eb:	8b 45 08             	mov    0x8(%ebp),%eax
    10ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10f1:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    10f5:	83 f8 ff             	cmp    $0xffffffff,%eax
    10f8:	74 22                	je     111c <binary_semaphore_up+0x68>
    10fa:	8b 45 08             	mov    0x8(%ebp),%eax
    10fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1100:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1104:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    1107:	7d 13                	jge    111c <binary_semaphore_up+0x68>
				minIndex = i;
    1109:	8b 45 f4             	mov    -0xc(%ebp),%eax
    110c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
    110f:	8b 45 08             	mov    0x8(%ebp),%eax
    1112:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1115:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1119:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
    111c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1120:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    1124:	7e c5                	jle    10eb <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
    1126:	8b 45 08             	mov    0x8(%ebp),%eax
    1129:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
    112f:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
    1133:	74 0b                	je     1140 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
    1135:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1138:	89 04 24             	mov    %eax,(%esp)
    113b:	e8 3e fe ff ff       	call   f7e <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
    1140:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1147:	e8 97 f4 ff ff       	call   5e3 <alarm>
	
    114c:	c9                   	leave  
    114d:	c3                   	ret    
