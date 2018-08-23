
_tests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:



int
main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  //bigFileTest(); 
  linkTest();
  11:	e8 9a 01 00 00       	call   1b0 <linkTest>
  tagsTest();
  16:	e8 05 02 00 00       	call   220 <tagsTest>
  exit();
  1b:	e8 e2 05 00 00       	call   602 <exit>

00000020 <bigFileTest>:
   kill(ppid); \
   exit(); \
}


void bigFileTest(){
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	57                   	push   %edi
  24:	56                   	push   %esi
  25:	53                   	push   %ebx
  26:	81 ec 14 02 00 00    	sub    $0x214,%esp
  char buf[512];
  int fd, i, sectors;

  fd = open("big.file", O_CREATE | O_WRONLY);
  2c:	68 01 02 00 00       	push   $0x201
  31:	68 90 0a 00 00       	push   $0xa90
  36:	e8 07 06 00 00       	call   642 <open>
  if(fd < 0){
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	85 c0                	test   %eax,%eax
  40:	0f 88 2a 01 00 00    	js     170 <bigFileTest+0x150>
  46:	89 c6                	mov    %eax,%esi
  48:	31 db                	xor    %ebx,%ebx
    *(int*)buf = sectors;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    sectors++;
    if (sectors % 100 == 0)
  4a:	bf 1f 85 eb 51       	mov    $0x51eb851f,%edi
  4f:	90                   	nop
  }

  sectors = 0;
  while(1){
    *(int*)buf = sectors;
    int cc = write(fd, buf, sizeof(buf));
  50:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  56:	83 ec 04             	sub    $0x4,%esp
    return;
  }

  sectors = 0;
  while(1){
    *(int*)buf = sectors;
  59:	89 9d e8 fd ff ff    	mov    %ebx,-0x218(%ebp)
    int cc = write(fd, buf, sizeof(buf));
  5f:	68 00 02 00 00       	push   $0x200
  64:	50                   	push   %eax
  65:	56                   	push   %esi
  66:	e8 b7 05 00 00       	call   622 <write>
    if(cc <= 0)
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	85 c0                	test   %eax,%eax
  70:	7e 2e                	jle    a0 <bigFileTest+0x80>
      break;
    sectors++;
  72:	83 c3 01             	add    $0x1,%ebx
    if (sectors % 100 == 0)
  75:	89 d8                	mov    %ebx,%eax
  77:	f7 ef                	imul   %edi
  79:	89 d8                	mov    %ebx,%eax
  7b:	c1 f8 1f             	sar    $0x1f,%eax
  7e:	c1 fa 05             	sar    $0x5,%edx
  81:	29 c2                	sub    %eax,%edx
  83:	6b d2 64             	imul   $0x64,%edx,%edx
  86:	39 d3                	cmp    %edx,%ebx
  88:	75 c6                	jne    50 <bigFileTest+0x30>
        printf(2, ".");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	68 99 0a 00 00       	push   $0xa99
  92:	6a 02                	push   $0x2
  94:	e8 d7 06 00 00       	call   770 <printf>
  99:	83 c4 10             	add    $0x10,%esp
  9c:	eb b2                	jmp    50 <bigFileTest+0x30>
  9e:	66 90                	xchg   %ax,%ax
  }

  printf(1, "\nwrote %d sectors\n", sectors);
  a0:	83 ec 04             	sub    $0x4,%esp
  a3:	53                   	push   %ebx
  a4:	68 9b 0a 00 00       	push   $0xa9b
  a9:	6a 01                	push   $0x1
  ab:	e8 c0 06 00 00       	call   770 <printf>

  close(fd);
  b0:	89 34 24             	mov    %esi,(%esp)
  b3:	e8 72 05 00 00       	call   62a <close>
  fd = open("big.file", O_RDONLY);
  b8:	58                   	pop    %eax
  b9:	5a                   	pop    %edx
  ba:	6a 00                	push   $0x0
  bc:	68 90 0a 00 00       	push   $0xa90
  c1:	e8 7c 05 00 00       	call   642 <open>
  if(fd < 0){
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	85 c0                	test   %eax,%eax
  }

  printf(1, "\nwrote %d sectors\n", sectors);

  close(fd);
  fd = open("big.file", O_RDONLY);
  cb:	89 c6                	mov    %eax,%esi
  if(fd < 0){
  cd:	0f 88 bd 00 00 00    	js     190 <bigFileTest+0x170>
    printf(2, "big: cannot re-open big.file for reading\n");
    return;
  }
  for(i = 0; i < sectors; i++){
  d3:	31 ff                	xor    %edi,%edi
  d5:	85 db                	test   %ebx,%ebx
  d7:	75 18                	jne    f1 <bigFileTest+0xd1>
  d9:	eb 55                	jmp    130 <bigFileTest+0x110>
  db:	90                   	nop
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      printf(2, "big: read error at sector %d\n", i);
      return;
    }
    if(*(int*)buf != i){
  e0:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  e6:	39 f8                	cmp    %edi,%eax
  e8:	75 66                	jne    150 <bigFileTest+0x130>
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    printf(2, "big: cannot re-open big.file for reading\n");
    return;
  }
  for(i = 0; i < sectors; i++){
  ea:	83 c7 01             	add    $0x1,%edi
  ed:	39 fb                	cmp    %edi,%ebx
  ef:	74 3f                	je     130 <bigFileTest+0x110>
    int cc = read(fd, buf, sizeof(buf));
  f1:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  f7:	83 ec 04             	sub    $0x4,%esp
  fa:	68 00 02 00 00       	push   $0x200
  ff:	50                   	push   %eax
 100:	56                   	push   %esi
 101:	e8 14 05 00 00       	call   61a <read>
    if(cc <= 0){
 106:	83 c4 10             	add    $0x10,%esp
 109:	85 c0                	test   %eax,%eax
 10b:	7f d3                	jg     e0 <bigFileTest+0xc0>
      printf(2, "big: read error at sector %d\n", i);
 10d:	83 ec 04             	sub    $0x4,%esp
 110:	57                   	push   %edi
 111:	68 c2 0a 00 00       	push   $0xac2
 116:	6a 02                	push   $0x2
 118:	e8 53 06 00 00       	call   770 <printf>
      return;
 11d:	83 c4 10             	add    $0x10,%esp
             *(int*)buf, i);
      return;
    }
  }
  printf(1, "done big file test\n"); 
}
 120:	8d 65 f4             	lea    -0xc(%ebp),%esp
 123:	5b                   	pop    %ebx
 124:	5e                   	pop    %esi
 125:	5f                   	pop    %edi
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    
 128:	90                   	nop
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(2, "big: read the wrong data (%d) for sector %d\n",
             *(int*)buf, i);
      return;
    }
  }
  printf(1, "done big file test\n"); 
 130:	83 ec 08             	sub    $0x8,%esp
 133:	68 ae 0a 00 00       	push   $0xaae
 138:	6a 01                	push   $0x1
 13a:	e8 31 06 00 00       	call   770 <printf>
 13f:	83 c4 10             	add    $0x10,%esp
}
 142:	8d 65 f4             	lea    -0xc(%ebp),%esp
 145:	5b                   	pop    %ebx
 146:	5e                   	pop    %esi
 147:	5f                   	pop    %edi
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cc <= 0){
      printf(2, "big: read error at sector %d\n", i);
      return;
    }
    if(*(int*)buf != i){
      printf(2, "big: read the wrong data (%d) for sector %d\n",
 150:	57                   	push   %edi
 151:	50                   	push   %eax
 152:	68 f4 0b 00 00       	push   $0xbf4
 157:	6a 02                	push   $0x2
 159:	e8 12 06 00 00       	call   770 <printf>
             *(int*)buf, i);
      return;
 15e:	83 c4 10             	add    $0x10,%esp
    }
  }
  printf(1, "done big file test\n"); 
}
 161:	8d 65 f4             	lea    -0xc(%ebp),%esp
 164:	5b                   	pop    %ebx
 165:	5e                   	pop    %esi
 166:	5f                   	pop    %edi
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char buf[512];
  int fd, i, sectors;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf(2, "big: cannot open big.file for writing\n");
 170:	83 ec 08             	sub    $0x8,%esp
 173:	68 a0 0b 00 00       	push   $0xba0
 178:	6a 02                	push   $0x2
 17a:	e8 f1 05 00 00       	call   770 <printf>
    return;
 17f:	83 c4 10             	add    $0x10,%esp
             *(int*)buf, i);
      return;
    }
  }
  printf(1, "done big file test\n"); 
}
 182:	8d 65 f4             	lea    -0xc(%ebp),%esp
 185:	5b                   	pop    %ebx
 186:	5e                   	pop    %esi
 187:	5f                   	pop    %edi
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  printf(1, "\nwrote %d sectors\n", sectors);

  close(fd);
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    printf(2, "big: cannot re-open big.file for reading\n");
 190:	83 ec 08             	sub    $0x8,%esp
 193:	68 c8 0b 00 00       	push   $0xbc8
 198:	6a 02                	push   $0x2
 19a:	e8 d1 05 00 00       	call   770 <printf>
    return;
 19f:	83 c4 10             	add    $0x10,%esp
             *(int*)buf, i);
      return;
    }
  }
  printf(1, "done big file test\n"); 
}
 1a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a5:	5b                   	pop    %ebx
 1a6:	5e                   	pop    %esi
 1a7:	5f                   	pop    %edi
 1a8:	5d                   	pop    %ebp
 1a9:	c3                   	ret    
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001b0 <linkTest>:

void linkTest(){
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	83 c4 80             	add    $0xffffff80,%esp
  char* newpath = "newpath";
  char* pathname = "pathname";
  char buf[100];
  int bufsize = 2; //size_t

  printf(1, "symlink:\n");
 1b6:	68 e0 0a 00 00       	push   $0xae0
 1bb:	6a 01                	push   $0x1
 1bd:	e8 ae 05 00 00       	call   770 <printf>
  printf(1, "%d\n", symlink(oldpath, newpath));
 1c2:	58                   	pop    %eax
 1c3:	5a                   	pop    %edx
 1c4:	68 ea 0a 00 00       	push   $0xaea
 1c9:	68 f2 0a 00 00       	push   $0xaf2
 1ce:	e8 cf 04 00 00       	call   6a2 <symlink>
 1d3:	83 c4 0c             	add    $0xc,%esp
 1d6:	50                   	push   %eax
 1d7:	68 1b 0b 00 00       	push   $0xb1b
 1dc:	6a 01                	push   $0x1
 1de:	e8 8d 05 00 00       	call   770 <printf>
  // printf(1, "\n");

  printf(1, "readlink:\n");
 1e3:	59                   	pop    %ecx
 1e4:	58                   	pop    %eax
 1e5:	68 fa 0a 00 00       	push   $0xafa
 1ea:	6a 01                	push   $0x1
 1ec:	e8 7f 05 00 00       	call   770 <printf>
  printf(1, "%d\n", readlink(pathname, buf, bufsize));
 1f1:	8d 45 94             	lea    -0x6c(%ebp),%eax
 1f4:	83 c4 0c             	add    $0xc,%esp
 1f7:	6a 02                	push   $0x2
 1f9:	50                   	push   %eax
 1fa:	68 05 0b 00 00       	push   $0xb05
 1ff:	e8 a6 04 00 00       	call   6aa <readlink>
 204:	83 c4 0c             	add    $0xc,%esp
 207:	50                   	push   %eax
 208:	68 1b 0b 00 00       	push   $0xb1b
 20d:	6a 01                	push   $0x1
 20f:	e8 5c 05 00 00       	call   770 <printf>
  // printf(1, "\n");
}
 214:	83 c4 10             	add    $0x10,%esp
 217:	c9                   	leave  
 218:	c3                   	ret    
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <tagsTest>:

void tagsTest(){
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	53                   	push   %ebx
 226:	83 ec 1c             	sub    $0x1c,%esp
  ppid = getpid();
 229:	e8 54 04 00 00       	call   682 <getpid>
  int fd = open("ls", O_RDWR);
 22e:	83 ec 08             	sub    $0x8,%esp
  printf(1, "%d\n", readlink(pathname, buf, bufsize));
  // printf(1, "\n");
}

