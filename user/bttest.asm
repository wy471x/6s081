
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
   e:	30e080e7          	jalr	782(ra) # 318 <sleep>
  exit(0);
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	274080e7          	jalr	628(ra) # 288 <exit>

000000000000001c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  1c:	1141                	addi	sp,sp,-16
  1e:	e422                	sd	s0,8(sp)
  20:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  22:	87aa                	mv	a5,a0
  24:	0585                	addi	a1,a1,1
  26:	0785                	addi	a5,a5,1
  28:	fff5c703          	lbu	a4,-1(a1)
  2c:	fee78fa3          	sb	a4,-1(a5)
  30:	fb75                	bnez	a4,24 <strcpy+0x8>
    ;
  return os;
}
  32:	6422                	ld	s0,8(sp)
  34:	0141                	addi	sp,sp,16
  36:	8082                	ret

0000000000000038 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  38:	1141                	addi	sp,sp,-16
  3a:	e422                	sd	s0,8(sp)
  3c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  3e:	00054783          	lbu	a5,0(a0)
  42:	cb91                	beqz	a5,56 <strcmp+0x1e>
  44:	0005c703          	lbu	a4,0(a1)
  48:	00f71763          	bne	a4,a5,56 <strcmp+0x1e>
    p++, q++;
  4c:	0505                	addi	a0,a0,1
  4e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	fbe5                	bnez	a5,44 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  56:	0005c503          	lbu	a0,0(a1)
}
  5a:	40a7853b          	subw	a0,a5,a0
  5e:	6422                	ld	s0,8(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strlen>:

uint
strlen(const char *s)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cf91                	beqz	a5,8a <strlen+0x26>
  70:	0505                	addi	a0,a0,1
  72:	87aa                	mv	a5,a0
  74:	86be                	mv	a3,a5
  76:	0785                	addi	a5,a5,1
  78:	fff7c703          	lbu	a4,-1(a5)
  7c:	ff65                	bnez	a4,74 <strlen+0x10>
  7e:	40a6853b          	subw	a0,a3,a0
  82:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
  for(n = 0; s[n]; n++)
  8a:	4501                	li	a0,0
  8c:	bfe5                	j	84 <strlen+0x20>

000000000000008e <memset>:

void*
memset(void *dst, int c, uint n)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  94:	ca19                	beqz	a2,aa <memset+0x1c>
  96:	87aa                	mv	a5,a0
  98:	1602                	slli	a2,a2,0x20
  9a:	9201                	srli	a2,a2,0x20
  9c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a4:	0785                	addi	a5,a5,1
  a6:	fee79de3          	bne	a5,a4,a0 <memset+0x12>
  }
  return dst;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strchr>:

char*
strchr(const char *s, char c)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb99                	beqz	a5,d0 <strchr+0x20>
    if(*s == c)
  bc:	00f58763          	beq	a1,a5,ca <strchr+0x1a>
  for(; *s; s++)
  c0:	0505                	addi	a0,a0,1
  c2:	00054783          	lbu	a5,0(a0)
  c6:	fbfd                	bnez	a5,bc <strchr+0xc>
      return (char*)s;
  return 0;
  c8:	4501                	li	a0,0
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret
  return 0;
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strchr+0x1a>

00000000000000d4 <gets>:

char*
gets(char *buf, int max)
{
  d4:	711d                	addi	sp,sp,-96
  d6:	ec86                	sd	ra,88(sp)
  d8:	e8a2                	sd	s0,80(sp)
  da:	e4a6                	sd	s1,72(sp)
  dc:	e0ca                	sd	s2,64(sp)
  de:	fc4e                	sd	s3,56(sp)
  e0:	f852                	sd	s4,48(sp)
  e2:	f456                	sd	s5,40(sp)
  e4:	f05a                	sd	s6,32(sp)
  e6:	ec5e                	sd	s7,24(sp)
  e8:	1080                	addi	s0,sp,96
  ea:	8baa                	mv	s7,a0
  ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ee:	892a                	mv	s2,a0
  f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f2:	4aa9                	li	s5,10
  f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  f6:	89a6                	mv	s3,s1
  f8:	2485                	addiw	s1,s1,1
  fa:	0344d863          	bge	s1,s4,12a <gets+0x56>
    cc = read(0, &c, 1);
  fe:	4605                	li	a2,1
 100:	faf40593          	addi	a1,s0,-81
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	19a080e7          	jalr	410(ra) # 2a0 <read>
    if(cc < 1)
 10e:	00a05e63          	blez	a0,12a <gets+0x56>
    buf[i++] = c;
 112:	faf44783          	lbu	a5,-81(s0)
 116:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11a:	01578763          	beq	a5,s5,128 <gets+0x54>
 11e:	0905                	addi	s2,s2,1
 120:	fd679be3          	bne	a5,s6,f6 <gets+0x22>
    buf[i++] = c;
 124:	89a6                	mv	s3,s1
 126:	a011                	j	12a <gets+0x56>
 128:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12a:	99de                	add	s3,s3,s7
 12c:	00098023          	sb	zero,0(s3)
  return buf;
}
 130:	855e                	mv	a0,s7
 132:	60e6                	ld	ra,88(sp)
 134:	6446                	ld	s0,80(sp)
 136:	64a6                	ld	s1,72(sp)
 138:	6906                	ld	s2,64(sp)
 13a:	79e2                	ld	s3,56(sp)
 13c:	7a42                	ld	s4,48(sp)
 13e:	7aa2                	ld	s5,40(sp)
 140:	7b02                	ld	s6,32(sp)
 142:	6be2                	ld	s7,24(sp)
 144:	6125                	addi	sp,sp,96
 146:	8082                	ret

0000000000000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	1101                	addi	sp,sp,-32
 14a:	ec06                	sd	ra,24(sp)
 14c:	e822                	sd	s0,16(sp)
 14e:	e04a                	sd	s2,0(sp)
 150:	1000                	addi	s0,sp,32
 152:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 154:	4581                	li	a1,0
 156:	00000097          	auipc	ra,0x0
 15a:	172080e7          	jalr	370(ra) # 2c8 <open>
  if(fd < 0)
 15e:	02054663          	bltz	a0,18a <stat+0x42>
 162:	e426                	sd	s1,8(sp)
 164:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 166:	85ca                	mv	a1,s2
 168:	00000097          	auipc	ra,0x0
 16c:	178080e7          	jalr	376(ra) # 2e0 <fstat>
 170:	892a                	mv	s2,a0
  close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	13c080e7          	jalr	316(ra) # 2b0 <close>
  return r;
 17c:	64a2                	ld	s1,8(sp)
}
 17e:	854a                	mv	a0,s2
 180:	60e2                	ld	ra,24(sp)
 182:	6442                	ld	s0,16(sp)
 184:	6902                	ld	s2,0(sp)
 186:	6105                	addi	sp,sp,32
 188:	8082                	ret
    return -1;
 18a:	597d                	li	s2,-1
 18c:	bfcd                	j	17e <stat+0x36>

000000000000018e <atoi>:

int
atoi(const char *s)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 194:	00054683          	lbu	a3,0(a0)
 198:	fd06879b          	addiw	a5,a3,-48
 19c:	0ff7f793          	zext.b	a5,a5
 1a0:	4625                	li	a2,9
 1a2:	02f66863          	bltu	a2,a5,1d2 <atoi+0x44>
 1a6:	872a                	mv	a4,a0
  n = 0;
 1a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1aa:	0705                	addi	a4,a4,1
 1ac:	0025179b          	slliw	a5,a0,0x2
 1b0:	9fa9                	addw	a5,a5,a0
 1b2:	0017979b          	slliw	a5,a5,0x1
 1b6:	9fb5                	addw	a5,a5,a3
 1b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1bc:	00074683          	lbu	a3,0(a4)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	fef671e3          	bgeu	a2,a5,1aa <atoi+0x1c>
  return n;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  n = 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <atoi+0x3e>

