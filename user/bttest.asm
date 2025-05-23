
user/_bttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sleep(1);
   8:	4505                	li	a0,1
   a:	00000097          	auipc	ra,0x0
   e:	342080e7          	jalr	834(ra) # 34c <sleep>
  exit(0);
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	2a8080e7          	jalr	680(ra) # 2bc <exit>

000000000000001c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  24:	87aa                	mv	a5,a0
  26:	0585                	addi	a1,a1,1
  28:	0785                	addi	a5,a5,1
  2a:	fff5c703          	lbu	a4,-1(a1)
  2e:	fee78fa3          	sb	a4,-1(a5)
  32:	fb75                	bnez	a4,26 <strcpy+0xa>
    ;
  return os;
}
  34:	60a2                	ld	ra,8(sp)
  36:	6402                	ld	s0,0(sp)
  38:	0141                	addi	sp,sp,16
  3a:	8082                	ret

000000000000003c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e406                	sd	ra,8(sp)
  40:	e022                	sd	s0,0(sp)
  42:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  44:	00054783          	lbu	a5,0(a0)
  48:	cb91                	beqz	a5,5c <strcmp+0x20>
  4a:	0005c703          	lbu	a4,0(a1)
  4e:	00f71763          	bne	a4,a5,5c <strcmp+0x20>
    p++, q++;
  52:	0505                	addi	a0,a0,1
  54:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	fbe5                	bnez	a5,4a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  5c:	0005c503          	lbu	a0,0(a1)
}
  60:	40a7853b          	subw	a0,a5,a0
  64:	60a2                	ld	ra,8(sp)
  66:	6402                	ld	s0,0(sp)
  68:	0141                	addi	sp,sp,16
  6a:	8082                	ret

000000000000006c <strlen>:

uint
strlen(const char *s)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e406                	sd	ra,8(sp)
  70:	e022                	sd	s0,0(sp)
  72:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  74:	00054783          	lbu	a5,0(a0)
  78:	cf99                	beqz	a5,96 <strlen+0x2a>
  7a:	0505                	addi	a0,a0,1
  7c:	87aa                	mv	a5,a0
  7e:	86be                	mv	a3,a5
  80:	0785                	addi	a5,a5,1
  82:	fff7c703          	lbu	a4,-1(a5)
  86:	ff65                	bnez	a4,7e <strlen+0x12>
  88:	40a6853b          	subw	a0,a3,a0
  8c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret
  for(n = 0; s[n]; n++)
  96:	4501                	li	a0,0
  98:	bfdd                	j	8e <strlen+0x22>

000000000000009a <memset>:

void*
memset(void *dst, int c, uint n)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1e>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x14>
  }
  return dst;
}
  b8:	60a2                	ld	ra,8(sp)
  ba:	6402                	ld	s0,0(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strchr>:

char*
strchr(const char *s, char c)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cf81                	beqz	a5,e4 <strchr+0x24>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1c>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xe>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfdd                	j	dc <strchr+0x1c>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	7159                	addi	sp,sp,-112
  ea:	f486                	sd	ra,104(sp)
  ec:	f0a2                	sd	s0,96(sp)
  ee:	eca6                	sd	s1,88(sp)
  f0:	e8ca                	sd	s2,80(sp)
  f2:	e4ce                	sd	s3,72(sp)
  f4:	e0d2                	sd	s4,64(sp)
  f6:	fc56                	sd	s5,56(sp)
  f8:	f85a                	sd	s6,48(sp)
  fa:	f45e                	sd	s7,40(sp)
  fc:	f062                	sd	s8,32(sp)
  fe:	ec66                	sd	s9,24(sp)
 100:	e86a                	sd	s10,16(sp)
 102:	1880                	addi	s0,sp,112
 104:	8caa                	mv	s9,a0
 106:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	892a                	mv	s2,a0
 10a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10c:	f9f40b13          	addi	s6,s0,-97
 110:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 112:	4ba9                	li	s7,10
 114:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 116:	8d26                	mv	s10,s1
 118:	0014899b          	addiw	s3,s1,1
 11c:	84ce                	mv	s1,s3
 11e:	0349d763          	bge	s3,s4,14c <gets+0x64>
    cc = read(0, &c, 1);
 122:	8656                	mv	a2,s5
 124:	85da                	mv	a1,s6
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	1ac080e7          	jalr	428(ra) # 2d4 <read>
    if(cc < 1)
 130:	00a05e63          	blez	a0,14c <gets+0x64>
    buf[i++] = c;
 134:	f9f44783          	lbu	a5,-97(s0)
 138:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13c:	01778763          	beq	a5,s7,14a <gets+0x62>
 140:	0905                	addi	s2,s2,1
 142:	fd879ae3          	bne	a5,s8,116 <gets+0x2e>
    buf[i++] = c;
 146:	8d4e                	mv	s10,s3
 148:	a011                	j	14c <gets+0x64>
 14a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 14c:	9d66                	add	s10,s10,s9
 14e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 152:	8566                	mv	a0,s9
 154:	70a6                	ld	ra,104(sp)
 156:	7406                	ld	s0,96(sp)
 158:	64e6                	ld	s1,88(sp)
 15a:	6946                	ld	s2,80(sp)
 15c:	69a6                	ld	s3,72(sp)
 15e:	6a06                	ld	s4,64(sp)
 160:	7ae2                	ld	s5,56(sp)
 162:	7b42                	ld	s6,48(sp)
 164:	7ba2                	ld	s7,40(sp)
 166:	7c02                	ld	s8,32(sp)
 168:	6ce2                	ld	s9,24(sp)
 16a:	6d42                	ld	s10,16(sp)
 16c:	6165                	addi	sp,sp,112
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	17e080e7          	jalr	382(ra) # 2fc <open>
  if(fd < 0)
 186:	02054663          	bltz	a0,1b2 <stat+0x42>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	184080e7          	jalr	388(ra) # 314 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	148080e7          	jalr	328(ra) # 2e4 <close>
  return r;
 1a4:	64a2                	ld	s1,8(sp)
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfcd                	j	1a6 <stat+0x36>

00000000000001b6 <atoi>:

int
atoi(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1be:	00054683          	lbu	a3,0(a0)
 1c2:	fd06879b          	addiw	a5,a3,-48
 1c6:	0ff7f793          	zext.b	a5,a5
 1ca:	4625                	li	a2,9
 1cc:	02f66963          	bltu	a2,a5,1fe <atoi+0x48>
 1d0:	872a                	mv	a4,a0
  n = 0;
 1d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d4:	0705                	addi	a4,a4,1
 1d6:	0025179b          	slliw	a5,a0,0x2
 1da:	9fa9                	addw	a5,a5,a0
 1dc:	0017979b          	slliw	a5,a5,0x1
 1e0:	9fb5                	addw	a5,a5,a3
 1e2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e6:	00074683          	lbu	a3,0(a4)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	fef671e3          	bgeu	a2,a5,1d4 <atoi+0x1e>
  return n;
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  n = 0;
 1fe:	4501                	li	a0,0
 200:	bfdd                	j	1f6 <atoi+0x40>

0000000000000202 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20a:	02b57563          	bgeu	a0,a1,234 <memmove+0x32>
    while(n-- > 0)
 20e:	00c05f63          	blez	a2,22c <memmove+0x2a>
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21a:	872a                	mv	a4,a0
      *dst++ = *src++;
 21c:	0585                	addi	a1,a1,1
 21e:	0705                	addi	a4,a4,1
 220:	fff5c683          	lbu	a3,-1(a1)
 224:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 228:	fee79ae3          	bne	a5,a4,21c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
    dst += n;
 234:	00c50733          	add	a4,a0,a2
    src += n;
 238:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23a:	fec059e3          	blez	a2,22c <memmove+0x2a>
 23e:	fff6079b          	addiw	a5,a2,-1
 242:	1782                	slli	a5,a5,0x20
 244:	9381                	srli	a5,a5,0x20
 246:	fff7c793          	not	a5,a5
 24a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24c:	15fd                	addi	a1,a1,-1
 24e:	177d                	addi	a4,a4,-1
 250:	0005c683          	lbu	a3,0(a1)
 254:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 258:	fef71ae3          	bne	a4,a5,24c <memmove+0x4a>
 25c:	bfc1                	j	22c <memmove+0x2a>

000000000000025e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 266:	ca0d                	beqz	a2,298 <memcmp+0x3a>
 268:	fff6069b          	addiw	a3,a2,-1
 26c:	1682                	slli	a3,a3,0x20
 26e:	9281                	srli	a3,a3,0x20
 270:	0685                	addi	a3,a3,1
 272:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 274:	00054783          	lbu	a5,0(a0)
 278:	0005c703          	lbu	a4,0(a1)
 27c:	00e79863          	bne	a5,a4,28c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 280:	0505                	addi	a0,a0,1
    p2++;
 282:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 284:	fed518e3          	bne	a0,a3,274 <memcmp+0x16>
  }
  return 0;
 288:	4501                	li	a0,0
 28a:	a019                	j	290 <memcmp+0x32>
      return *p1 - *p2;
 28c:	40e7853b          	subw	a0,a5,a4
}
 290:	60a2                	ld	ra,8(sp)
 292:	6402                	ld	s0,0(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfdd                	j	290 <memcmp+0x32>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a4:	00000097          	auipc	ra,0x0
 2a8:	f5e080e7          	jalr	-162(ra) # 202 <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b4:	4885                	li	a7,1
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2bc:	4889                	li	a7,2
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c4:	488d                	li	a7,3
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2cc:	4891                	li	a7,4
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <read>:
.global read
read:
 li a7, SYS_read
 2d4:	4895                	li	a7,5
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <write>:
.global write
write:
 li a7, SYS_write
 2dc:	48c1                	li	a7,16
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <close>:
.global close
close:
 li a7, SYS_close
 2e4:	48d5                	li	a7,21
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ec:	4899                	li	a7,6
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f4:	489d                	li	a7,7
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <open>:
.global open
open:
 li a7, SYS_open
 2fc:	48bd                	li	a7,15
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 304:	48c5                	li	a7,17
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30c:	48c9                	li	a7,18
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 314:	48a1                	li	a7,8
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <link>:
.global link
link:
 li a7, SYS_link
 31c:	48cd                	li	a7,19
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 324:	48d1                	li	a7,20
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32c:	48a5                	li	a7,9
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <dup>:
.global dup
dup:
 li a7, SYS_dup
 334:	48a9                	li	a7,10
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33c:	48ad                	li	a7,11
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 344:	48b1                	li	a7,12
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34c:	48b5                	li	a7,13
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 354:	48b9                	li	a7,14
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 35c:	48d9                	li	a7,22
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 364:	48dd                	li	a7,23
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36c:	1101                	addi	sp,sp,-32
 36e:	ec06                	sd	ra,24(sp)
 370:	e822                	sd	s0,16(sp)
 372:	1000                	addi	s0,sp,32
 374:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 378:	4605                	li	a2,1
 37a:	fef40593          	addi	a1,s0,-17
 37e:	00000097          	auipc	ra,0x0
 382:	f5e080e7          	jalr	-162(ra) # 2dc <write>
}
 386:	60e2                	ld	ra,24(sp)
 388:	6442                	ld	s0,16(sp)
 38a:	6105                	addi	sp,sp,32
 38c:	8082                	ret