void tagsTest(){
  ppid = getpid();
 231:	a3 88 0f 00 00       	mov    %eax,0xf88
  int fd = open("ls", O_RDWR);
 236:	6a 02                	push   $0x2
 238:	68 0e 0b 00 00       	push   $0xb0e
 23d:	e8 00 04 00 00       	call   642 <open>
  printf(1, "fd of ls: %d\n", fd);
 242:	83 c4 0c             	add    $0xc,%esp
  // printf(1, "\n");
}

void tagsTest(){
  ppid = getpid();
  int fd = open("ls", O_RDWR);
 245:	89 c7                	mov    %eax,%edi
  printf(1, "fd of ls: %d\n", fd);
 247:	50                   	push   %eax
 248:	68 11 0b 00 00       	push   $0xb11
 24d:	6a 01                	push   $0x1
 24f:	e8 1c 05 00 00       	call   770 <printf>
  char* val1 = "value1";
  char* val2 = "value2";

  char buf[7];

  int res = ftag(fd, key1, val1);
 254:	83 c4 0c             	add    $0xc,%esp
 257:	68 1f 0b 00 00       	push   $0xb1f
 25c:	68 26 0b 00 00       	push   $0xb26
 261:	57                   	push   %edi
 262:	e8 4b 04 00 00       	call   6b2 <ftag>
  assert(res > 0);
 267:	83 c4 10             	add    $0x10,%esp
 26a:	85 c0                	test   %eax,%eax
 26c:	0f 8e 4a 01 00 00    	jle    3bc <tagsTest+0x19c>
  res = ftag(fd, key2, val2);
 272:	83 ec 04             	sub    $0x4,%esp
 275:	68 64 0b 00 00       	push   $0xb64
 27a:	68 6b 0b 00 00       	push   $0xb6b
 27f:	57                   	push   %edi
 280:	e8 2d 04 00 00       	call   6b2 <ftag>
  assert(res > 0);
 285:	83 c4 10             	add    $0x10,%esp
 288:	85 c0                	test   %eax,%eax
 28a:	0f 8e 0f 01 00 00    	jle    39f <tagsTest+0x17f>

  gettag(fd, key1, buf);
 290:	8d 75 e1             	lea    -0x1f(%ebp),%esi
 293:	83 ec 04             	sub    $0x4,%esp
  printf(1, "buf is: %s\n", buf);

  int i;
  for(i = 0; i < strlen(val1); i++){
 296:	31 db                	xor    %ebx,%ebx
  int res = ftag(fd, key1, val1);
  assert(res > 0);
  res = ftag(fd, key2, val2);
  assert(res > 0);

  gettag(fd, key1, buf);
 298:	56                   	push   %esi
 299:	68 26 0b 00 00       	push   $0xb26
 29e:	57                   	push   %edi
 29f:	e8 1e 04 00 00       	call   6c2 <gettag>
  printf(1, "buf is: %s\n", buf);
 2a4:	83 c4 0c             	add    $0xc,%esp
 2a7:	56                   	push   %esi
 2a8:	68 70 0b 00 00       	push   $0xb70
 2ad:	6a 01                	push   $0x1
 2af:	e8 bc 04 00 00       	call   770 <printf>

  int i;
  for(i = 0; i < strlen(val1); i++){
 2b4:	83 c4 10             	add    $0x10,%esp
 2b7:	eb 1a                	jmp    2d3 <tagsTest+0xb3>
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    char v_actual = buf[i];
    char v_expected = val1[i];
    assert(v_actual == v_expected);
 2c0:	0f b6 83 1f 0b 00 00 	movzbl 0xb1f(%ebx),%eax
 2c7:	38 04 1e             	cmp    %al,(%esi,%ebx,1)
 2ca:	0f 85 85 00 00 00    	jne    355 <tagsTest+0x135>

  gettag(fd, key1, buf);
  printf(1, "buf is: %s\n", buf);

  int i;
  for(i = 0; i < strlen(val1); i++){
 2d0:	83 c3 01             	add    $0x1,%ebx
 2d3:	83 ec 0c             	sub    $0xc,%esp
 2d6:	68 1f 0b 00 00       	push   $0xb1f
 2db:	e8 60 01 00 00       	call   440 <strlen>
 2e0:	83 c4 10             	add    $0x10,%esp
 2e3:	39 d8                	cmp    %ebx,%eax
 2e5:	77 d9                	ja     2c0 <tagsTest+0xa0>
    char v_actual = buf[i];
    char v_expected = val1[i];
    assert(v_actual == v_expected);
  }
  
  gettag(fd, key2, buf);
 2e7:	83 ec 04             	sub    $0x4,%esp
  printf(1, "buf is: %s\n", buf);
  
  for(i = 0; i < strlen(val2); i++){
 2ea:	31 db                	xor    %ebx,%ebx
    char v_actual = buf[i];
    char v_expected = val1[i];
    assert(v_actual == v_expected);
  }
  
  gettag(fd, key2, buf);
 2ec:	56                   	push   %esi
 2ed:	68 6b 0b 00 00       	push   $0xb6b
 2f2:	57                   	push   %edi
 2f3:	e8 ca 03 00 00       	call   6c2 <gettag>
  printf(1, "buf is: %s\n", buf);
 2f8:	83 c4 0c             	add    $0xc,%esp
 2fb:	56                   	push   %esi
 2fc:	68 70 0b 00 00       	push   $0xb70
 301:	6a 01                	push   $0x1
 303:	e8 68 04 00 00       	call   770 <printf>
  
  for(i = 0; i < strlen(val2); i++){
 308:	83 c4 10             	add    $0x10,%esp
 30b:	eb 12                	jmp    31f <tagsTest+0xff>
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    char v_actual = buf[i];
    char v_expected = val2[i];
    assert(v_actual == v_expected);
 310:	0f b6 83 64 0b 00 00 	movzbl 0xb64(%ebx),%eax
 317:	38 04 1e             	cmp    %al,(%esi,%ebx,1)
 31a:	75 7f                	jne    39b <tagsTest+0x17b>
  }
  
  gettag(fd, key2, buf);
  printf(1, "buf is: %s\n", buf);
  
  for(i = 0; i < strlen(val2); i++){
 31c:	83 c3 01             	add    $0x1,%ebx
 31f:	83 ec 0c             	sub    $0xc,%esp
 322:	68 64 0b 00 00       	push   $0xb64
 327:	e8 14 01 00 00       	call   440 <strlen>
 32c:	83 c4 10             	add    $0x10,%esp
 32f:	39 d8                	cmp    %ebx,%eax
 331:	77 dd                	ja     310 <tagsTest+0xf0>
    char v_actual = buf[i];
    char v_expected = val2[i];
    assert(v_actual == v_expected);
  }

  close(fd);
 333:	83 ec 0c             	sub    $0xc,%esp
 336:	57                   	push   %edi
 337:	e8 ee 02 00 00       	call   62a <close>
  printf(1, "TEST PASSED\n");
 33c:	58                   	pop    %eax
 33d:	5a                   	pop    %edx
 33e:	68 93 0b 00 00       	push   $0xb93
 343:	6a 01                	push   $0x1
 345:	e8 26 04 00 00       	call   770 <printf>
}
 34a:	83 c4 10             	add    $0x10,%esp
 34d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 350:	5b                   	pop    %ebx
 351:	5e                   	pop    %esi
 352:	5f                   	pop    %edi
 353:	5d                   	pop    %ebp
 354:	c3                   	ret    

  int i;
  for(i = 0; i < strlen(val1); i++){
    char v_actual = buf[i];
    char v_expected = val1[i];
    assert(v_actual == v_expected);
 355:	6a 75                	push   $0x75
  printf(1, "buf is: %s\n", buf);
  
  for(i = 0; i < strlen(val2); i++){
    char v_actual = buf[i];
    char v_expected = val2[i];
    assert(v_actual == v_expected);
 357:	68 2b 0b 00 00       	push   $0xb2b
 35c:	68 33 0b 00 00       	push   $0xb33
 361:	6a 01                	push   $0x1
 363:	e8 08 04 00 00       	call   770 <printf>
 368:	83 c4 0c             	add    $0xc,%esp
 36b:	68 7c 0b 00 00       	push   $0xb7c
  char buf[7];

  int res = ftag(fd, key1, val1);
  assert(res > 0);
  res = ftag(fd, key2, val2);
  assert(res > 0);
 370:	68 43 0b 00 00       	push   $0xb43
 375:	6a 01                	push   $0x1
 377:	e8 f4 03 00 00       	call   770 <printf>
 37c:	59                   	pop    %ecx
 37d:	5b                   	pop    %ebx
 37e:	68 57 0b 00 00       	push   $0xb57
 383:	6a 01                	push   $0x1
 385:	e8 e6 03 00 00       	call   770 <printf>
 38a:	5e                   	pop    %esi
 38b:	ff 35 88 0f 00 00    	pushl  0xf88
 391:	e8 9c 02 00 00       	call   632 <kill>
 396:	e8 67 02 00 00       	call   602 <exit>
  printf(1, "buf is: %s\n", buf);
  
  for(i = 0; i < strlen(val2); i++){
    char v_actual = buf[i];
    char v_expected = val2[i];
    assert(v_actual == v_expected);
 39b:	6a 7e                	push   $0x7e
 39d:	eb b8                	jmp    357 <tagsTest+0x137>
  char buf[7];

  int res = ftag(fd, key1, val1);
  assert(res > 0);
  res = ftag(fd, key2, val2);
  assert(res > 0);
 39f:	6a 6c                	push   $0x6c
 3a1:	68 2b 0b 00 00       	push   $0xb2b
 3a6:	68 33 0b 00 00       	push   $0xb33
 3ab:	6a 01                	push   $0x1
 3ad:	e8 be 03 00 00       	call   770 <printf>
 3b2:	83 c4 0c             	add    $0xc,%esp
 3b5:	68 3b 0b 00 00       	push   $0xb3b
 3ba:	eb b4                	jmp    370 <tagsTest+0x150>
  char* val2 = "value2";

  char buf[7];

  int res = ftag(fd, key1, val1);
  assert(res > 0);
 3bc:	6a 6a                	push   $0x6a
 3be:	eb e1                	jmp    3a1 <tagsTest+0x181>

000003c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ca:	89 c2                	mov    %eax,%edx
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d0:	83 c1 01             	add    $0x1,%ecx
 3d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3d7:	83 c2 01             	add    $0x1,%edx
 3da:	84 db                	test   %bl,%bl
 3dc:	88 5a ff             	mov    %bl,-0x1(%edx)
 3df:	75 ef                	jne    3d0 <strcpy+0x10>
    ;
  return os;
}
 3e1:	5b                   	pop    %ebx
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	56                   	push   %esi
 3f4:	53                   	push   %ebx
 3f5:	8b 55 08             	mov    0x8(%ebp),%edx
 3f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3fb:	0f b6 02             	movzbl (%edx),%eax
 3fe:	0f b6 19             	movzbl (%ecx),%ebx
 401:	84 c0                	test   %al,%al
 403:	75 1e                	jne    423 <strcmp+0x33>
 405:	eb 29                	jmp    430 <strcmp+0x40>
 407:	89 f6                	mov    %esi,%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 410:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 413:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 416:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 419:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 41d:	84 c0                	test   %al,%al
 41f:	74 0f                	je     430 <strcmp+0x40>
 421:	89 f1                	mov    %esi,%ecx
 423:	38 d8                	cmp    %bl,%al
 425:	74 e9                	je     410 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 427:	29 d8                	sub    %ebx,%eax
}
 429:	5b                   	pop    %ebx
 42a:	5e                   	pop    %esi
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret    
 42d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 430:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 432:	29 d8                	sub    %ebx,%eax
}
 434:	5b                   	pop    %ebx
 435:	5e                   	pop    %esi
 436:	5d                   	pop    %ebp
 437:	c3                   	ret    
 438:	90                   	nop
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000440 <strlen>:

uint
strlen(char *s)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 446:	80 39 00             	cmpb   $0x0,(%ecx)
 449:	74 12                	je     45d <strlen+0x1d>
 44b:	31 d2                	xor    %edx,%edx
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	83 c2 01             	add    $0x1,%edx
 453:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 457:	89 d0                	mov    %edx,%eax
 459:	75 f5                	jne    450 <strlen+0x10>
    ;
  return n;
}
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 45d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    
 461:	eb 0d                	jmp    470 <memset>
 463:	90                   	nop
 464:	90                   	nop
 465:	90                   	nop
 466:	90                   	nop
 467:	90                   	nop
 468:	90                   	nop
 469:	90                   	nop
 46a:	90                   	nop
 46b:	90                   	nop
 46c:	90                   	nop
 46d:	90                   	nop
 46e:	90                   	nop
 46f:	90                   	nop

00000470 <memset>:

void*
memset(void *dst, int c, uint n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 477:	8b 4d 10             	mov    0x10(%ebp),%ecx
 47a:	8b 45 0c             	mov    0xc(%ebp),%eax
 47d:	89 d7                	mov    %edx,%edi
 47f:	fc                   	cld    
 480:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 482:	89 d0                	mov    %edx,%eax
 484:	5f                   	pop    %edi
 485:	5d                   	pop    %ebp
 486:	c3                   	ret    
 487:	89 f6                	mov    %esi,%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000490 <strchr>:

char*
strchr(const char *s, char c)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	53                   	push   %ebx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 49a:	0f b6 10             	movzbl (%eax),%edx
 49d:	84 d2                	test   %dl,%dl
 49f:	74 1d                	je     4be <strchr+0x2e>
    if(*s == c)
 4a1:	38 d3                	cmp    %dl,%bl
 4a3:	89 d9                	mov    %ebx,%ecx
 4a5:	75 0d                	jne    4b4 <strchr+0x24>
 4a7:	eb 17                	jmp    4c0 <strchr+0x30>
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4b0:	38 ca                	cmp    %cl,%dl
 4b2:	74 0c                	je     4c0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4b4:	83 c0 01             	add    $0x1,%eax
 4b7:	0f b6 10             	movzbl (%eax),%edx
 4ba:	84 d2                	test   %dl,%dl
 4bc:	75 f2                	jne    4b0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 4be:	31 c0                	xor    %eax,%eax
}
 4c0:	5b                   	pop    %ebx
 4c1:	5d                   	pop    %ebp
 4c2:	c3                   	ret    
 4c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <gets>:

char*
gets(char *buf, int max)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 4d8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 4db:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4de:	eb 29                	jmp    509 <gets+0x39>
    cc = read(0, &c, 1);
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	6a 01                	push   $0x1
 4e5:	57                   	push   %edi
 4e6:	6a 00                	push   $0x0
 4e8:	e8 2d 01 00 00       	call   61a <read>
    if(cc < 1)
 4ed:	83 c4 10             	add    $0x10,%esp
 4f0:	85 c0                	test   %eax,%eax
 4f2:	7e 1d                	jle    511 <gets+0x41>
      break;
    buf[i++] = c;
 4f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4f8:	8b 55 08             	mov    0x8(%ebp),%edx
 4fb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 4fd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 4ff:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 503:	74 1b                	je     520 <gets+0x50>
 505:	3c 0d                	cmp    $0xd,%al
 507:	74 17                	je     520 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 509:	8d 5e 01             	lea    0x1(%esi),%ebx
 50c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 50f:	7c cf                	jl     4e0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 518:	8d 65 f4             	lea    -0xc(%ebp),%esp
 51b:	5b                   	pop    %ebx
 51c:	5e                   	pop    %esi
 51d:	5f                   	pop    %edi
 51e:	5d                   	pop    %ebp
 51f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 520:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 523:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 525:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 529:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52c:	5b                   	pop    %ebx
 52d:	5e                   	pop    %esi
 52e:	5f                   	pop    %edi
 52f:	5d                   	pop    %ebp
 530:	c3                   	ret    
 531:	eb 0d                	jmp    540 <stat>
 533:	90                   	nop
 534:	90                   	nop
 535:	90                   	nop
 536:	90                   	nop
 537:	90                   	nop
 538:	90                   	nop
 539:	90                   	nop
 53a:	90                   	nop
 53b:	90                   	nop
 53c:	90                   	nop
 53d:	90                   	nop
 53e:	90                   	nop
 53f:	90                   	nop

00000540 <stat>:

int
stat(char *n, struct stat *st)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	56                   	push   %esi
 544:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 545:	83 ec 08             	sub    $0x8,%esp
 548:	6a 00                	push   $0x0
 54a:	ff 75 08             	pushl  0x8(%ebp)
 54d:	e8 f0 00 00 00       	call   642 <open>
  if(fd < 0)
 552:	83 c4 10             	add    $0x10,%esp
 555:	85 c0                	test   %eax,%eax
 557:	78 27                	js     580 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 559:	83 ec 08             	sub    $0x8,%esp
 55c:	ff 75 0c             	pushl  0xc(%ebp)
 55f:	89 c3                	mov    %eax,%ebx
 561:	50                   	push   %eax
 562:	e8 f3 00 00 00       	call   65a <fstat>
 567:	89 c6                	mov    %eax,%esi
  close(fd);
 569:	89 1c 24             	mov    %ebx,(%esp)
 56c:	e8 b9 00 00 00       	call   62a <close>
  return r;
 571:	83 c4 10             	add    $0x10,%esp
 574:	89 f0                	mov    %esi,%eax
}
 576:	8d 65 f8             	lea    -0x8(%ebp),%esp
 579:	5b                   	pop    %ebx
 57a:	5e                   	pop    %esi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
 57d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 585:	eb ef                	jmp    576 <stat+0x36>
 587:	89 f6                	mov    %esi,%esi
 589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000590 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	53                   	push   %ebx
 594:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 597:	0f be 11             	movsbl (%ecx),%edx
 59a:	8d 42 d0             	lea    -0x30(%edx),%eax
 59d:	3c 09                	cmp    $0x9,%al
 59f:	b8 00 00 00 00       	mov    $0x0,%eax
 5a4:	77 1f                	ja     5c5 <atoi+0x35>
 5a6:	8d 76 00             	lea    0x0(%esi),%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 5b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5b3:	83 c1 01             	add    $0x1,%ecx
 5b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5ba:	0f be 11             	movsbl (%ecx),%edx
 5bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5c0:	80 fb 09             	cmp    $0x9,%bl
 5c3:	76 eb                	jbe    5b0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 5c5:	5b                   	pop    %ebx
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret    
 5c8:	90                   	nop
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	56                   	push   %esi
 5d4:	53                   	push   %ebx
 5d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5de:	85 db                	test   %ebx,%ebx
 5e0:	7e 14                	jle    5f6 <memmove+0x26>
 5e2:	31 d2                	xor    %edx,%edx
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5ef:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5f2:	39 da                	cmp    %ebx,%edx
 5f4:	75 f2                	jne    5e8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 5f6:	5b                   	pop    %ebx
 5f7:	5e                   	pop    %esi
 5f8:	5d                   	pop    %ebp
 5f9:	c3                   	ret    

