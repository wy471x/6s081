
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	33c080e7          	jalr	828(ra) # 348 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	310080e7          	jalr	784(ra) # 348 <strlen>
  40:	47b5                	li	a5,13
  42:	00a7f863          	bgeu	a5,a0,52 <fmtname+0x52>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  46:	8526                	mv	a0,s1
  48:	70a2                	ld	ra,40(sp)
  4a:	7402                	ld	s0,32(sp)
  4c:	64e2                	ld	s1,24(sp)
  4e:	6145                	addi	sp,sp,48
  50:	8082                	ret
  52:	e84a                	sd	s2,16(sp)
  54:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  56:	8526                	mv	a0,s1
  58:	00000097          	auipc	ra,0x0
  5c:	2f0080e7          	jalr	752(ra) # 348 <strlen>
  60:	862a                	mv	a2,a0
  62:	00001997          	auipc	s3,0x1
  66:	b3698993          	addi	s3,s3,-1226 # b98 <buf.0>
  6a:	85a6                	mv	a1,s1
  6c:	854e                	mv	a0,s3
  6e:	00000097          	auipc	ra,0x0
  72:	470080e7          	jalr	1136(ra) # 4de <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  76:	8526                	mv	a0,s1
  78:	00000097          	auipc	ra,0x0
  7c:	2d0080e7          	jalr	720(ra) # 348 <strlen>
  80:	892a                	mv	s2,a0
  82:	8526                	mv	a0,s1
  84:	00000097          	auipc	ra,0x0
  88:	2c4080e7          	jalr	708(ra) # 348 <strlen>
  8c:	1902                	slli	s2,s2,0x20
  8e:	02095913          	srli	s2,s2,0x20
  92:	4639                	li	a2,14
  94:	9e09                	subw	a2,a2,a0
  96:	02000593          	li	a1,32
  9a:	01298533          	add	a0,s3,s2
  9e:	00000097          	auipc	ra,0x0
  a2:	2d8080e7          	jalr	728(ra) # 376 <memset>
  return buf;
  a6:	84ce                	mv	s1,s3
  a8:	6942                	ld	s2,16(sp)
  aa:	69a2                	ld	s3,8(sp)
  ac:	bf69                	j	46 <fmtname+0x46>

00000000000000ae <ls>:

void
ls(char *path)
{
  ae:	d7010113          	addi	sp,sp,-656
  b2:	28113423          	sd	ra,648(sp)
  b6:	28813023          	sd	s0,640(sp)
  ba:	27213823          	sd	s2,624(sp)
  be:	0d00                	addi	s0,sp,656
  c0:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c2:	4581                	li	a1,0
  c4:	00000097          	auipc	ra,0x0
  c8:	514080e7          	jalr	1300(ra) # 5d8 <open>
  cc:	06054963          	bltz	a0,13e <ls+0x90>
  d0:	26913c23          	sd	s1,632(sp)
  d4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  d6:	d7840593          	addi	a1,s0,-648
  da:	00000097          	auipc	ra,0x0
  de:	516080e7          	jalr	1302(ra) # 5f0 <fstat>
  e2:	06054963          	bltz	a0,154 <ls+0xa6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  e6:	d8041783          	lh	a5,-640(s0)
  ea:	4705                	li	a4,1
  ec:	08e78663          	beq	a5,a4,178 <ls+0xca>
  f0:	4709                	li	a4,2
  f2:	02e79663          	bne	a5,a4,11e <ls+0x70>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
  f6:	854a                	mv	a0,s2
  f8:	00000097          	auipc	ra,0x0
  fc:	f08080e7          	jalr	-248(ra) # 0 <fmtname>
 100:	85aa                	mv	a1,a0
 102:	d8843703          	ld	a4,-632(s0)
 106:	d7c42683          	lw	a3,-644(s0)
 10a:	d8041603          	lh	a2,-640(s0)
 10e:	00001517          	auipc	a0,0x1
 112:	9ca50513          	addi	a0,a0,-1590 # ad8 <malloc+0x12e>
 116:	00000097          	auipc	ra,0x0
 11a:	7d8080e7          	jalr	2008(ra) # 8ee <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 11e:	8526                	mv	a0,s1
 120:	00000097          	auipc	ra,0x0
 124:	4a0080e7          	jalr	1184(ra) # 5c0 <close>
 128:	27813483          	ld	s1,632(sp)
}
 12c:	28813083          	ld	ra,648(sp)
 130:	28013403          	ld	s0,640(sp)
 134:	27013903          	ld	s2,624(sp)
 138:	29010113          	addi	sp,sp,656
 13c:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 13e:	864a                	mv	a2,s2
 140:	00001597          	auipc	a1,0x1
 144:	96858593          	addi	a1,a1,-1688 # aa8 <malloc+0xfe>
 148:	4509                	li	a0,2
 14a:	00000097          	auipc	ra,0x0
 14e:	776080e7          	jalr	1910(ra) # 8c0 <fprintf>
    return;
 152:	bfe9                	j	12c <ls+0x7e>
    fprintf(2, "ls: cannot stat %s\n", path);
 154:	864a                	mv	a2,s2
 156:	00001597          	auipc	a1,0x1
 15a:	96a58593          	addi	a1,a1,-1686 # ac0 <malloc+0x116>
 15e:	4509                	li	a0,2
 160:	00000097          	auipc	ra,0x0
 164:	760080e7          	jalr	1888(ra) # 8c0 <fprintf>
    close(fd);
 168:	8526                	mv	a0,s1
 16a:	00000097          	auipc	ra,0x0
 16e:	456080e7          	jalr	1110(ra) # 5c0 <close>
    return;
 172:	27813483          	ld	s1,632(sp)
 176:	bf5d                	j	12c <ls+0x7e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 178:	854a                	mv	a0,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	1ce080e7          	jalr	462(ra) # 348 <strlen>
 182:	2541                	addiw	a0,a0,16
 184:	20000793          	li	a5,512
 188:	00a7fb63          	bgeu	a5,a0,19e <ls+0xf0>
      printf("ls: path too long\n");
 18c:	00001517          	auipc	a0,0x1
 190:	95c50513          	addi	a0,a0,-1700 # ae8 <malloc+0x13e>
 194:	00000097          	auipc	ra,0x0
 198:	75a080e7          	jalr	1882(ra) # 8ee <printf>
      break;
 19c:	b749                	j	11e <ls+0x70>
 19e:	27313423          	sd	s3,616(sp)
 1a2:	27413023          	sd	s4,608(sp)
 1a6:	25513c23          	sd	s5,600(sp)
 1aa:	25613823          	sd	s6,592(sp)
 1ae:	25713423          	sd	s7,584(sp)
 1b2:	25813023          	sd	s8,576(sp)
 1b6:	23913c23          	sd	s9,568(sp)
 1ba:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 1be:	da040993          	addi	s3,s0,-608
 1c2:	85ca                	mv	a1,s2
 1c4:	854e                	mv	a0,s3
 1c6:	00000097          	auipc	ra,0x0
 1ca:	132080e7          	jalr	306(ra) # 2f8 <strcpy>
    p = buf+strlen(buf);
 1ce:	854e                	mv	a0,s3
 1d0:	00000097          	auipc	ra,0x0
 1d4:	178080e7          	jalr	376(ra) # 348 <strlen>
 1d8:	1502                	slli	a0,a0,0x20
 1da:	9101                	srli	a0,a0,0x20
 1dc:	99aa                	add	s3,s3,a0
    *p++ = '/';
 1de:	00198c93          	addi	s9,s3,1
 1e2:	02f00793          	li	a5,47
 1e6:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ea:	d9040a13          	addi	s4,s0,-624
 1ee:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1f0:	d9240c13          	addi	s8,s0,-622
 1f4:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1f6:	d7840b13          	addi	s6,s0,-648
 1fa:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1fe:	00001d17          	auipc	s10,0x1
 202:	902d0d13          	addi	s10,s10,-1790 # b00 <malloc+0x156>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 206:	a811                	j	21a <ls+0x16c>
        printf("ls: cannot stat %s\n", buf);
 208:	85d6                	mv	a1,s5
 20a:	00001517          	auipc	a0,0x1
 20e:	8b650513          	addi	a0,a0,-1866 # ac0 <malloc+0x116>
 212:	00000097          	auipc	ra,0x0
 216:	6dc080e7          	jalr	1756(ra) # 8ee <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 21a:	864a                	mv	a2,s2
 21c:	85d2                	mv	a1,s4
 21e:	8526                	mv	a0,s1
 220:	00000097          	auipc	ra,0x0
 224:	390080e7          	jalr	912(ra) # 5b0 <read>
 228:	05251863          	bne	a0,s2,278 <ls+0x1ca>
      if(de.inum == 0)
 22c:	d9045783          	lhu	a5,-624(s0)
 230:	d7ed                	beqz	a5,21a <ls+0x16c>
      memmove(p, de.name, DIRSIZ);
 232:	865e                	mv	a2,s7
 234:	85e2                	mv	a1,s8
 236:	8566                	mv	a0,s9
 238:	00000097          	auipc	ra,0x0
 23c:	2a6080e7          	jalr	678(ra) # 4de <memmove>
      p[DIRSIZ] = 0;
 240:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 244:	85da                	mv	a1,s6
 246:	8556                	mv	a0,s5
 248:	00000097          	auipc	ra,0x0
 24c:	204080e7          	jalr	516(ra) # 44c <stat>
 250:	fa054ce3          	bltz	a0,208 <ls+0x15a>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 254:	8556                	mv	a0,s5
 256:	00000097          	auipc	ra,0x0
 25a:	daa080e7          	jalr	-598(ra) # 0 <fmtname>
 25e:	85aa                	mv	a1,a0
 260:	d8843703          	ld	a4,-632(s0)
 264:	d7c42683          	lw	a3,-644(s0)
 268:	d8041603          	lh	a2,-640(s0)
 26c:	856a                	mv	a0,s10
 26e:	00000097          	auipc	ra,0x0
 272:	680080e7          	jalr	1664(ra) # 8ee <printf>
 276:	b755                	j	21a <ls+0x16c>
 278:	26813983          	ld	s3,616(sp)
 27c:	26013a03          	ld	s4,608(sp)
 280:	25813a83          	ld	s5,600(sp)
 284:	25013b03          	ld	s6,592(sp)
 288:	24813b83          	ld	s7,584(sp)
 28c:	24013c03          	ld	s8,576(sp)
 290:	23813c83          	ld	s9,568(sp)
 294:	23013d03          	ld	s10,560(sp)
 298:	b559                	j	11e <ls+0x70>

000000000000029a <main>:

int
main(int argc, char *argv[])
{
 29a:	1101                	addi	sp,sp,-32
 29c:	ec06                	sd	ra,24(sp)
 29e:	e822                	sd	s0,16(sp)
 2a0:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 2a2:	4785                	li	a5,1
 2a4:	02a7db63          	bge	a5,a0,2da <main+0x40>
 2a8:	e426                	sd	s1,8(sp)
 2aa:	e04a                	sd	s2,0(sp)
 2ac:	00858493          	addi	s1,a1,8
 2b0:	ffe5091b          	addiw	s2,a0,-2
 2b4:	02091793          	slli	a5,s2,0x20
 2b8:	01d7d913          	srli	s2,a5,0x1d
 2bc:	05c1                	addi	a1,a1,16
 2be:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2c0:	6088                	ld	a0,0(s1)
 2c2:	00000097          	auipc	ra,0x0
 2c6:	dec080e7          	jalr	-532(ra) # ae <ls>
  for(i=1; i<argc; i++)
 2ca:	04a1                	addi	s1,s1,8
 2cc:	ff249ae3          	bne	s1,s2,2c0 <main+0x26>
  exit(0);
 2d0:	4501                	li	a0,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	2c6080e7          	jalr	710(ra) # 598 <exit>
 2da:	e426                	sd	s1,8(sp)
 2dc:	e04a                	sd	s2,0(sp)
    ls(".");
 2de:	00001517          	auipc	a0,0x1
 2e2:	83250513          	addi	a0,a0,-1998 # b10 <malloc+0x166>
 2e6:	00000097          	auipc	ra,0x0
 2ea:	dc8080e7          	jalr	-568(ra) # ae <ls>
    exit(0);
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	2a8080e7          	jalr	680(ra) # 598 <exit>

00000000000002f8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 300:	87aa                	mv	a5,a0
 302:	0585                	addi	a1,a1,1
 304:	0785                	addi	a5,a5,1
 306:	fff5c703          	lbu	a4,-1(a1)
 30a:	fee78fa3          	sb	a4,-1(a5)
 30e:	fb75                	bnez	a4,302 <strcpy+0xa>
    ;
  return os;
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 320:	00054783          	lbu	a5,0(a0)
 324:	cb91                	beqz	a5,338 <strcmp+0x20>
 326:	0005c703          	lbu	a4,0(a1)
 32a:	00f71763          	bne	a4,a5,338 <strcmp+0x20>
    p++, q++;
 32e:	0505                	addi	a0,a0,1
 330:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 332:	00054783          	lbu	a5,0(a0)
 336:	fbe5                	bnez	a5,326 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 338:	0005c503          	lbu	a0,0(a1)
}
 33c:	40a7853b          	subw	a0,a5,a0
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <strlen>:

uint
strlen(const char *s)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e406                	sd	ra,8(sp)
 34c:	e022                	sd	s0,0(sp)
 34e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 350:	00054783          	lbu	a5,0(a0)
 354:	cf99                	beqz	a5,372 <strlen+0x2a>
 356:	0505                	addi	a0,a0,1
 358:	87aa                	mv	a5,a0
 35a:	86be                	mv	a3,a5
 35c:	0785                	addi	a5,a5,1
 35e:	fff7c703          	lbu	a4,-1(a5)
 362:	ff65                	bnez	a4,35a <strlen+0x12>
 364:	40a6853b          	subw	a0,a3,a0
 368:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
  for(n = 0; s[n]; n++)
 372:	4501                	li	a0,0
 374:	bfdd                	j	36a <strlen+0x22>

0000000000000376 <memset>:

void*
memset(void *dst, int c, uint n)
{
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 37e:	ca19                	beqz	a2,394 <memset+0x1e>
 380:	87aa                	mv	a5,a0
 382:	1602                	slli	a2,a2,0x20
 384:	9201                	srli	a2,a2,0x20
 386:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 38a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 38e:	0785                	addi	a5,a5,1
 390:	fee79de3          	bne	a5,a4,38a <memset+0x14>
  }
  return dst;
}
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret

000000000000039c <strchr>:

char*
strchr(const char *s, char c)
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3a4:	00054783          	lbu	a5,0(a0)
 3a8:	cf81                	beqz	a5,3c0 <strchr+0x24>
    if(*s == c)
 3aa:	00f58763          	beq	a1,a5,3b8 <strchr+0x1c>
  for(; *s; s++)
 3ae:	0505                	addi	a0,a0,1
 3b0:	00054783          	lbu	a5,0(a0)
 3b4:	fbfd                	bnez	a5,3aa <strchr+0xe>
      return (char*)s;
  return 0;
 3b6:	4501                	li	a0,0
}
 3b8:	60a2                	ld	ra,8(sp)
 3ba:	6402                	ld	s0,0(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret
  return 0;
 3c0:	4501                	li	a0,0
 3c2:	bfdd                	j	3b8 <strchr+0x1c>

00000000000003c4 <gets>:

char*
gets(char *buf, int max)
{
 3c4:	7159                	addi	sp,sp,-112
 3c6:	f486                	sd	ra,104(sp)
 3c8:	f0a2                	sd	s0,96(sp)
 3ca:	eca6                	sd	s1,88(sp)
 3cc:	e8ca                	sd	s2,80(sp)
 3ce:	e4ce                	sd	s3,72(sp)
 3d0:	e0d2                	sd	s4,64(sp)
 3d2:	fc56                	sd	s5,56(sp)
 3d4:	f85a                	sd	s6,48(sp)
 3d6:	f45e                	sd	s7,40(sp)
 3d8:	f062                	sd	s8,32(sp)
 3da:	ec66                	sd	s9,24(sp)
 3dc:	e86a                	sd	s10,16(sp)
 3de:	1880                	addi	s0,sp,112
 3e0:	8caa                	mv	s9,a0
 3e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e4:	892a                	mv	s2,a0
 3e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3e8:	f9f40b13          	addi	s6,s0,-97
 3ec:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ee:	4ba9                	li	s7,10
 3f0:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 3f2:	8d26                	mv	s10,s1
 3f4:	0014899b          	addiw	s3,s1,1
 3f8:	84ce                	mv	s1,s3
 3fa:	0349d763          	bge	s3,s4,428 <gets+0x64>
    cc = read(0, &c, 1);
 3fe:	8656                	mv	a2,s5
 400:	85da                	mv	a1,s6
 402:	4501                	li	a0,0
 404:	00000097          	auipc	ra,0x0
 408:	1ac080e7          	jalr	428(ra) # 5b0 <read>
    if(cc < 1)
 40c:	00a05e63          	blez	a0,428 <gets+0x64>
    buf[i++] = c;
 410:	f9f44783          	lbu	a5,-97(s0)
 414:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 418:	01778763          	beq	a5,s7,426 <gets+0x62>
 41c:	0905                	addi	s2,s2,1
 41e:	fd879ae3          	bne	a5,s8,3f2 <gets+0x2e>
    buf[i++] = c;
 422:	8d4e                	mv	s10,s3
 424:	a011                	j	428 <gets+0x64>
 426:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 428:	9d66                	add	s10,s10,s9
 42a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 42e:	8566                	mv	a0,s9
 430:	70a6                	ld	ra,104(sp)
 432:	7406                	ld	s0,96(sp)
 434:	64e6                	ld	s1,88(sp)
 436:	6946                	ld	s2,80(sp)
 438:	69a6                	ld	s3,72(sp)
 43a:	6a06                	ld	s4,64(sp)
 43c:	7ae2                	ld	s5,56(sp)
 43e:	7b42                	ld	s6,48(sp)
 440:	7ba2                	ld	s7,40(sp)
 442:	7c02                	ld	s8,32(sp)
 444:	6ce2                	ld	s9,24(sp)
 446:	6d42                	ld	s10,16(sp)
 448:	6165                	addi	sp,sp,112
 44a:	8082                	ret

000000000000044c <stat>:

int
stat(const char *n, struct stat *st)
{
 44c:	1101                	addi	sp,sp,-32
 44e:	ec06                	sd	ra,24(sp)
 450:	e822                	sd	s0,16(sp)
 452:	e04a                	sd	s2,0(sp)
 454:	1000                	addi	s0,sp,32
 456:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 458:	4581                	li	a1,0
 45a:	00000097          	auipc	ra,0x0
 45e:	17e080e7          	jalr	382(ra) # 5d8 <open>
  if(fd < 0)
 462:	02054663          	bltz	a0,48e <stat+0x42>
 466:	e426                	sd	s1,8(sp)
 468:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 46a:	85ca                	mv	a1,s2
 46c:	00000097          	auipc	ra,0x0
 470:	184080e7          	jalr	388(ra) # 5f0 <fstat>
 474:	892a                	mv	s2,a0
  close(fd);
 476:	8526                	mv	a0,s1
 478:	00000097          	auipc	ra,0x0
 47c:	148080e7          	jalr	328(ra) # 5c0 <close>
  return r;
 480:	64a2                	ld	s1,8(sp)
}
 482:	854a                	mv	a0,s2
 484:	60e2                	ld	ra,24(sp)
 486:	6442                	ld	s0,16(sp)
 488:	6902                	ld	s2,0(sp)
 48a:	6105                	addi	sp,sp,32
 48c:	8082                	ret
    return -1;
 48e:	597d                	li	s2,-1
 490:	bfcd                	j	482 <stat+0x36>

0000000000000492 <atoi>:

int
atoi(const char *s)
{
 492:	1141                	addi	sp,sp,-16
 494:	e406                	sd	ra,8(sp)
 496:	e022                	sd	s0,0(sp)
 498:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 49a:	00054683          	lbu	a3,0(a0)
 49e:	fd06879b          	addiw	a5,a3,-48
 4a2:	0ff7f793          	zext.b	a5,a5
 4a6:	4625                	li	a2,9
 4a8:	02f66963          	bltu	a2,a5,4da <atoi+0x48>
 4ac:	872a                	mv	a4,a0
  n = 0;
 4ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4b0:	0705                	addi	a4,a4,1
 4b2:	0025179b          	slliw	a5,a0,0x2
 4b6:	9fa9                	addw	a5,a5,a0
 4b8:	0017979b          	slliw	a5,a5,0x1
 4bc:	9fb5                	addw	a5,a5,a3
 4be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4c2:	00074683          	lbu	a3,0(a4)
 4c6:	fd06879b          	addiw	a5,a3,-48
 4ca:	0ff7f793          	zext.b	a5,a5
 4ce:	fef671e3          	bgeu	a2,a5,4b0 <atoi+0x1e>
  return n;
}
 4d2:	60a2                	ld	ra,8(sp)
 4d4:	6402                	ld	s0,0(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret
  n = 0;
 4da:	4501                	li	a0,0
 4dc:	bfdd                	j	4d2 <atoi+0x40>

00000000000004de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e6:	02b57563          	bgeu	a0,a1,510 <memmove+0x32>
    while(n-- > 0)
 4ea:	00c05f63          	blez	a2,508 <memmove+0x2a>
 4ee:	1602                	slli	a2,a2,0x20
 4f0:	9201                	srli	a2,a2,0x20
 4f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4f8:	0585                	addi	a1,a1,1
 4fa:	0705                	addi	a4,a4,1
 4fc:	fff5c683          	lbu	a3,-1(a1)
 500:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 504:	fee79ae3          	bne	a5,a4,4f8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 508:	60a2                	ld	ra,8(sp)
 50a:	6402                	ld	s0,0(sp)
 50c:	0141                	addi	sp,sp,16
 50e:	8082                	ret
    dst += n;
 510:	00c50733          	add	a4,a0,a2
    src += n;
 514:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 516:	fec059e3          	blez	a2,508 <memmove+0x2a>
 51a:	fff6079b          	addiw	a5,a2,-1
 51e:	1782                	slli	a5,a5,0x20
 520:	9381                	srli	a5,a5,0x20
 522:	fff7c793          	not	a5,a5
 526:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 528:	15fd                	addi	a1,a1,-1
 52a:	177d                	addi	a4,a4,-1
 52c:	0005c683          	lbu	a3,0(a1)
 530:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 534:	fef71ae3          	bne	a4,a5,528 <memmove+0x4a>
 538:	bfc1                	j	508 <memmove+0x2a>

000000000000053a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 53a:	1141                	addi	sp,sp,-16
 53c:	e406                	sd	ra,8(sp)
 53e:	e022                	sd	s0,0(sp)
 540:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 542:	ca0d                	beqz	a2,574 <memcmp+0x3a>
 544:	fff6069b          	addiw	a3,a2,-1
 548:	1682                	slli	a3,a3,0x20
 54a:	9281                	srli	a3,a3,0x20
 54c:	0685                	addi	a3,a3,1
 54e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 550:	00054783          	lbu	a5,0(a0)
 554:	0005c703          	lbu	a4,0(a1)
 558:	00e79863          	bne	a5,a4,568 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 55c:	0505                	addi	a0,a0,1
    p2++;
 55e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 560:	fed518e3          	bne	a0,a3,550 <memcmp+0x16>
  }
  return 0;
 564:	4501                	li	a0,0
 566:	a019                	j	56c <memcmp+0x32>
      return *p1 - *p2;
 568:	40e7853b          	subw	a0,a5,a4
}
 56c:	60a2                	ld	ra,8(sp)
 56e:	6402                	ld	s0,0(sp)
 570:	0141                	addi	sp,sp,16
 572:	8082                	ret
  return 0;
 574:	4501                	li	a0,0
 576:	bfdd                	j	56c <memcmp+0x32>

0000000000000578 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 578:	1141                	addi	sp,sp,-16
 57a:	e406                	sd	ra,8(sp)
 57c:	e022                	sd	s0,0(sp)
 57e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 580:	00000097          	auipc	ra,0x0
 584:	f5e080e7          	jalr	-162(ra) # 4de <memmove>
}
 588:	60a2                	ld	ra,8(sp)
 58a:	6402                	ld	s0,0(sp)
 58c:	0141                	addi	sp,sp,16
 58e:	8082                	ret