00000000000001d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1dc:	02b57463          	bgeu	a0,a1,204 <memmove+0x2e>
    while(n-- > 0)
 1e0:	00c05f63          	blez	a2,1fe <memmove+0x28>
 1e4:	1602                	slli	a2,a2,0x20
 1e6:	9201                	srli	a2,a2,0x20
 1e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 1ee:	0585                	addi	a1,a1,1
 1f0:	0705                	addi	a4,a4,1
 1f2:	fff5c683          	lbu	a3,-1(a1)
 1f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fa:	fef71ae3          	bne	a4,a5,1ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
    dst += n;
 204:	00c50733          	add	a4,a0,a2
    src += n;
 208:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20a:	fec05ae3          	blez	a2,1fe <memmove+0x28>
 20e:	fff6079b          	addiw	a5,a2,-1
 212:	1782                	slli	a5,a5,0x20
 214:	9381                	srli	a5,a5,0x20
 216:	fff7c793          	not	a5,a5
 21a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21c:	15fd                	addi	a1,a1,-1
 21e:	177d                	addi	a4,a4,-1
 220:	0005c683          	lbu	a3,0(a1)
 224:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 228:	fee79ae3          	bne	a5,a4,21c <memmove+0x46>
 22c:	bfc9                	j	1fe <memmove+0x28>

000000000000022e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 234:	ca05                	beqz	a2,264 <memcmp+0x36>
 236:	fff6069b          	addiw	a3,a2,-1
 23a:	1682                	slli	a3,a3,0x20
 23c:	9281                	srli	a3,a3,0x20
 23e:	0685                	addi	a3,a3,1
 240:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 242:	00054783          	lbu	a5,0(a0)
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00e79863          	bne	a5,a4,25a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 24e:	0505                	addi	a0,a0,1
    p2++;
 250:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 252:	fed518e3          	bne	a0,a3,242 <memcmp+0x14>
  }
  return 0;
 256:	4501                	li	a0,0
 258:	a019                	j	25e <memcmp+0x30>
      return *p1 - *p2;
 25a:	40e7853b          	subw	a0,a5,a4
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  return 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <memcmp+0x30>

0000000000000268 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 270:	00000097          	auipc	ra,0x0
 274:	f66080e7          	jalr	-154(ra) # 1d6 <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 280:	4885                	li	a7,1
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <exit>:
.global exit
exit:
 li a7, SYS_exit
 288:	4889                	li	a7,2
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <wait>:
.global wait
wait:
 li a7, SYS_wait
 290:	488d                	li	a7,3
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 298:	4891                	li	a7,4
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <read>:
.global read
read:
 li a7, SYS_read
 2a0:	4895                	li	a7,5
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <write>:
.global write
write:
 li a7, SYS_write
 2a8:	48c1                	li	a7,16
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <close>:
.global close
close:
 li a7, SYS_close
 2b0:	48d5                	li	a7,21
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b8:	4899                	li	a7,6
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c0:	489d                	li	a7,7
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <open>:
.global open
open:
 li a7, SYS_open
 2c8:	48bd                	li	a7,15
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d0:	48c5                	li	a7,17
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d8:	48c9                	li	a7,18
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e0:	48a1                	li	a7,8
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <link>:
.global link
link:
 li a7, SYS_link
 2e8:	48cd                	li	a7,19
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f0:	48d1                	li	a7,20
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f8:	48a5                	li	a7,9
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <dup>:
.global dup
dup:
 li a7, SYS_dup
 300:	48a9                	li	a7,10
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48ad                	li	a7,11
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 310:	48b1                	li	a7,12
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 318:	48b5                	li	a7,13
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 320:	48b9                	li	a7,14
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 328:	1101                	addi	sp,sp,-32
 32a:	ec06                	sd	ra,24(sp)
 32c:	e822                	sd	s0,16(sp)
 32e:	1000                	addi	s0,sp,32
 330:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 334:	4605                	li	a2,1
 336:	fef40593          	addi	a1,s0,-17
 33a:	00000097          	auipc	ra,0x0
 33e:	f6e080e7          	jalr	-146(ra) # 2a8 <write>
}
 342:	60e2                	ld	ra,24(sp)
 344:	6442                	ld	s0,16(sp)
 346:	6105                	addi	sp,sp,32
 348:	8082                	ret

