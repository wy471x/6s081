
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7df63          	bge	a5,a0,48 <main+0x48>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1da080e7          	jalr	474(ra) # 202 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	308080e7          	jalr	776(ra) # 338 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2c8080e7          	jalr	712(ra) # 308 <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00000597          	auipc	a1,0x0
  50:	7dc58593          	addi	a1,a1,2012 # 828 <malloc+0xfe>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	5ea080e7          	jalr	1514(ra) # 640 <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	2a8080e7          	jalr	680(ra) # 308 <exit>

0000000000000068 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  68:	1141                	addi	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  70:	87aa                	mv	a5,a0
  72:	0585                	addi	a1,a1,1
  74:	0785                	addi	a5,a5,1
  76:	fff5c703          	lbu	a4,-1(a1)
  7a:	fee78fa3          	sb	a4,-1(a5)
  7e:	fb75                	bnez	a4,72 <strcpy+0xa>
    ;
  return os;
}
  80:	60a2                	ld	ra,8(sp)
  82:	6402                	ld	s0,0(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e406                	sd	ra,8(sp)
  8c:	e022                	sd	s0,0(sp)
  8e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  90:	00054783          	lbu	a5,0(a0)
  94:	cb91                	beqz	a5,a8 <strcmp+0x20>
  96:	0005c703          	lbu	a4,0(a1)
  9a:	00f71763          	bne	a4,a5,a8 <strcmp+0x20>
    p++, q++;
  9e:	0505                	addi	a0,a0,1
  a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	fbe5                	bnez	a5,96 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a8:	0005c503          	lbu	a0,0(a1)
}
  ac:	40a7853b          	subw	a0,a5,a0
  b0:	60a2                	ld	ra,8(sp)
  b2:	6402                	ld	s0,0(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strlen>:

uint
strlen(const char *s)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	cf99                	beqz	a5,e2 <strlen+0x2a>
  c6:	0505                	addi	a0,a0,1
  c8:	87aa                	mv	a5,a0
  ca:	86be                	mv	a3,a5
  cc:	0785                	addi	a5,a5,1
  ce:	fff7c703          	lbu	a4,-1(a5)
  d2:	ff65                	bnez	a4,ca <strlen+0x12>
  d4:	40a6853b          	subw	a0,a3,a0
  d8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  da:	60a2                	ld	ra,8(sp)
  dc:	6402                	ld	s0,0(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  for(n = 0; s[n]; n++)
  e2:	4501                	li	a0,0
  e4:	bfdd                	j	da <strlen+0x22>

00000000000000e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ee:	ca19                	beqz	a2,104 <memset+0x1e>
  f0:	87aa                	mv	a5,a0
  f2:	1602                	slli	a2,a2,0x20
  f4:	9201                	srli	a2,a2,0x20
  f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fe:	0785                	addi	a5,a5,1
 100:	fee79de3          	bne	a5,a4,fa <memset+0x14>
  }
  return dst;
}
 104:	60a2                	ld	ra,8(sp)
 106:	6402                	ld	s0,0(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  for(; *s; s++)
 114:	00054783          	lbu	a5,0(a0)
 118:	cf81                	beqz	a5,130 <strchr+0x24>
    if(*s == c)
 11a:	00f58763          	beq	a1,a5,128 <strchr+0x1c>
  for(; *s; s++)
 11e:	0505                	addi	a0,a0,1
 120:	00054783          	lbu	a5,0(a0)
 124:	fbfd                	bnez	a5,11a <strchr+0xe>
      return (char*)s;
  return 0;
 126:	4501                	li	a0,0
}
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfdd                	j	128 <strchr+0x1c>