0000000000000590 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 590:	4885                	li	a7,1
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <exit>:
.global exit
exit:
 li a7, SYS_exit
 598:	4889                	li	a7,2
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a0:	488d                	li	a7,3
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5a8:	4891                	li	a7,4
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <read>:
.global read
read:
 li a7, SYS_read
 5b0:	4895                	li	a7,5
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <write>:
.global write
write:
 li a7, SYS_write
 5b8:	48c1                	li	a7,16
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <close>:
.global close
close:
 li a7, SYS_close
 5c0:	48d5                	li	a7,21
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5c8:	4899                	li	a7,6
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d0:	489d                	li	a7,7
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <open>:
.global open
open:
 li a7, SYS_open
 5d8:	48bd                	li	a7,15
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e0:	48c5                	li	a7,17
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5e8:	48c9                	li	a7,18
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f0:	48a1                	li	a7,8
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <link>:
.global link
link:
 li a7, SYS_link
 5f8:	48cd                	li	a7,19
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 600:	48d1                	li	a7,20
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 608:	48a5                	li	a7,9
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <dup>:
.global dup
dup:
 li a7, SYS_dup
 610:	48a9                	li	a7,10
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 618:	48ad                	li	a7,11
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 620:	48b1                	li	a7,12
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 628:	48b5                	li	a7,13
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 630:	48b9                	li	a7,14
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 638:	1101                	addi	sp,sp,-32
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 644:	4605                	li	a2,1
 646:	fef40593          	addi	a1,s0,-17
 64a:	00000097          	auipc	ra,0x0
 64e:	f6e080e7          	jalr	-146(ra) # 5b8 <write>
}
 652:	60e2                	ld	ra,24(sp)
 654:	6442                	ld	s0,16(sp)
 656:	6105                	addi	sp,sp,32
 658:	8082                	ret

000000000000065a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65a:	7139                	addi	sp,sp,-64
 65c:	fc06                	sd	ra,56(sp)
 65e:	f822                	sd	s0,48(sp)
 660:	f426                	sd	s1,40(sp)
 662:	f04a                	sd	s2,32(sp)
 664:	ec4e                	sd	s3,24(sp)
 666:	0080                	addi	s0,sp,64
 668:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66a:	c299                	beqz	a3,670 <printint+0x16>
 66c:	0805c063          	bltz	a1,6ec <printint+0x92>
  neg = 0;
 670:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 672:	fc040313          	addi	t1,s0,-64
  neg = 0;
 676:	869a                	mv	a3,t1
  i = 0;
 678:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 67a:	00000817          	auipc	a6,0x0
 67e:	4fe80813          	addi	a6,a6,1278 # b78 <digits>
 682:	88be                	mv	a7,a5
 684:	0017851b          	addiw	a0,a5,1
 688:	87aa                	mv	a5,a0
 68a:	02c5f73b          	remuw	a4,a1,a2
 68e:	1702                	slli	a4,a4,0x20
 690:	9301                	srli	a4,a4,0x20
 692:	9742                	add	a4,a4,a6
 694:	00074703          	lbu	a4,0(a4)
 698:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 69c:	872e                	mv	a4,a1
 69e:	02c5d5bb          	divuw	a1,a1,a2
 6a2:	0685                	addi	a3,a3,1
 6a4:	fcc77fe3          	bgeu	a4,a2,682 <printint+0x28>
  if(neg)
 6a8:	000e0c63          	beqz	t3,6c0 <printint+0x66>
    buf[i++] = '-';
 6ac:	fd050793          	addi	a5,a0,-48
 6b0:	00878533          	add	a0,a5,s0
 6b4:	02d00793          	li	a5,45
 6b8:	fef50823          	sb	a5,-16(a0)
 6bc:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6c0:	fff7899b          	addiw	s3,a5,-1
 6c4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6c8:	fff4c583          	lbu	a1,-1(s1)
 6cc:	854a                	mv	a0,s2
 6ce:	00000097          	auipc	ra,0x0
 6d2:	f6a080e7          	jalr	-150(ra) # 638 <putc>
  while(--i >= 0)
 6d6:	39fd                	addiw	s3,s3,-1
 6d8:	14fd                	addi	s1,s1,-1
 6da:	fe09d7e3          	bgez	s3,6c8 <printint+0x6e>
}
 6de:	70e2                	ld	ra,56(sp)
 6e0:	7442                	ld	s0,48(sp)
 6e2:	74a2                	ld	s1,40(sp)
 6e4:	7902                	ld	s2,32(sp)
 6e6:	69e2                	ld	s3,24(sp)
 6e8:	6121                	addi	sp,sp,64
 6ea:	8082                	ret
    x = -xx;
 6ec:	40b005bb          	negw	a1,a1
    neg = 1;
 6f0:	4e05                	li	t3,1
    x = -xx;
 6f2:	b741                	j	672 <printint+0x18>