000000000000034a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 34a:	7139                	addi	sp,sp,-64
 34c:	fc06                	sd	ra,56(sp)
 34e:	f822                	sd	s0,48(sp)
 350:	f426                	sd	s1,40(sp)
 352:	0080                	addi	s0,sp,64
 354:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 356:	c299                	beqz	a3,35c <printint+0x12>
 358:	0805cb63          	bltz	a1,3ee <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 35c:	2581                	sext.w	a1,a1
  neg = 0;
 35e:	4881                	li	a7,0
 360:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 364:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 366:	2601                	sext.w	a2,a2
 368:	00000517          	auipc	a0,0x0
 36c:	4a050513          	addi	a0,a0,1184 # 808 <digits>
 370:	883a                	mv	a6,a4
 372:	2705                	addiw	a4,a4,1
 374:	02c5f7bb          	remuw	a5,a1,a2
 378:	1782                	slli	a5,a5,0x20
 37a:	9381                	srli	a5,a5,0x20
 37c:	97aa                	add	a5,a5,a0
 37e:	0007c783          	lbu	a5,0(a5)
 382:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 386:	0005879b          	sext.w	a5,a1
 38a:	02c5d5bb          	divuw	a1,a1,a2
 38e:	0685                	addi	a3,a3,1
 390:	fec7f0e3          	bgeu	a5,a2,370 <printint+0x26>
  if(neg)
 394:	00088c63          	beqz	a7,3ac <printint+0x62>
    buf[i++] = '-';
 398:	fd070793          	addi	a5,a4,-48
 39c:	00878733          	add	a4,a5,s0
 3a0:	02d00793          	li	a5,45
 3a4:	fef70823          	sb	a5,-16(a4)
 3a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ac:	02e05c63          	blez	a4,3e4 <printint+0x9a>
 3b0:	f04a                	sd	s2,32(sp)
 3b2:	ec4e                	sd	s3,24(sp)
 3b4:	fc040793          	addi	a5,s0,-64
 3b8:	00e78933          	add	s2,a5,a4
 3bc:	fff78993          	addi	s3,a5,-1
 3c0:	99ba                	add	s3,s3,a4
 3c2:	377d                	addiw	a4,a4,-1
 3c4:	1702                	slli	a4,a4,0x20
 3c6:	9301                	srli	a4,a4,0x20
 3c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3cc:	fff94583          	lbu	a1,-1(s2)
 3d0:	8526                	mv	a0,s1
 3d2:	00000097          	auipc	ra,0x0
 3d6:	f56080e7          	jalr	-170(ra) # 328 <putc>
  while(--i >= 0)
 3da:	197d                	addi	s2,s2,-1
 3dc:	ff3918e3          	bne	s2,s3,3cc <printint+0x82>
 3e0:	7902                	ld	s2,32(sp)
 3e2:	69e2                	ld	s3,24(sp)
}
 3e4:	70e2                	ld	ra,56(sp)
 3e6:	7442                	ld	s0,48(sp)
 3e8:	74a2                	ld	s1,40(sp)
 3ea:	6121                	addi	sp,sp,64
 3ec:	8082                	ret
    x = -xx;
 3ee:	40b005bb          	negw	a1,a1
    neg = 1;
 3f2:	4885                	li	a7,1
    x = -xx;
 3f4:	b7b5                	j	360 <printint+0x16>