0000000000000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	7159                	addi	sp,sp,-112
 136:	f486                	sd	ra,104(sp)
 138:	f0a2                	sd	s0,96(sp)
 13a:	eca6                	sd	s1,88(sp)
 13c:	e8ca                	sd	s2,80(sp)
 13e:	e4ce                	sd	s3,72(sp)
 140:	e0d2                	sd	s4,64(sp)
 142:	fc56                	sd	s5,56(sp)
 144:	f85a                	sd	s6,48(sp)
 146:	f45e                	sd	s7,40(sp)
 148:	f062                	sd	s8,32(sp)
 14a:	ec66                	sd	s9,24(sp)
 14c:	e86a                	sd	s10,16(sp)
 14e:	1880                	addi	s0,sp,112
 150:	8caa                	mv	s9,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
 158:	f9f40b13          	addi	s6,s0,-97
 15c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15e:	4ba9                	li	s7,10
 160:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 162:	8d26                	mv	s10,s1
 164:	0014899b          	addiw	s3,s1,1
 168:	84ce                	mv	s1,s3
 16a:	0349d763          	bge	s3,s4,198 <gets+0x64>
    cc = read(0, &c, 1);
 16e:	8656                	mv	a2,s5
 170:	85da                	mv	a1,s6
 172:	4501                	li	a0,0
 174:	00000097          	auipc	ra,0x0
 178:	1ac080e7          	jalr	428(ra) # 320 <read>
    if(cc < 1)
 17c:	00a05e63          	blez	a0,198 <gets+0x64>
    buf[i++] = c;
 180:	f9f44783          	lbu	a5,-97(s0)
 184:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 188:	01778763          	beq	a5,s7,196 <gets+0x62>
 18c:	0905                	addi	s2,s2,1
 18e:	fd879ae3          	bne	a5,s8,162 <gets+0x2e>
    buf[i++] = c;
 192:	8d4e                	mv	s10,s3
 194:	a011                	j	198 <gets+0x64>
 196:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 198:	9d66                	add	s10,s10,s9
 19a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 19e:	8566                	mv	a0,s9
 1a0:	70a6                	ld	ra,104(sp)
 1a2:	7406                	ld	s0,96(sp)
 1a4:	64e6                	ld	s1,88(sp)
 1a6:	6946                	ld	s2,80(sp)
 1a8:	69a6                	ld	s3,72(sp)
 1aa:	6a06                	ld	s4,64(sp)
 1ac:	7ae2                	ld	s5,56(sp)
 1ae:	7b42                	ld	s6,48(sp)
 1b0:	7ba2                	ld	s7,40(sp)
 1b2:	7c02                	ld	s8,32(sp)
 1b4:	6ce2                	ld	s9,24(sp)
 1b6:	6d42                	ld	s10,16(sp)
 1b8:	6165                	addi	sp,sp,112
 1ba:	8082                	ret

00000000000001bc <stat>:

int
stat(const char *n, struct stat *st)
{
 1bc:	1101                	addi	sp,sp,-32
 1be:	ec06                	sd	ra,24(sp)
 1c0:	e822                	sd	s0,16(sp)
 1c2:	e04a                	sd	s2,0(sp)
 1c4:	1000                	addi	s0,sp,32
 1c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c8:	4581                	li	a1,0
 1ca:	00000097          	auipc	ra,0x0
 1ce:	17e080e7          	jalr	382(ra) # 348 <open>
  if(fd < 0)
 1d2:	02054663          	bltz	a0,1fe <stat+0x42>
 1d6:	e426                	sd	s1,8(sp)
 1d8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1da:	85ca                	mv	a1,s2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	184080e7          	jalr	388(ra) # 360 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	00000097          	auipc	ra,0x0
 1ec:	148080e7          	jalr	328(ra) # 330 <close>
  return r;
 1f0:	64a2                	ld	s1,8(sp)
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfcd                	j	1f2 <stat+0x36>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66963          	bltu	a2,a5,24a <atoi+0x48>
 21c:	872a                	mv	a4,a0
  n = 0;
 21e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1e>
  return n;
}
 242:	60a2                	ld	ra,8(sp)
 244:	6402                	ld	s0,0(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfdd                	j	242 <atoi+0x40>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 256:	02b57563          	bgeu	a0,a1,280 <memmove+0x32>
    while(n-- > 0)
 25a:	00c05f63          	blez	a2,278 <memmove+0x2a>
 25e:	1602                	slli	a2,a2,0x20
 260:	9201                	srli	a2,a2,0x20
 262:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 266:	872a                	mv	a4,a0
      *dst++ = *src++;
 268:	0585                	addi	a1,a1,1
 26a:	0705                	addi	a4,a4,1
 26c:	fff5c683          	lbu	a3,-1(a1)
 270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec059e3          	blez	a2,278 <memmove+0x2a>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fef71ae3          	bne	a4,a5,298 <memmove+0x4a>
 2a8:	bfc1                	j	278 <memmove+0x2a>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b2:	ca0d                	beqz	a2,2e4 <memcmp+0x3a>
 2b4:	fff6069b          	addiw	a3,a2,-1
 2b8:	1682                	slli	a3,a3,0x20
 2ba:	9281                	srli	a3,a3,0x20
 2bc:	0685                	addi	a3,a3,1
 2be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2cc:	0505                	addi	a0,a0,1
    p2++;
 2ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x16>
  }
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x32>
      return *p1 - *p2;
 2d8:	40e7853b          	subw	a0,a5,a4
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  return 0;
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <memcmp+0x32>