000000000000038e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38e:	7139                	addi	sp,sp,-64
 390:	fc06                	sd	ra,56(sp)
 392:	f822                	sd	s0,48(sp)
 394:	f426                	sd	s1,40(sp)
 396:	f04a                	sd	s2,32(sp)
 398:	ec4e                	sd	s3,24(sp)
 39a:	0080                	addi	s0,sp,64
 39c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39e:	c299                	beqz	a3,3a4 <printint+0x16>
 3a0:	0805c063          	bltz	a1,420 <printint+0x92>
  neg = 0;
 3a4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3a6:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3aa:	869a                	mv	a3,t1
  i = 0;
 3ac:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3ae:	00000817          	auipc	a6,0x0
 3b2:	48a80813          	addi	a6,a6,1162 # 838 <digits>
 3b6:	88be                	mv	a7,a5
 3b8:	0017851b          	addiw	a0,a5,1
 3bc:	87aa                	mv	a5,a0
 3be:	02c5f73b          	remuw	a4,a1,a2
 3c2:	1702                	slli	a4,a4,0x20
 3c4:	9301                	srli	a4,a4,0x20
 3c6:	9742                	add	a4,a4,a6
 3c8:	00074703          	lbu	a4,0(a4)
 3cc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3d0:	872e                	mv	a4,a1
 3d2:	02c5d5bb          	divuw	a1,a1,a2
 3d6:	0685                	addi	a3,a3,1
 3d8:	fcc77fe3          	bgeu	a4,a2,3b6 <printint+0x28>
  if(neg)
 3dc:	000e0c63          	beqz	t3,3f4 <printint+0x66>
    buf[i++] = '-';
 3e0:	fd050793          	addi	a5,a0,-48
 3e4:	00878533          	add	a0,a5,s0
 3e8:	02d00793          	li	a5,45
 3ec:	fef50823          	sb	a5,-16(a0)
 3f0:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 3f4:	fff7899b          	addiw	s3,a5,-1
 3f8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 3fc:	fff4c583          	lbu	a1,-1(s1)
 400:	854a                	mv	a0,s2
 402:	00000097          	auipc	ra,0x0
 406:	f6a080e7          	jalr	-150(ra) # 36c <putc>
  while(--i >= 0)
 40a:	39fd                	addiw	s3,s3,-1
 40c:	14fd                	addi	s1,s1,-1
 40e:	fe09d7e3          	bgez	s3,3fc <printint+0x6e>
}
 412:	70e2                	ld	ra,56(sp)
 414:	7442                	ld	s0,48(sp)
 416:	74a2                	ld	s1,40(sp)
 418:	7902                	ld	s2,32(sp)
 41a:	69e2                	ld	s3,24(sp)
 41c:	6121                	addi	sp,sp,64
 41e:	8082                	ret
    x = -xx;
 420:	40b005bb          	negw	a1,a1
    neg = 1;
 424:	4e05                	li	t3,1
    x = -xx;
 426:	b741                	j	3a6 <printint+0x18>