00000000000003f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3f6:	715d                	addi	sp,sp,-80
 3f8:	e486                	sd	ra,72(sp)
 3fa:	e0a2                	sd	s0,64(sp)
 3fc:	f84a                	sd	s2,48(sp)
 3fe:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 400:	0005c903          	lbu	s2,0(a1)
 404:	1a090a63          	beqz	s2,5b8 <vprintf+0x1c2>
 408:	fc26                	sd	s1,56(sp)
 40a:	f44e                	sd	s3,40(sp)
 40c:	f052                	sd	s4,32(sp)
 40e:	ec56                	sd	s5,24(sp)
 410:	e85a                	sd	s6,16(sp)
 412:	e45e                	sd	s7,8(sp)
 414:	8aaa                	mv	s5,a0
 416:	8bb2                	mv	s7,a2
 418:	00158493          	addi	s1,a1,1
  state = 0;
 41c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 41e:	02500a13          	li	s4,37
 422:	4b55                	li	s6,21
 424:	a839                	j	442 <vprintf+0x4c>
        putc(fd, c);
 426:	85ca                	mv	a1,s2
 428:	8556                	mv	a0,s5
 42a:	00000097          	auipc	ra,0x0
 42e:	efe080e7          	jalr	-258(ra) # 328 <putc>
 432:	a019                	j	438 <vprintf+0x42>
    } else if(state == '%'){
 434:	01498d63          	beq	s3,s4,44e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 438:	0485                	addi	s1,s1,1
 43a:	fff4c903          	lbu	s2,-1(s1)
 43e:	16090763          	beqz	s2,5ac <vprintf+0x1b6>
    if(state == 0){
 442:	fe0999e3          	bnez	s3,434 <vprintf+0x3e>
      if(c == '%'){
 446:	ff4910e3          	bne	s2,s4,426 <vprintf+0x30>
        state = '%';
 44a:	89d2                	mv	s3,s4
 44c:	b7f5                	j	438 <vprintf+0x42>
      if(c == 'd'){
 44e:	13490463          	beq	s2,s4,576 <vprintf+0x180>
 452:	f9d9079b          	addiw	a5,s2,-99
 456:	0ff7f793          	zext.b	a5,a5
 45a:	12fb6763          	bltu	s6,a5,588 <vprintf+0x192>
 45e:	f9d9079b          	addiw	a5,s2,-99
 462:	0ff7f713          	zext.b	a4,a5
 466:	12eb6163          	bltu	s6,a4,588 <vprintf+0x192>
 46a:	00271793          	slli	a5,a4,0x2
 46e:	00000717          	auipc	a4,0x0
 472:	34270713          	addi	a4,a4,834 # 7b0 <malloc+0x108>
 476:	97ba                	add	a5,a5,a4
 478:	439c                	lw	a5,0(a5)
 47a:	97ba                	add	a5,a5,a4
 47c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 47e:	008b8913          	addi	s2,s7,8
 482:	4685                	li	a3,1
 484:	4629                	li	a2,10
 486:	000ba583          	lw	a1,0(s7)
 48a:	8556                	mv	a0,s5
 48c:	00000097          	auipc	ra,0x0
 490:	ebe080e7          	jalr	-322(ra) # 34a <printint>
 494:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 496:	4981                	li	s3,0
 498:	b745                	j	438 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 49a:	008b8913          	addi	s2,s7,8
 49e:	4681                	li	a3,0
 4a0:	4629                	li	a2,10
 4a2:	000ba583          	lw	a1,0(s7)
 4a6:	8556                	mv	a0,s5
 4a8:	00000097          	auipc	ra,0x0
 4ac:	ea2080e7          	jalr	-350(ra) # 34a <printint>
 4b0:	8bca                	mv	s7,s2
      state = 0;
 4b2:	4981                	li	s3,0
 4b4:	b751                	j	438 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4b6:	008b8913          	addi	s2,s7,8
 4ba:	4681                	li	a3,0
 4bc:	4641                	li	a2,16
 4be:	000ba583          	lw	a1,0(s7)
 4c2:	8556                	mv	a0,s5
 4c4:	00000097          	auipc	ra,0x0
 4c8:	e86080e7          	jalr	-378(ra) # 34a <printint>
 4cc:	8bca                	mv	s7,s2
      state = 0;
 4ce:	4981                	li	s3,0
 4d0:	b7a5                	j	438 <vprintf+0x42>
 4d2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 4d4:	008b8c13          	addi	s8,s7,8
 4d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4dc:	03000593          	li	a1,48
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	e46080e7          	jalr	-442(ra) # 328 <putc>
  putc(fd, 'x');
 4ea:	07800593          	li	a1,120
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	e38080e7          	jalr	-456(ra) # 328 <putc>
 4f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fa:	00000b97          	auipc	s7,0x0
 4fe:	30eb8b93          	addi	s7,s7,782 # 808 <digits>
 502:	03c9d793          	srli	a5,s3,0x3c
 506:	97de                	add	a5,a5,s7
 508:	0007c583          	lbu	a1,0(a5)
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e1a080e7          	jalr	-486(ra) # 328 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 516:	0992                	slli	s3,s3,0x4
 518:	397d                	addiw	s2,s2,-1
 51a:	fe0914e3          	bnez	s2,502 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 51e:	8be2                	mv	s7,s8
      state = 0;
 520:	4981                	li	s3,0
 522:	6c02                	ld	s8,0(sp)
 524:	bf11                	j	438 <vprintf+0x42>
        s = va_arg(ap, char*);
 526:	008b8993          	addi	s3,s7,8
 52a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 52e:	02090163          	beqz	s2,550 <vprintf+0x15a>
        while(*s != 0){
 532:	00094583          	lbu	a1,0(s2)
 536:	c9a5                	beqz	a1,5a6 <vprintf+0x1b0>
          putc(fd, *s);
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	dee080e7          	jalr	-530(ra) # 328 <putc>
          s++;
 542:	0905                	addi	s2,s2,1
        while(*s != 0){
 544:	00094583          	lbu	a1,0(s2)
 548:	f9e5                	bnez	a1,538 <vprintf+0x142>
        s = va_arg(ap, char*);
 54a:	8bce                	mv	s7,s3
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b5ed                	j	438 <vprintf+0x42>
          s = "(null)";
 550:	00000917          	auipc	s2,0x0
 554:	25890913          	addi	s2,s2,600 # 7a8 <malloc+0x100>
        while(*s != 0){
 558:	02800593          	li	a1,40
 55c:	bff1                	j	538 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 55e:	008b8913          	addi	s2,s7,8
 562:	000bc583          	lbu	a1,0(s7)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	dc0080e7          	jalr	-576(ra) # 328 <putc>
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	b5d1                	j	438 <vprintf+0x42>
        putc(fd, c);
 576:	02500593          	li	a1,37
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	dac080e7          	jalr	-596(ra) # 328 <putc>
      state = 0;
 584:	4981                	li	s3,0
 586:	bd4d                	j	438 <vprintf+0x42>
        putc(fd, '%');
 588:	02500593          	li	a1,37
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	d9a080e7          	jalr	-614(ra) # 328 <putc>
        putc(fd, c);
 596:	85ca                	mv	a1,s2
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	d8e080e7          	jalr	-626(ra) # 328 <putc>
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bd51                	j	438 <vprintf+0x42>
        s = va_arg(ap, char*);
 5a6:	8bce                	mv	s7,s3
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b579                	j	438 <vprintf+0x42>
 5ac:	74e2                	ld	s1,56(sp)
 5ae:	79a2                	ld	s3,40(sp)
 5b0:	7a02                	ld	s4,32(sp)
 5b2:	6ae2                	ld	s5,24(sp)
 5b4:	6b42                	ld	s6,16(sp)
 5b6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5b8:	60a6                	ld	ra,72(sp)
 5ba:	6406                	ld	s0,64(sp)
 5bc:	7942                	ld	s2,48(sp)
 5be:	6161                	addi	sp,sp,80
 5c0:	8082                	ret

00000000000005c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5c2:	715d                	addi	sp,sp,-80
 5c4:	ec06                	sd	ra,24(sp)
 5c6:	e822                	sd	s0,16(sp)
 5c8:	1000                	addi	s0,sp,32
 5ca:	e010                	sd	a2,0(s0)
 5cc:	e414                	sd	a3,8(s0)
 5ce:	e818                	sd	a4,16(s0)
 5d0:	ec1c                	sd	a5,24(s0)
 5d2:	03043023          	sd	a6,32(s0)
 5d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5de:	8622                	mv	a2,s0
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e16080e7          	jalr	-490(ra) # 3f6 <vprintf>
}
 5e8:	60e2                	ld	ra,24(sp)
 5ea:	6442                	ld	s0,16(sp)
 5ec:	6161                	addi	sp,sp,80
 5ee:	8082                	ret

00000000000005f0 <printf>:

void
printf(const char *fmt, ...)
{
 5f0:	711d                	addi	sp,sp,-96
 5f2:	ec06                	sd	ra,24(sp)
 5f4:	e822                	sd	s0,16(sp)
 5f6:	1000                	addi	s0,sp,32
 5f8:	e40c                	sd	a1,8(s0)
 5fa:	e810                	sd	a2,16(s0)
 5fc:	ec14                	sd	a3,24(s0)
 5fe:	f018                	sd	a4,32(s0)
 600:	f41c                	sd	a5,40(s0)
 602:	03043823          	sd	a6,48(s0)
 606:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 60a:	00840613          	addi	a2,s0,8
 60e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 612:	85aa                	mv	a1,a0
 614:	4505                	li	a0,1
 616:	00000097          	auipc	ra,0x0
 61a:	de0080e7          	jalr	-544(ra) # 3f6 <vprintf>
}
 61e:	60e2                	ld	ra,24(sp)
 620:	6442                	ld	s0,16(sp)
 622:	6125                	addi	sp,sp,96
 624:	8082                	ret

0000000000000626 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 626:	1141                	addi	sp,sp,-16
 628:	e422                	sd	s0,8(sp)
 62a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 630:	00000797          	auipc	a5,0x0
 634:	1f07b783          	ld	a5,496(a5) # 820 <freep>
 638:	a02d                	j	662 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 63a:	4618                	lw	a4,8(a2)
 63c:	9f2d                	addw	a4,a4,a1
 63e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 642:	6398                	ld	a4,0(a5)
 644:	6310                	ld	a2,0(a4)
 646:	a83d                	j	684 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 648:	ff852703          	lw	a4,-8(a0)
 64c:	9f31                	addw	a4,a4,a2
 64e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 650:	ff053683          	ld	a3,-16(a0)
 654:	a091                	j	698 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 656:	6398                	ld	a4,0(a5)
 658:	00e7e463          	bltu	a5,a4,660 <free+0x3a>
 65c:	00e6ea63          	bltu	a3,a4,670 <free+0x4a>
{
 660:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 662:	fed7fae3          	bgeu	a5,a3,656 <free+0x30>
 666:	6398                	ld	a4,0(a5)
 668:	00e6e463          	bltu	a3,a4,670 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66c:	fee7eae3          	bltu	a5,a4,660 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 670:	ff852583          	lw	a1,-8(a0)
 674:	6390                	ld	a2,0(a5)
 676:	02059813          	slli	a6,a1,0x20
 67a:	01c85713          	srli	a4,a6,0x1c
 67e:	9736                	add	a4,a4,a3
 680:	fae60de3          	beq	a2,a4,63a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 688:	4790                	lw	a2,8(a5)
 68a:	02061593          	slli	a1,a2,0x20
 68e:	01c5d713          	srli	a4,a1,0x1c
 692:	973e                	add	a4,a4,a5
 694:	fae68ae3          	beq	a3,a4,648 <free+0x22>
    p->s.ptr = bp->s.ptr;
 698:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 69a:	00000717          	auipc	a4,0x0
 69e:	18f73323          	sd	a5,390(a4) # 820 <freep>
}
 6a2:	6422                	ld	s0,8(sp)
 6a4:	0141                	addi	sp,sp,16
 6a6:	8082                	ret

00000000000006a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a8:	7139                	addi	sp,sp,-64
 6aa:	fc06                	sd	ra,56(sp)
 6ac:	f822                	sd	s0,48(sp)
 6ae:	f426                	sd	s1,40(sp)
 6b0:	ec4e                	sd	s3,24(sp)
 6b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b4:	02051493          	slli	s1,a0,0x20
 6b8:	9081                	srli	s1,s1,0x20
 6ba:	04bd                	addi	s1,s1,15
 6bc:	8091                	srli	s1,s1,0x4
 6be:	0014899b          	addiw	s3,s1,1
 6c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6c4:	00000517          	auipc	a0,0x0
 6c8:	15c53503          	ld	a0,348(a0) # 820 <freep>
 6cc:	c915                	beqz	a0,700 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6d0:	4798                	lw	a4,8(a5)
 6d2:	08977e63          	bgeu	a4,s1,76e <malloc+0xc6>
 6d6:	f04a                	sd	s2,32(sp)
 6d8:	e852                	sd	s4,16(sp)
 6da:	e456                	sd	s5,8(sp)
 6dc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 6de:	8a4e                	mv	s4,s3
 6e0:	0009871b          	sext.w	a4,s3
 6e4:	6685                	lui	a3,0x1
 6e6:	00d77363          	bgeu	a4,a3,6ec <malloc+0x44>
 6ea:	6a05                	lui	s4,0x1
 6ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6f4:	00000917          	auipc	s2,0x0
 6f8:	12c90913          	addi	s2,s2,300 # 820 <freep>
  if(p == (char*)-1)
 6fc:	5afd                	li	s5,-1
 6fe:	a091                	j	742 <malloc+0x9a>
 700:	f04a                	sd	s2,32(sp)
 702:	e852                	sd	s4,16(sp)
 704:	e456                	sd	s5,8(sp)
 706:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 708:	00000797          	auipc	a5,0x0
 70c:	12078793          	addi	a5,a5,288 # 828 <base>
 710:	00000717          	auipc	a4,0x0
 714:	10f73823          	sd	a5,272(a4) # 820 <freep>
 718:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 71a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 71e:	b7c1                	j	6de <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 720:	6398                	ld	a4,0(a5)
 722:	e118                	sd	a4,0(a0)
 724:	a08d                	j	786 <malloc+0xde>
  hp->s.size = nu;
 726:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 72a:	0541                	addi	a0,a0,16
 72c:	00000097          	auipc	ra,0x0
 730:	efa080e7          	jalr	-262(ra) # 626 <free>
  return freep;
 734:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 738:	c13d                	beqz	a0,79e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 73c:	4798                	lw	a4,8(a5)
 73e:	02977463          	bgeu	a4,s1,766 <malloc+0xbe>
    if(p == freep)
 742:	00093703          	ld	a4,0(s2)
 746:	853e                	mv	a0,a5
 748:	fef719e3          	bne	a4,a5,73a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 74c:	8552                	mv	a0,s4
 74e:	00000097          	auipc	ra,0x0
 752:	bc2080e7          	jalr	-1086(ra) # 310 <sbrk>
  if(p == (char*)-1)
 756:	fd5518e3          	bne	a0,s5,726 <malloc+0x7e>
        return 0;
 75a:	4501                	li	a0,0
 75c:	7902                	ld	s2,32(sp)
 75e:	6a42                	ld	s4,16(sp)
 760:	6aa2                	ld	s5,8(sp)
 762:	6b02                	ld	s6,0(sp)
 764:	a03d                	j	792 <malloc+0xea>
 766:	7902                	ld	s2,32(sp)
 768:	6a42                	ld	s4,16(sp)
 76a:	6aa2                	ld	s5,8(sp)
 76c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 76e:	fae489e3          	beq	s1,a4,720 <malloc+0x78>
        p->s.size -= nunits;
 772:	4137073b          	subw	a4,a4,s3
 776:	c798                	sw	a4,8(a5)
        p += p->s.size;
 778:	02071693          	slli	a3,a4,0x20
 77c:	01c6d713          	srli	a4,a3,0x1c
 780:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 782:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 786:	00000717          	auipc	a4,0x0
 78a:	08a73d23          	sd	a0,154(a4) # 820 <freep>
      return (void*)(p + 1);
 78e:	01078513          	addi	a0,a5,16
  }
}
 792:	70e2                	ld	ra,56(sp)
 794:	7442                	ld	s0,48(sp)
 796:	74a2                	ld	s1,40(sp)
 798:	69e2                	ld	s3,24(sp)
 79a:	6121                	addi	sp,sp,64
 79c:	8082                	ret
 79e:	7902                	ld	s2,32(sp)
 7a0:	6a42                	ld	s4,16(sp)
 7a2:	6aa2                	ld	s5,8(sp)
 7a4:	6b02                	ld	s6,0(sp)
 7a6:	b7f5                	j	792 <malloc+0xea>