00000000000002e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f0:	00000097          	auipc	ra,0x0
 2f4:	f5e080e7          	jalr	-162(ra) # 24e <memmove>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 300:	4885                	li	a7,1
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exit>:
.global exit
exit:
 li a7, SYS_exit
 308:	4889                	li	a7,2
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <wait>:
.global wait
wait:
 li a7, SYS_wait
 310:	488d                	li	a7,3
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 318:	4891                	li	a7,4
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <read>:
.global read
read:
 li a7, SYS_read
 320:	4895                	li	a7,5
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <write>:
.global write
write:
 li a7, SYS_write
 328:	48c1                	li	a7,16
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <close>:
.global close
close:
 li a7, SYS_close
 330:	48d5                	li	a7,21
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <kill>:
.global kill
kill:
 li a7, SYS_kill
 338:	4899                	li	a7,6
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <exec>:
.global exec
exec:
 li a7, SYS_exec
 340:	489d                	li	a7,7
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <open>:
.global open
open:
 li a7, SYS_open
 348:	48bd                	li	a7,15
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 350:	48c5                	li	a7,17
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 358:	48c9                	li	a7,18
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 360:	48a1                	li	a7,8
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <link>:
.global link
link:
 li a7, SYS_link
 368:	48cd                	li	a7,19
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 370:	48d1                	li	a7,20
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 378:	48a5                	li	a7,9
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <dup>:
.global dup
dup:
 li a7, SYS_dup
 380:	48a9                	li	a7,10
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 388:	48ad                	li	a7,11
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 390:	48b1                	li	a7,12
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 398:	48b5                	li	a7,13
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a0:	48b9                	li	a7,14
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 3a8:	48d9                	li	a7,22
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 3b0:	48dd                	li	a7,23
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	1000                	addi	s0,sp,32
 3c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c4:	4605                	li	a2,1
 3c6:	fef40593          	addi	a1,s0,-17
 3ca:	00000097          	auipc	ra,0x0
 3ce:	f5e080e7          	jalr	-162(ra) # 328 <write>
}
 3d2:	60e2                	ld	ra,24(sp)
 3d4:	6442                	ld	s0,16(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret

00000000000003da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3da:	7139                	addi	sp,sp,-64
 3dc:	fc06                	sd	ra,56(sp)
 3de:	f822                	sd	s0,48(sp)
 3e0:	f426                	sd	s1,40(sp)
 3e2:	f04a                	sd	s2,32(sp)
 3e4:	ec4e                	sd	s3,24(sp)
 3e6:	0080                	addi	s0,sp,64
 3e8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ea:	c299                	beqz	a3,3f0 <printint+0x16>
 3ec:	0805c063          	bltz	a1,46c <printint+0x92>
  neg = 0;
 3f0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3f2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3f6:	869a                	mv	a3,t1
  i = 0;
 3f8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3fa:	00000817          	auipc	a6,0x0
 3fe:	4a680813          	addi	a6,a6,1190 # 8a0 <digits>
 402:	88be                	mv	a7,a5
 404:	0017851b          	addiw	a0,a5,1
 408:	87aa                	mv	a5,a0
 40a:	02c5f73b          	remuw	a4,a1,a2
 40e:	1702                	slli	a4,a4,0x20
 410:	9301                	srli	a4,a4,0x20
 412:	9742                	add	a4,a4,a6
 414:	00074703          	lbu	a4,0(a4)
 418:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 41c:	872e                	mv	a4,a1
 41e:	02c5d5bb          	divuw	a1,a1,a2
 422:	0685                	addi	a3,a3,1
 424:	fcc77fe3          	bgeu	a4,a2,402 <printint+0x28>
  if(neg)
 428:	000e0c63          	beqz	t3,440 <printint+0x66>
    buf[i++] = '-';
 42c:	fd050793          	addi	a5,a0,-48
 430:	00878533          	add	a0,a5,s0
 434:	02d00793          	li	a5,45
 438:	fef50823          	sb	a5,-16(a0)
 43c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 440:	fff7899b          	addiw	s3,a5,-1
 444:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 448:	fff4c583          	lbu	a1,-1(s1)
 44c:	854a                	mv	a0,s2
 44e:	00000097          	auipc	ra,0x0
 452:	f6a080e7          	jalr	-150(ra) # 3b8 <putc>
  while(--i >= 0)
 456:	39fd                	addiw	s3,s3,-1
 458:	14fd                	addi	s1,s1,-1
 45a:	fe09d7e3          	bgez	s3,448 <printint+0x6e>
}
 45e:	70e2                	ld	ra,56(sp)
 460:	7442                	ld	s0,48(sp)
 462:	74a2                	ld	s1,40(sp)
 464:	7902                	ld	s2,32(sp)
 466:	69e2                	ld	s3,24(sp)
 468:	6121                	addi	sp,sp,64
 46a:	8082                	ret
    x = -xx;
 46c:	40b005bb          	negw	a1,a1
    neg = 1;
 470:	4e05                	li	t3,1
    x = -xx;
 472:	b741                	j	3f2 <printint+0x18>