0000000000000428 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 428:	715d                	addi	sp,sp,-80
 42a:	e486                	sd	ra,72(sp)
 42c:	e0a2                	sd	s0,64(sp)
 42e:	f84a                	sd	s2,48(sp)
 430:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 432:	0005c903          	lbu	s2,0(a1)
 436:	1a090a63          	beqz	s2,5ea <vprintf+0x1c2>
 43a:	fc26                	sd	s1,56(sp)
 43c:	f44e                	sd	s3,40(sp)
 43e:	f052                	sd	s4,32(sp)
 440:	ec56                	sd	s5,24(sp)
 442:	e85a                	sd	s6,16(sp)
 444:	e45e                	sd	s7,8(sp)
 446:	8aaa                	mv	s5,a0
 448:	8bb2                	mv	s7,a2
 44a:	00158493          	addi	s1,a1,1
  state = 0;
 44e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 450:	02500a13          	li	s4,37
 454:	4b55                	li	s6,21
 456:	a839                	j	474 <vprintf+0x4c>
        putc(fd, c);
 458:	85ca                	mv	a1,s2
 45a:	8556                	mv	a0,s5
 45c:	00000097          	auipc	ra,0x0
 460:	f10080e7          	jalr	-240(ra) # 36c <putc>
 464:	a019                	j	46a <vprintf+0x42>
    } else if(state == '%'){
 466:	01498d63          	beq	s3,s4,480 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 46a:	0485                	addi	s1,s1,1
 46c:	fff4c903          	lbu	s2,-1(s1)
 470:	16090763          	beqz	s2,5de <vprintf+0x1b6>
    if(state == 0){
 474:	fe0999e3          	bnez	s3,466 <vprintf+0x3e>
      if(c == '%'){
 478:	ff4910e3          	bne	s2,s4,458 <vprintf+0x30>
        state = '%';
 47c:	89d2                	mv	s3,s4
 47e:	b7f5                	j	46a <vprintf+0x42>
      if(c == 'd'){
 480:	13490463          	beq	s2,s4,5a8 <vprintf+0x180>
 484:	f9d9079b          	addiw	a5,s2,-99
 488:	0ff7f793          	zext.b	a5,a5
 48c:	12fb6763          	bltu	s6,a5,5ba <vprintf+0x192>
 490:	f9d9079b          	addiw	a5,s2,-99
 494:	0ff7f713          	zext.b	a4,a5
 498:	12eb6163          	bltu	s6,a4,5ba <vprintf+0x192>
 49c:	00271793          	slli	a5,a4,0x2
 4a0:	00000717          	auipc	a4,0x0
 4a4:	34070713          	addi	a4,a4,832 # 7e0 <malloc+0x102>
 4a8:	97ba                	add	a5,a5,a4
 4aa:	439c                	lw	a5,0(a5)
 4ac:	97ba                	add	a5,a5,a4
 4ae:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4b0:	008b8913          	addi	s2,s7,8
 4b4:	4685                	li	a3,1
 4b6:	4629                	li	a2,10
 4b8:	000ba583          	lw	a1,0(s7)
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	ed0080e7          	jalr	-304(ra) # 38e <printint>
 4c6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	b745                	j	46a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4cc:	008b8913          	addi	s2,s7,8
 4d0:	4681                	li	a3,0
 4d2:	4629                	li	a2,10
 4d4:	000ba583          	lw	a1,0(s7)
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	eb4080e7          	jalr	-332(ra) # 38e <printint>
 4e2:	8bca                	mv	s7,s2
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b751                	j	46a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4e8:	008b8913          	addi	s2,s7,8
 4ec:	4681                	li	a3,0
 4ee:	4641                	li	a2,16
 4f0:	000ba583          	lw	a1,0(s7)
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	e98080e7          	jalr	-360(ra) # 38e <printint>
 4fe:	8bca                	mv	s7,s2
      state = 0;
 500:	4981                	li	s3,0
 502:	b7a5                	j	46a <vprintf+0x42>
 504:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 506:	008b8c13          	addi	s8,s7,8
 50a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 50e:	03000593          	li	a1,48
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	e58080e7          	jalr	-424(ra) # 36c <putc>
  putc(fd, 'x');
 51c:	07800593          	li	a1,120
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e4a080e7          	jalr	-438(ra) # 36c <putc>
 52a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52c:	00000b97          	auipc	s7,0x0
 530:	30cb8b93          	addi	s7,s7,780 # 838 <digits>
 534:	03c9d793          	srli	a5,s3,0x3c
 538:	97de                	add	a5,a5,s7
 53a:	0007c583          	lbu	a1,0(a5)
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e2c080e7          	jalr	-468(ra) # 36c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 548:	0992                	slli	s3,s3,0x4
 54a:	397d                	addiw	s2,s2,-1
 54c:	fe0914e3          	bnez	s2,534 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 550:	8be2                	mv	s7,s8
      state = 0;
 552:	4981                	li	s3,0
 554:	6c02                	ld	s8,0(sp)
 556:	bf11                	j	46a <vprintf+0x42>
        s = va_arg(ap, char*);
 558:	008b8993          	addi	s3,s7,8
 55c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 560:	02090163          	beqz	s2,582 <vprintf+0x15a>
        while(*s != 0){
 564:	00094583          	lbu	a1,0(s2)
 568:	c9a5                	beqz	a1,5d8 <vprintf+0x1b0>
          putc(fd, *s);
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e00080e7          	jalr	-512(ra) # 36c <putc>
          s++;
 574:	0905                	addi	s2,s2,1
        while(*s != 0){
 576:	00094583          	lbu	a1,0(s2)
 57a:	f9e5                	bnez	a1,56a <vprintf+0x142>
        s = va_arg(ap, char*);
 57c:	8bce                	mv	s7,s3
      state = 0;
 57e:	4981                	li	s3,0
 580:	b5ed                	j	46a <vprintf+0x42>
          s = "(null)";
 582:	00000917          	auipc	s2,0x0
 586:	25690913          	addi	s2,s2,598 # 7d8 <malloc+0xfa>
        while(*s != 0){
 58a:	02800593          	li	a1,40
 58e:	bff1                	j	56a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 590:	008b8913          	addi	s2,s7,8
 594:	000bc583          	lbu	a1,0(s7)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	dd2080e7          	jalr	-558(ra) # 36c <putc>
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b5d1                	j	46a <vprintf+0x42>
        putc(fd, c);
 5a8:	02500593          	li	a1,37
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	dbe080e7          	jalr	-578(ra) # 36c <putc>
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bd4d                	j	46a <vprintf+0x42>
        putc(fd, '%');
 5ba:	02500593          	li	a1,37
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	dac080e7          	jalr	-596(ra) # 36c <putc>
        putc(fd, c);
 5c8:	85ca                	mv	a1,s2
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	da0080e7          	jalr	-608(ra) # 36c <putc>
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bd51                	j	46a <vprintf+0x42>
        s = va_arg(ap, char*);
 5d8:	8bce                	mv	s7,s3
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b579                	j	46a <vprintf+0x42>
 5de:	74e2                	ld	s1,56(sp)
 5e0:	79a2                	ld	s3,40(sp)
 5e2:	7a02                	ld	s4,32(sp)
 5e4:	6ae2                	ld	s5,24(sp)
 5e6:	6b42                	ld	s6,16(sp)
 5e8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5ea:	60a6                	ld	ra,72(sp)
 5ec:	6406                	ld	s0,64(sp)
 5ee:	7942                	ld	s2,48(sp)
 5f0:	6161                	addi	sp,sp,80
 5f2:	8082                	ret

00000000000005f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5f4:	715d                	addi	sp,sp,-80
 5f6:	ec06                	sd	ra,24(sp)
 5f8:	e822                	sd	s0,16(sp)
 5fa:	1000                	addi	s0,sp,32
 5fc:	e010                	sd	a2,0(s0)
 5fe:	e414                	sd	a3,8(s0)
 600:	e818                	sd	a4,16(s0)
 602:	ec1c                	sd	a5,24(s0)
 604:	03043023          	sd	a6,32(s0)
 608:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 60c:	8622                	mv	a2,s0
 60e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 612:	00000097          	auipc	ra,0x0
 616:	e16080e7          	jalr	-490(ra) # 428 <vprintf>
}
 61a:	60e2                	ld	ra,24(sp)
 61c:	6442                	ld	s0,16(sp)
 61e:	6161                	addi	sp,sp,80
 620:	8082                	ret

0000000000000622 <printf>:

void
printf(const char *fmt, ...)
{
 622:	711d                	addi	sp,sp,-96
 624:	ec06                	sd	ra,24(sp)
 626:	e822                	sd	s0,16(sp)
 628:	1000                	addi	s0,sp,32
 62a:	e40c                	sd	a1,8(s0)
 62c:	e810                	sd	a2,16(s0)
 62e:	ec14                	sd	a3,24(s0)
 630:	f018                	sd	a4,32(s0)
 632:	f41c                	sd	a5,40(s0)
 634:	03043823          	sd	a6,48(s0)
 638:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 63c:	00840613          	addi	a2,s0,8
 640:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 644:	85aa                	mv	a1,a0
 646:	4505                	li	a0,1
 648:	00000097          	auipc	ra,0x0
 64c:	de0080e7          	jalr	-544(ra) # 428 <vprintf>
}
 650:	60e2                	ld	ra,24(sp)
 652:	6442                	ld	s0,16(sp)
 654:	6125                	addi	sp,sp,96
 656:	8082                	ret

0000000000000658 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 658:	1141                	addi	sp,sp,-16
 65a:	e406                	sd	ra,8(sp)
 65c:	e022                	sd	s0,0(sp)
 65e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 660:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 664:	00000797          	auipc	a5,0x0
 668:	1ec7b783          	ld	a5,492(a5) # 850 <freep>
 66c:	a02d                	j	696 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 66e:	4618                	lw	a4,8(a2)
 670:	9f2d                	addw	a4,a4,a1
 672:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 676:	6398                	ld	a4,0(a5)
 678:	6310                	ld	a2,0(a4)
 67a:	a83d                	j	6b8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 67c:	ff852703          	lw	a4,-8(a0)
 680:	9f31                	addw	a4,a4,a2
 682:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 684:	ff053683          	ld	a3,-16(a0)
 688:	a091                	j	6cc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68a:	6398                	ld	a4,0(a5)
 68c:	00e7e463          	bltu	a5,a4,694 <free+0x3c>
 690:	00e6ea63          	bltu	a3,a4,6a4 <free+0x4c>
{
 694:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 696:	fed7fae3          	bgeu	a5,a3,68a <free+0x32>
 69a:	6398                	ld	a4,0(a5)
 69c:	00e6e463          	bltu	a3,a4,6a4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	fee7eae3          	bltu	a5,a4,694 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 6a4:	ff852583          	lw	a1,-8(a0)
 6a8:	6390                	ld	a2,0(a5)
 6aa:	02059813          	slli	a6,a1,0x20
 6ae:	01c85713          	srli	a4,a6,0x1c
 6b2:	9736                	add	a4,a4,a3
 6b4:	fae60de3          	beq	a2,a4,66e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6bc:	4790                	lw	a2,8(a5)
 6be:	02061593          	slli	a1,a2,0x20
 6c2:	01c5d713          	srli	a4,a1,0x1c
 6c6:	973e                	add	a4,a4,a5
 6c8:	fae68ae3          	beq	a3,a4,67c <free+0x24>
    p->s.ptr = bp->s.ptr;
 6cc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6ce:	00000717          	auipc	a4,0x0
 6d2:	18f73123          	sd	a5,386(a4) # 850 <freep>
}
 6d6:	60a2                	ld	ra,8(sp)
 6d8:	6402                	ld	s0,0(sp)
 6da:	0141                	addi	sp,sp,16
 6dc:	8082                	ret

00000000000006de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6de:	7139                	addi	sp,sp,-64
 6e0:	fc06                	sd	ra,56(sp)
 6e2:	f822                	sd	s0,48(sp)
 6e4:	f04a                	sd	s2,32(sp)
 6e6:	ec4e                	sd	s3,24(sp)
 6e8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ea:	02051993          	slli	s3,a0,0x20
 6ee:	0209d993          	srli	s3,s3,0x20
 6f2:	09bd                	addi	s3,s3,15
 6f4:	0049d993          	srli	s3,s3,0x4
 6f8:	2985                	addiw	s3,s3,1
 6fa:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 6fc:	00000517          	auipc	a0,0x0
 700:	15453503          	ld	a0,340(a0) # 850 <freep>
 704:	c905                	beqz	a0,734 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 706:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 708:	4798                	lw	a4,8(a5)
 70a:	09377a63          	bgeu	a4,s3,79e <malloc+0xc0>
 70e:	f426                	sd	s1,40(sp)
 710:	e852                	sd	s4,16(sp)
 712:	e456                	sd	s5,8(sp)
 714:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 716:	8a4e                	mv	s4,s3
 718:	6705                	lui	a4,0x1
 71a:	00e9f363          	bgeu	s3,a4,720 <malloc+0x42>
 71e:	6a05                	lui	s4,0x1
 720:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 724:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 728:	00000497          	auipc	s1,0x0
 72c:	12848493          	addi	s1,s1,296 # 850 <freep>
  if(p == (char*)-1)
 730:	5afd                	li	s5,-1
 732:	a089                	j	774 <malloc+0x96>
 734:	f426                	sd	s1,40(sp)
 736:	e852                	sd	s4,16(sp)
 738:	e456                	sd	s5,8(sp)
 73a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 73c:	00000797          	auipc	a5,0x0
 740:	11c78793          	addi	a5,a5,284 # 858 <base>
 744:	00000717          	auipc	a4,0x0
 748:	10f73623          	sd	a5,268(a4) # 850 <freep>
 74c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 74e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 752:	b7d1                	j	716 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 754:	6398                	ld	a4,0(a5)
 756:	e118                	sd	a4,0(a0)
 758:	a8b9                	j	7b6 <malloc+0xd8>
  hp->s.size = nu;
 75a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 75e:	0541                	addi	a0,a0,16
 760:	00000097          	auipc	ra,0x0
 764:	ef8080e7          	jalr	-264(ra) # 658 <free>
  return freep;
 768:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 76a:	c135                	beqz	a0,7ce <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76e:	4798                	lw	a4,8(a5)
 770:	03277363          	bgeu	a4,s2,796 <malloc+0xb8>
    if(p == freep)
 774:	6098                	ld	a4,0(s1)
 776:	853e                	mv	a0,a5
 778:	fef71ae3          	bne	a4,a5,76c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 77c:	8552                	mv	a0,s4
 77e:	00000097          	auipc	ra,0x0
 782:	bc6080e7          	jalr	-1082(ra) # 344 <sbrk>
  if(p == (char*)-1)
 786:	fd551ae3          	bne	a0,s5,75a <malloc+0x7c>
        return 0;
 78a:	4501                	li	a0,0
 78c:	74a2                	ld	s1,40(sp)
 78e:	6a42                	ld	s4,16(sp)
 790:	6aa2                	ld	s5,8(sp)
 792:	6b02                	ld	s6,0(sp)
 794:	a03d                	j	7c2 <malloc+0xe4>
 796:	74a2                	ld	s1,40(sp)
 798:	6a42                	ld	s4,16(sp)
 79a:	6aa2                	ld	s5,8(sp)
 79c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 79e:	fae90be3          	beq	s2,a4,754 <malloc+0x76>
        p->s.size -= nunits;
 7a2:	4137073b          	subw	a4,a4,s3
 7a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7a8:	02071693          	slli	a3,a4,0x20
 7ac:	01c6d713          	srli	a4,a3,0x1c
 7b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7b6:	00000717          	auipc	a4,0x0
 7ba:	08a73d23          	sd	a0,154(a4) # 850 <freep>
      return (void*)(p + 1);
 7be:	01078513          	addi	a0,a5,16
  }
}
 7c2:	70e2                	ld	ra,56(sp)
 7c4:	7442                	ld	s0,48(sp)
 7c6:	7902                	ld	s2,32(sp)
 7c8:	69e2                	ld	s3,24(sp)
 7ca:	6121                	addi	sp,sp,64
 7cc:	8082                	ret
 7ce:	74a2                	ld	s1,40(sp)
 7d0:	6a42                	ld	s4,16(sp)
 7d2:	6aa2                	ld	s5,8(sp)
 7d4:	6b02                	ld	s6,0(sp)
 7d6:	b7f5                	j	7c2 <malloc+0xe4>