00000000000006f4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6f4:	715d                	addi	sp,sp,-80
 6f6:	e486                	sd	ra,72(sp)
 6f8:	e0a2                	sd	s0,64(sp)
 6fa:	f84a                	sd	s2,48(sp)
 6fc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6fe:	0005c903          	lbu	s2,0(a1)
 702:	1a090a63          	beqz	s2,8b6 <vprintf+0x1c2>
 706:	fc26                	sd	s1,56(sp)
 708:	f44e                	sd	s3,40(sp)
 70a:	f052                	sd	s4,32(sp)
 70c:	ec56                	sd	s5,24(sp)
 70e:	e85a                	sd	s6,16(sp)
 710:	e45e                	sd	s7,8(sp)
 712:	8aaa                	mv	s5,a0
 714:	8bb2                	mv	s7,a2
 716:	00158493          	addi	s1,a1,1
  state = 0;
 71a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 71c:	02500a13          	li	s4,37
 720:	4b55                	li	s6,21
 722:	a839                	j	740 <vprintf+0x4c>
        putc(fd, c);
 724:	85ca                	mv	a1,s2
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	f10080e7          	jalr	-240(ra) # 638 <putc>
 730:	a019                	j	736 <vprintf+0x42>
    } else if(state == '%'){
 732:	01498d63          	beq	s3,s4,74c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 736:	0485                	addi	s1,s1,1
 738:	fff4c903          	lbu	s2,-1(s1)
 73c:	16090763          	beqz	s2,8aa <vprintf+0x1b6>
    if(state == 0){
 740:	fe0999e3          	bnez	s3,732 <vprintf+0x3e>
      if(c == '%'){
 744:	ff4910e3          	bne	s2,s4,724 <vprintf+0x30>
        state = '%';
 748:	89d2                	mv	s3,s4
 74a:	b7f5                	j	736 <vprintf+0x42>
      if(c == 'd'){
 74c:	13490463          	beq	s2,s4,874 <vprintf+0x180>
 750:	f9d9079b          	addiw	a5,s2,-99
 754:	0ff7f793          	zext.b	a5,a5
 758:	12fb6763          	bltu	s6,a5,886 <vprintf+0x192>
 75c:	f9d9079b          	addiw	a5,s2,-99
 760:	0ff7f713          	zext.b	a4,a5
 764:	12eb6163          	bltu	s6,a4,886 <vprintf+0x192>
 768:	00271793          	slli	a5,a4,0x2
 76c:	00000717          	auipc	a4,0x0
 770:	3b470713          	addi	a4,a4,948 # b20 <malloc+0x176>
 774:	97ba                	add	a5,a5,a4
 776:	439c                	lw	a5,0(a5)
 778:	97ba                	add	a5,a5,a4
 77a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 77c:	008b8913          	addi	s2,s7,8
 780:	4685                	li	a3,1
 782:	4629                	li	a2,10
 784:	000ba583          	lw	a1,0(s7)
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	ed0080e7          	jalr	-304(ra) # 65a <printint>
 792:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 794:	4981                	li	s3,0
 796:	b745                	j	736 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 798:	008b8913          	addi	s2,s7,8
 79c:	4681                	li	a3,0
 79e:	4629                	li	a2,10
 7a0:	000ba583          	lw	a1,0(s7)
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	eb4080e7          	jalr	-332(ra) # 65a <printint>
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b751                	j	736 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	4681                	li	a3,0
 7ba:	4641                	li	a2,16
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e98080e7          	jalr	-360(ra) # 65a <printint>
 7ca:	8bca                	mv	s7,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b7a5                	j	736 <vprintf+0x42>
 7d0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7d2:	008b8c13          	addi	s8,s7,8
 7d6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7da:	03000593          	li	a1,48
 7de:	8556                	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e58080e7          	jalr	-424(ra) # 638 <putc>
  putc(fd, 'x');
 7e8:	07800593          	li	a1,120
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e4a080e7          	jalr	-438(ra) # 638 <putc>
 7f6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f8:	00000b97          	auipc	s7,0x0
 7fc:	380b8b93          	addi	s7,s7,896 # b78 <digits>
 800:	03c9d793          	srli	a5,s3,0x3c
 804:	97de                	add	a5,a5,s7
 806:	0007c583          	lbu	a1,0(a5)
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	e2c080e7          	jalr	-468(ra) # 638 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 814:	0992                	slli	s3,s3,0x4
 816:	397d                	addiw	s2,s2,-1
 818:	fe0914e3          	bnez	s2,800 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 81c:	8be2                	mv	s7,s8
      state = 0;
 81e:	4981                	li	s3,0
 820:	6c02                	ld	s8,0(sp)
 822:	bf11                	j	736 <vprintf+0x42>
        s = va_arg(ap, char*);
 824:	008b8993          	addi	s3,s7,8
 828:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 82c:	02090163          	beqz	s2,84e <vprintf+0x15a>
        while(*s != 0){
 830:	00094583          	lbu	a1,0(s2)
 834:	c9a5                	beqz	a1,8a4 <vprintf+0x1b0>
          putc(fd, *s);
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	e00080e7          	jalr	-512(ra) # 638 <putc>
          s++;
 840:	0905                	addi	s2,s2,1
        while(*s != 0){
 842:	00094583          	lbu	a1,0(s2)
 846:	f9e5                	bnez	a1,836 <vprintf+0x142>
        s = va_arg(ap, char*);
 848:	8bce                	mv	s7,s3
      state = 0;
 84a:	4981                	li	s3,0
 84c:	b5ed                	j	736 <vprintf+0x42>
          s = "(null)";
 84e:	00000917          	auipc	s2,0x0
 852:	2ca90913          	addi	s2,s2,714 # b18 <malloc+0x16e>
        while(*s != 0){
 856:	02800593          	li	a1,40
 85a:	bff1                	j	836 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 85c:	008b8913          	addi	s2,s7,8
 860:	000bc583          	lbu	a1,0(s7)
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	dd2080e7          	jalr	-558(ra) # 638 <putc>
 86e:	8bca                	mv	s7,s2
      state = 0;
 870:	4981                	li	s3,0
 872:	b5d1                	j	736 <vprintf+0x42>
        putc(fd, c);
 874:	02500593          	li	a1,37
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	dbe080e7          	jalr	-578(ra) # 638 <putc>
      state = 0;
 882:	4981                	li	s3,0
 884:	bd4d                	j	736 <vprintf+0x42>
        putc(fd, '%');
 886:	02500593          	li	a1,37
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	dac080e7          	jalr	-596(ra) # 638 <putc>
        putc(fd, c);
 894:	85ca                	mv	a1,s2
 896:	8556                	mv	a0,s5
 898:	00000097          	auipc	ra,0x0
 89c:	da0080e7          	jalr	-608(ra) # 638 <putc>
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bd51                	j	736 <vprintf+0x42>
        s = va_arg(ap, char*);
 8a4:	8bce                	mv	s7,s3
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	b579                	j	736 <vprintf+0x42>
 8aa:	74e2                	ld	s1,56(sp)
 8ac:	79a2                	ld	s3,40(sp)
 8ae:	7a02                	ld	s4,32(sp)
 8b0:	6ae2                	ld	s5,24(sp)
 8b2:	6b42                	ld	s6,16(sp)
 8b4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8b6:	60a6                	ld	ra,72(sp)
 8b8:	6406                	ld	s0,64(sp)
 8ba:	7942                	ld	s2,48(sp)
 8bc:	6161                	addi	sp,sp,80
 8be:	8082                	ret

00000000000008c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c0:	715d                	addi	sp,sp,-80
 8c2:	ec06                	sd	ra,24(sp)
 8c4:	e822                	sd	s0,16(sp)
 8c6:	1000                	addi	s0,sp,32
 8c8:	e010                	sd	a2,0(s0)
 8ca:	e414                	sd	a3,8(s0)
 8cc:	e818                	sd	a4,16(s0)
 8ce:	ec1c                	sd	a5,24(s0)
 8d0:	03043023          	sd	a6,32(s0)
 8d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8d8:	8622                	mv	a2,s0
 8da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8de:	00000097          	auipc	ra,0x0
 8e2:	e16080e7          	jalr	-490(ra) # 6f4 <vprintf>
}
 8e6:	60e2                	ld	ra,24(sp)
 8e8:	6442                	ld	s0,16(sp)
 8ea:	6161                	addi	sp,sp,80
 8ec:	8082                	ret

00000000000008ee <printf>:

void
printf(const char *fmt, ...)
{
 8ee:	711d                	addi	sp,sp,-96
 8f0:	ec06                	sd	ra,24(sp)
 8f2:	e822                	sd	s0,16(sp)
 8f4:	1000                	addi	s0,sp,32
 8f6:	e40c                	sd	a1,8(s0)
 8f8:	e810                	sd	a2,16(s0)
 8fa:	ec14                	sd	a3,24(s0)
 8fc:	f018                	sd	a4,32(s0)
 8fe:	f41c                	sd	a5,40(s0)
 900:	03043823          	sd	a6,48(s0)
 904:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 908:	00840613          	addi	a2,s0,8
 90c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 910:	85aa                	mv	a1,a0
 912:	4505                	li	a0,1
 914:	00000097          	auipc	ra,0x0
 918:	de0080e7          	jalr	-544(ra) # 6f4 <vprintf>
}
 91c:	60e2                	ld	ra,24(sp)
 91e:	6442                	ld	s0,16(sp)
 920:	6125                	addi	sp,sp,96
 922:	8082                	ret

0000000000000924 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 924:	1141                	addi	sp,sp,-16
 926:	e406                	sd	ra,8(sp)
 928:	e022                	sd	s0,0(sp)
 92a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 92c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 930:	00000797          	auipc	a5,0x0
 934:	2607b783          	ld	a5,608(a5) # b90 <freep>
 938:	a02d                	j	962 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 93a:	4618                	lw	a4,8(a2)
 93c:	9f2d                	addw	a4,a4,a1
 93e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 942:	6398                	ld	a4,0(a5)
 944:	6310                	ld	a2,0(a4)
 946:	a83d                	j	984 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 948:	ff852703          	lw	a4,-8(a0)
 94c:	9f31                	addw	a4,a4,a2
 94e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 950:	ff053683          	ld	a3,-16(a0)
 954:	a091                	j	998 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 956:	6398                	ld	a4,0(a5)
 958:	00e7e463          	bltu	a5,a4,960 <free+0x3c>
 95c:	00e6ea63          	bltu	a3,a4,970 <free+0x4c>
{
 960:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 962:	fed7fae3          	bgeu	a5,a3,956 <free+0x32>
 966:	6398                	ld	a4,0(a5)
 968:	00e6e463          	bltu	a3,a4,970 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96c:	fee7eae3          	bltu	a5,a4,960 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 970:	ff852583          	lw	a1,-8(a0)
 974:	6390                	ld	a2,0(a5)
 976:	02059813          	slli	a6,a1,0x20
 97a:	01c85713          	srli	a4,a6,0x1c
 97e:	9736                	add	a4,a4,a3
 980:	fae60de3          	beq	a2,a4,93a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 984:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 988:	4790                	lw	a2,8(a5)
 98a:	02061593          	slli	a1,a2,0x20
 98e:	01c5d713          	srli	a4,a1,0x1c
 992:	973e                	add	a4,a4,a5
 994:	fae68ae3          	beq	a3,a4,948 <free+0x24>
    p->s.ptr = bp->s.ptr;
 998:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 99a:	00000717          	auipc	a4,0x0
 99e:	1ef73b23          	sd	a5,502(a4) # b90 <freep>
}
 9a2:	60a2                	ld	ra,8(sp)
 9a4:	6402                	ld	s0,0(sp)
 9a6:	0141                	addi	sp,sp,16
 9a8:	8082                	ret

00000000000009aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9aa:	7139                	addi	sp,sp,-64
 9ac:	fc06                	sd	ra,56(sp)
 9ae:	f822                	sd	s0,48(sp)
 9b0:	f04a                	sd	s2,32(sp)
 9b2:	ec4e                	sd	s3,24(sp)
 9b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b6:	02051993          	slli	s3,a0,0x20
 9ba:	0209d993          	srli	s3,s3,0x20
 9be:	09bd                	addi	s3,s3,15
 9c0:	0049d993          	srli	s3,s3,0x4
 9c4:	2985                	addiw	s3,s3,1
 9c6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9c8:	00000517          	auipc	a0,0x0
 9cc:	1c853503          	ld	a0,456(a0) # b90 <freep>
 9d0:	c905                	beqz	a0,a00 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d4:	4798                	lw	a4,8(a5)
 9d6:	09377a63          	bgeu	a4,s3,a6a <malloc+0xc0>
 9da:	f426                	sd	s1,40(sp)
 9dc:	e852                	sd	s4,16(sp)
 9de:	e456                	sd	s5,8(sp)
 9e0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9e2:	8a4e                	mv	s4,s3
 9e4:	6705                	lui	a4,0x1
 9e6:	00e9f363          	bgeu	s3,a4,9ec <malloc+0x42>
 9ea:	6a05                	lui	s4,0x1
 9ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f4:	00000497          	auipc	s1,0x0
 9f8:	19c48493          	addi	s1,s1,412 # b90 <freep>
  if(p == (char*)-1)
 9fc:	5afd                	li	s5,-1
 9fe:	a089                	j	a40 <malloc+0x96>
 a00:	f426                	sd	s1,40(sp)
 a02:	e852                	sd	s4,16(sp)
 a04:	e456                	sd	s5,8(sp)
 a06:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a08:	00000797          	auipc	a5,0x0
 a0c:	1a078793          	addi	a5,a5,416 # ba8 <base>
 a10:	00000717          	auipc	a4,0x0
 a14:	18f73023          	sd	a5,384(a4) # b90 <freep>
 a18:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a1a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1e:	b7d1                	j	9e2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a20:	6398                	ld	a4,0(a5)
 a22:	e118                	sd	a4,0(a0)
 a24:	a8b9                	j	a82 <malloc+0xd8>
  hp->s.size = nu;
 a26:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a2a:	0541                	addi	a0,a0,16
 a2c:	00000097          	auipc	ra,0x0
 a30:	ef8080e7          	jalr	-264(ra) # 924 <free>
  return freep;
 a34:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a36:	c135                	beqz	a0,a9a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a38:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3a:	4798                	lw	a4,8(a5)
 a3c:	03277363          	bgeu	a4,s2,a62 <malloc+0xb8>
    if(p == freep)
 a40:	6098                	ld	a4,0(s1)
 a42:	853e                	mv	a0,a5
 a44:	fef71ae3          	bne	a4,a5,a38 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a48:	8552                	mv	a0,s4
 a4a:	00000097          	auipc	ra,0x0
 a4e:	bd6080e7          	jalr	-1066(ra) # 620 <sbrk>
  if(p == (char*)-1)
 a52:	fd551ae3          	bne	a0,s5,a26 <malloc+0x7c>
        return 0;
 a56:	4501                	li	a0,0
 a58:	74a2                	ld	s1,40(sp)
 a5a:	6a42                	ld	s4,16(sp)
 a5c:	6aa2                	ld	s5,8(sp)
 a5e:	6b02                	ld	s6,0(sp)
 a60:	a03d                	j	a8e <malloc+0xe4>
 a62:	74a2                	ld	s1,40(sp)
 a64:	6a42                	ld	s4,16(sp)
 a66:	6aa2                	ld	s5,8(sp)
 a68:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a6a:	fae90be3          	beq	s2,a4,a20 <malloc+0x76>
        p->s.size -= nunits;
 a6e:	4137073b          	subw	a4,a4,s3
 a72:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a74:	02071693          	slli	a3,a4,0x20
 a78:	01c6d713          	srli	a4,a3,0x1c
 a7c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a7e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a82:	00000717          	auipc	a4,0x0
 a86:	10a73723          	sd	a0,270(a4) # b90 <freep>
      return (void*)(p + 1);
 a8a:	01078513          	addi	a0,a5,16
  }
}
 a8e:	70e2                	ld	ra,56(sp)
 a90:	7442                	ld	s0,48(sp)
 a92:	7902                	ld	s2,32(sp)
 a94:	69e2                	ld	s3,24(sp)
 a96:	6121                	addi	sp,sp,64
 a98:	8082                	ret
 a9a:	74a2                	ld	s1,40(sp)
 a9c:	6a42                	ld	s4,16(sp)
 a9e:	6aa2                	ld	s5,8(sp)
 aa0:	6b02                	ld	s6,0(sp)
 aa2:	b7f5                	j	a8e <malloc+0xe4>