000005fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5fa:	b8 01 00 00 00       	mov    $0x1,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <exit>:
SYSCALL(exit)
 602:	b8 02 00 00 00       	mov    $0x2,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <wait>:
SYSCALL(wait)
 60a:	b8 03 00 00 00       	mov    $0x3,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <pipe>:
SYSCALL(pipe)
 612:	b8 04 00 00 00       	mov    $0x4,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <read>:
SYSCALL(read)
 61a:	b8 05 00 00 00       	mov    $0x5,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <write>:
SYSCALL(write)
 622:	b8 10 00 00 00       	mov    $0x10,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <close>:
SYSCALL(close)
 62a:	b8 15 00 00 00       	mov    $0x15,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <kill>:
SYSCALL(kill)
 632:	b8 06 00 00 00       	mov    $0x6,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <exec>:
SYSCALL(exec)
 63a:	b8 07 00 00 00       	mov    $0x7,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <open>:
SYSCALL(open)
 642:	b8 0f 00 00 00       	mov    $0xf,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mknod>:
SYSCALL(mknod)
 64a:	b8 11 00 00 00       	mov    $0x11,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <unlink>:
SYSCALL(unlink)
 652:	b8 12 00 00 00       	mov    $0x12,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <fstat>:
SYSCALL(fstat)
 65a:	b8 08 00 00 00       	mov    $0x8,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <link>:
SYSCALL(link)
 662:	b8 13 00 00 00       	mov    $0x13,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <mkdir>:
SYSCALL(mkdir)
 66a:	b8 14 00 00 00       	mov    $0x14,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <chdir>:
SYSCALL(chdir)
 672:	b8 09 00 00 00       	mov    $0x9,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <dup>:
SYSCALL(dup)
 67a:	b8 0a 00 00 00       	mov    $0xa,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <getpid>:
SYSCALL(getpid)
 682:	b8 0b 00 00 00       	mov    $0xb,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <sbrk>:
SYSCALL(sbrk)
 68a:	b8 0c 00 00 00       	mov    $0xc,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <sleep>:
SYSCALL(sleep)
 692:	b8 0d 00 00 00       	mov    $0xd,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <uptime>:
SYSCALL(uptime)
 69a:	b8 0e 00 00 00       	mov    $0xe,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <symlink>:
SYSCALL(symlink)
 6a2:	b8 16 00 00 00       	mov    $0x16,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <readlink>:
SYSCALL(readlink)
 6aa:	b8 17 00 00 00       	mov    $0x17,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <ftag>:
SYSCALL(ftag)
 6b2:	b8 18 00 00 00       	mov    $0x18,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <funtag>:
SYSCALL(funtag)
 6ba:	b8 19 00 00 00       	mov    $0x19,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <gettag>:
SYSCALL(gettag)
 6c2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    
 6ca:	66 90                	xchg   %ax,%ax
 6cc:	66 90                	xchg   %ax,%ax
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	89 c6                	mov    %eax,%esi
 6d8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6de:	85 db                	test   %ebx,%ebx
 6e0:	74 7e                	je     760 <printint+0x90>
 6e2:	89 d0                	mov    %edx,%eax
 6e4:	c1 e8 1f             	shr    $0x1f,%eax
 6e7:	84 c0                	test   %al,%al
 6e9:	74 75                	je     760 <printint+0x90>
    neg = 1;
    x = -xx;
 6eb:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 6ed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 6f4:	f7 d8                	neg    %eax
 6f6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 6f9:	31 ff                	xor    %edi,%edi
 6fb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6fe:	89 ce                	mov    %ecx,%esi
 700:	eb 08                	jmp    70a <printint+0x3a>
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 708:	89 cf                	mov    %ecx,%edi
 70a:	31 d2                	xor    %edx,%edx
 70c:	8d 4f 01             	lea    0x1(%edi),%ecx
 70f:	f7 f6                	div    %esi
 711:	0f b6 92 2c 0c 00 00 	movzbl 0xc2c(%edx),%edx
  }while((x /= base) != 0);
 718:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 71a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 71d:	75 e9                	jne    708 <printint+0x38>
  if(neg)
 71f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 722:	8b 75 c0             	mov    -0x40(%ebp),%esi
 725:	85 c0                	test   %eax,%eax
 727:	74 08                	je     731 <printint+0x61>
    buf[i++] = '-';
 729:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 72e:	8d 4f 02             	lea    0x2(%edi),%ecx
 731:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 735:	8d 76 00             	lea    0x0(%esi),%esi
 738:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 73b:	83 ec 04             	sub    $0x4,%esp
 73e:	83 ef 01             	sub    $0x1,%edi
 741:	6a 01                	push   $0x1
 743:	53                   	push   %ebx
 744:	56                   	push   %esi
 745:	88 45 d7             	mov    %al,-0x29(%ebp)
 748:	e8 d5 fe ff ff       	call   622 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 74d:	83 c4 10             	add    $0x10,%esp
 750:	39 df                	cmp    %ebx,%edi
 752:	75 e4                	jne    738 <printint+0x68>
    putc(fd, buf[i]);
}
 754:	8d 65 f4             	lea    -0xc(%ebp),%esp
 757:	5b                   	pop    %ebx
 758:	5e                   	pop    %esi
 759:	5f                   	pop    %edi
 75a:	5d                   	pop    %ebp
 75b:	c3                   	ret    
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 760:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 762:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 769:	eb 8b                	jmp    6f6 <printint+0x26>
 76b:	90                   	nop
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000770 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 776:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 779:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 77c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 77f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 782:	89 45 d0             	mov    %eax,-0x30(%ebp)
 785:	0f b6 1e             	movzbl (%esi),%ebx
 788:	83 c6 01             	add    $0x1,%esi
 78b:	84 db                	test   %bl,%bl
 78d:	0f 84 b0 00 00 00    	je     843 <printf+0xd3>
 793:	31 d2                	xor    %edx,%edx
 795:	eb 39                	jmp    7d0 <printf+0x60>
 797:	89 f6                	mov    %esi,%esi
 799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7a0:	83 f8 25             	cmp    $0x25,%eax
 7a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 7a6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7ab:	74 18                	je     7c5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7ad:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 7b0:	83 ec 04             	sub    $0x4,%esp
 7b3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 7b6:	6a 01                	push   $0x1
 7b8:	50                   	push   %eax
 7b9:	57                   	push   %edi
 7ba:	e8 63 fe ff ff       	call   622 <write>
 7bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 7c2:	83 c4 10             	add    $0x10,%esp
 7c5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7c8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7cc:	84 db                	test   %bl,%bl
 7ce:	74 73                	je     843 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 7d0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 7d2:	0f be cb             	movsbl %bl,%ecx
 7d5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7d8:	74 c6                	je     7a0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7da:	83 fa 25             	cmp    $0x25,%edx
 7dd:	75 e6                	jne    7c5 <printf+0x55>
      if(c == 'd'){
 7df:	83 f8 64             	cmp    $0x64,%eax
 7e2:	0f 84 f8 00 00 00    	je     8e0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7e8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7ee:	83 f9 70             	cmp    $0x70,%ecx
 7f1:	74 5d                	je     850 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7f3:	83 f8 73             	cmp    $0x73,%eax
 7f6:	0f 84 84 00 00 00    	je     880 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7fc:	83 f8 63             	cmp    $0x63,%eax
 7ff:	0f 84 ea 00 00 00    	je     8ef <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 805:	83 f8 25             	cmp    $0x25,%eax
 808:	0f 84 c2 00 00 00    	je     8d0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 80e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 811:	83 ec 04             	sub    $0x4,%esp
 814:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 818:	6a 01                	push   $0x1
 81a:	50                   	push   %eax
 81b:	57                   	push   %edi
 81c:	e8 01 fe ff ff       	call   622 <write>
 821:	83 c4 0c             	add    $0xc,%esp
 824:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 827:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 82a:	6a 01                	push   $0x1
 82c:	50                   	push   %eax
 82d:	57                   	push   %edi
 82e:	83 c6 01             	add    $0x1,%esi
 831:	e8 ec fd ff ff       	call   622 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 836:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 83a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 83d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 83f:	84 db                	test   %bl,%bl
 841:	75 8d                	jne    7d0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 843:	8d 65 f4             	lea    -0xc(%ebp),%esp
 846:	5b                   	pop    %ebx
 847:	5e                   	pop    %esi
 848:	5f                   	pop    %edi
 849:	5d                   	pop    %ebp
 84a:	c3                   	ret    
 84b:	90                   	nop
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 850:	83 ec 0c             	sub    $0xc,%esp
 853:	b9 10 00 00 00       	mov    $0x10,%ecx
 858:	6a 00                	push   $0x0
 85a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 85d:	89 f8                	mov    %edi,%eax
 85f:	8b 13                	mov    (%ebx),%edx
 861:	e8 6a fe ff ff       	call   6d0 <printint>
        ap++;
 866:	89 d8                	mov    %ebx,%eax
 868:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 86b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 86d:	83 c0 04             	add    $0x4,%eax
 870:	89 45 d0             	mov    %eax,-0x30(%ebp)
 873:	e9 4d ff ff ff       	jmp    7c5 <printf+0x55>
 878:	90                   	nop
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 880:	8b 45 d0             	mov    -0x30(%ebp),%eax
 883:	8b 18                	mov    (%eax),%ebx
        ap++;
 885:	83 c0 04             	add    $0x4,%eax
 888:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 88b:	b8 24 0c 00 00       	mov    $0xc24,%eax
 890:	85 db                	test   %ebx,%ebx
 892:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 895:	0f b6 03             	movzbl (%ebx),%eax
 898:	84 c0                	test   %al,%al
 89a:	74 23                	je     8bf <printf+0x14f>
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8a0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8a3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 8a6:	83 ec 04             	sub    $0x4,%esp
 8a9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 8ab:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8ae:	50                   	push   %eax
 8af:	57                   	push   %edi
 8b0:	e8 6d fd ff ff       	call   622 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8b5:	0f b6 03             	movzbl (%ebx),%eax
 8b8:	83 c4 10             	add    $0x10,%esp
 8bb:	84 c0                	test   %al,%al
 8bd:	75 e1                	jne    8a0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8bf:	31 d2                	xor    %edx,%edx
 8c1:	e9 ff fe ff ff       	jmp    7c5 <printf+0x55>
 8c6:	8d 76 00             	lea    0x0(%esi),%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8d0:	83 ec 04             	sub    $0x4,%esp
 8d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8d9:	6a 01                	push   $0x1
 8db:	e9 4c ff ff ff       	jmp    82c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8e0:	83 ec 0c             	sub    $0xc,%esp
 8e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8e8:	6a 01                	push   $0x1
 8ea:	e9 6b ff ff ff       	jmp    85a <printf+0xea>
 8ef:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8f2:	83 ec 04             	sub    $0x4,%esp
 8f5:	8b 03                	mov    (%ebx),%eax
 8f7:	6a 01                	push   $0x1
 8f9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 8fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8ff:	50                   	push   %eax
 900:	57                   	push   %edi
 901:	e8 1c fd ff ff       	call   622 <write>
 906:	e9 5b ff ff ff       	jmp    866 <printf+0xf6>
 90b:	66 90                	xchg   %ax,%ax
 90d:	66 90                	xchg   %ax,%ax
 90f:	90                   	nop

00000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 911:	a1 7c 0f 00 00       	mov    0xf7c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 916:	89 e5                	mov    %esp,%ebp
 918:	57                   	push   %edi
 919:	56                   	push   %esi
 91a:	53                   	push   %ebx
 91b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 920:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 923:	39 c8                	cmp    %ecx,%eax
 925:	73 19                	jae    940 <free+0x30>
 927:	89 f6                	mov    %esi,%esi
 929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 930:	39 d1                	cmp    %edx,%ecx
 932:	72 1c                	jb     950 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	39 d0                	cmp    %edx,%eax
 936:	73 18                	jae    950 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 938:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93e:	72 f0                	jb     930 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 940:	39 d0                	cmp    %edx,%eax
 942:	72 f4                	jb     938 <free+0x28>
 944:	39 d1                	cmp    %edx,%ecx
 946:	73 f0                	jae    938 <free+0x28>
 948:	90                   	nop
 949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 950:	8b 73 fc             	mov    -0x4(%ebx),%esi
 953:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 956:	39 d7                	cmp    %edx,%edi
 958:	74 19                	je     973 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 95a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 95d:	8b 50 04             	mov    0x4(%eax),%edx
 960:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 963:	39 f1                	cmp    %esi,%ecx
 965:	74 23                	je     98a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 967:	89 08                	mov    %ecx,(%eax)
  freep = p;
 969:	a3 7c 0f 00 00       	mov    %eax,0xf7c
}
 96e:	5b                   	pop    %ebx
 96f:	5e                   	pop    %esi
 970:	5f                   	pop    %edi
 971:	5d                   	pop    %ebp
 972:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 973:	03 72 04             	add    0x4(%edx),%esi
 976:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 979:	8b 10                	mov    (%eax),%edx
 97b:	8b 12                	mov    (%edx),%edx
 97d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 980:	8b 50 04             	mov    0x4(%eax),%edx
 983:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 986:	39 f1                	cmp    %esi,%ecx
 988:	75 dd                	jne    967 <free+0x57>
    p->s.size += bp->s.size;
 98a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 98d:	a3 7c 0f 00 00       	mov    %eax,0xf7c
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 992:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 995:	8b 53 f8             	mov    -0x8(%ebx),%edx
 998:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 99a:	5b                   	pop    %ebx
 99b:	5e                   	pop    %esi
 99c:	5f                   	pop    %edi
 99d:	5d                   	pop    %ebp
 99e:	c3                   	ret    
 99f:	90                   	nop

