
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  // fprintf(2, "$ ");
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	33658593          	addi	a1,a1,822 # 1348 <malloc+0x100>
      1a:	8532                	mv	a0,a2
      1c:	00001097          	auipc	ra,0x1
      20:	e2a080e7          	jalr	-470(ra) # e46 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	bda080e7          	jalr	-1062(ra) # c04 <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c1c080e7          	jalr	-996(ra) # c52 <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a0053b          	negw	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	2f858593          	addi	a1,a1,760 # 1358 <malloc+0x110>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	0f4080e7          	jalr	244(ra) # 115e <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	db2080e7          	jalr	-590(ra) # e26 <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	d9a080e7          	jalr	-614(ra) # e1e <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	2c650513          	addi	a0,a0,710 # 1360 <malloc+0x118>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b2:	c115                	beqz	a0,d6 <runcmd+0x2c>
      b4:	ec26                	sd	s1,24(sp)
      b6:	84aa                	mv	s1,a0
  switch(cmd->type){
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e363          	bltu	a5,a4,e2 <runcmd+0x38>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	39a70713          	addi	a4,a4,922 # 1460 <malloc+0x218>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
    exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	d4c080e7          	jalr	-692(ra) # e26 <exit>
    panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	28650513          	addi	a0,a0,646 # 1368 <malloc+0x120>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
    exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	d64080e7          	jalr	-668(ra) # e5e <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	26c58593          	addi	a1,a1,620 # 1370 <malloc+0x128>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	050080e7          	jalr	80(ra) # 115e <fprintf>
  exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	d0e080e7          	jalr	-754(ra) # e26 <exit>
      exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	d04080e7          	jalr	-764(ra) # e26 <exit>
    close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	d22080e7          	jalr	-734(ra) # e4e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	d2e080e7          	jalr	-722(ra) # e66 <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
    runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	23058593          	addi	a1,a1,560 # 1380 <malloc+0x138>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	004080e7          	jalr	4(ra) # 115e <fprintf>
      exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	cc2080e7          	jalr	-830(ra) # e26 <exit>
    if(fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f10080e7          	jalr	-240(ra) # 7c <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd6>
      runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f32080e7          	jalr	-206(ra) # aa <runcmd>
    wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	cac080e7          	jalr	-852(ra) # e2e <wait>
    runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
    if(pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	c9e080e7          	jalr	-866(ra) # e36 <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
    if(fork1() == 0){
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
      close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	c9e080e7          	jalr	-866(ra) # e4e <close>
      dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	ce2080e7          	jalr	-798(ra) # e9e <dup>
      close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	c86080e7          	jalr	-890(ra) # e4e <close>
      close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	c7a080e7          	jalr	-902(ra) # e4e <close>
      runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
      panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	1aa50513          	addi	a0,a0,426 # 1390 <malloc+0x148>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
    if(fork1() == 0){
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
      close(0);
     200:	00001097          	auipc	ra,0x1
     204:	c4e080e7          	jalr	-946(ra) # e4e <close>
      dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	c92080e7          	jalr	-878(ra) # e9e <dup>
      close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	c36080e7          	jalr	-970(ra) # e4e <close>
      close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	c2a080e7          	jalr	-982(ra) # e4e <close>
      runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
    close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	c14080e7          	jalr	-1004(ra) # e4e <close>
    close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	c08080e7          	jalr	-1016(ra) # e4e <close>
    wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	bde080e7          	jalr	-1058(ra) # e2e <wait>
    wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	bd4080e7          	jalr	-1068(ra) # e2e <wait>
    break;
     262:	bd55                	j	116 <runcmd+0x6c>
    if(fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e18080e7          	jalr	-488(ra) # 7c <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6c>
      runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e38080e7          	jalr	-456(ra) # aa <runcmd>

000000000000027a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     27a:	1101                	addi	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00001097          	auipc	ra,0x1
     28c:	fc0080e7          	jalr	-64(ra) # 1248 <malloc>
     290:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	96c080e7          	jalr	-1684(ra) # c04 <memset>
  cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	addi	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	addi	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	addi	s0,sp,64
     2c4:	8b2a                	mv	s6,a0
     2c6:	8aae                	mv	s5,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	89b6                	mv	s3,a3
     2cc:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00001097          	auipc	ra,0x1
     2d6:	f76080e7          	jalr	-138(ra) # 1248 <malloc>
     2da:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	922080e7          	jalr	-1758(ra) # c04 <memset>
  cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ee:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f2:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2fa:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fe:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	addi	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	addi	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	addi	s0,sp,48
     326:	89aa                	mv	s3,a0
     328:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	f1c080e7          	jalr	-228(ra) # 1248 <malloc>
     334:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	8ca080e7          	jalr	-1846(ra) # c04 <memset>
  cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     346:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     34a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	addi	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	addi	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	addi	s0,sp,48
     36c:	89aa                	mv	s3,a0
     36e:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	ed6080e7          	jalr	-298(ra) # 1248 <malloc>
     37a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	884080e7          	jalr	-1916(ra) # c04 <memset>
  cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38c:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     390:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	addi	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	addi	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	addi	s0,sp,32
     3b0:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	e94080e7          	jalr	-364(ra) # 1248 <malloc>
     3bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	842080e7          	jalr	-1982(ra) # c04 <memset>
  cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	addi	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	addi	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	addi	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fc:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fe:	00001997          	auipc	s3,0x1
     402:	10a98993          	addi	s3,s3,266 # 1508 <whitespace>
     406:	00b4fe63          	bgeu	s1,a1,422 <gettoken+0x42>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00001097          	auipc	ra,0x1
     414:	81a080e7          	jalr	-2022(ra) # c2a <strchr>
     418:	c509                	beqz	a0,422 <gettoken+0x42>
    s++;
     41a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
     420:	84ca                	mv	s1,s2
  if(q)
     422:	000a8463          	beqz	s5,42a <gettoken+0x4a>
    *q = s;
     426:	009ab023          	sd	s1,0(s5)
  ret = *s;
     42a:	0004c783          	lbu	a5,0(s1)
     42e:	00078a9b          	sext.w	s5,a5
  switch(*s){
     432:	03c00713          	li	a4,60
     436:	06f76663          	bltu	a4,a5,4a2 <gettoken+0xc2>
     43a:	03a00713          	li	a4,58
     43e:	00f76e63          	bltu	a4,a5,45a <gettoken+0x7a>
     442:	cf89                	beqz	a5,45c <gettoken+0x7c>
     444:	02600713          	li	a4,38
     448:	00e78963          	beq	a5,a4,45a <gettoken+0x7a>
     44c:	fd87879b          	addiw	a5,a5,-40
     450:	0ff7f793          	zext.b	a5,a5
     454:	4705                	li	a4,1
     456:	06f76d63          	bltu	a4,a5,4d0 <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     45a:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45c:	000b0463          	beqz	s6,464 <gettoken+0x84>
    *eq = s;
     460:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     464:	00001997          	auipc	s3,0x1
     468:	0a498993          	addi	s3,s3,164 # 1508 <whitespace>
     46c:	0124fe63          	bgeu	s1,s2,488 <gettoken+0xa8>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	00000097          	auipc	ra,0x0
     47a:	7b4080e7          	jalr	1972(ra) # c2a <strchr>
     47e:	c509                	beqz	a0,488 <gettoken+0xa8>
    s++;
     480:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     482:	fe9917e3          	bne	s2,s1,470 <gettoken+0x90>
     486:	84ca                	mv	s1,s2
  *ps = s;
     488:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48c:	8556                	mv	a0,s5
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6b02                	ld	s6,0(sp)
     49e:	6121                	addi	sp,sp,64
     4a0:	8082                	ret
  switch(*s){
     4a2:	03e00713          	li	a4,62
     4a6:	02e79163          	bne	a5,a4,4c8 <gettoken+0xe8>
    s++;
     4aa:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4ae:	0014c703          	lbu	a4,1(s1)
     4b2:	03e00793          	li	a5,62
      s++;
     4b6:	0489                	addi	s1,s1,2
      ret = '+';
     4b8:	02b00a93          	li	s5,43
    if(*s == '>'){
     4bc:	faf700e3          	beq	a4,a5,45c <gettoken+0x7c>
    s++;
     4c0:	84b6                	mv	s1,a3
  ret = *s;
     4c2:	03e00a93          	li	s5,62
     4c6:	bf59                	j	45c <gettoken+0x7c>
  switch(*s){
     4c8:	07c00713          	li	a4,124
     4cc:	f8e787e3          	beq	a5,a4,45a <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4d0:	00001997          	auipc	s3,0x1
     4d4:	03898993          	addi	s3,s3,56 # 1508 <whitespace>
     4d8:	00001a97          	auipc	s5,0x1
     4dc:	028a8a93          	addi	s5,s5,40 # 1500 <symbols>
     4e0:	0524f163          	bgeu	s1,s2,522 <gettoken+0x142>
     4e4:	0004c583          	lbu	a1,0(s1)
     4e8:	854e                	mv	a0,s3
     4ea:	00000097          	auipc	ra,0x0
     4ee:	740080e7          	jalr	1856(ra) # c2a <strchr>
     4f2:	e50d                	bnez	a0,51c <gettoken+0x13c>
     4f4:	0004c583          	lbu	a1,0(s1)
     4f8:	8556                	mv	a0,s5
     4fa:	00000097          	auipc	ra,0x0
     4fe:	730080e7          	jalr	1840(ra) # c2a <strchr>
     502:	e911                	bnez	a0,516 <gettoken+0x136>
      s++;
     504:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     506:	fc991fe3          	bne	s2,s1,4e4 <gettoken+0x104>
  if(eq)
     50a:	84ca                	mv	s1,s2
    ret = 'a';
     50c:	06100a93          	li	s5,97
  if(eq)
     510:	f40b18e3          	bnez	s6,460 <gettoken+0x80>
     514:	bf95                	j	488 <gettoken+0xa8>
    ret = 'a';
     516:	06100a93          	li	s5,97
     51a:	b789                	j	45c <gettoken+0x7c>
     51c:	06100a93          	li	s5,97
     520:	bf35                	j	45c <gettoken+0x7c>
     522:	06100a93          	li	s5,97
  if(eq)
     526:	f20b1de3          	bnez	s6,460 <gettoken+0x80>
     52a:	bfb9                	j	488 <gettoken+0xa8>

000000000000052c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     52c:	7139                	addi	sp,sp,-64
     52e:	fc06                	sd	ra,56(sp)
     530:	f822                	sd	s0,48(sp)
     532:	f426                	sd	s1,40(sp)
     534:	f04a                	sd	s2,32(sp)
     536:	ec4e                	sd	s3,24(sp)
     538:	e852                	sd	s4,16(sp)
     53a:	e456                	sd	s5,8(sp)
     53c:	0080                	addi	s0,sp,64
     53e:	8a2a                	mv	s4,a0
     540:	892e                	mv	s2,a1
     542:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     544:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     546:	00001997          	auipc	s3,0x1
     54a:	fc298993          	addi	s3,s3,-62 # 1508 <whitespace>
     54e:	00b4fe63          	bgeu	s1,a1,56a <peek+0x3e>
     552:	0004c583          	lbu	a1,0(s1)
     556:	854e                	mv	a0,s3
     558:	00000097          	auipc	ra,0x0
     55c:	6d2080e7          	jalr	1746(ra) # c2a <strchr>
     560:	c509                	beqz	a0,56a <peek+0x3e>
    s++;
     562:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     564:	fe9917e3          	bne	s2,s1,552 <peek+0x26>
     568:	84ca                	mv	s1,s2
  *ps = s;
     56a:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56e:	0004c583          	lbu	a1,0(s1)
     572:	4501                	li	a0,0
     574:	e991                	bnez	a1,588 <peek+0x5c>
}
     576:	70e2                	ld	ra,56(sp)
     578:	7442                	ld	s0,48(sp)
     57a:	74a2                	ld	s1,40(sp)
     57c:	7902                	ld	s2,32(sp)
     57e:	69e2                	ld	s3,24(sp)
     580:	6a42                	ld	s4,16(sp)
     582:	6aa2                	ld	s5,8(sp)
     584:	6121                	addi	sp,sp,64
     586:	8082                	ret
  return *s && strchr(toks, *s);
     588:	8556                	mv	a0,s5
     58a:	00000097          	auipc	ra,0x0
     58e:	6a0080e7          	jalr	1696(ra) # c2a <strchr>
     592:	00a03533          	snez	a0,a0
     596:	b7c5                	j	576 <peek+0x4a>

0000000000000598 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     598:	7159                	addi	sp,sp,-112
     59a:	f486                	sd	ra,104(sp)
     59c:	f0a2                	sd	s0,96(sp)
     59e:	eca6                	sd	s1,88(sp)
     5a0:	e8ca                	sd	s2,80(sp)
     5a2:	e4ce                	sd	s3,72(sp)
     5a4:	e0d2                	sd	s4,64(sp)
     5a6:	fc56                	sd	s5,56(sp)
     5a8:	f85a                	sd	s6,48(sp)
     5aa:	f45e                	sd	s7,40(sp)
     5ac:	f062                	sd	s8,32(sp)
     5ae:	ec66                	sd	s9,24(sp)
     5b0:	1880                	addi	s0,sp,112
     5b2:	8a2a                	mv	s4,a0
     5b4:	89ae                	mv	s3,a1
     5b6:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b8:	00001b17          	auipc	s6,0x1
     5bc:	e00b0b13          	addi	s6,s6,-512 # 13b8 <malloc+0x170>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5c0:	f9040c93          	addi	s9,s0,-112
     5c4:	f9840c13          	addi	s8,s0,-104
     5c8:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     5cc:	a02d                	j	5f6 <parseredirs+0x5e>
      panic("missing file for redirection");
     5ce:	00001517          	auipc	a0,0x1
     5d2:	dca50513          	addi	a0,a0,-566 # 1398 <malloc+0x150>
     5d6:	00000097          	auipc	ra,0x0
     5da:	a80080e7          	jalr	-1408(ra) # 56 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5de:	4701                	li	a4,0
     5e0:	4681                	li	a3,0
     5e2:	f9043603          	ld	a2,-112(s0)
     5e6:	f9843583          	ld	a1,-104(s0)
     5ea:	8552                	mv	a0,s4
     5ec:	00000097          	auipc	ra,0x0
     5f0:	cc4080e7          	jalr	-828(ra) # 2b0 <redircmd>
     5f4:	8a2a                	mv	s4,a0
    switch(tok){
     5f6:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     5fa:	865a                	mv	a2,s6
     5fc:	85ca                	mv	a1,s2
     5fe:	854e                	mv	a0,s3
     600:	00000097          	auipc	ra,0x0
     604:	f2c080e7          	jalr	-212(ra) # 52c <peek>
     608:	c935                	beqz	a0,67c <parseredirs+0xe4>
    tok = gettoken(ps, es, 0, 0);
     60a:	4681                	li	a3,0
     60c:	4601                	li	a2,0
     60e:	85ca                	mv	a1,s2
     610:	854e                	mv	a0,s3
     612:	00000097          	auipc	ra,0x0
     616:	dce080e7          	jalr	-562(ra) # 3e0 <gettoken>
     61a:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     61c:	86e6                	mv	a3,s9
     61e:	8662                	mv	a2,s8
     620:	85ca                	mv	a1,s2
     622:	854e                	mv	a0,s3
     624:	00000097          	auipc	ra,0x0
     628:	dbc080e7          	jalr	-580(ra) # 3e0 <gettoken>
     62c:	fb7511e3          	bne	a0,s7,5ce <parseredirs+0x36>
    switch(tok){
     630:	fb5487e3          	beq	s1,s5,5de <parseredirs+0x46>
     634:	03e00793          	li	a5,62
     638:	02f48463          	beq	s1,a5,660 <parseredirs+0xc8>
     63c:	02b00793          	li	a5,43
     640:	faf49de3          	bne	s1,a5,5fa <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     644:	4705                	li	a4,1
     646:	20100693          	li	a3,513
     64a:	f9043603          	ld	a2,-112(s0)
     64e:	f9843583          	ld	a1,-104(s0)
     652:	8552                	mv	a0,s4
     654:	00000097          	auipc	ra,0x0
     658:	c5c080e7          	jalr	-932(ra) # 2b0 <redircmd>
     65c:	8a2a                	mv	s4,a0
      break;
     65e:	bf61                	j	5f6 <parseredirs+0x5e>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     660:	4705                	li	a4,1
     662:	60100693          	li	a3,1537
     666:	f9043603          	ld	a2,-112(s0)
     66a:	f9843583          	ld	a1,-104(s0)
     66e:	8552                	mv	a0,s4
     670:	00000097          	auipc	ra,0x0
     674:	c40080e7          	jalr	-960(ra) # 2b0 <redircmd>
     678:	8a2a                	mv	s4,a0
      break;
     67a:	bfb5                	j	5f6 <parseredirs+0x5e>
    }
  }
  return cmd;
}
     67c:	8552                	mv	a0,s4
     67e:	70a6                	ld	ra,104(sp)
     680:	7406                	ld	s0,96(sp)
     682:	64e6                	ld	s1,88(sp)
     684:	6946                	ld	s2,80(sp)
     686:	69a6                	ld	s3,72(sp)
     688:	6a06                	ld	s4,64(sp)
     68a:	7ae2                	ld	s5,56(sp)
     68c:	7b42                	ld	s6,48(sp)
     68e:	7ba2                	ld	s7,40(sp)
     690:	7c02                	ld	s8,32(sp)
     692:	6ce2                	ld	s9,24(sp)
     694:	6165                	addi	sp,sp,112
     696:	8082                	ret

0000000000000698 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     698:	7119                	addi	sp,sp,-128
     69a:	fc86                	sd	ra,120(sp)
     69c:	f8a2                	sd	s0,112(sp)
     69e:	f4a6                	sd	s1,104(sp)
     6a0:	e8d2                	sd	s4,80(sp)
     6a2:	e4d6                	sd	s5,72(sp)
     6a4:	0100                	addi	s0,sp,128
     6a6:	8a2a                	mv	s4,a0
     6a8:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6aa:	00001617          	auipc	a2,0x1
     6ae:	d1660613          	addi	a2,a2,-746 # 13c0 <malloc+0x178>
     6b2:	00000097          	auipc	ra,0x0
     6b6:	e7a080e7          	jalr	-390(ra) # 52c <peek>
     6ba:	e521                	bnez	a0,702 <parseexec+0x6a>
     6bc:	f0ca                	sd	s2,96(sp)
     6be:	ecce                	sd	s3,88(sp)
     6c0:	e0da                	sd	s6,64(sp)
     6c2:	fc5e                	sd	s7,56(sp)
     6c4:	f862                	sd	s8,48(sp)
     6c6:	f466                	sd	s9,40(sp)
     6c8:	f06a                	sd	s10,32(sp)
     6ca:	ec6e                	sd	s11,24(sp)
     6cc:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6ce:	00000097          	auipc	ra,0x0
     6d2:	bac080e7          	jalr	-1108(ra) # 27a <execcmd>
     6d6:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6d8:	8656                	mv	a2,s5
     6da:	85d2                	mv	a1,s4
     6dc:	00000097          	auipc	ra,0x0
     6e0:	ebc080e7          	jalr	-324(ra) # 598 <parseredirs>
     6e4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6e6:	008d8913          	addi	s2,s11,8
     6ea:	00001b17          	auipc	s6,0x1
     6ee:	cf6b0b13          	addi	s6,s6,-778 # 13e0 <malloc+0x198>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     6f2:	f8040c13          	addi	s8,s0,-128
     6f6:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     6fa:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6fe:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     700:	a081                	j	740 <parseexec+0xa8>
    return parseblock(ps, es);
     702:	85d6                	mv	a1,s5
     704:	8552                	mv	a0,s4
     706:	00000097          	auipc	ra,0x0
     70a:	1bc080e7          	jalr	444(ra) # 8c2 <parseblock>
     70e:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     710:	8526                	mv	a0,s1
     712:	70e6                	ld	ra,120(sp)
     714:	7446                	ld	s0,112(sp)
     716:	74a6                	ld	s1,104(sp)
     718:	6a46                	ld	s4,80(sp)
     71a:	6aa6                	ld	s5,72(sp)
     71c:	6109                	addi	sp,sp,128
     71e:	8082                	ret
      panic("syntax");
     720:	00001517          	auipc	a0,0x1
     724:	ca850513          	addi	a0,a0,-856 # 13c8 <malloc+0x180>
     728:	00000097          	auipc	ra,0x0
     72c:	92e080e7          	jalr	-1746(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     730:	8656                	mv	a2,s5
     732:	85d2                	mv	a1,s4
     734:	8526                	mv	a0,s1
     736:	00000097          	auipc	ra,0x0
     73a:	e62080e7          	jalr	-414(ra) # 598 <parseredirs>
     73e:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     740:	865a                	mv	a2,s6
     742:	85d6                	mv	a1,s5
     744:	8552                	mv	a0,s4
     746:	00000097          	auipc	ra,0x0
     74a:	de6080e7          	jalr	-538(ra) # 52c <peek>
     74e:	e121                	bnez	a0,78e <parseexec+0xf6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     750:	86e2                	mv	a3,s8
     752:	865e                	mv	a2,s7
     754:	85d6                	mv	a1,s5
     756:	8552                	mv	a0,s4
     758:	00000097          	auipc	ra,0x0
     75c:	c88080e7          	jalr	-888(ra) # 3e0 <gettoken>
     760:	c51d                	beqz	a0,78e <parseexec+0xf6>
    if(tok != 'a')
     762:	fba51fe3          	bne	a0,s10,720 <parseexec+0x88>
    cmd->argv[argc] = q;
     766:	f8843783          	ld	a5,-120(s0)
     76a:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     76e:	f8043783          	ld	a5,-128(s0)
     772:	04f93823          	sd	a5,80(s2)
    argc++;
     776:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     778:	0921                	addi	s2,s2,8
     77a:	fb999be3          	bne	s3,s9,730 <parseexec+0x98>
      panic("too many args");
     77e:	00001517          	auipc	a0,0x1
     782:	c5250513          	addi	a0,a0,-942 # 13d0 <malloc+0x188>
     786:	00000097          	auipc	ra,0x0
     78a:	8d0080e7          	jalr	-1840(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     78e:	098e                	slli	s3,s3,0x3
     790:	9dce                	add	s11,s11,s3
     792:	000db423          	sd	zero,8(s11)
  cmd->eargv[argc] = 0;
     796:	040dbc23          	sd	zero,88(s11)
     79a:	7906                	ld	s2,96(sp)
     79c:	69e6                	ld	s3,88(sp)
     79e:	6b06                	ld	s6,64(sp)
     7a0:	7be2                	ld	s7,56(sp)
     7a2:	7c42                	ld	s8,48(sp)
     7a4:	7ca2                	ld	s9,40(sp)
     7a6:	7d02                	ld	s10,32(sp)
     7a8:	6de2                	ld	s11,24(sp)
  return ret;
     7aa:	b79d                	j	710 <parseexec+0x78>

00000000000007ac <parsepipe>:
{
     7ac:	7179                	addi	sp,sp,-48
     7ae:	f406                	sd	ra,40(sp)
     7b0:	f022                	sd	s0,32(sp)
     7b2:	ec26                	sd	s1,24(sp)
     7b4:	e84a                	sd	s2,16(sp)
     7b6:	e44e                	sd	s3,8(sp)
     7b8:	1800                	addi	s0,sp,48
     7ba:	892a                	mv	s2,a0
     7bc:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7be:	00000097          	auipc	ra,0x0
     7c2:	eda080e7          	jalr	-294(ra) # 698 <parseexec>
     7c6:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7c8:	00001617          	auipc	a2,0x1
     7cc:	c2060613          	addi	a2,a2,-992 # 13e8 <malloc+0x1a0>
     7d0:	85ce                	mv	a1,s3
     7d2:	854a                	mv	a0,s2
     7d4:	00000097          	auipc	ra,0x0
     7d8:	d58080e7          	jalr	-680(ra) # 52c <peek>
     7dc:	e909                	bnez	a0,7ee <parsepipe+0x42>
}
     7de:	8526                	mv	a0,s1
     7e0:	70a2                	ld	ra,40(sp)
     7e2:	7402                	ld	s0,32(sp)
     7e4:	64e2                	ld	s1,24(sp)
     7e6:	6942                	ld	s2,16(sp)
     7e8:	69a2                	ld	s3,8(sp)
     7ea:	6145                	addi	sp,sp,48
     7ec:	8082                	ret
    gettoken(ps, es, 0, 0);
     7ee:	4681                	li	a3,0
     7f0:	4601                	li	a2,0
     7f2:	85ce                	mv	a1,s3
     7f4:	854a                	mv	a0,s2
     7f6:	00000097          	auipc	ra,0x0
     7fa:	bea080e7          	jalr	-1046(ra) # 3e0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7fe:	85ce                	mv	a1,s3
     800:	854a                	mv	a0,s2
     802:	00000097          	auipc	ra,0x0
     806:	faa080e7          	jalr	-86(ra) # 7ac <parsepipe>
     80a:	85aa                	mv	a1,a0
     80c:	8526                	mv	a0,s1
     80e:	00000097          	auipc	ra,0x0
     812:	b0a080e7          	jalr	-1270(ra) # 318 <pipecmd>
     816:	84aa                	mv	s1,a0
  return cmd;
     818:	b7d9                	j	7de <parsepipe+0x32>

000000000000081a <parseline>:
{
     81a:	7179                	addi	sp,sp,-48
     81c:	f406                	sd	ra,40(sp)
     81e:	f022                	sd	s0,32(sp)
     820:	ec26                	sd	s1,24(sp)
     822:	e84a                	sd	s2,16(sp)
     824:	e44e                	sd	s3,8(sp)
     826:	e052                	sd	s4,0(sp)
     828:	1800                	addi	s0,sp,48
     82a:	892a                	mv	s2,a0
     82c:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     82e:	00000097          	auipc	ra,0x0
     832:	f7e080e7          	jalr	-130(ra) # 7ac <parsepipe>
     836:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     838:	00001a17          	auipc	s4,0x1
     83c:	bb8a0a13          	addi	s4,s4,-1096 # 13f0 <malloc+0x1a8>
     840:	a839                	j	85e <parseline+0x44>
    gettoken(ps, es, 0, 0);
     842:	4681                	li	a3,0
     844:	4601                	li	a2,0
     846:	85ce                	mv	a1,s3
     848:	854a                	mv	a0,s2
     84a:	00000097          	auipc	ra,0x0
     84e:	b96080e7          	jalr	-1130(ra) # 3e0 <gettoken>
    cmd = backcmd(cmd);
     852:	8526                	mv	a0,s1
     854:	00000097          	auipc	ra,0x0
     858:	b50080e7          	jalr	-1200(ra) # 3a4 <backcmd>
     85c:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     85e:	8652                	mv	a2,s4
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00000097          	auipc	ra,0x0
     868:	cc8080e7          	jalr	-824(ra) # 52c <peek>
     86c:	f979                	bnez	a0,842 <parseline+0x28>
  if(peek(ps, es, ";")){
     86e:	00001617          	auipc	a2,0x1
     872:	b8a60613          	addi	a2,a2,-1142 # 13f8 <malloc+0x1b0>
     876:	85ce                	mv	a1,s3
     878:	854a                	mv	a0,s2
     87a:	00000097          	auipc	ra,0x0
     87e:	cb2080e7          	jalr	-846(ra) # 52c <peek>
     882:	e911                	bnez	a0,896 <parseline+0x7c>
}
     884:	8526                	mv	a0,s1
     886:	70a2                	ld	ra,40(sp)
     888:	7402                	ld	s0,32(sp)
     88a:	64e2                	ld	s1,24(sp)
     88c:	6942                	ld	s2,16(sp)
     88e:	69a2                	ld	s3,8(sp)
     890:	6a02                	ld	s4,0(sp)
     892:	6145                	addi	sp,sp,48
     894:	8082                	ret
    gettoken(ps, es, 0, 0);
     896:	4681                	li	a3,0
     898:	4601                	li	a2,0
     89a:	85ce                	mv	a1,s3
     89c:	854a                	mv	a0,s2
     89e:	00000097          	auipc	ra,0x0
     8a2:	b42080e7          	jalr	-1214(ra) # 3e0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8a6:	85ce                	mv	a1,s3
     8a8:	854a                	mv	a0,s2
     8aa:	00000097          	auipc	ra,0x0
     8ae:	f70080e7          	jalr	-144(ra) # 81a <parseline>
     8b2:	85aa                	mv	a1,a0
     8b4:	8526                	mv	a0,s1
     8b6:	00000097          	auipc	ra,0x0
     8ba:	aa8080e7          	jalr	-1368(ra) # 35e <listcmd>
     8be:	84aa                	mv	s1,a0
  return cmd;
     8c0:	b7d1                	j	884 <parseline+0x6a>

00000000000008c2 <parseblock>:
{
     8c2:	7179                	addi	sp,sp,-48
     8c4:	f406                	sd	ra,40(sp)
     8c6:	f022                	sd	s0,32(sp)
     8c8:	ec26                	sd	s1,24(sp)
     8ca:	e84a                	sd	s2,16(sp)
     8cc:	e44e                	sd	s3,8(sp)
     8ce:	1800                	addi	s0,sp,48
     8d0:	84aa                	mv	s1,a0
     8d2:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8d4:	00001617          	auipc	a2,0x1
     8d8:	aec60613          	addi	a2,a2,-1300 # 13c0 <malloc+0x178>
     8dc:	00000097          	auipc	ra,0x0
     8e0:	c50080e7          	jalr	-944(ra) # 52c <peek>
     8e4:	c12d                	beqz	a0,946 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8e6:	4681                	li	a3,0
     8e8:	4601                	li	a2,0
     8ea:	85ca                	mv	a1,s2
     8ec:	8526                	mv	a0,s1
     8ee:	00000097          	auipc	ra,0x0
     8f2:	af2080e7          	jalr	-1294(ra) # 3e0 <gettoken>
  cmd = parseline(ps, es);
     8f6:	85ca                	mv	a1,s2
     8f8:	8526                	mv	a0,s1
     8fa:	00000097          	auipc	ra,0x0
     8fe:	f20080e7          	jalr	-224(ra) # 81a <parseline>
     902:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     904:	00001617          	auipc	a2,0x1
     908:	b0c60613          	addi	a2,a2,-1268 # 1410 <malloc+0x1c8>
     90c:	85ca                	mv	a1,s2
     90e:	8526                	mv	a0,s1
     910:	00000097          	auipc	ra,0x0
     914:	c1c080e7          	jalr	-996(ra) # 52c <peek>
     918:	cd1d                	beqz	a0,956 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     91a:	4681                	li	a3,0
     91c:	4601                	li	a2,0
     91e:	85ca                	mv	a1,s2
     920:	8526                	mv	a0,s1
     922:	00000097          	auipc	ra,0x0
     926:	abe080e7          	jalr	-1346(ra) # 3e0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     92a:	864a                	mv	a2,s2
     92c:	85a6                	mv	a1,s1
     92e:	854e                	mv	a0,s3
     930:	00000097          	auipc	ra,0x0
     934:	c68080e7          	jalr	-920(ra) # 598 <parseredirs>
}
     938:	70a2                	ld	ra,40(sp)
     93a:	7402                	ld	s0,32(sp)
     93c:	64e2                	ld	s1,24(sp)
     93e:	6942                	ld	s2,16(sp)
     940:	69a2                	ld	s3,8(sp)
     942:	6145                	addi	sp,sp,48
     944:	8082                	ret
    panic("parseblock");
     946:	00001517          	auipc	a0,0x1
     94a:	aba50513          	addi	a0,a0,-1350 # 1400 <malloc+0x1b8>
     94e:	fffff097          	auipc	ra,0xfffff
     952:	708080e7          	jalr	1800(ra) # 56 <panic>
    panic("syntax - missing )");
     956:	00001517          	auipc	a0,0x1
     95a:	ac250513          	addi	a0,a0,-1342 # 1418 <malloc+0x1d0>
     95e:	fffff097          	auipc	ra,0xfffff
     962:	6f8080e7          	jalr	1784(ra) # 56 <panic>

0000000000000966 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     966:	1101                	addi	sp,sp,-32
     968:	ec06                	sd	ra,24(sp)
     96a:	e822                	sd	s0,16(sp)
     96c:	e426                	sd	s1,8(sp)
     96e:	1000                	addi	s0,sp,32
     970:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     972:	c521                	beqz	a0,9ba <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     974:	4118                	lw	a4,0(a0)
     976:	4795                	li	a5,5
     978:	04e7e163          	bltu	a5,a4,9ba <nulterminate+0x54>
     97c:	00056783          	lwu	a5,0(a0)
     980:	078a                	slli	a5,a5,0x2
     982:	00001717          	auipc	a4,0x1
     986:	af670713          	addi	a4,a4,-1290 # 1478 <malloc+0x230>
     98a:	97ba                	add	a5,a5,a4
     98c:	439c                	lw	a5,0(a5)
     98e:	97ba                	add	a5,a5,a4
     990:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     992:	651c                	ld	a5,8(a0)
     994:	c39d                	beqz	a5,9ba <nulterminate+0x54>
     996:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     99a:	67b8                	ld	a4,72(a5)
     99c:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     9a0:	07a1                	addi	a5,a5,8
     9a2:	ff87b703          	ld	a4,-8(a5)
     9a6:	fb75                	bnez	a4,99a <nulterminate+0x34>
     9a8:	a809                	j	9ba <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     9aa:	6508                	ld	a0,8(a0)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	fba080e7          	jalr	-70(ra) # 966 <nulterminate>
    *rcmd->efile = 0;
     9b4:	6c9c                	ld	a5,24(s1)
     9b6:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9ba:	8526                	mv	a0,s1
     9bc:	60e2                	ld	ra,24(sp)
     9be:	6442                	ld	s0,16(sp)
     9c0:	64a2                	ld	s1,8(sp)
     9c2:	6105                	addi	sp,sp,32
     9c4:	8082                	ret
    nulterminate(pcmd->left);
     9c6:	6508                	ld	a0,8(a0)
     9c8:	00000097          	auipc	ra,0x0
     9cc:	f9e080e7          	jalr	-98(ra) # 966 <nulterminate>
    nulterminate(pcmd->right);
     9d0:	6888                	ld	a0,16(s1)
     9d2:	00000097          	auipc	ra,0x0
     9d6:	f94080e7          	jalr	-108(ra) # 966 <nulterminate>
    break;
     9da:	b7c5                	j	9ba <nulterminate+0x54>
    nulterminate(lcmd->left);
     9dc:	6508                	ld	a0,8(a0)
     9de:	00000097          	auipc	ra,0x0
     9e2:	f88080e7          	jalr	-120(ra) # 966 <nulterminate>
    nulterminate(lcmd->right);
     9e6:	6888                	ld	a0,16(s1)
     9e8:	00000097          	auipc	ra,0x0
     9ec:	f7e080e7          	jalr	-130(ra) # 966 <nulterminate>
    break;
     9f0:	b7e9                	j	9ba <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9f2:	6508                	ld	a0,8(a0)
     9f4:	00000097          	auipc	ra,0x0
     9f8:	f72080e7          	jalr	-142(ra) # 966 <nulterminate>
    break;
     9fc:	bf7d                	j	9ba <nulterminate+0x54>

00000000000009fe <parsecmd>:
{
     9fe:	7139                	addi	sp,sp,-64
     a00:	fc06                	sd	ra,56(sp)
     a02:	f822                	sd	s0,48(sp)
     a04:	f426                	sd	s1,40(sp)
     a06:	f04a                	sd	s2,32(sp)
     a08:	ec4e                	sd	s3,24(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     a10:	84aa                	mv	s1,a0
     a12:	00000097          	auipc	ra,0x0
     a16:	1c4080e7          	jalr	452(ra) # bd6 <strlen>
     a1a:	1502                	slli	a0,a0,0x20
     a1c:	9101                	srli	a0,a0,0x20
     a1e:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a20:	fc840993          	addi	s3,s0,-56
     a24:	85a6                	mv	a1,s1
     a26:	854e                	mv	a0,s3
     a28:	00000097          	auipc	ra,0x0
     a2c:	df2080e7          	jalr	-526(ra) # 81a <parseline>
     a30:	892a                	mv	s2,a0
  peek(&s, es, "");
     a32:	00001617          	auipc	a2,0x1
     a36:	91e60613          	addi	a2,a2,-1762 # 1350 <malloc+0x108>
     a3a:	85a6                	mv	a1,s1
     a3c:	854e                	mv	a0,s3
     a3e:	00000097          	auipc	ra,0x0
     a42:	aee080e7          	jalr	-1298(ra) # 52c <peek>
  if(s != es){
     a46:	fc843603          	ld	a2,-56(s0)
     a4a:	00961f63          	bne	a2,s1,a68 <parsecmd+0x6a>
  nulterminate(cmd);
     a4e:	854a                	mv	a0,s2
     a50:	00000097          	auipc	ra,0x0
     a54:	f16080e7          	jalr	-234(ra) # 966 <nulterminate>
}
     a58:	854a                	mv	a0,s2
     a5a:	70e2                	ld	ra,56(sp)
     a5c:	7442                	ld	s0,48(sp)
     a5e:	74a2                	ld	s1,40(sp)
     a60:	7902                	ld	s2,32(sp)
     a62:	69e2                	ld	s3,24(sp)
     a64:	6121                	addi	sp,sp,64
     a66:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a68:	00001597          	auipc	a1,0x1
     a6c:	9c858593          	addi	a1,a1,-1592 # 1430 <malloc+0x1e8>
     a70:	4509                	li	a0,2
     a72:	00000097          	auipc	ra,0x0
     a76:	6ec080e7          	jalr	1772(ra) # 115e <fprintf>
    panic("syntax");
     a7a:	00001517          	auipc	a0,0x1
     a7e:	94e50513          	addi	a0,a0,-1714 # 13c8 <malloc+0x180>
     a82:	fffff097          	auipc	ra,0xfffff
     a86:	5d4080e7          	jalr	1492(ra) # 56 <panic>

0000000000000a8a <main>:
{
     a8a:	7139                	addi	sp,sp,-64
     a8c:	fc06                	sd	ra,56(sp)
     a8e:	f822                	sd	s0,48(sp)
     a90:	f426                	sd	s1,40(sp)
     a92:	f04a                	sd	s2,32(sp)
     a94:	ec4e                	sd	s3,24(sp)
     a96:	e852                	sd	s4,16(sp)
     a98:	e456                	sd	s5,8(sp)
     a9a:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a9c:	4489                	li	s1,2
     a9e:	00001917          	auipc	s2,0x1
     aa2:	9a290913          	addi	s2,s2,-1630 # 1440 <malloc+0x1f8>
     aa6:	85a6                	mv	a1,s1
     aa8:	854a                	mv	a0,s2
     aaa:	00000097          	auipc	ra,0x0
     aae:	3bc080e7          	jalr	956(ra) # e66 <open>
     ab2:	00054863          	bltz	a0,ac2 <main+0x38>
    if(fd >= 3){
     ab6:	fea4d8e3          	bge	s1,a0,aa6 <main+0x1c>
      close(fd);
     aba:	00000097          	auipc	ra,0x0
     abe:	394080e7          	jalr	916(ra) # e4e <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ac2:	00001497          	auipc	s1,0x1
     ac6:	a5648493          	addi	s1,s1,-1450 # 1518 <buf.0>
     aca:	06400913          	li	s2,100
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ace:	06300993          	li	s3,99
     ad2:	02000a13          	li	s4,32
     ad6:	a819                	j	aec <main+0x62>
    if(fork1() == 0)
     ad8:	fffff097          	auipc	ra,0xfffff
     adc:	5a4080e7          	jalr	1444(ra) # 7c <fork1>
     ae0:	c151                	beqz	a0,b64 <main+0xda>
    wait(0);
     ae2:	4501                	li	a0,0
     ae4:	00000097          	auipc	ra,0x0
     ae8:	34a080e7          	jalr	842(ra) # e2e <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aec:	85ca                	mv	a1,s2
     aee:	8526                	mv	a0,s1
     af0:	fffff097          	auipc	ra,0xfffff
     af4:	510080e7          	jalr	1296(ra) # 0 <getcmd>
     af8:	08054263          	bltz	a0,b7c <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     afc:	0004c783          	lbu	a5,0(s1)
     b00:	fd379ce3          	bne	a5,s3,ad8 <main+0x4e>
     b04:	0014c783          	lbu	a5,1(s1)
     b08:	fd2798e3          	bne	a5,s2,ad8 <main+0x4e>
     b0c:	0024c783          	lbu	a5,2(s1)
     b10:	fd4794e3          	bne	a5,s4,ad8 <main+0x4e>
      buf[strlen(buf)-1] = 0;  // chop \n
     b14:	00001a97          	auipc	s5,0x1
     b18:	a04a8a93          	addi	s5,s5,-1532 # 1518 <buf.0>
     b1c:	8556                	mv	a0,s5
     b1e:	00000097          	auipc	ra,0x0
     b22:	0b8080e7          	jalr	184(ra) # bd6 <strlen>
     b26:	fff5079b          	addiw	a5,a0,-1
     b2a:	1782                	slli	a5,a5,0x20
     b2c:	9381                	srli	a5,a5,0x20
     b2e:	9abe                	add	s5,s5,a5
     b30:	000a8023          	sb	zero,0(s5)
      if(chdir(buf+3) < 0)
     b34:	00001517          	auipc	a0,0x1
     b38:	9e750513          	addi	a0,a0,-1561 # 151b <buf.0+0x3>
     b3c:	00000097          	auipc	ra,0x0
     b40:	35a080e7          	jalr	858(ra) # e96 <chdir>
     b44:	fa0554e3          	bgez	a0,aec <main+0x62>
        fprintf(2, "cannot cd %s\n", buf+3);
     b48:	00001617          	auipc	a2,0x1
     b4c:	9d360613          	addi	a2,a2,-1581 # 151b <buf.0+0x3>
     b50:	00001597          	auipc	a1,0x1
     b54:	8f858593          	addi	a1,a1,-1800 # 1448 <malloc+0x200>
     b58:	4509                	li	a0,2
     b5a:	00000097          	auipc	ra,0x0
     b5e:	604080e7          	jalr	1540(ra) # 115e <fprintf>
     b62:	b769                	j	aec <main+0x62>
      runcmd(parsecmd(buf));
     b64:	00001517          	auipc	a0,0x1
     b68:	9b450513          	addi	a0,a0,-1612 # 1518 <buf.0>
     b6c:	00000097          	auipc	ra,0x0
     b70:	e92080e7          	jalr	-366(ra) # 9fe <parsecmd>
     b74:	fffff097          	auipc	ra,0xfffff
     b78:	536080e7          	jalr	1334(ra) # aa <runcmd>
  exit(0);
     b7c:	4501                	li	a0,0
     b7e:	00000097          	auipc	ra,0x0
     b82:	2a8080e7          	jalr	680(ra) # e26 <exit>

0000000000000b86 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b86:	1141                	addi	sp,sp,-16
     b88:	e406                	sd	ra,8(sp)
     b8a:	e022                	sd	s0,0(sp)
     b8c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b8e:	87aa                	mv	a5,a0
     b90:	0585                	addi	a1,a1,1
     b92:	0785                	addi	a5,a5,1
     b94:	fff5c703          	lbu	a4,-1(a1)
     b98:	fee78fa3          	sb	a4,-1(a5)
     b9c:	fb75                	bnez	a4,b90 <strcpy+0xa>
    ;
  return os;
}
     b9e:	60a2                	ld	ra,8(sp)
     ba0:	6402                	ld	s0,0(sp)
     ba2:	0141                	addi	sp,sp,16
     ba4:	8082                	ret

0000000000000ba6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba6:	1141                	addi	sp,sp,-16
     ba8:	e406                	sd	ra,8(sp)
     baa:	e022                	sd	s0,0(sp)
     bac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bae:	00054783          	lbu	a5,0(a0)
     bb2:	cb91                	beqz	a5,bc6 <strcmp+0x20>
     bb4:	0005c703          	lbu	a4,0(a1)
     bb8:	00f71763          	bne	a4,a5,bc6 <strcmp+0x20>
    p++, q++;
     bbc:	0505                	addi	a0,a0,1
     bbe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	fbe5                	bnez	a5,bb4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     bc6:	0005c503          	lbu	a0,0(a1)
}
     bca:	40a7853b          	subw	a0,a5,a0
     bce:	60a2                	ld	ra,8(sp)
     bd0:	6402                	ld	s0,0(sp)
     bd2:	0141                	addi	sp,sp,16
     bd4:	8082                	ret

0000000000000bd6 <strlen>:

uint
strlen(const char *s)
{
     bd6:	1141                	addi	sp,sp,-16
     bd8:	e406                	sd	ra,8(sp)
     bda:	e022                	sd	s0,0(sp)
     bdc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bde:	00054783          	lbu	a5,0(a0)
     be2:	cf99                	beqz	a5,c00 <strlen+0x2a>
     be4:	0505                	addi	a0,a0,1
     be6:	87aa                	mv	a5,a0
     be8:	86be                	mv	a3,a5
     bea:	0785                	addi	a5,a5,1
     bec:	fff7c703          	lbu	a4,-1(a5)
     bf0:	ff65                	bnez	a4,be8 <strlen+0x12>
     bf2:	40a6853b          	subw	a0,a3,a0
     bf6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     bf8:	60a2                	ld	ra,8(sp)
     bfa:	6402                	ld	s0,0(sp)
     bfc:	0141                	addi	sp,sp,16
     bfe:	8082                	ret
  for(n = 0; s[n]; n++)
     c00:	4501                	li	a0,0
     c02:	bfdd                	j	bf8 <strlen+0x22>

0000000000000c04 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c04:	1141                	addi	sp,sp,-16
     c06:	e406                	sd	ra,8(sp)
     c08:	e022                	sd	s0,0(sp)
     c0a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c0c:	ca19                	beqz	a2,c22 <memset+0x1e>
     c0e:	87aa                	mv	a5,a0
     c10:	1602                	slli	a2,a2,0x20
     c12:	9201                	srli	a2,a2,0x20
     c14:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c18:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c1c:	0785                	addi	a5,a5,1
     c1e:	fee79de3          	bne	a5,a4,c18 <memset+0x14>
  }
  return dst;
}
     c22:	60a2                	ld	ra,8(sp)
     c24:	6402                	ld	s0,0(sp)
     c26:	0141                	addi	sp,sp,16
     c28:	8082                	ret

0000000000000c2a <strchr>:

char*
strchr(const char *s, char c)
{
     c2a:	1141                	addi	sp,sp,-16
     c2c:	e406                	sd	ra,8(sp)
     c2e:	e022                	sd	s0,0(sp)
     c30:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c32:	00054783          	lbu	a5,0(a0)
     c36:	cf81                	beqz	a5,c4e <strchr+0x24>
    if(*s == c)
     c38:	00f58763          	beq	a1,a5,c46 <strchr+0x1c>
  for(; *s; s++)
     c3c:	0505                	addi	a0,a0,1
     c3e:	00054783          	lbu	a5,0(a0)
     c42:	fbfd                	bnez	a5,c38 <strchr+0xe>
      return (char*)s;
  return 0;
     c44:	4501                	li	a0,0
}
     c46:	60a2                	ld	ra,8(sp)
     c48:	6402                	ld	s0,0(sp)
     c4a:	0141                	addi	sp,sp,16
     c4c:	8082                	ret
  return 0;
     c4e:	4501                	li	a0,0
     c50:	bfdd                	j	c46 <strchr+0x1c>

0000000000000c52 <gets>:

char*
gets(char *buf, int max)
{
     c52:	7159                	addi	sp,sp,-112
     c54:	f486                	sd	ra,104(sp)
     c56:	f0a2                	sd	s0,96(sp)
     c58:	eca6                	sd	s1,88(sp)
     c5a:	e8ca                	sd	s2,80(sp)
     c5c:	e4ce                	sd	s3,72(sp)
     c5e:	e0d2                	sd	s4,64(sp)
     c60:	fc56                	sd	s5,56(sp)
     c62:	f85a                	sd	s6,48(sp)
     c64:	f45e                	sd	s7,40(sp)
     c66:	f062                	sd	s8,32(sp)
     c68:	ec66                	sd	s9,24(sp)
     c6a:	e86a                	sd	s10,16(sp)
     c6c:	1880                	addi	s0,sp,112
     c6e:	8caa                	mv	s9,a0
     c70:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c72:	892a                	mv	s2,a0
     c74:	4481                	li	s1,0
    cc = read(0, &c, 1);
     c76:	f9f40b13          	addi	s6,s0,-97
     c7a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c7c:	4ba9                	li	s7,10
     c7e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     c80:	8d26                	mv	s10,s1
     c82:	0014899b          	addiw	s3,s1,1
     c86:	84ce                	mv	s1,s3
     c88:	0349d763          	bge	s3,s4,cb6 <gets+0x64>
    cc = read(0, &c, 1);
     c8c:	8656                	mv	a2,s5
     c8e:	85da                	mv	a1,s6
     c90:	4501                	li	a0,0
     c92:	00000097          	auipc	ra,0x0
     c96:	1ac080e7          	jalr	428(ra) # e3e <read>
    if(cc < 1)
     c9a:	00a05e63          	blez	a0,cb6 <gets+0x64>
    buf[i++] = c;
     c9e:	f9f44783          	lbu	a5,-97(s0)
     ca2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ca6:	01778763          	beq	a5,s7,cb4 <gets+0x62>
     caa:	0905                	addi	s2,s2,1
     cac:	fd879ae3          	bne	a5,s8,c80 <gets+0x2e>
    buf[i++] = c;
     cb0:	8d4e                	mv	s10,s3
     cb2:	a011                	j	cb6 <gets+0x64>
     cb4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     cb6:	9d66                	add	s10,s10,s9
     cb8:	000d0023          	sb	zero,0(s10)
  return buf;
}
     cbc:	8566                	mv	a0,s9
     cbe:	70a6                	ld	ra,104(sp)
     cc0:	7406                	ld	s0,96(sp)
     cc2:	64e6                	ld	s1,88(sp)
     cc4:	6946                	ld	s2,80(sp)
     cc6:	69a6                	ld	s3,72(sp)
     cc8:	6a06                	ld	s4,64(sp)
     cca:	7ae2                	ld	s5,56(sp)
     ccc:	7b42                	ld	s6,48(sp)
     cce:	7ba2                	ld	s7,40(sp)
     cd0:	7c02                	ld	s8,32(sp)
     cd2:	6ce2                	ld	s9,24(sp)
     cd4:	6d42                	ld	s10,16(sp)
     cd6:	6165                	addi	sp,sp,112
     cd8:	8082                	ret

0000000000000cda <stat>:

int
stat(const char *n, struct stat *st)
{
     cda:	1101                	addi	sp,sp,-32
     cdc:	ec06                	sd	ra,24(sp)
     cde:	e822                	sd	s0,16(sp)
     ce0:	e04a                	sd	s2,0(sp)
     ce2:	1000                	addi	s0,sp,32
     ce4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ce6:	4581                	li	a1,0
     ce8:	00000097          	auipc	ra,0x0
     cec:	17e080e7          	jalr	382(ra) # e66 <open>
  if(fd < 0)
     cf0:	02054663          	bltz	a0,d1c <stat+0x42>
     cf4:	e426                	sd	s1,8(sp)
     cf6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cf8:	85ca                	mv	a1,s2
     cfa:	00000097          	auipc	ra,0x0
     cfe:	184080e7          	jalr	388(ra) # e7e <fstat>
     d02:	892a                	mv	s2,a0
  close(fd);
     d04:	8526                	mv	a0,s1
     d06:	00000097          	auipc	ra,0x0
     d0a:	148080e7          	jalr	328(ra) # e4e <close>
  return r;
     d0e:	64a2                	ld	s1,8(sp)
}
     d10:	854a                	mv	a0,s2
     d12:	60e2                	ld	ra,24(sp)
     d14:	6442                	ld	s0,16(sp)
     d16:	6902                	ld	s2,0(sp)
     d18:	6105                	addi	sp,sp,32
     d1a:	8082                	ret
    return -1;
     d1c:	597d                	li	s2,-1
     d1e:	bfcd                	j	d10 <stat+0x36>

0000000000000d20 <atoi>:

int
atoi(const char *s)
{
     d20:	1141                	addi	sp,sp,-16
     d22:	e406                	sd	ra,8(sp)
     d24:	e022                	sd	s0,0(sp)
     d26:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d28:	00054683          	lbu	a3,0(a0)
     d2c:	fd06879b          	addiw	a5,a3,-48
     d30:	0ff7f793          	zext.b	a5,a5
     d34:	4625                	li	a2,9
     d36:	02f66963          	bltu	a2,a5,d68 <atoi+0x48>
     d3a:	872a                	mv	a4,a0
  n = 0;
     d3c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d3e:	0705                	addi	a4,a4,1
     d40:	0025179b          	slliw	a5,a0,0x2
     d44:	9fa9                	addw	a5,a5,a0
     d46:	0017979b          	slliw	a5,a5,0x1
     d4a:	9fb5                	addw	a5,a5,a3
     d4c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d50:	00074683          	lbu	a3,0(a4)
     d54:	fd06879b          	addiw	a5,a3,-48
     d58:	0ff7f793          	zext.b	a5,a5
     d5c:	fef671e3          	bgeu	a2,a5,d3e <atoi+0x1e>
  return n;
}
     d60:	60a2                	ld	ra,8(sp)
     d62:	6402                	ld	s0,0(sp)
     d64:	0141                	addi	sp,sp,16
     d66:	8082                	ret
  n = 0;
     d68:	4501                	li	a0,0
     d6a:	bfdd                	j	d60 <atoi+0x40>

0000000000000d6c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d6c:	1141                	addi	sp,sp,-16
     d6e:	e406                	sd	ra,8(sp)
     d70:	e022                	sd	s0,0(sp)
     d72:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d74:	02b57563          	bgeu	a0,a1,d9e <memmove+0x32>
    while(n-- > 0)
     d78:	00c05f63          	blez	a2,d96 <memmove+0x2a>
     d7c:	1602                	slli	a2,a2,0x20
     d7e:	9201                	srli	a2,a2,0x20
     d80:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d84:	872a                	mv	a4,a0
      *dst++ = *src++;
     d86:	0585                	addi	a1,a1,1
     d88:	0705                	addi	a4,a4,1
     d8a:	fff5c683          	lbu	a3,-1(a1)
     d8e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d92:	fee79ae3          	bne	a5,a4,d86 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d96:	60a2                	ld	ra,8(sp)
     d98:	6402                	ld	s0,0(sp)
     d9a:	0141                	addi	sp,sp,16
     d9c:	8082                	ret
    dst += n;
     d9e:	00c50733          	add	a4,a0,a2
    src += n;
     da2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     da4:	fec059e3          	blez	a2,d96 <memmove+0x2a>
     da8:	fff6079b          	addiw	a5,a2,-1
     dac:	1782                	slli	a5,a5,0x20
     dae:	9381                	srli	a5,a5,0x20
     db0:	fff7c793          	not	a5,a5
     db4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     db6:	15fd                	addi	a1,a1,-1
     db8:	177d                	addi	a4,a4,-1
     dba:	0005c683          	lbu	a3,0(a1)
     dbe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dc2:	fef71ae3          	bne	a4,a5,db6 <memmove+0x4a>
     dc6:	bfc1                	j	d96 <memmove+0x2a>

0000000000000dc8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dc8:	1141                	addi	sp,sp,-16
     dca:	e406                	sd	ra,8(sp)
     dcc:	e022                	sd	s0,0(sp)
     dce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dd0:	ca0d                	beqz	a2,e02 <memcmp+0x3a>
     dd2:	fff6069b          	addiw	a3,a2,-1
     dd6:	1682                	slli	a3,a3,0x20
     dd8:	9281                	srli	a3,a3,0x20
     dda:	0685                	addi	a3,a3,1
     ddc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dde:	00054783          	lbu	a5,0(a0)
     de2:	0005c703          	lbu	a4,0(a1)
     de6:	00e79863          	bne	a5,a4,df6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     dea:	0505                	addi	a0,a0,1
    p2++;
     dec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dee:	fed518e3          	bne	a0,a3,dde <memcmp+0x16>
  }
  return 0;
     df2:	4501                	li	a0,0
     df4:	a019                	j	dfa <memcmp+0x32>
      return *p1 - *p2;
     df6:	40e7853b          	subw	a0,a5,a4
}
     dfa:	60a2                	ld	ra,8(sp)
     dfc:	6402                	ld	s0,0(sp)
     dfe:	0141                	addi	sp,sp,16
     e00:	8082                	ret
  return 0;
     e02:	4501                	li	a0,0
     e04:	bfdd                	j	dfa <memcmp+0x32>

0000000000000e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e06:	1141                	addi	sp,sp,-16
     e08:	e406                	sd	ra,8(sp)
     e0a:	e022                	sd	s0,0(sp)
     e0c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e0e:	00000097          	auipc	ra,0x0
     e12:	f5e080e7          	jalr	-162(ra) # d6c <memmove>
}
     e16:	60a2                	ld	ra,8(sp)
     e18:	6402                	ld	s0,0(sp)
     e1a:	0141                	addi	sp,sp,16
     e1c:	8082                	ret

0000000000000e1e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e1e:	4885                	li	a7,1
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e26:	4889                	li	a7,2
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <wait>:
.global wait
wait:
 li a7, SYS_wait
     e2e:	488d                	li	a7,3
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e36:	4891                	li	a7,4
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <read>:
.global read
read:
 li a7, SYS_read
     e3e:	4895                	li	a7,5
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <write>:
.global write
write:
 li a7, SYS_write
     e46:	48c1                	li	a7,16
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <close>:
.global close
close:
 li a7, SYS_close
     e4e:	48d5                	li	a7,21
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e56:	4899                	li	a7,6
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e5e:	489d                	li	a7,7
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <open>:
.global open
open:
 li a7, SYS_open
     e66:	48bd                	li	a7,15
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e6e:	48c5                	li	a7,17
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e76:	48c9                	li	a7,18
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e7e:	48a1                	li	a7,8
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <link>:
.global link
link:
 li a7, SYS_link
     e86:	48cd                	li	a7,19
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e8e:	48d1                	li	a7,20
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e96:	48a5                	li	a7,9
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	8082                	ret

0000000000000e9e <dup>:
.global dup
dup:
 li a7, SYS_dup
     e9e:	48a9                	li	a7,10
 ecall
     ea0:	00000073          	ecall
 ret
     ea4:	8082                	ret

0000000000000ea6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ea6:	48ad                	li	a7,11
 ecall
     ea8:	00000073          	ecall
 ret
     eac:	8082                	ret

0000000000000eae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     eae:	48b1                	li	a7,12
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	8082                	ret

0000000000000eb6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     eb6:	48b5                	li	a7,13
 ecall
     eb8:	00000073          	ecall
 ret
     ebc:	8082                	ret

0000000000000ebe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ebe:	48b9                	li	a7,14
 ecall
     ec0:	00000073          	ecall
 ret
     ec4:	8082                	ret

0000000000000ec6 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
     ec6:	48d9                	li	a7,22
 ecall
     ec8:	00000073          	ecall
 ret
     ecc:	8082                	ret

0000000000000ece <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
     ece:	48dd                	li	a7,23
 ecall
     ed0:	00000073          	ecall
 ret
     ed4:	8082                	ret

0000000000000ed6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ed6:	1101                	addi	sp,sp,-32
     ed8:	ec06                	sd	ra,24(sp)
     eda:	e822                	sd	s0,16(sp)
     edc:	1000                	addi	s0,sp,32
     ede:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ee2:	4605                	li	a2,1
     ee4:	fef40593          	addi	a1,s0,-17
     ee8:	00000097          	auipc	ra,0x0
     eec:	f5e080e7          	jalr	-162(ra) # e46 <write>
}
     ef0:	60e2                	ld	ra,24(sp)
     ef2:	6442                	ld	s0,16(sp)
     ef4:	6105                	addi	sp,sp,32
     ef6:	8082                	ret

0000000000000ef8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ef8:	7139                	addi	sp,sp,-64
     efa:	fc06                	sd	ra,56(sp)
     efc:	f822                	sd	s0,48(sp)
     efe:	f426                	sd	s1,40(sp)
     f00:	f04a                	sd	s2,32(sp)
     f02:	ec4e                	sd	s3,24(sp)
     f04:	0080                	addi	s0,sp,64
     f06:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f08:	c299                	beqz	a3,f0e <printint+0x16>
     f0a:	0805c063          	bltz	a1,f8a <printint+0x92>
  neg = 0;
     f0e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     f10:	fc040313          	addi	t1,s0,-64
  neg = 0;
     f14:	869a                	mv	a3,t1
  i = 0;
     f16:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     f18:	00000817          	auipc	a6,0x0
     f1c:	5d080813          	addi	a6,a6,1488 # 14e8 <digits>
     f20:	88be                	mv	a7,a5
     f22:	0017851b          	addiw	a0,a5,1
     f26:	87aa                	mv	a5,a0
     f28:	02c5f73b          	remuw	a4,a1,a2
     f2c:	1702                	slli	a4,a4,0x20
     f2e:	9301                	srli	a4,a4,0x20
     f30:	9742                	add	a4,a4,a6
     f32:	00074703          	lbu	a4,0(a4)
     f36:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     f3a:	872e                	mv	a4,a1
     f3c:	02c5d5bb          	divuw	a1,a1,a2
     f40:	0685                	addi	a3,a3,1
     f42:	fcc77fe3          	bgeu	a4,a2,f20 <printint+0x28>
  if(neg)
     f46:	000e0c63          	beqz	t3,f5e <printint+0x66>
    buf[i++] = '-';
     f4a:	fd050793          	addi	a5,a0,-48
     f4e:	00878533          	add	a0,a5,s0
     f52:	02d00793          	li	a5,45
     f56:	fef50823          	sb	a5,-16(a0)
     f5a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     f5e:	fff7899b          	addiw	s3,a5,-1
     f62:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     f66:	fff4c583          	lbu	a1,-1(s1)
     f6a:	854a                	mv	a0,s2
     f6c:	00000097          	auipc	ra,0x0
     f70:	f6a080e7          	jalr	-150(ra) # ed6 <putc>
  while(--i >= 0)
     f74:	39fd                	addiw	s3,s3,-1
     f76:	14fd                	addi	s1,s1,-1
     f78:	fe09d7e3          	bgez	s3,f66 <printint+0x6e>
}
     f7c:	70e2                	ld	ra,56(sp)
     f7e:	7442                	ld	s0,48(sp)
     f80:	74a2                	ld	s1,40(sp)
     f82:	7902                	ld	s2,32(sp)
     f84:	69e2                	ld	s3,24(sp)
     f86:	6121                	addi	sp,sp,64
     f88:	8082                	ret
    x = -xx;
     f8a:	40b005bb          	negw	a1,a1
    neg = 1;
     f8e:	4e05                	li	t3,1
    x = -xx;
     f90:	b741                	j	f10 <printint+0x18>

0000000000000f92 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f92:	715d                	addi	sp,sp,-80
     f94:	e486                	sd	ra,72(sp)
     f96:	e0a2                	sd	s0,64(sp)
     f98:	f84a                	sd	s2,48(sp)
     f9a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f9c:	0005c903          	lbu	s2,0(a1)
     fa0:	1a090a63          	beqz	s2,1154 <vprintf+0x1c2>
     fa4:	fc26                	sd	s1,56(sp)
     fa6:	f44e                	sd	s3,40(sp)
     fa8:	f052                	sd	s4,32(sp)
     faa:	ec56                	sd	s5,24(sp)
     fac:	e85a                	sd	s6,16(sp)
     fae:	e45e                	sd	s7,8(sp)
     fb0:	8aaa                	mv	s5,a0
     fb2:	8bb2                	mv	s7,a2
     fb4:	00158493          	addi	s1,a1,1
  state = 0;
     fb8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fba:	02500a13          	li	s4,37
     fbe:	4b55                	li	s6,21
     fc0:	a839                	j	fde <vprintf+0x4c>
        putc(fd, c);
     fc2:	85ca                	mv	a1,s2
     fc4:	8556                	mv	a0,s5
     fc6:	00000097          	auipc	ra,0x0
     fca:	f10080e7          	jalr	-240(ra) # ed6 <putc>
     fce:	a019                	j	fd4 <vprintf+0x42>
    } else if(state == '%'){
     fd0:	01498d63          	beq	s3,s4,fea <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     fd4:	0485                	addi	s1,s1,1
     fd6:	fff4c903          	lbu	s2,-1(s1)
     fda:	16090763          	beqz	s2,1148 <vprintf+0x1b6>
    if(state == 0){
     fde:	fe0999e3          	bnez	s3,fd0 <vprintf+0x3e>
      if(c == '%'){
     fe2:	ff4910e3          	bne	s2,s4,fc2 <vprintf+0x30>
        state = '%';
     fe6:	89d2                	mv	s3,s4
     fe8:	b7f5                	j	fd4 <vprintf+0x42>
      if(c == 'd'){
     fea:	13490463          	beq	s2,s4,1112 <vprintf+0x180>
     fee:	f9d9079b          	addiw	a5,s2,-99
     ff2:	0ff7f793          	zext.b	a5,a5
     ff6:	12fb6763          	bltu	s6,a5,1124 <vprintf+0x192>
     ffa:	f9d9079b          	addiw	a5,s2,-99
     ffe:	0ff7f713          	zext.b	a4,a5
    1002:	12eb6163          	bltu	s6,a4,1124 <vprintf+0x192>
    1006:	00271793          	slli	a5,a4,0x2
    100a:	00000717          	auipc	a4,0x0
    100e:	48670713          	addi	a4,a4,1158 # 1490 <malloc+0x248>
    1012:	97ba                	add	a5,a5,a4
    1014:	439c                	lw	a5,0(a5)
    1016:	97ba                	add	a5,a5,a4
    1018:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    101a:	008b8913          	addi	s2,s7,8
    101e:	4685                	li	a3,1
    1020:	4629                	li	a2,10
    1022:	000ba583          	lw	a1,0(s7)
    1026:	8556                	mv	a0,s5
    1028:	00000097          	auipc	ra,0x0
    102c:	ed0080e7          	jalr	-304(ra) # ef8 <printint>
    1030:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1032:	4981                	li	s3,0
    1034:	b745                	j	fd4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1036:	008b8913          	addi	s2,s7,8
    103a:	4681                	li	a3,0
    103c:	4629                	li	a2,10
    103e:	000ba583          	lw	a1,0(s7)
    1042:	8556                	mv	a0,s5
    1044:	00000097          	auipc	ra,0x0
    1048:	eb4080e7          	jalr	-332(ra) # ef8 <printint>
    104c:	8bca                	mv	s7,s2
      state = 0;
    104e:	4981                	li	s3,0
    1050:	b751                	j	fd4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1052:	008b8913          	addi	s2,s7,8
    1056:	4681                	li	a3,0
    1058:	4641                	li	a2,16
    105a:	000ba583          	lw	a1,0(s7)
    105e:	8556                	mv	a0,s5
    1060:	00000097          	auipc	ra,0x0
    1064:	e98080e7          	jalr	-360(ra) # ef8 <printint>
    1068:	8bca                	mv	s7,s2
      state = 0;
    106a:	4981                	li	s3,0
    106c:	b7a5                	j	fd4 <vprintf+0x42>
    106e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1070:	008b8c13          	addi	s8,s7,8
    1074:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1078:	03000593          	li	a1,48
    107c:	8556                	mv	a0,s5
    107e:	00000097          	auipc	ra,0x0
    1082:	e58080e7          	jalr	-424(ra) # ed6 <putc>
  putc(fd, 'x');
    1086:	07800593          	li	a1,120
    108a:	8556                	mv	a0,s5
    108c:	00000097          	auipc	ra,0x0
    1090:	e4a080e7          	jalr	-438(ra) # ed6 <putc>
    1094:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1096:	00000b97          	auipc	s7,0x0
    109a:	452b8b93          	addi	s7,s7,1106 # 14e8 <digits>
    109e:	03c9d793          	srli	a5,s3,0x3c
    10a2:	97de                	add	a5,a5,s7
    10a4:	0007c583          	lbu	a1,0(a5)
    10a8:	8556                	mv	a0,s5
    10aa:	00000097          	auipc	ra,0x0
    10ae:	e2c080e7          	jalr	-468(ra) # ed6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10b2:	0992                	slli	s3,s3,0x4
    10b4:	397d                	addiw	s2,s2,-1
    10b6:	fe0914e3          	bnez	s2,109e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    10ba:	8be2                	mv	s7,s8
      state = 0;
    10bc:	4981                	li	s3,0
    10be:	6c02                	ld	s8,0(sp)
    10c0:	bf11                	j	fd4 <vprintf+0x42>
        s = va_arg(ap, char*);
    10c2:	008b8993          	addi	s3,s7,8
    10c6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10ca:	02090163          	beqz	s2,10ec <vprintf+0x15a>
        while(*s != 0){
    10ce:	00094583          	lbu	a1,0(s2)
    10d2:	c9a5                	beqz	a1,1142 <vprintf+0x1b0>
          putc(fd, *s);
    10d4:	8556                	mv	a0,s5
    10d6:	00000097          	auipc	ra,0x0
    10da:	e00080e7          	jalr	-512(ra) # ed6 <putc>
          s++;
    10de:	0905                	addi	s2,s2,1
        while(*s != 0){
    10e0:	00094583          	lbu	a1,0(s2)
    10e4:	f9e5                	bnez	a1,10d4 <vprintf+0x142>
        s = va_arg(ap, char*);
    10e6:	8bce                	mv	s7,s3
      state = 0;
    10e8:	4981                	li	s3,0
    10ea:	b5ed                	j	fd4 <vprintf+0x42>
          s = "(null)";
    10ec:	00000917          	auipc	s2,0x0
    10f0:	36c90913          	addi	s2,s2,876 # 1458 <malloc+0x210>
        while(*s != 0){
    10f4:	02800593          	li	a1,40
    10f8:	bff1                	j	10d4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    10fa:	008b8913          	addi	s2,s7,8
    10fe:	000bc583          	lbu	a1,0(s7)
    1102:	8556                	mv	a0,s5
    1104:	00000097          	auipc	ra,0x0
    1108:	dd2080e7          	jalr	-558(ra) # ed6 <putc>
    110c:	8bca                	mv	s7,s2
      state = 0;
    110e:	4981                	li	s3,0
    1110:	b5d1                	j	fd4 <vprintf+0x42>
        putc(fd, c);
    1112:	02500593          	li	a1,37
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	dbe080e7          	jalr	-578(ra) # ed6 <putc>
      state = 0;
    1120:	4981                	li	s3,0
    1122:	bd4d                	j	fd4 <vprintf+0x42>
        putc(fd, '%');
    1124:	02500593          	li	a1,37
    1128:	8556                	mv	a0,s5
    112a:	00000097          	auipc	ra,0x0
    112e:	dac080e7          	jalr	-596(ra) # ed6 <putc>
        putc(fd, c);
    1132:	85ca                	mv	a1,s2
    1134:	8556                	mv	a0,s5
    1136:	00000097          	auipc	ra,0x0
    113a:	da0080e7          	jalr	-608(ra) # ed6 <putc>
      state = 0;
    113e:	4981                	li	s3,0
    1140:	bd51                	j	fd4 <vprintf+0x42>
        s = va_arg(ap, char*);
    1142:	8bce                	mv	s7,s3
      state = 0;
    1144:	4981                	li	s3,0
    1146:	b579                	j	fd4 <vprintf+0x42>
    1148:	74e2                	ld	s1,56(sp)
    114a:	79a2                	ld	s3,40(sp)
    114c:	7a02                	ld	s4,32(sp)
    114e:	6ae2                	ld	s5,24(sp)
    1150:	6b42                	ld	s6,16(sp)
    1152:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1154:	60a6                	ld	ra,72(sp)
    1156:	6406                	ld	s0,64(sp)
    1158:	7942                	ld	s2,48(sp)
    115a:	6161                	addi	sp,sp,80
    115c:	8082                	ret

000000000000115e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    115e:	715d                	addi	sp,sp,-80
    1160:	ec06                	sd	ra,24(sp)
    1162:	e822                	sd	s0,16(sp)
    1164:	1000                	addi	s0,sp,32
    1166:	e010                	sd	a2,0(s0)
    1168:	e414                	sd	a3,8(s0)
    116a:	e818                	sd	a4,16(s0)
    116c:	ec1c                	sd	a5,24(s0)
    116e:	03043023          	sd	a6,32(s0)
    1172:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1176:	8622                	mv	a2,s0
    1178:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    117c:	00000097          	auipc	ra,0x0
    1180:	e16080e7          	jalr	-490(ra) # f92 <vprintf>
}
    1184:	60e2                	ld	ra,24(sp)
    1186:	6442                	ld	s0,16(sp)
    1188:	6161                	addi	sp,sp,80
    118a:	8082                	ret

000000000000118c <printf>:

void
printf(const char *fmt, ...)
{
    118c:	711d                	addi	sp,sp,-96
    118e:	ec06                	sd	ra,24(sp)
    1190:	e822                	sd	s0,16(sp)
    1192:	1000                	addi	s0,sp,32
    1194:	e40c                	sd	a1,8(s0)
    1196:	e810                	sd	a2,16(s0)
    1198:	ec14                	sd	a3,24(s0)
    119a:	f018                	sd	a4,32(s0)
    119c:	f41c                	sd	a5,40(s0)
    119e:	03043823          	sd	a6,48(s0)
    11a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11a6:	00840613          	addi	a2,s0,8
    11aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11ae:	85aa                	mv	a1,a0
    11b0:	4505                	li	a0,1
    11b2:	00000097          	auipc	ra,0x0
    11b6:	de0080e7          	jalr	-544(ra) # f92 <vprintf>
}
    11ba:	60e2                	ld	ra,24(sp)
    11bc:	6442                	ld	s0,16(sp)
    11be:	6125                	addi	sp,sp,96
    11c0:	8082                	ret

00000000000011c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11c2:	1141                	addi	sp,sp,-16
    11c4:	e406                	sd	ra,8(sp)
    11c6:	e022                	sd	s0,0(sp)
    11c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ce:	00000797          	auipc	a5,0x0
    11d2:	3427b783          	ld	a5,834(a5) # 1510 <freep>
    11d6:	a02d                	j	1200 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11d8:	4618                	lw	a4,8(a2)
    11da:	9f2d                	addw	a4,a4,a1
    11dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11e0:	6398                	ld	a4,0(a5)
    11e2:	6310                	ld	a2,0(a4)
    11e4:	a83d                	j	1222 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11e6:	ff852703          	lw	a4,-8(a0)
    11ea:	9f31                	addw	a4,a4,a2
    11ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11ee:	ff053683          	ld	a3,-16(a0)
    11f2:	a091                	j	1236 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f4:	6398                	ld	a4,0(a5)
    11f6:	00e7e463          	bltu	a5,a4,11fe <free+0x3c>
    11fa:	00e6ea63          	bltu	a3,a4,120e <free+0x4c>
{
    11fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1200:	fed7fae3          	bgeu	a5,a3,11f4 <free+0x32>
    1204:	6398                	ld	a4,0(a5)
    1206:	00e6e463          	bltu	a3,a4,120e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    120a:	fee7eae3          	bltu	a5,a4,11fe <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    120e:	ff852583          	lw	a1,-8(a0)
    1212:	6390                	ld	a2,0(a5)
    1214:	02059813          	slli	a6,a1,0x20
    1218:	01c85713          	srli	a4,a6,0x1c
    121c:	9736                	add	a4,a4,a3
    121e:	fae60de3          	beq	a2,a4,11d8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1222:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1226:	4790                	lw	a2,8(a5)
    1228:	02061593          	slli	a1,a2,0x20
    122c:	01c5d713          	srli	a4,a1,0x1c
    1230:	973e                	add	a4,a4,a5
    1232:	fae68ae3          	beq	a3,a4,11e6 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1236:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1238:	00000717          	auipc	a4,0x0
    123c:	2cf73c23          	sd	a5,728(a4) # 1510 <freep>
}
    1240:	60a2                	ld	ra,8(sp)
    1242:	6402                	ld	s0,0(sp)
    1244:	0141                	addi	sp,sp,16
    1246:	8082                	ret

0000000000001248 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1248:	7139                	addi	sp,sp,-64
    124a:	fc06                	sd	ra,56(sp)
    124c:	f822                	sd	s0,48(sp)
    124e:	f04a                	sd	s2,32(sp)
    1250:	ec4e                	sd	s3,24(sp)
    1252:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1254:	02051993          	slli	s3,a0,0x20
    1258:	0209d993          	srli	s3,s3,0x20
    125c:	09bd                	addi	s3,s3,15
    125e:	0049d993          	srli	s3,s3,0x4
    1262:	2985                	addiw	s3,s3,1
    1264:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1266:	00000517          	auipc	a0,0x0
    126a:	2aa53503          	ld	a0,682(a0) # 1510 <freep>
    126e:	c905                	beqz	a0,129e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1270:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1272:	4798                	lw	a4,8(a5)
    1274:	09377a63          	bgeu	a4,s3,1308 <malloc+0xc0>
    1278:	f426                	sd	s1,40(sp)
    127a:	e852                	sd	s4,16(sp)
    127c:	e456                	sd	s5,8(sp)
    127e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1280:	8a4e                	mv	s4,s3
    1282:	6705                	lui	a4,0x1
    1284:	00e9f363          	bgeu	s3,a4,128a <malloc+0x42>
    1288:	6a05                	lui	s4,0x1
    128a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    128e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1292:	00000497          	auipc	s1,0x0
    1296:	27e48493          	addi	s1,s1,638 # 1510 <freep>
  if(p == (char*)-1)
    129a:	5afd                	li	s5,-1
    129c:	a089                	j	12de <malloc+0x96>
    129e:	f426                	sd	s1,40(sp)
    12a0:	e852                	sd	s4,16(sp)
    12a2:	e456                	sd	s5,8(sp)
    12a4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12a6:	00000797          	auipc	a5,0x0
    12aa:	2da78793          	addi	a5,a5,730 # 1580 <base>
    12ae:	00000717          	auipc	a4,0x0
    12b2:	26f73123          	sd	a5,610(a4) # 1510 <freep>
    12b6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12b8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12bc:	b7d1                	j	1280 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    12be:	6398                	ld	a4,0(a5)
    12c0:	e118                	sd	a4,0(a0)
    12c2:	a8b9                	j	1320 <malloc+0xd8>
  hp->s.size = nu;
    12c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12c8:	0541                	addi	a0,a0,16
    12ca:	00000097          	auipc	ra,0x0
    12ce:	ef8080e7          	jalr	-264(ra) # 11c2 <free>
  return freep;
    12d2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    12d4:	c135                	beqz	a0,1338 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12d8:	4798                	lw	a4,8(a5)
    12da:	03277363          	bgeu	a4,s2,1300 <malloc+0xb8>
    if(p == freep)
    12de:	6098                	ld	a4,0(s1)
    12e0:	853e                	mv	a0,a5
    12e2:	fef71ae3          	bne	a4,a5,12d6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    12e6:	8552                	mv	a0,s4
    12e8:	00000097          	auipc	ra,0x0
    12ec:	bc6080e7          	jalr	-1082(ra) # eae <sbrk>
  if(p == (char*)-1)
    12f0:	fd551ae3          	bne	a0,s5,12c4 <malloc+0x7c>
        return 0;
    12f4:	4501                	li	a0,0
    12f6:	74a2                	ld	s1,40(sp)
    12f8:	6a42                	ld	s4,16(sp)
    12fa:	6aa2                	ld	s5,8(sp)
    12fc:	6b02                	ld	s6,0(sp)
    12fe:	a03d                	j	132c <malloc+0xe4>
    1300:	74a2                	ld	s1,40(sp)
    1302:	6a42                	ld	s4,16(sp)
    1304:	6aa2                	ld	s5,8(sp)
    1306:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1308:	fae90be3          	beq	s2,a4,12be <malloc+0x76>
        p->s.size -= nunits;
    130c:	4137073b          	subw	a4,a4,s3
    1310:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1312:	02071693          	slli	a3,a4,0x20
    1316:	01c6d713          	srli	a4,a3,0x1c
    131a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    131c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1320:	00000717          	auipc	a4,0x0
    1324:	1ea73823          	sd	a0,496(a4) # 1510 <freep>
      return (void*)(p + 1);
    1328:	01078513          	addi	a0,a5,16
  }
}
    132c:	70e2                	ld	ra,56(sp)
    132e:	7442                	ld	s0,48(sp)
    1330:	7902                	ld	s2,32(sp)
    1332:	69e2                	ld	s3,24(sp)
    1334:	6121                	addi	sp,sp,64
    1336:	8082                	ret
    1338:	74a2                	ld	s1,40(sp)
    133a:	6a42                	ld	s4,16(sp)
    133c:	6aa2                	ld	s5,8(sp)
    133e:	6b02                	ld	s6,0(sp)
    1340:	b7f5                	j	132c <malloc+0xe4>