0000000000000474 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 474:	715d                	addi	sp,sp,-80
 476:	e486                	sd	ra,72(sp)
 478:	e0a2                	sd	s0,64(sp)
 47a:	f84a                	sd	s2,48(sp)
 47c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47e:	0005c903          	lbu	s2,0(a1)
 482:	1a090a63          	beqz	s2,636 <vprintf+0x1c2>
 486:	fc26                	sd	s1,56(sp)
 488:	f44e                	sd	s3,40(sp)
 48a:	f052                	sd	s4,32(sp)
 48c:	ec56                	sd	s5,24(sp)
 48e:	e85a                	sd	s6,16(sp)
 490:	e45e                	sd	s7,8(sp)
 492:	8aaa                	mv	s5,a0
 494:	8bb2                	mv	s7,a2
 496:	00158493          	addi	s1,a1,1
  state = 0;
 49a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49c:	02500a13          	li	s4,37
 4a0:	4b55                	li	s6,21
 4a2:	a839                	j	4c0 <vprintf+0x4c>
        putc(fd, c);
 4a4:	85ca                	mv	a1,s2
 4a6:	8556                	mv	a0,s5
 4a8:	00000097          	auipc	ra,0x0
 4ac:	f10080e7          	jalr	-240(ra) # 3b8 <putc>
 4b0:	a019                	j	4b6 <vprintf+0x42>
    } else if(state == '%'){
 4b2:	01498d63          	beq	s3,s4,4cc <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4b6:	0485                	addi	s1,s1,1
 4b8:	fff4c903          	lbu	s2,-1(s1)
 4bc:	16090763          	beqz	s2,62a <vprintf+0x1b6>
    if(state == 0){
 4c0:	fe0999e3          	bnez	s3,4b2 <vprintf+0x3e>
      if(c == '%'){
 4c4:	ff4910e3          	bne	s2,s4,4a4 <vprintf+0x30>
        state = '%';
 4c8:	89d2                	mv	s3,s4
 4ca:	b7f5                	j	4b6 <vprintf+0x42>
      if(c == 'd'){
 4cc:	13490463          	beq	s2,s4,5f4 <vprintf+0x180>
 4d0:	f9d9079b          	addiw	a5,s2,-99
 4d4:	0ff7f793          	zext.b	a5,a5
 4d8:	12fb6763          	bltu	s6,a5,606 <vprintf+0x192>
 4dc:	f9d9079b          	addiw	a5,s2,-99
 4e0:	0ff7f713          	zext.b	a4,a5
 4e4:	12eb6163          	bltu	s6,a4,606 <vprintf+0x192>
 4e8:	00271793          	slli	a5,a4,0x2
 4ec:	00000717          	auipc	a4,0x0
 4f0:	35c70713          	addi	a4,a4,860 # 848 <malloc+0x11e>
 4f4:	97ba                	add	a5,a5,a4
 4f6:	439c                	lw	a5,0(a5)
 4f8:	97ba                	add	a5,a5,a4
 4fa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4fc:	008b8913          	addi	s2,s7,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000ba583          	lw	a1,0(s7)
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	ed0080e7          	jalr	-304(ra) # 3da <printint>
 512:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 514:	4981                	li	s3,0
 516:	b745                	j	4b6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 518:	008b8913          	addi	s2,s7,8
 51c:	4681                	li	a3,0
 51e:	4629                	li	a2,10
 520:	000ba583          	lw	a1,0(s7)
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	eb4080e7          	jalr	-332(ra) # 3da <printint>
 52e:	8bca                	mv	s7,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	b751                	j	4b6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 534:	008b8913          	addi	s2,s7,8
 538:	4681                	li	a3,0
 53a:	4641                	li	a2,16
 53c:	000ba583          	lw	a1,0(s7)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e98080e7          	jalr	-360(ra) # 3da <printint>
 54a:	8bca                	mv	s7,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b7a5                	j	4b6 <vprintf+0x42>
 550:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 552:	008b8c13          	addi	s8,s7,8
 556:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 55a:	03000593          	li	a1,48
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e58080e7          	jalr	-424(ra) # 3b8 <putc>
  putc(fd, 'x');
 568:	07800593          	li	a1,120
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e4a080e7          	jalr	-438(ra) # 3b8 <putc>
 576:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 578:	00000b97          	auipc	s7,0x0
 57c:	328b8b93          	addi	s7,s7,808 # 8a0 <digits>
 580:	03c9d793          	srli	a5,s3,0x3c
 584:	97de                	add	a5,a5,s7
 586:	0007c583          	lbu	a1,0(a5)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e2c080e7          	jalr	-468(ra) # 3b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 594:	0992                	slli	s3,s3,0x4
 596:	397d                	addiw	s2,s2,-1
 598:	fe0914e3          	bnez	s2,580 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 59c:	8be2                	mv	s7,s8
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	6c02                	ld	s8,0(sp)
 5a2:	bf11                	j	4b6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5a4:	008b8993          	addi	s3,s7,8
 5a8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5ac:	02090163          	beqz	s2,5ce <vprintf+0x15a>
        while(*s != 0){
 5b0:	00094583          	lbu	a1,0(s2)
 5b4:	c9a5                	beqz	a1,624 <vprintf+0x1b0>
          putc(fd, *s);
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e00080e7          	jalr	-512(ra) # 3b8 <putc>
          s++;
 5c0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c2:	00094583          	lbu	a1,0(s2)
 5c6:	f9e5                	bnez	a1,5b6 <vprintf+0x142>
        s = va_arg(ap, char*);
 5c8:	8bce                	mv	s7,s3
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b5ed                	j	4b6 <vprintf+0x42>
          s = "(null)";
 5ce:	00000917          	auipc	s2,0x0
 5d2:	27290913          	addi	s2,s2,626 # 840 <malloc+0x116>
        while(*s != 0){
 5d6:	02800593          	li	a1,40
 5da:	bff1                	j	5b6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	000bc583          	lbu	a1,0(s7)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	dd2080e7          	jalr	-558(ra) # 3b8 <putc>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b5d1                	j	4b6 <vprintf+0x42>
        putc(fd, c);
 5f4:	02500593          	li	a1,37
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	dbe080e7          	jalr	-578(ra) # 3b8 <putc>
      state = 0;
 602:	4981                	li	s3,0
 604:	bd4d                	j	4b6 <vprintf+0x42>
        putc(fd, '%');
 606:	02500593          	li	a1,37
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	dac080e7          	jalr	-596(ra) # 3b8 <putc>
        putc(fd, c);
 614:	85ca                	mv	a1,s2
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	da0080e7          	jalr	-608(ra) # 3b8 <putc>
      state = 0;
 620:	4981                	li	s3,0
 622:	bd51                	j	4b6 <vprintf+0x42>
        s = va_arg(ap, char*);
 624:	8bce                	mv	s7,s3
      state = 0;
 626:	4981                	li	s3,0
 628:	b579                	j	4b6 <vprintf+0x42>
 62a:	74e2                	ld	s1,56(sp)
 62c:	79a2                	ld	s3,40(sp)
 62e:	7a02                	ld	s4,32(sp)
 630:	6ae2                	ld	s5,24(sp)
 632:	6b42                	ld	s6,16(sp)
 634:	6ba2                	ld	s7,8(sp)
    }
  }
}
 636:	60a6                	ld	ra,72(sp)
 638:	6406                	ld	s0,64(sp)
 63a:	7942                	ld	s2,48(sp)
 63c:	6161                	addi	sp,sp,80
 63e:	8082                	ret

0000000000000640 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 640:	715d                	addi	sp,sp,-80
 642:	ec06                	sd	ra,24(sp)
 644:	e822                	sd	s0,16(sp)
 646:	1000                	addi	s0,sp,32
 648:	e010                	sd	a2,0(s0)
 64a:	e414                	sd	a3,8(s0)
 64c:	e818                	sd	a4,16(s0)
 64e:	ec1c                	sd	a5,24(s0)
 650:	03043023          	sd	a6,32(s0)
 654:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 658:	8622                	mv	a2,s0
 65a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65e:	00000097          	auipc	ra,0x0
 662:	e16080e7          	jalr	-490(ra) # 474 <vprintf>
}
 666:	60e2                	ld	ra,24(sp)
 668:	6442                	ld	s0,16(sp)
 66a:	6161                	addi	sp,sp,80
 66c:	8082                	ret

000000000000066e <printf>:

void
printf(const char *fmt, ...)
{
 66e:	711d                	addi	sp,sp,-96
 670:	ec06                	sd	ra,24(sp)
 672:	e822                	sd	s0,16(sp)
 674:	1000                	addi	s0,sp,32
 676:	e40c                	sd	a1,8(s0)
 678:	e810                	sd	a2,16(s0)
 67a:	ec14                	sd	a3,24(s0)
 67c:	f018                	sd	a4,32(s0)
 67e:	f41c                	sd	a5,40(s0)
 680:	03043823          	sd	a6,48(s0)
 684:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 688:	00840613          	addi	a2,s0,8
 68c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 690:	85aa                	mv	a1,a0
 692:	4505                	li	a0,1
 694:	00000097          	auipc	ra,0x0
 698:	de0080e7          	jalr	-544(ra) # 474 <vprintf>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6125                	addi	sp,sp,96
 6a2:	8082                	ret

00000000000006a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a4:	1141                	addi	sp,sp,-16
 6a6:	e406                	sd	ra,8(sp)
 6a8:	e022                	sd	s0,0(sp)
 6aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	00000797          	auipc	a5,0x0
 6b4:	2087b783          	ld	a5,520(a5) # 8b8 <freep>
 6b8:	a02d                	j	6e2 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ba:	4618                	lw	a4,8(a2)
 6bc:	9f2d                	addw	a4,a4,a1
 6be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	6398                	ld	a4,0(a5)
 6c4:	6310                	ld	a2,0(a4)
 6c6:	a83d                	j	704 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c8:	ff852703          	lw	a4,-8(a0)
 6cc:	9f31                	addw	a4,a4,a2
 6ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6d0:	ff053683          	ld	a3,-16(a0)
 6d4:	a091                	j	718 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d6:	6398                	ld	a4,0(a5)
 6d8:	00e7e463          	bltu	a5,a4,6e0 <free+0x3c>
 6dc:	00e6ea63          	bltu	a3,a4,6f0 <free+0x4c>
{
 6e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	fed7fae3          	bgeu	a5,a3,6d6 <free+0x32>
 6e6:	6398                	ld	a4,0(a5)
 6e8:	00e6e463          	bltu	a3,a4,6f0 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ec:	fee7eae3          	bltu	a5,a4,6e0 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 6f0:	ff852583          	lw	a1,-8(a0)
 6f4:	6390                	ld	a2,0(a5)
 6f6:	02059813          	slli	a6,a1,0x20
 6fa:	01c85713          	srli	a4,a6,0x1c
 6fe:	9736                	add	a4,a4,a3
 700:	fae60de3          	beq	a2,a4,6ba <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 708:	4790                	lw	a2,8(a5)
 70a:	02061593          	slli	a1,a2,0x20
 70e:	01c5d713          	srli	a4,a1,0x1c
 712:	973e                	add	a4,a4,a5
 714:	fae68ae3          	beq	a3,a4,6c8 <free+0x24>
    p->s.ptr = bp->s.ptr;
 718:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 71a:	00000717          	auipc	a4,0x0
 71e:	18f73f23          	sd	a5,414(a4) # 8b8 <freep>
}
 722:	60a2                	ld	ra,8(sp)
 724:	6402                	ld	s0,0(sp)
 726:	0141                	addi	sp,sp,16
 728:	8082                	ret

000000000000072a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 72a:	7139                	addi	sp,sp,-64
 72c:	fc06                	sd	ra,56(sp)
 72e:	f822                	sd	s0,48(sp)
 730:	f04a                	sd	s2,32(sp)
 732:	ec4e                	sd	s3,24(sp)
 734:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 736:	02051993          	slli	s3,a0,0x20
 73a:	0209d993          	srli	s3,s3,0x20
 73e:	09bd                	addi	s3,s3,15
 740:	0049d993          	srli	s3,s3,0x4
 744:	2985                	addiw	s3,s3,1
 746:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 748:	00000517          	auipc	a0,0x0
 74c:	17053503          	ld	a0,368(a0) # 8b8 <freep>
 750:	c905                	beqz	a0,780 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 752:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 754:	4798                	lw	a4,8(a5)
 756:	09377a63          	bgeu	a4,s3,7ea <malloc+0xc0>
 75a:	f426                	sd	s1,40(sp)
 75c:	e852                	sd	s4,16(sp)
 75e:	e456                	sd	s5,8(sp)
 760:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 762:	8a4e                	mv	s4,s3
 764:	6705                	lui	a4,0x1
 766:	00e9f363          	bgeu	s3,a4,76c <malloc+0x42>
 76a:	6a05                	lui	s4,0x1
 76c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 770:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 774:	00000497          	auipc	s1,0x0
 778:	14448493          	addi	s1,s1,324 # 8b8 <freep>
  if(p == (char*)-1)
 77c:	5afd                	li	s5,-1
 77e:	a089                	j	7c0 <malloc+0x96>
 780:	f426                	sd	s1,40(sp)
 782:	e852                	sd	s4,16(sp)
 784:	e456                	sd	s5,8(sp)
 786:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 788:	00000797          	auipc	a5,0x0
 78c:	13878793          	addi	a5,a5,312 # 8c0 <base>
 790:	00000717          	auipc	a4,0x0
 794:	12f73423          	sd	a5,296(a4) # 8b8 <freep>
 798:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 79a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 79e:	b7d1                	j	762 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7a0:	6398                	ld	a4,0(a5)
 7a2:	e118                	sd	a4,0(a0)
 7a4:	a8b9                	j	802 <malloc+0xd8>
  hp->s.size = nu;
 7a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7aa:	0541                	addi	a0,a0,16
 7ac:	00000097          	auipc	ra,0x0
 7b0:	ef8080e7          	jalr	-264(ra) # 6a4 <free>
  return freep;
 7b4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7b6:	c135                	beqz	a0,81a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ba:	4798                	lw	a4,8(a5)
 7bc:	03277363          	bgeu	a4,s2,7e2 <malloc+0xb8>
    if(p == freep)
 7c0:	6098                	ld	a4,0(s1)
 7c2:	853e                	mv	a0,a5
 7c4:	fef71ae3          	bne	a4,a5,7b8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7c8:	8552                	mv	a0,s4
 7ca:	00000097          	auipc	ra,0x0
 7ce:	bc6080e7          	jalr	-1082(ra) # 390 <sbrk>
  if(p == (char*)-1)
 7d2:	fd551ae3          	bne	a0,s5,7a6 <malloc+0x7c>
        return 0;
 7d6:	4501                	li	a0,0
 7d8:	74a2                	ld	s1,40(sp)
 7da:	6a42                	ld	s4,16(sp)
 7dc:	6aa2                	ld	s5,8(sp)
 7de:	6b02                	ld	s6,0(sp)
 7e0:	a03d                	j	80e <malloc+0xe4>
 7e2:	74a2                	ld	s1,40(sp)
 7e4:	6a42                	ld	s4,16(sp)
 7e6:	6aa2                	ld	s5,8(sp)
 7e8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7ea:	fae90be3          	beq	s2,a4,7a0 <malloc+0x76>
        p->s.size -= nunits;
 7ee:	4137073b          	subw	a4,a4,s3
 7f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f4:	02071693          	slli	a3,a4,0x20
 7f8:	01c6d713          	srli	a4,a3,0x1c
 7fc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7fe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 802:	00000717          	auipc	a4,0x0
 806:	0aa73b23          	sd	a0,182(a4) # 8b8 <freep>
      return (void*)(p + 1);
 80a:	01078513          	addi	a0,a5,16
  }
}
 80e:	70e2                	ld	ra,56(sp)
 810:	7442                	ld	s0,48(sp)
 812:	7902                	ld	s2,32(sp)
 814:	69e2                	ld	s3,24(sp)
 816:	6121                	addi	sp,sp,64
 818:	8082                	ret
 81a:	74a2                	ld	s1,40(sp)
 81c:	6a42                	ld	s4,16(sp)
 81e:	6aa2                	ld	s5,8(sp)
 820:	6b02                	ld	s6,0(sp)
 822:	b7f5                	j	80e <malloc+0xe4>