000009a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	57                   	push   %edi
 9a4:	56                   	push   %esi
 9a5:	53                   	push   %ebx
 9a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9ac:	8b 15 7c 0f 00 00    	mov    0xf7c,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b2:	8d 78 07             	lea    0x7(%eax),%edi
 9b5:	c1 ef 03             	shr    $0x3,%edi
 9b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9bb:	85 d2                	test   %edx,%edx
 9bd:	0f 84 a3 00 00 00    	je     a66 <malloc+0xc6>
 9c3:	8b 02                	mov    (%edx),%eax
 9c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9c8:	39 cf                	cmp    %ecx,%edi
 9ca:	76 74                	jbe    a40 <malloc+0xa0>
 9cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9d2:	be 00 10 00 00       	mov    $0x1000,%esi
 9d7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 9de:	0f 43 f7             	cmovae %edi,%esi
 9e1:	ba 00 80 00 00       	mov    $0x8000,%edx
 9e6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 9ec:	0f 46 da             	cmovbe %edx,%ebx
 9ef:	eb 10                	jmp    a01 <malloc+0x61>
 9f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9fa:	8b 48 04             	mov    0x4(%eax),%ecx
 9fd:	39 cf                	cmp    %ecx,%edi
 9ff:	76 3f                	jbe    a40 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a01:	39 05 7c 0f 00 00    	cmp    %eax,0xf7c
 a07:	89 c2                	mov    %eax,%edx
 a09:	75 ed                	jne    9f8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 a0b:	83 ec 0c             	sub    $0xc,%esp
 a0e:	53                   	push   %ebx
 a0f:	e8 76 fc ff ff       	call   68a <sbrk>
  if(p == (char*)-1)
 a14:	83 c4 10             	add    $0x10,%esp
 a17:	83 f8 ff             	cmp    $0xffffffff,%eax
 a1a:	74 1c                	je     a38 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a1c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 a1f:	83 ec 0c             	sub    $0xc,%esp
 a22:	83 c0 08             	add    $0x8,%eax
 a25:	50                   	push   %eax
 a26:	e8 e5 fe ff ff       	call   910 <free>
  return freep;
 a2b:	8b 15 7c 0f 00 00    	mov    0xf7c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a31:	83 c4 10             	add    $0x10,%esp
 a34:	85 d2                	test   %edx,%edx
 a36:	75 c0                	jne    9f8 <malloc+0x58>
        return 0;
 a38:	31 c0                	xor    %eax,%eax
 a3a:	eb 1c                	jmp    a58 <malloc+0xb8>
 a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 a40:	39 cf                	cmp    %ecx,%edi
 a42:	74 1c                	je     a60 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a44:	29 f9                	sub    %edi,%ecx
 a46:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a49:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a4c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 a4f:	89 15 7c 0f 00 00    	mov    %edx,0xf7c
      return (void*)(p + 1);
 a55:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a5b:	5b                   	pop    %ebx
 a5c:	5e                   	pop    %esi
 a5d:	5f                   	pop    %edi
 a5e:	5d                   	pop    %ebp
 a5f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a60:	8b 08                	mov    (%eax),%ecx
 a62:	89 0a                	mov    %ecx,(%edx)
 a64:	eb e9                	jmp    a4f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a66:	c7 05 7c 0f 00 00 80 	movl   $0xf80,0xf7c
 a6d:	0f 00 00 
 a70:	c7 05 80 0f 00 00 80 	movl   $0xf80,0xf80
 a77:	0f 00 00 
    base.s.size = 0;
 a7a:	b8 80 0f 00 00       	mov    $0xf80,%eax
 a7f:	c7 05 84 0f 00 00 00 	movl   $0x0,0xf84
 a86:	00 00 00 
 a89:	e9 3e ff ff ff       	jmp    9cc <malloc+0x2c>
