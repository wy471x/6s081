
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
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	32058593          	addi	a1,a1,800 # 1330 <malloc+0xfa>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	132080e7          	jalr	306(ra) # 114c <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	bda080e7          	jalr	-1062(ra) # c02 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	c1c080e7          	jalr	-996(ra) # c50 <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a0053b          	negw	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	2e258593          	addi	a1,a1,738 # 1340 <malloc+0x10a>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	0e4080e7          	jalr	228(ra) # 114c <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	db2080e7          	jalr	-590(ra) # e24 <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	d9a080e7          	jalr	-614(ra) # e1c <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	2b050513          	addi	a0,a0,688 # 1348 <malloc+0x112>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	addi	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b0:	c115                	beqz	a0,d4 <runcmd+0x2c>
      b2:	ec26                	sd	s1,24(sp)
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e363          	bltu	a5,a4,e0 <runcmd+0x38>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	slli	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	38470713          	addi	a4,a4,900 # 1448 <malloc+0x212>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
      d4:	ec26                	sd	s1,24(sp)
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00001097          	auipc	ra,0x1
      dc:	d4c080e7          	jalr	-692(ra) # e24 <exit>
    panic("runcmd");
      e0:	00001517          	auipc	a0,0x1
      e4:	27050513          	addi	a0,a0,624 # 1350 <malloc+0x11a>
      e8:	00000097          	auipc	ra,0x0
      ec:	f6c080e7          	jalr	-148(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      f0:	6508                	ld	a0,8(a0)
      f2:	c515                	beqz	a0,11e <runcmd+0x76>
    exec(ecmd->argv[0], ecmd->argv);
      f4:	00848593          	addi	a1,s1,8
      f8:	00001097          	auipc	ra,0x1
      fc:	d64080e7          	jalr	-668(ra) # e5c <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     100:	6490                	ld	a2,8(s1)
     102:	00001597          	auipc	a1,0x1
     106:	25658593          	addi	a1,a1,598 # 1358 <malloc+0x122>
     10a:	4509                	li	a0,2
     10c:	00001097          	auipc	ra,0x1
     110:	040080e7          	jalr	64(ra) # 114c <fprintf>
  exit(0);
     114:	4501                	li	a0,0
     116:	00001097          	auipc	ra,0x1
     11a:	d0e080e7          	jalr	-754(ra) # e24 <exit>
      exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	d04080e7          	jalr	-764(ra) # e24 <exit>
    close(rcmd->fd);
     128:	5148                	lw	a0,36(a0)
     12a:	00001097          	auipc	ra,0x1
     12e:	d22080e7          	jalr	-734(ra) # e4c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     132:	508c                	lw	a1,32(s1)
     134:	6888                	ld	a0,16(s1)
     136:	00001097          	auipc	ra,0x1
     13a:	d2e080e7          	jalr	-722(ra) # e64 <open>
     13e:	00054763          	bltz	a0,14c <runcmd+0xa4>
    runcmd(rcmd->cmd);
     142:	6488                	ld	a0,8(s1)
     144:	00000097          	auipc	ra,0x0
     148:	f64080e7          	jalr	-156(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14c:	6890                	ld	a2,16(s1)
     14e:	00001597          	auipc	a1,0x1
     152:	21a58593          	addi	a1,a1,538 # 1368 <malloc+0x132>
     156:	4509                	li	a0,2
     158:	00001097          	auipc	ra,0x1
     15c:	ff4080e7          	jalr	-12(ra) # 114c <fprintf>
      exit(1);
     160:	4505                	li	a0,1
     162:	00001097          	auipc	ra,0x1
     166:	cc2080e7          	jalr	-830(ra) # e24 <exit>
    if(fork1() == 0)
     16a:	00000097          	auipc	ra,0x0
     16e:	f10080e7          	jalr	-240(ra) # 7a <fork1>
     172:	e511                	bnez	a0,17e <runcmd+0xd6>
      runcmd(lcmd->left);
     174:	6488                	ld	a0,8(s1)
     176:	00000097          	auipc	ra,0x0
     17a:	f32080e7          	jalr	-206(ra) # a8 <runcmd>
    wait(0);
     17e:	4501                	li	a0,0
     180:	00001097          	auipc	ra,0x1
     184:	cac080e7          	jalr	-852(ra) # e2c <wait>
    runcmd(lcmd->right);
     188:	6888                	ld	a0,16(s1)
     18a:	00000097          	auipc	ra,0x0
     18e:	f1e080e7          	jalr	-226(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     192:	fd840513          	addi	a0,s0,-40
     196:	00001097          	auipc	ra,0x1
     19a:	c9e080e7          	jalr	-866(ra) # e34 <pipe>
     19e:	04054363          	bltz	a0,1e4 <runcmd+0x13c>
    if(fork1() == 0){
     1a2:	00000097          	auipc	ra,0x0
     1a6:	ed8080e7          	jalr	-296(ra) # 7a <fork1>
     1aa:	e529                	bnez	a0,1f4 <runcmd+0x14c>
      close(1);
     1ac:	4505                	li	a0,1
     1ae:	00001097          	auipc	ra,0x1
     1b2:	c9e080e7          	jalr	-866(ra) # e4c <close>
      dup(p[1]);
     1b6:	fdc42503          	lw	a0,-36(s0)
     1ba:	00001097          	auipc	ra,0x1
     1be:	ce2080e7          	jalr	-798(ra) # e9c <dup>
      close(p[0]);
     1c2:	fd842503          	lw	a0,-40(s0)
     1c6:	00001097          	auipc	ra,0x1
     1ca:	c86080e7          	jalr	-890(ra) # e4c <close>
      close(p[1]);
     1ce:	fdc42503          	lw	a0,-36(s0)
     1d2:	00001097          	auipc	ra,0x1
     1d6:	c7a080e7          	jalr	-902(ra) # e4c <close>
      runcmd(pcmd->left);
     1da:	6488                	ld	a0,8(s1)
     1dc:	00000097          	auipc	ra,0x0
     1e0:	ecc080e7          	jalr	-308(ra) # a8 <runcmd>
      panic("pipe");
     1e4:	00001517          	auipc	a0,0x1
     1e8:	19450513          	addi	a0,a0,404 # 1378 <malloc+0x142>
     1ec:	00000097          	auipc	ra,0x0
     1f0:	e68080e7          	jalr	-408(ra) # 54 <panic>
    if(fork1() == 0){
     1f4:	00000097          	auipc	ra,0x0
     1f8:	e86080e7          	jalr	-378(ra) # 7a <fork1>
     1fc:	ed05                	bnez	a0,234 <runcmd+0x18c>
      close(0);
     1fe:	00001097          	auipc	ra,0x1
     202:	c4e080e7          	jalr	-946(ra) # e4c <close>
      dup(p[0]);
     206:	fd842503          	lw	a0,-40(s0)
     20a:	00001097          	auipc	ra,0x1
     20e:	c92080e7          	jalr	-878(ra) # e9c <dup>
      close(p[0]);
     212:	fd842503          	lw	a0,-40(s0)
     216:	00001097          	auipc	ra,0x1
     21a:	c36080e7          	jalr	-970(ra) # e4c <close>
      close(p[1]);
     21e:	fdc42503          	lw	a0,-36(s0)
     222:	00001097          	auipc	ra,0x1
     226:	c2a080e7          	jalr	-982(ra) # e4c <close>
      runcmd(pcmd->right);
     22a:	6888                	ld	a0,16(s1)
     22c:	00000097          	auipc	ra,0x0
     230:	e7c080e7          	jalr	-388(ra) # a8 <runcmd>
    close(p[0]);
     234:	fd842503          	lw	a0,-40(s0)
     238:	00001097          	auipc	ra,0x1
     23c:	c14080e7          	jalr	-1004(ra) # e4c <close>
    close(p[1]);
     240:	fdc42503          	lw	a0,-36(s0)
     244:	00001097          	auipc	ra,0x1
     248:	c08080e7          	jalr	-1016(ra) # e4c <close>
    wait(0);
     24c:	4501                	li	a0,0
     24e:	00001097          	auipc	ra,0x1
     252:	bde080e7          	jalr	-1058(ra) # e2c <wait>
    wait(0);
     256:	4501                	li	a0,0
     258:	00001097          	auipc	ra,0x1
     25c:	bd4080e7          	jalr	-1068(ra) # e2c <wait>
    break;
     260:	bd55                	j	114 <runcmd+0x6c>
    if(fork1() == 0)
     262:	00000097          	auipc	ra,0x0
     266:	e18080e7          	jalr	-488(ra) # 7a <fork1>
     26a:	ea0515e3          	bnez	a0,114 <runcmd+0x6c>
      runcmd(bcmd->cmd);
     26e:	6488                	ld	a0,8(s1)
     270:	00000097          	auipc	ra,0x0
     274:	e38080e7          	jalr	-456(ra) # a8 <runcmd>

0000000000000278 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     278:	1101                	addi	sp,sp,-32
     27a:	ec06                	sd	ra,24(sp)
     27c:	e822                	sd	s0,16(sp)
     27e:	e426                	sd	s1,8(sp)
     280:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     282:	0a800513          	li	a0,168
     286:	00001097          	auipc	ra,0x1
     28a:	fb0080e7          	jalr	-80(ra) # 1236 <malloc>
     28e:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     290:	0a800613          	li	a2,168
     294:	4581                	li	a1,0
     296:	00001097          	auipc	ra,0x1
     29a:	96c080e7          	jalr	-1684(ra) # c02 <memset>
  cmd->type = EXEC;
     29e:	4785                	li	a5,1
     2a0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a2:	8526                	mv	a0,s1
     2a4:	60e2                	ld	ra,24(sp)
     2a6:	6442                	ld	s0,16(sp)
     2a8:	64a2                	ld	s1,8(sp)
     2aa:	6105                	addi	sp,sp,32
     2ac:	8082                	ret

00000000000002ae <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ae:	7139                	addi	sp,sp,-64
     2b0:	fc06                	sd	ra,56(sp)
     2b2:	f822                	sd	s0,48(sp)
     2b4:	f426                	sd	s1,40(sp)
     2b6:	f04a                	sd	s2,32(sp)
     2b8:	ec4e                	sd	s3,24(sp)
     2ba:	e852                	sd	s4,16(sp)
     2bc:	e456                	sd	s5,8(sp)
     2be:	e05a                	sd	s6,0(sp)
     2c0:	0080                	addi	s0,sp,64
     2c2:	8b2a                	mv	s6,a0
     2c4:	8aae                	mv	s5,a1
     2c6:	8a32                	mv	s4,a2
     2c8:	89b6                	mv	s3,a3
     2ca:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2cc:	02800513          	li	a0,40
     2d0:	00001097          	auipc	ra,0x1
     2d4:	f66080e7          	jalr	-154(ra) # 1236 <malloc>
     2d8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2da:	02800613          	li	a2,40
     2de:	4581                	li	a1,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	922080e7          	jalr	-1758(ra) # c02 <memset>
  cmd->type = REDIR;
     2e8:	4789                	li	a5,2
     2ea:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ec:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f0:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f4:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f8:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fc:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	70e2                	ld	ra,56(sp)
     304:	7442                	ld	s0,48(sp)
     306:	74a2                	ld	s1,40(sp)
     308:	7902                	ld	s2,32(sp)
     30a:	69e2                	ld	s3,24(sp)
     30c:	6a42                	ld	s4,16(sp)
     30e:	6aa2                	ld	s5,8(sp)
     310:	6b02                	ld	s6,0(sp)
     312:	6121                	addi	sp,sp,64
     314:	8082                	ret

0000000000000316 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     316:	7179                	addi	sp,sp,-48
     318:	f406                	sd	ra,40(sp)
     31a:	f022                	sd	s0,32(sp)
     31c:	ec26                	sd	s1,24(sp)
     31e:	e84a                	sd	s2,16(sp)
     320:	e44e                	sd	s3,8(sp)
     322:	1800                	addi	s0,sp,48
     324:	89aa                	mv	s3,a0
     326:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     328:	4561                	li	a0,24
     32a:	00001097          	auipc	ra,0x1
     32e:	f0c080e7          	jalr	-244(ra) # 1236 <malloc>
     332:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     334:	4661                	li	a2,24
     336:	4581                	li	a1,0
     338:	00001097          	auipc	ra,0x1
     33c:	8ca080e7          	jalr	-1846(ra) # c02 <memset>
  cmd->type = PIPE;
     340:	478d                	li	a5,3
     342:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     344:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     348:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34c:	8526                	mv	a0,s1
     34e:	70a2                	ld	ra,40(sp)
     350:	7402                	ld	s0,32(sp)
     352:	64e2                	ld	s1,24(sp)
     354:	6942                	ld	s2,16(sp)
     356:	69a2                	ld	s3,8(sp)
     358:	6145                	addi	sp,sp,48
     35a:	8082                	ret

000000000000035c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35c:	7179                	addi	sp,sp,-48
     35e:	f406                	sd	ra,40(sp)
     360:	f022                	sd	s0,32(sp)
     362:	ec26                	sd	s1,24(sp)
     364:	e84a                	sd	s2,16(sp)
     366:	e44e                	sd	s3,8(sp)
     368:	1800                	addi	s0,sp,48
     36a:	89aa                	mv	s3,a0
     36c:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36e:	4561                	li	a0,24
     370:	00001097          	auipc	ra,0x1
     374:	ec6080e7          	jalr	-314(ra) # 1236 <malloc>
     378:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37a:	4661                	li	a2,24
     37c:	4581                	li	a1,0
     37e:	00001097          	auipc	ra,0x1
     382:	884080e7          	jalr	-1916(ra) # c02 <memset>
  cmd->type = LIST;
     386:	4791                	li	a5,4
     388:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38a:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38e:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     392:	8526                	mv	a0,s1
     394:	70a2                	ld	ra,40(sp)
     396:	7402                	ld	s0,32(sp)
     398:	64e2                	ld	s1,24(sp)
     39a:	6942                	ld	s2,16(sp)
     39c:	69a2                	ld	s3,8(sp)
     39e:	6145                	addi	sp,sp,48
     3a0:	8082                	ret

00000000000003a2 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a2:	1101                	addi	sp,sp,-32
     3a4:	ec06                	sd	ra,24(sp)
     3a6:	e822                	sd	s0,16(sp)
     3a8:	e426                	sd	s1,8(sp)
     3aa:	e04a                	sd	s2,0(sp)
     3ac:	1000                	addi	s0,sp,32
     3ae:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b0:	4541                	li	a0,16
     3b2:	00001097          	auipc	ra,0x1
     3b6:	e84080e7          	jalr	-380(ra) # 1236 <malloc>
     3ba:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3bc:	4641                	li	a2,16
     3be:	4581                	li	a1,0
     3c0:	00001097          	auipc	ra,0x1
     3c4:	842080e7          	jalr	-1982(ra) # c02 <memset>
  cmd->type = BACK;
     3c8:	4795                	li	a5,5
     3ca:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3cc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d0:	8526                	mv	a0,s1
     3d2:	60e2                	ld	ra,24(sp)
     3d4:	6442                	ld	s0,16(sp)
     3d6:	64a2                	ld	s1,8(sp)
     3d8:	6902                	ld	s2,0(sp)
     3da:	6105                	addi	sp,sp,32
     3dc:	8082                	ret

00000000000003de <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3de:	7139                	addi	sp,sp,-64
     3e0:	fc06                	sd	ra,56(sp)
     3e2:	f822                	sd	s0,48(sp)
     3e4:	f426                	sd	s1,40(sp)
     3e6:	f04a                	sd	s2,32(sp)
     3e8:	ec4e                	sd	s3,24(sp)
     3ea:	e852                	sd	s4,16(sp)
     3ec:	e456                	sd	s5,8(sp)
     3ee:	e05a                	sd	s6,0(sp)
     3f0:	0080                	addi	s0,sp,64
     3f2:	8a2a                	mv	s4,a0
     3f4:	892e                	mv	s2,a1
     3f6:	8ab2                	mv	s5,a2
     3f8:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fa:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fc:	00001997          	auipc	s3,0x1
     400:	0f498993          	addi	s3,s3,244 # 14f0 <whitespace>
     404:	00b4fe63          	bgeu	s1,a1,420 <gettoken+0x42>
     408:	0004c583          	lbu	a1,0(s1)
     40c:	854e                	mv	a0,s3
     40e:	00001097          	auipc	ra,0x1
     412:	81a080e7          	jalr	-2022(ra) # c28 <strchr>
     416:	c509                	beqz	a0,420 <gettoken+0x42>
    s++;
     418:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41a:	fe9917e3          	bne	s2,s1,408 <gettoken+0x2a>
     41e:	84ca                	mv	s1,s2
  if(q)
     420:	000a8463          	beqz	s5,428 <gettoken+0x4a>
    *q = s;
     424:	009ab023          	sd	s1,0(s5)
  ret = *s;
     428:	0004c783          	lbu	a5,0(s1)
     42c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     430:	03c00713          	li	a4,60
     434:	06f76663          	bltu	a4,a5,4a0 <gettoken+0xc2>
     438:	03a00713          	li	a4,58
     43c:	00f76e63          	bltu	a4,a5,458 <gettoken+0x7a>
     440:	cf89                	beqz	a5,45a <gettoken+0x7c>
     442:	02600713          	li	a4,38
     446:	00e78963          	beq	a5,a4,458 <gettoken+0x7a>
     44a:	fd87879b          	addiw	a5,a5,-40
     44e:	0ff7f793          	zext.b	a5,a5
     452:	4705                	li	a4,1
     454:	06f76d63          	bltu	a4,a5,4ce <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     458:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45a:	000b0463          	beqz	s6,462 <gettoken+0x84>
    *eq = s;
     45e:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     462:	00001997          	auipc	s3,0x1
     466:	08e98993          	addi	s3,s3,142 # 14f0 <whitespace>
     46a:	0124fe63          	bgeu	s1,s2,486 <gettoken+0xa8>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	00000097          	auipc	ra,0x0
     478:	7b4080e7          	jalr	1972(ra) # c28 <strchr>
     47c:	c509                	beqz	a0,486 <gettoken+0xa8>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9917e3          	bne	s2,s1,46e <gettoken+0x90>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48a:	8556                	mv	a0,s5
     48c:	70e2                	ld	ra,56(sp)
     48e:	7442                	ld	s0,48(sp)
     490:	74a2                	ld	s1,40(sp)
     492:	7902                	ld	s2,32(sp)
     494:	69e2                	ld	s3,24(sp)
     496:	6a42                	ld	s4,16(sp)
     498:	6aa2                	ld	s5,8(sp)
     49a:	6b02                	ld	s6,0(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
  switch(*s){
     4a0:	03e00713          	li	a4,62
     4a4:	02e79163          	bne	a5,a4,4c6 <gettoken+0xe8>
    s++;
     4a8:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4ac:	0014c703          	lbu	a4,1(s1)
     4b0:	03e00793          	li	a5,62
      s++;
     4b4:	0489                	addi	s1,s1,2
      ret = '+';
     4b6:	02b00a93          	li	s5,43
    if(*s == '>'){
     4ba:	faf700e3          	beq	a4,a5,45a <gettoken+0x7c>
    s++;
     4be:	84b6                	mv	s1,a3
  ret = *s;
     4c0:	03e00a93          	li	s5,62
     4c4:	bf59                	j	45a <gettoken+0x7c>
  switch(*s){
     4c6:	07c00713          	li	a4,124
     4ca:	f8e787e3          	beq	a5,a4,458 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4ce:	00001997          	auipc	s3,0x1
     4d2:	02298993          	addi	s3,s3,34 # 14f0 <whitespace>
     4d6:	00001a97          	auipc	s5,0x1
     4da:	012a8a93          	addi	s5,s5,18 # 14e8 <symbols>
     4de:	0524f163          	bgeu	s1,s2,520 <gettoken+0x142>
     4e2:	0004c583          	lbu	a1,0(s1)
     4e6:	854e                	mv	a0,s3
     4e8:	00000097          	auipc	ra,0x0
     4ec:	740080e7          	jalr	1856(ra) # c28 <strchr>
     4f0:	e50d                	bnez	a0,51a <gettoken+0x13c>
     4f2:	0004c583          	lbu	a1,0(s1)
     4f6:	8556                	mv	a0,s5
     4f8:	00000097          	auipc	ra,0x0
     4fc:	730080e7          	jalr	1840(ra) # c28 <strchr>
     500:	e911                	bnez	a0,514 <gettoken+0x136>
      s++;
     502:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     504:	fc991fe3          	bne	s2,s1,4e2 <gettoken+0x104>
  if(eq)
     508:	84ca                	mv	s1,s2
    ret = 'a';
     50a:	06100a93          	li	s5,97
  if(eq)
     50e:	f40b18e3          	bnez	s6,45e <gettoken+0x80>
     512:	bf95                	j	486 <gettoken+0xa8>
    ret = 'a';
     514:	06100a93          	li	s5,97
     518:	b789                	j	45a <gettoken+0x7c>
     51a:	06100a93          	li	s5,97
     51e:	bf35                	j	45a <gettoken+0x7c>
     520:	06100a93          	li	s5,97
  if(eq)
     524:	f20b1de3          	bnez	s6,45e <gettoken+0x80>
     528:	bfb9                	j	486 <gettoken+0xa8>

000000000000052a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     52a:	7139                	addi	sp,sp,-64
     52c:	fc06                	sd	ra,56(sp)
     52e:	f822                	sd	s0,48(sp)
     530:	f426                	sd	s1,40(sp)
     532:	f04a                	sd	s2,32(sp)
     534:	ec4e                	sd	s3,24(sp)
     536:	e852                	sd	s4,16(sp)
     538:	e456                	sd	s5,8(sp)
     53a:	0080                	addi	s0,sp,64
     53c:	8a2a                	mv	s4,a0
     53e:	892e                	mv	s2,a1
     540:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     542:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     544:	00001997          	auipc	s3,0x1
     548:	fac98993          	addi	s3,s3,-84 # 14f0 <whitespace>
     54c:	00b4fe63          	bgeu	s1,a1,568 <peek+0x3e>
     550:	0004c583          	lbu	a1,0(s1)
     554:	854e                	mv	a0,s3
     556:	00000097          	auipc	ra,0x0
     55a:	6d2080e7          	jalr	1746(ra) # c28 <strchr>
     55e:	c509                	beqz	a0,568 <peek+0x3e>
    s++;
     560:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     562:	fe9917e3          	bne	s2,s1,550 <peek+0x26>
     566:	84ca                	mv	s1,s2
  *ps = s;
     568:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56c:	0004c583          	lbu	a1,0(s1)
     570:	4501                	li	a0,0
     572:	e991                	bnez	a1,586 <peek+0x5c>
}
     574:	70e2                	ld	ra,56(sp)
     576:	7442                	ld	s0,48(sp)
     578:	74a2                	ld	s1,40(sp)
     57a:	7902                	ld	s2,32(sp)
     57c:	69e2                	ld	s3,24(sp)
     57e:	6a42                	ld	s4,16(sp)
     580:	6aa2                	ld	s5,8(sp)
     582:	6121                	addi	sp,sp,64
     584:	8082                	ret
  return *s && strchr(toks, *s);
     586:	8556                	mv	a0,s5
     588:	00000097          	auipc	ra,0x0
     58c:	6a0080e7          	jalr	1696(ra) # c28 <strchr>
     590:	00a03533          	snez	a0,a0
     594:	b7c5                	j	574 <peek+0x4a>

0000000000000596 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     596:	7159                	addi	sp,sp,-112
     598:	f486                	sd	ra,104(sp)
     59a:	f0a2                	sd	s0,96(sp)
     59c:	eca6                	sd	s1,88(sp)
     59e:	e8ca                	sd	s2,80(sp)
     5a0:	e4ce                	sd	s3,72(sp)
     5a2:	e0d2                	sd	s4,64(sp)
     5a4:	fc56                	sd	s5,56(sp)
     5a6:	f85a                	sd	s6,48(sp)
     5a8:	f45e                	sd	s7,40(sp)
     5aa:	f062                	sd	s8,32(sp)
     5ac:	ec66                	sd	s9,24(sp)
     5ae:	1880                	addi	s0,sp,112
     5b0:	8a2a                	mv	s4,a0
     5b2:	89ae                	mv	s3,a1
     5b4:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b6:	00001b17          	auipc	s6,0x1
     5ba:	deab0b13          	addi	s6,s6,-534 # 13a0 <malloc+0x16a>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5be:	f9040c93          	addi	s9,s0,-112
     5c2:	f9840c13          	addi	s8,s0,-104
     5c6:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     5ca:	a02d                	j	5f4 <parseredirs+0x5e>
      panic("missing file for redirection");
     5cc:	00001517          	auipc	a0,0x1
     5d0:	db450513          	addi	a0,a0,-588 # 1380 <malloc+0x14a>
     5d4:	00000097          	auipc	ra,0x0
     5d8:	a80080e7          	jalr	-1408(ra) # 54 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5dc:	4701                	li	a4,0
     5de:	4681                	li	a3,0
     5e0:	f9043603          	ld	a2,-112(s0)
     5e4:	f9843583          	ld	a1,-104(s0)
     5e8:	8552                	mv	a0,s4
     5ea:	00000097          	auipc	ra,0x0
     5ee:	cc4080e7          	jalr	-828(ra) # 2ae <redircmd>
     5f2:	8a2a                	mv	s4,a0
    switch(tok){
     5f4:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     5f8:	865a                	mv	a2,s6
     5fa:	85ca                	mv	a1,s2
     5fc:	854e                	mv	a0,s3
     5fe:	00000097          	auipc	ra,0x0
     602:	f2c080e7          	jalr	-212(ra) # 52a <peek>
     606:	c935                	beqz	a0,67a <parseredirs+0xe4>
    tok = gettoken(ps, es, 0, 0);
     608:	4681                	li	a3,0
     60a:	4601                	li	a2,0
     60c:	85ca                	mv	a1,s2
     60e:	854e                	mv	a0,s3
     610:	00000097          	auipc	ra,0x0
     614:	dce080e7          	jalr	-562(ra) # 3de <gettoken>
     618:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     61a:	86e6                	mv	a3,s9
     61c:	8662                	mv	a2,s8
     61e:	85ca                	mv	a1,s2
     620:	854e                	mv	a0,s3
     622:	00000097          	auipc	ra,0x0
     626:	dbc080e7          	jalr	-580(ra) # 3de <gettoken>
     62a:	fb7511e3          	bne	a0,s7,5cc <parseredirs+0x36>
    switch(tok){
     62e:	fb5487e3          	beq	s1,s5,5dc <parseredirs+0x46>
     632:	03e00793          	li	a5,62
     636:	02f48463          	beq	s1,a5,65e <parseredirs+0xc8>
     63a:	02b00793          	li	a5,43
     63e:	faf49de3          	bne	s1,a5,5f8 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     642:	4705                	li	a4,1
     644:	20100693          	li	a3,513
     648:	f9043603          	ld	a2,-112(s0)
     64c:	f9843583          	ld	a1,-104(s0)
     650:	8552                	mv	a0,s4
     652:	00000097          	auipc	ra,0x0
     656:	c5c080e7          	jalr	-932(ra) # 2ae <redircmd>
     65a:	8a2a                	mv	s4,a0
      break;
     65c:	bf61                	j	5f4 <parseredirs+0x5e>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     65e:	4705                	li	a4,1
     660:	60100693          	li	a3,1537
     664:	f9043603          	ld	a2,-112(s0)
     668:	f9843583          	ld	a1,-104(s0)
     66c:	8552                	mv	a0,s4
     66e:	00000097          	auipc	ra,0x0
     672:	c40080e7          	jalr	-960(ra) # 2ae <redircmd>
     676:	8a2a                	mv	s4,a0
      break;
     678:	bfb5                	j	5f4 <parseredirs+0x5e>
    }
  }
  return cmd;
}
     67a:	8552                	mv	a0,s4
     67c:	70a6                	ld	ra,104(sp)
     67e:	7406                	ld	s0,96(sp)
     680:	64e6                	ld	s1,88(sp)
     682:	6946                	ld	s2,80(sp)
     684:	69a6                	ld	s3,72(sp)
     686:	6a06                	ld	s4,64(sp)
     688:	7ae2                	ld	s5,56(sp)
     68a:	7b42                	ld	s6,48(sp)
     68c:	7ba2                	ld	s7,40(sp)
     68e:	7c02                	ld	s8,32(sp)
     690:	6ce2                	ld	s9,24(sp)
     692:	6165                	addi	sp,sp,112
     694:	8082                	ret

0000000000000696 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     696:	7119                	addi	sp,sp,-128
     698:	fc86                	sd	ra,120(sp)
     69a:	f8a2                	sd	s0,112(sp)
     69c:	f4a6                	sd	s1,104(sp)
     69e:	e8d2                	sd	s4,80(sp)
     6a0:	e4d6                	sd	s5,72(sp)
     6a2:	0100                	addi	s0,sp,128
     6a4:	8a2a                	mv	s4,a0
     6a6:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6a8:	00001617          	auipc	a2,0x1
     6ac:	d0060613          	addi	a2,a2,-768 # 13a8 <malloc+0x172>
     6b0:	00000097          	auipc	ra,0x0
     6b4:	e7a080e7          	jalr	-390(ra) # 52a <peek>
     6b8:	e521                	bnez	a0,700 <parseexec+0x6a>
     6ba:	f0ca                	sd	s2,96(sp)
     6bc:	ecce                	sd	s3,88(sp)
     6be:	e0da                	sd	s6,64(sp)
     6c0:	fc5e                	sd	s7,56(sp)
     6c2:	f862                	sd	s8,48(sp)
     6c4:	f466                	sd	s9,40(sp)
     6c6:	f06a                	sd	s10,32(sp)
     6c8:	ec6e                	sd	s11,24(sp)
     6ca:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6cc:	00000097          	auipc	ra,0x0
     6d0:	bac080e7          	jalr	-1108(ra) # 278 <execcmd>
     6d4:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6d6:	8656                	mv	a2,s5
     6d8:	85d2                	mv	a1,s4
     6da:	00000097          	auipc	ra,0x0
     6de:	ebc080e7          	jalr	-324(ra) # 596 <parseredirs>
     6e2:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6e4:	008d8913          	addi	s2,s11,8
     6e8:	00001b17          	auipc	s6,0x1
     6ec:	ce0b0b13          	addi	s6,s6,-800 # 13c8 <malloc+0x192>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     6f0:	f8040c13          	addi	s8,s0,-128
     6f4:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     6f8:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6fc:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     6fe:	a081                	j	73e <parseexec+0xa8>
    return parseblock(ps, es);
     700:	85d6                	mv	a1,s5
     702:	8552                	mv	a0,s4
     704:	00000097          	auipc	ra,0x0
     708:	1bc080e7          	jalr	444(ra) # 8c0 <parseblock>
     70c:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     70e:	8526                	mv	a0,s1
     710:	70e6                	ld	ra,120(sp)
     712:	7446                	ld	s0,112(sp)
     714:	74a6                	ld	s1,104(sp)
     716:	6a46                	ld	s4,80(sp)
     718:	6aa6                	ld	s5,72(sp)
     71a:	6109                	addi	sp,sp,128
     71c:	8082                	ret
      panic("syntax");
     71e:	00001517          	auipc	a0,0x1
     722:	c9250513          	addi	a0,a0,-878 # 13b0 <malloc+0x17a>
     726:	00000097          	auipc	ra,0x0
     72a:	92e080e7          	jalr	-1746(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     72e:	8656                	mv	a2,s5
     730:	85d2                	mv	a1,s4
     732:	8526                	mv	a0,s1
     734:	00000097          	auipc	ra,0x0
     738:	e62080e7          	jalr	-414(ra) # 596 <parseredirs>
     73c:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     73e:	865a                	mv	a2,s6
     740:	85d6                	mv	a1,s5
     742:	8552                	mv	a0,s4
     744:	00000097          	auipc	ra,0x0
     748:	de6080e7          	jalr	-538(ra) # 52a <peek>
     74c:	e121                	bnez	a0,78c <parseexec+0xf6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     74e:	86e2                	mv	a3,s8
     750:	865e                	mv	a2,s7
     752:	85d6                	mv	a1,s5
     754:	8552                	mv	a0,s4
     756:	00000097          	auipc	ra,0x0
     75a:	c88080e7          	jalr	-888(ra) # 3de <gettoken>
     75e:	c51d                	beqz	a0,78c <parseexec+0xf6>
    if(tok != 'a')
     760:	fba51fe3          	bne	a0,s10,71e <parseexec+0x88>
    cmd->argv[argc] = q;
     764:	f8843783          	ld	a5,-120(s0)
     768:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     76c:	f8043783          	ld	a5,-128(s0)
     770:	04f93823          	sd	a5,80(s2)
    argc++;
     774:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     776:	0921                	addi	s2,s2,8
     778:	fb999be3          	bne	s3,s9,72e <parseexec+0x98>
      panic("too many args");
     77c:	00001517          	auipc	a0,0x1
     780:	c3c50513          	addi	a0,a0,-964 # 13b8 <malloc+0x182>
     784:	00000097          	auipc	ra,0x0
     788:	8d0080e7          	jalr	-1840(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     78c:	098e                	slli	s3,s3,0x3
     78e:	9dce                	add	s11,s11,s3
     790:	000db423          	sd	zero,8(s11)
  cmd->eargv[argc] = 0;
     794:	040dbc23          	sd	zero,88(s11)
     798:	7906                	ld	s2,96(sp)
     79a:	69e6                	ld	s3,88(sp)
     79c:	6b06                	ld	s6,64(sp)
     79e:	7be2                	ld	s7,56(sp)
     7a0:	7c42                	ld	s8,48(sp)
     7a2:	7ca2                	ld	s9,40(sp)
     7a4:	7d02                	ld	s10,32(sp)
     7a6:	6de2                	ld	s11,24(sp)
  return ret;
     7a8:	b79d                	j	70e <parseexec+0x78>

00000000000007aa <parsepipe>:
{
     7aa:	7179                	addi	sp,sp,-48
     7ac:	f406                	sd	ra,40(sp)
     7ae:	f022                	sd	s0,32(sp)
     7b0:	ec26                	sd	s1,24(sp)
     7b2:	e84a                	sd	s2,16(sp)
     7b4:	e44e                	sd	s3,8(sp)
     7b6:	1800                	addi	s0,sp,48
     7b8:	892a                	mv	s2,a0
     7ba:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7bc:	00000097          	auipc	ra,0x0
     7c0:	eda080e7          	jalr	-294(ra) # 696 <parseexec>
     7c4:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7c6:	00001617          	auipc	a2,0x1
     7ca:	c0a60613          	addi	a2,a2,-1014 # 13d0 <malloc+0x19a>
     7ce:	85ce                	mv	a1,s3
     7d0:	854a                	mv	a0,s2
     7d2:	00000097          	auipc	ra,0x0
     7d6:	d58080e7          	jalr	-680(ra) # 52a <peek>
     7da:	e909                	bnez	a0,7ec <parsepipe+0x42>
}
     7dc:	8526                	mv	a0,s1
     7de:	70a2                	ld	ra,40(sp)
     7e0:	7402                	ld	s0,32(sp)
     7e2:	64e2                	ld	s1,24(sp)
     7e4:	6942                	ld	s2,16(sp)
     7e6:	69a2                	ld	s3,8(sp)
     7e8:	6145                	addi	sp,sp,48
     7ea:	8082                	ret
    gettoken(ps, es, 0, 0);
     7ec:	4681                	li	a3,0
     7ee:	4601                	li	a2,0
     7f0:	85ce                	mv	a1,s3
     7f2:	854a                	mv	a0,s2
     7f4:	00000097          	auipc	ra,0x0
     7f8:	bea080e7          	jalr	-1046(ra) # 3de <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7fc:	85ce                	mv	a1,s3
     7fe:	854a                	mv	a0,s2
     800:	00000097          	auipc	ra,0x0
     804:	faa080e7          	jalr	-86(ra) # 7aa <parsepipe>
     808:	85aa                	mv	a1,a0
     80a:	8526                	mv	a0,s1
     80c:	00000097          	auipc	ra,0x0
     810:	b0a080e7          	jalr	-1270(ra) # 316 <pipecmd>
     814:	84aa                	mv	s1,a0
  return cmd;
     816:	b7d9                	j	7dc <parsepipe+0x32>

0000000000000818 <parseline>:
{
     818:	7179                	addi	sp,sp,-48
     81a:	f406                	sd	ra,40(sp)
     81c:	f022                	sd	s0,32(sp)
     81e:	ec26                	sd	s1,24(sp)
     820:	e84a                	sd	s2,16(sp)
     822:	e44e                	sd	s3,8(sp)
     824:	e052                	sd	s4,0(sp)
     826:	1800                	addi	s0,sp,48
     828:	892a                	mv	s2,a0
     82a:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     82c:	00000097          	auipc	ra,0x0
     830:	f7e080e7          	jalr	-130(ra) # 7aa <parsepipe>
     834:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     836:	00001a17          	auipc	s4,0x1
     83a:	ba2a0a13          	addi	s4,s4,-1118 # 13d8 <malloc+0x1a2>
     83e:	a839                	j	85c <parseline+0x44>
    gettoken(ps, es, 0, 0);
     840:	4681                	li	a3,0
     842:	4601                	li	a2,0
     844:	85ce                	mv	a1,s3
     846:	854a                	mv	a0,s2
     848:	00000097          	auipc	ra,0x0
     84c:	b96080e7          	jalr	-1130(ra) # 3de <gettoken>
    cmd = backcmd(cmd);
     850:	8526                	mv	a0,s1
     852:	00000097          	auipc	ra,0x0
     856:	b50080e7          	jalr	-1200(ra) # 3a2 <backcmd>
     85a:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     85c:	8652                	mv	a2,s4
     85e:	85ce                	mv	a1,s3
     860:	854a                	mv	a0,s2
     862:	00000097          	auipc	ra,0x0
     866:	cc8080e7          	jalr	-824(ra) # 52a <peek>
     86a:	f979                	bnez	a0,840 <parseline+0x28>
  if(peek(ps, es, ";")){
     86c:	00001617          	auipc	a2,0x1
     870:	b7460613          	addi	a2,a2,-1164 # 13e0 <malloc+0x1aa>
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00000097          	auipc	ra,0x0
     87c:	cb2080e7          	jalr	-846(ra) # 52a <peek>
     880:	e911                	bnez	a0,894 <parseline+0x7c>
}
     882:	8526                	mv	a0,s1
     884:	70a2                	ld	ra,40(sp)
     886:	7402                	ld	s0,32(sp)
     888:	64e2                	ld	s1,24(sp)
     88a:	6942                	ld	s2,16(sp)
     88c:	69a2                	ld	s3,8(sp)
     88e:	6a02                	ld	s4,0(sp)
     890:	6145                	addi	sp,sp,48
     892:	8082                	ret
    gettoken(ps, es, 0, 0);
     894:	4681                	li	a3,0
     896:	4601                	li	a2,0
     898:	85ce                	mv	a1,s3
     89a:	854a                	mv	a0,s2
     89c:	00000097          	auipc	ra,0x0
     8a0:	b42080e7          	jalr	-1214(ra) # 3de <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8a4:	85ce                	mv	a1,s3
     8a6:	854a                	mv	a0,s2
     8a8:	00000097          	auipc	ra,0x0
     8ac:	f70080e7          	jalr	-144(ra) # 818 <parseline>
     8b0:	85aa                	mv	a1,a0
     8b2:	8526                	mv	a0,s1
     8b4:	00000097          	auipc	ra,0x0
     8b8:	aa8080e7          	jalr	-1368(ra) # 35c <listcmd>
     8bc:	84aa                	mv	s1,a0
  return cmd;
     8be:	b7d1                	j	882 <parseline+0x6a>

00000000000008c0 <parseblock>:
{
     8c0:	7179                	addi	sp,sp,-48
     8c2:	f406                	sd	ra,40(sp)
     8c4:	f022                	sd	s0,32(sp)
     8c6:	ec26                	sd	s1,24(sp)
     8c8:	e84a                	sd	s2,16(sp)
     8ca:	e44e                	sd	s3,8(sp)
     8cc:	1800                	addi	s0,sp,48
     8ce:	84aa                	mv	s1,a0
     8d0:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8d2:	00001617          	auipc	a2,0x1
     8d6:	ad660613          	addi	a2,a2,-1322 # 13a8 <malloc+0x172>
     8da:	00000097          	auipc	ra,0x0
     8de:	c50080e7          	jalr	-944(ra) # 52a <peek>
     8e2:	c12d                	beqz	a0,944 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8e4:	4681                	li	a3,0
     8e6:	4601                	li	a2,0
     8e8:	85ca                	mv	a1,s2
     8ea:	8526                	mv	a0,s1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	af2080e7          	jalr	-1294(ra) # 3de <gettoken>
  cmd = parseline(ps, es);
     8f4:	85ca                	mv	a1,s2
     8f6:	8526                	mv	a0,s1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	f20080e7          	jalr	-224(ra) # 818 <parseline>
     900:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     902:	00001617          	auipc	a2,0x1
     906:	af660613          	addi	a2,a2,-1290 # 13f8 <malloc+0x1c2>
     90a:	85ca                	mv	a1,s2
     90c:	8526                	mv	a0,s1
     90e:	00000097          	auipc	ra,0x0
     912:	c1c080e7          	jalr	-996(ra) # 52a <peek>
     916:	cd1d                	beqz	a0,954 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     918:	4681                	li	a3,0
     91a:	4601                	li	a2,0
     91c:	85ca                	mv	a1,s2
     91e:	8526                	mv	a0,s1
     920:	00000097          	auipc	ra,0x0
     924:	abe080e7          	jalr	-1346(ra) # 3de <gettoken>
  cmd = parseredirs(cmd, ps, es);
     928:	864a                	mv	a2,s2
     92a:	85a6                	mv	a1,s1
     92c:	854e                	mv	a0,s3
     92e:	00000097          	auipc	ra,0x0
     932:	c68080e7          	jalr	-920(ra) # 596 <parseredirs>
}
     936:	70a2                	ld	ra,40(sp)
     938:	7402                	ld	s0,32(sp)
     93a:	64e2                	ld	s1,24(sp)
     93c:	6942                	ld	s2,16(sp)
     93e:	69a2                	ld	s3,8(sp)
     940:	6145                	addi	sp,sp,48
     942:	8082                	ret
    panic("parseblock");
     944:	00001517          	auipc	a0,0x1
     948:	aa450513          	addi	a0,a0,-1372 # 13e8 <malloc+0x1b2>
     94c:	fffff097          	auipc	ra,0xfffff
     950:	708080e7          	jalr	1800(ra) # 54 <panic>
    panic("syntax - missing )");
     954:	00001517          	auipc	a0,0x1
     958:	aac50513          	addi	a0,a0,-1364 # 1400 <malloc+0x1ca>
     95c:	fffff097          	auipc	ra,0xfffff
     960:	6f8080e7          	jalr	1784(ra) # 54 <panic>

0000000000000964 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     964:	1101                	addi	sp,sp,-32
     966:	ec06                	sd	ra,24(sp)
     968:	e822                	sd	s0,16(sp)
     96a:	e426                	sd	s1,8(sp)
     96c:	1000                	addi	s0,sp,32
     96e:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     970:	c521                	beqz	a0,9b8 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     972:	4118                	lw	a4,0(a0)
     974:	4795                	li	a5,5
     976:	04e7e163          	bltu	a5,a4,9b8 <nulterminate+0x54>
     97a:	00056783          	lwu	a5,0(a0)
     97e:	078a                	slli	a5,a5,0x2
     980:	00001717          	auipc	a4,0x1
     984:	ae070713          	addi	a4,a4,-1312 # 1460 <malloc+0x22a>
     988:	97ba                	add	a5,a5,a4
     98a:	439c                	lw	a5,0(a5)
     98c:	97ba                	add	a5,a5,a4
     98e:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     990:	651c                	ld	a5,8(a0)
     992:	c39d                	beqz	a5,9b8 <nulterminate+0x54>
     994:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     998:	67b8                	ld	a4,72(a5)
     99a:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     99e:	07a1                	addi	a5,a5,8
     9a0:	ff87b703          	ld	a4,-8(a5)
     9a4:	fb75                	bnez	a4,998 <nulterminate+0x34>
     9a6:	a809                	j	9b8 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     9a8:	6508                	ld	a0,8(a0)
     9aa:	00000097          	auipc	ra,0x0
     9ae:	fba080e7          	jalr	-70(ra) # 964 <nulterminate>
    *rcmd->efile = 0;
     9b2:	6c9c                	ld	a5,24(s1)
     9b4:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9b8:	8526                	mv	a0,s1
     9ba:	60e2                	ld	ra,24(sp)
     9bc:	6442                	ld	s0,16(sp)
     9be:	64a2                	ld	s1,8(sp)
     9c0:	6105                	addi	sp,sp,32
     9c2:	8082                	ret
    nulterminate(pcmd->left);
     9c4:	6508                	ld	a0,8(a0)
     9c6:	00000097          	auipc	ra,0x0
     9ca:	f9e080e7          	jalr	-98(ra) # 964 <nulterminate>
    nulterminate(pcmd->right);
     9ce:	6888                	ld	a0,16(s1)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	f94080e7          	jalr	-108(ra) # 964 <nulterminate>
    break;
     9d8:	b7c5                	j	9b8 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9da:	6508                	ld	a0,8(a0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	f88080e7          	jalr	-120(ra) # 964 <nulterminate>
    nulterminate(lcmd->right);
     9e4:	6888                	ld	a0,16(s1)
     9e6:	00000097          	auipc	ra,0x0
     9ea:	f7e080e7          	jalr	-130(ra) # 964 <nulterminate>
    break;
     9ee:	b7e9                	j	9b8 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9f0:	6508                	ld	a0,8(a0)
     9f2:	00000097          	auipc	ra,0x0
     9f6:	f72080e7          	jalr	-142(ra) # 964 <nulterminate>
    break;
     9fa:	bf7d                	j	9b8 <nulterminate+0x54>

00000000000009fc <parsecmd>:
{
     9fc:	7139                	addi	sp,sp,-64
     9fe:	fc06                	sd	ra,56(sp)
     a00:	f822                	sd	s0,48(sp)
     a02:	f426                	sd	s1,40(sp)
     a04:	f04a                	sd	s2,32(sp)
     a06:	ec4e                	sd	s3,24(sp)
     a08:	0080                	addi	s0,sp,64
     a0a:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     a0e:	84aa                	mv	s1,a0
     a10:	00000097          	auipc	ra,0x0
     a14:	1c4080e7          	jalr	452(ra) # bd4 <strlen>
     a18:	1502                	slli	a0,a0,0x20
     a1a:	9101                	srli	a0,a0,0x20
     a1c:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a1e:	fc840993          	addi	s3,s0,-56
     a22:	85a6                	mv	a1,s1
     a24:	854e                	mv	a0,s3
     a26:	00000097          	auipc	ra,0x0
     a2a:	df2080e7          	jalr	-526(ra) # 818 <parseline>
     a2e:	892a                	mv	s2,a0
  peek(&s, es, "");
     a30:	00001617          	auipc	a2,0x1
     a34:	90860613          	addi	a2,a2,-1784 # 1338 <malloc+0x102>
     a38:	85a6                	mv	a1,s1
     a3a:	854e                	mv	a0,s3
     a3c:	00000097          	auipc	ra,0x0
     a40:	aee080e7          	jalr	-1298(ra) # 52a <peek>
  if(s != es){
     a44:	fc843603          	ld	a2,-56(s0)
     a48:	00961f63          	bne	a2,s1,a66 <parsecmd+0x6a>
  nulterminate(cmd);
     a4c:	854a                	mv	a0,s2
     a4e:	00000097          	auipc	ra,0x0
     a52:	f16080e7          	jalr	-234(ra) # 964 <nulterminate>
}
     a56:	854a                	mv	a0,s2
     a58:	70e2                	ld	ra,56(sp)
     a5a:	7442                	ld	s0,48(sp)
     a5c:	74a2                	ld	s1,40(sp)
     a5e:	7902                	ld	s2,32(sp)
     a60:	69e2                	ld	s3,24(sp)
     a62:	6121                	addi	sp,sp,64
     a64:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a66:	00001597          	auipc	a1,0x1
     a6a:	9b258593          	addi	a1,a1,-1614 # 1418 <malloc+0x1e2>
     a6e:	4509                	li	a0,2
     a70:	00000097          	auipc	ra,0x0
     a74:	6dc080e7          	jalr	1756(ra) # 114c <fprintf>
    panic("syntax");
     a78:	00001517          	auipc	a0,0x1
     a7c:	93850513          	addi	a0,a0,-1736 # 13b0 <malloc+0x17a>
     a80:	fffff097          	auipc	ra,0xfffff
     a84:	5d4080e7          	jalr	1492(ra) # 54 <panic>

0000000000000a88 <main>:
{
     a88:	7139                	addi	sp,sp,-64
     a8a:	fc06                	sd	ra,56(sp)
     a8c:	f822                	sd	s0,48(sp)
     a8e:	f426                	sd	s1,40(sp)
     a90:	f04a                	sd	s2,32(sp)
     a92:	ec4e                	sd	s3,24(sp)
     a94:	e852                	sd	s4,16(sp)
     a96:	e456                	sd	s5,8(sp)
     a98:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a9a:	4489                	li	s1,2
     a9c:	00001917          	auipc	s2,0x1
     aa0:	98c90913          	addi	s2,s2,-1652 # 1428 <malloc+0x1f2>
     aa4:	85a6                	mv	a1,s1
     aa6:	854a                	mv	a0,s2
     aa8:	00000097          	auipc	ra,0x0
     aac:	3bc080e7          	jalr	956(ra) # e64 <open>
     ab0:	00054863          	bltz	a0,ac0 <main+0x38>
    if(fd >= 3){
     ab4:	fea4d8e3          	bge	s1,a0,aa4 <main+0x1c>
      close(fd);
     ab8:	00000097          	auipc	ra,0x0
     abc:	394080e7          	jalr	916(ra) # e4c <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ac0:	00001497          	auipc	s1,0x1
     ac4:	a4048493          	addi	s1,s1,-1472 # 1500 <buf.0>
     ac8:	06400913          	li	s2,100
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     acc:	06300993          	li	s3,99
     ad0:	02000a13          	li	s4,32
     ad4:	a819                	j	aea <main+0x62>
    if(fork1() == 0)
     ad6:	fffff097          	auipc	ra,0xfffff
     ada:	5a4080e7          	jalr	1444(ra) # 7a <fork1>
     ade:	c151                	beqz	a0,b62 <main+0xda>
    wait(0);
     ae0:	4501                	li	a0,0
     ae2:	00000097          	auipc	ra,0x0
     ae6:	34a080e7          	jalr	842(ra) # e2c <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aea:	85ca                	mv	a1,s2
     aec:	8526                	mv	a0,s1
     aee:	fffff097          	auipc	ra,0xfffff
     af2:	512080e7          	jalr	1298(ra) # 0 <getcmd>
     af6:	08054263          	bltz	a0,b7a <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     afa:	0004c783          	lbu	a5,0(s1)
     afe:	fd379ce3          	bne	a5,s3,ad6 <main+0x4e>
     b02:	0014c783          	lbu	a5,1(s1)
     b06:	fd2798e3          	bne	a5,s2,ad6 <main+0x4e>
     b0a:	0024c783          	lbu	a5,2(s1)
     b0e:	fd4794e3          	bne	a5,s4,ad6 <main+0x4e>
      buf[strlen(buf)-1] = 0;  // chop \n
     b12:	00001a97          	auipc	s5,0x1
     b16:	9eea8a93          	addi	s5,s5,-1554 # 1500 <buf.0>
     b1a:	8556                	mv	a0,s5
     b1c:	00000097          	auipc	ra,0x0
     b20:	0b8080e7          	jalr	184(ra) # bd4 <strlen>
     b24:	fff5079b          	addiw	a5,a0,-1
     b28:	1782                	slli	a5,a5,0x20
     b2a:	9381                	srli	a5,a5,0x20
     b2c:	9abe                	add	s5,s5,a5
     b2e:	000a8023          	sb	zero,0(s5)
      if(chdir(buf+3) < 0)
     b32:	00001517          	auipc	a0,0x1
     b36:	9d150513          	addi	a0,a0,-1583 # 1503 <buf.0+0x3>
     b3a:	00000097          	auipc	ra,0x0
     b3e:	35a080e7          	jalr	858(ra) # e94 <chdir>
     b42:	fa0554e3          	bgez	a0,aea <main+0x62>
        fprintf(2, "cannot cd %s\n", buf+3);
     b46:	00001617          	auipc	a2,0x1
     b4a:	9bd60613          	addi	a2,a2,-1603 # 1503 <buf.0+0x3>
     b4e:	00001597          	auipc	a1,0x1
     b52:	8e258593          	addi	a1,a1,-1822 # 1430 <malloc+0x1fa>
     b56:	4509                	li	a0,2
     b58:	00000097          	auipc	ra,0x0
     b5c:	5f4080e7          	jalr	1524(ra) # 114c <fprintf>
     b60:	b769                	j	aea <main+0x62>
      runcmd(parsecmd(buf));
     b62:	00001517          	auipc	a0,0x1
     b66:	99e50513          	addi	a0,a0,-1634 # 1500 <buf.0>
     b6a:	00000097          	auipc	ra,0x0
     b6e:	e92080e7          	jalr	-366(ra) # 9fc <parsecmd>
     b72:	fffff097          	auipc	ra,0xfffff
     b76:	536080e7          	jalr	1334(ra) # a8 <runcmd>
  exit(0);
     b7a:	4501                	li	a0,0
     b7c:	00000097          	auipc	ra,0x0
     b80:	2a8080e7          	jalr	680(ra) # e24 <exit>

0000000000000b84 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b84:	1141                	addi	sp,sp,-16
     b86:	e406                	sd	ra,8(sp)
     b88:	e022                	sd	s0,0(sp)
     b8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b8c:	87aa                	mv	a5,a0
     b8e:	0585                	addi	a1,a1,1
     b90:	0785                	addi	a5,a5,1
     b92:	fff5c703          	lbu	a4,-1(a1)
     b96:	fee78fa3          	sb	a4,-1(a5)
     b9a:	fb75                	bnez	a4,b8e <strcpy+0xa>
    ;
  return os;
}
     b9c:	60a2                	ld	ra,8(sp)
     b9e:	6402                	ld	s0,0(sp)
     ba0:	0141                	addi	sp,sp,16
     ba2:	8082                	ret

0000000000000ba4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba4:	1141                	addi	sp,sp,-16
     ba6:	e406                	sd	ra,8(sp)
     ba8:	e022                	sd	s0,0(sp)
     baa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bac:	00054783          	lbu	a5,0(a0)
     bb0:	cb91                	beqz	a5,bc4 <strcmp+0x20>
     bb2:	0005c703          	lbu	a4,0(a1)
     bb6:	00f71763          	bne	a4,a5,bc4 <strcmp+0x20>
    p++, q++;
     bba:	0505                	addi	a0,a0,1
     bbc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bbe:	00054783          	lbu	a5,0(a0)
     bc2:	fbe5                	bnez	a5,bb2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     bc4:	0005c503          	lbu	a0,0(a1)
}
     bc8:	40a7853b          	subw	a0,a5,a0
     bcc:	60a2                	ld	ra,8(sp)
     bce:	6402                	ld	s0,0(sp)
     bd0:	0141                	addi	sp,sp,16
     bd2:	8082                	ret

0000000000000bd4 <strlen>:

uint
strlen(const char *s)
{
     bd4:	1141                	addi	sp,sp,-16
     bd6:	e406                	sd	ra,8(sp)
     bd8:	e022                	sd	s0,0(sp)
     bda:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bdc:	00054783          	lbu	a5,0(a0)
     be0:	cf99                	beqz	a5,bfe <strlen+0x2a>
     be2:	0505                	addi	a0,a0,1
     be4:	87aa                	mv	a5,a0
     be6:	86be                	mv	a3,a5
     be8:	0785                	addi	a5,a5,1
     bea:	fff7c703          	lbu	a4,-1(a5)
     bee:	ff65                	bnez	a4,be6 <strlen+0x12>
     bf0:	40a6853b          	subw	a0,a3,a0
     bf4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     bf6:	60a2                	ld	ra,8(sp)
     bf8:	6402                	ld	s0,0(sp)
     bfa:	0141                	addi	sp,sp,16
     bfc:	8082                	ret
  for(n = 0; s[n]; n++)
     bfe:	4501                	li	a0,0
     c00:	bfdd                	j	bf6 <strlen+0x22>

0000000000000c02 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c02:	1141                	addi	sp,sp,-16
     c04:	e406                	sd	ra,8(sp)
     c06:	e022                	sd	s0,0(sp)
     c08:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c0a:	ca19                	beqz	a2,c20 <memset+0x1e>
     c0c:	87aa                	mv	a5,a0
     c0e:	1602                	slli	a2,a2,0x20
     c10:	9201                	srli	a2,a2,0x20
     c12:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c16:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c1a:	0785                	addi	a5,a5,1
     c1c:	fee79de3          	bne	a5,a4,c16 <memset+0x14>
  }
  return dst;
}
     c20:	60a2                	ld	ra,8(sp)
     c22:	6402                	ld	s0,0(sp)
     c24:	0141                	addi	sp,sp,16
     c26:	8082                	ret

0000000000000c28 <strchr>:

char*
strchr(const char *s, char c)
{
     c28:	1141                	addi	sp,sp,-16
     c2a:	e406                	sd	ra,8(sp)
     c2c:	e022                	sd	s0,0(sp)
     c2e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c30:	00054783          	lbu	a5,0(a0)
     c34:	cf81                	beqz	a5,c4c <strchr+0x24>
    if(*s == c)
     c36:	00f58763          	beq	a1,a5,c44 <strchr+0x1c>
  for(; *s; s++)
     c3a:	0505                	addi	a0,a0,1
     c3c:	00054783          	lbu	a5,0(a0)
     c40:	fbfd                	bnez	a5,c36 <strchr+0xe>
      return (char*)s;
  return 0;
     c42:	4501                	li	a0,0
}
     c44:	60a2                	ld	ra,8(sp)
     c46:	6402                	ld	s0,0(sp)
     c48:	0141                	addi	sp,sp,16
     c4a:	8082                	ret
  return 0;
     c4c:	4501                	li	a0,0
     c4e:	bfdd                	j	c44 <strchr+0x1c>

0000000000000c50 <gets>:

char*
gets(char *buf, int max)
{
     c50:	7159                	addi	sp,sp,-112
     c52:	f486                	sd	ra,104(sp)
     c54:	f0a2                	sd	s0,96(sp)
     c56:	eca6                	sd	s1,88(sp)
     c58:	e8ca                	sd	s2,80(sp)
     c5a:	e4ce                	sd	s3,72(sp)
     c5c:	e0d2                	sd	s4,64(sp)
     c5e:	fc56                	sd	s5,56(sp)
     c60:	f85a                	sd	s6,48(sp)
     c62:	f45e                	sd	s7,40(sp)
     c64:	f062                	sd	s8,32(sp)
     c66:	ec66                	sd	s9,24(sp)
     c68:	e86a                	sd	s10,16(sp)
     c6a:	1880                	addi	s0,sp,112
     c6c:	8caa                	mv	s9,a0
     c6e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c70:	892a                	mv	s2,a0
     c72:	4481                	li	s1,0
    cc = read(0, &c, 1);
     c74:	f9f40b13          	addi	s6,s0,-97
     c78:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c7a:	4ba9                	li	s7,10
     c7c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     c7e:	8d26                	mv	s10,s1
     c80:	0014899b          	addiw	s3,s1,1
     c84:	84ce                	mv	s1,s3
     c86:	0349d763          	bge	s3,s4,cb4 <gets+0x64>
    cc = read(0, &c, 1);
     c8a:	8656                	mv	a2,s5
     c8c:	85da                	mv	a1,s6
     c8e:	4501                	li	a0,0
     c90:	00000097          	auipc	ra,0x0
     c94:	1ac080e7          	jalr	428(ra) # e3c <read>
    if(cc < 1)
     c98:	00a05e63          	blez	a0,cb4 <gets+0x64>
    buf[i++] = c;
     c9c:	f9f44783          	lbu	a5,-97(s0)
     ca0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ca4:	01778763          	beq	a5,s7,cb2 <gets+0x62>
     ca8:	0905                	addi	s2,s2,1
     caa:	fd879ae3          	bne	a5,s8,c7e <gets+0x2e>
    buf[i++] = c;
     cae:	8d4e                	mv	s10,s3
     cb0:	a011                	j	cb4 <gets+0x64>
     cb2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     cb4:	9d66                	add	s10,s10,s9
     cb6:	000d0023          	sb	zero,0(s10)
  return buf;
}
     cba:	8566                	mv	a0,s9
     cbc:	70a6                	ld	ra,104(sp)
     cbe:	7406                	ld	s0,96(sp)
     cc0:	64e6                	ld	s1,88(sp)
     cc2:	6946                	ld	s2,80(sp)
     cc4:	69a6                	ld	s3,72(sp)
     cc6:	6a06                	ld	s4,64(sp)
     cc8:	7ae2                	ld	s5,56(sp)
     cca:	7b42                	ld	s6,48(sp)
     ccc:	7ba2                	ld	s7,40(sp)
     cce:	7c02                	ld	s8,32(sp)
     cd0:	6ce2                	ld	s9,24(sp)
     cd2:	6d42                	ld	s10,16(sp)
     cd4:	6165                	addi	sp,sp,112
     cd6:	8082                	ret

0000000000000cd8 <stat>:

int
stat(const char *n, struct stat *st)
{
     cd8:	1101                	addi	sp,sp,-32
     cda:	ec06                	sd	ra,24(sp)
     cdc:	e822                	sd	s0,16(sp)
     cde:	e04a                	sd	s2,0(sp)
     ce0:	1000                	addi	s0,sp,32
     ce2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ce4:	4581                	li	a1,0
     ce6:	00000097          	auipc	ra,0x0
     cea:	17e080e7          	jalr	382(ra) # e64 <open>
  if(fd < 0)
     cee:	02054663          	bltz	a0,d1a <stat+0x42>
     cf2:	e426                	sd	s1,8(sp)
     cf4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cf6:	85ca                	mv	a1,s2
     cf8:	00000097          	auipc	ra,0x0
     cfc:	184080e7          	jalr	388(ra) # e7c <fstat>
     d00:	892a                	mv	s2,a0
  close(fd);
     d02:	8526                	mv	a0,s1
     d04:	00000097          	auipc	ra,0x0
     d08:	148080e7          	jalr	328(ra) # e4c <close>
  return r;
     d0c:	64a2                	ld	s1,8(sp)
}
     d0e:	854a                	mv	a0,s2
     d10:	60e2                	ld	ra,24(sp)
     d12:	6442                	ld	s0,16(sp)
     d14:	6902                	ld	s2,0(sp)
     d16:	6105                	addi	sp,sp,32
     d18:	8082                	ret
    return -1;
     d1a:	597d                	li	s2,-1
     d1c:	bfcd                	j	d0e <stat+0x36>

0000000000000d1e <atoi>:

int
atoi(const char *s)
{
     d1e:	1141                	addi	sp,sp,-16
     d20:	e406                	sd	ra,8(sp)
     d22:	e022                	sd	s0,0(sp)
     d24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d26:	00054683          	lbu	a3,0(a0)
     d2a:	fd06879b          	addiw	a5,a3,-48
     d2e:	0ff7f793          	zext.b	a5,a5
     d32:	4625                	li	a2,9
     d34:	02f66963          	bltu	a2,a5,d66 <atoi+0x48>
     d38:	872a                	mv	a4,a0
  n = 0;
     d3a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d3c:	0705                	addi	a4,a4,1
     d3e:	0025179b          	slliw	a5,a0,0x2
     d42:	9fa9                	addw	a5,a5,a0
     d44:	0017979b          	slliw	a5,a5,0x1
     d48:	9fb5                	addw	a5,a5,a3
     d4a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d4e:	00074683          	lbu	a3,0(a4)
     d52:	fd06879b          	addiw	a5,a3,-48
     d56:	0ff7f793          	zext.b	a5,a5
     d5a:	fef671e3          	bgeu	a2,a5,d3c <atoi+0x1e>
  return n;
}
     d5e:	60a2                	ld	ra,8(sp)
     d60:	6402                	ld	s0,0(sp)
     d62:	0141                	addi	sp,sp,16
     d64:	8082                	ret
  n = 0;
     d66:	4501                	li	a0,0
     d68:	bfdd                	j	d5e <atoi+0x40>

0000000000000d6a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d6a:	1141                	addi	sp,sp,-16
     d6c:	e406                	sd	ra,8(sp)
     d6e:	e022                	sd	s0,0(sp)
     d70:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d72:	02b57563          	bgeu	a0,a1,d9c <memmove+0x32>
    while(n-- > 0)
     d76:	00c05f63          	blez	a2,d94 <memmove+0x2a>
     d7a:	1602                	slli	a2,a2,0x20
     d7c:	9201                	srli	a2,a2,0x20
     d7e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d82:	872a                	mv	a4,a0
      *dst++ = *src++;
     d84:	0585                	addi	a1,a1,1
     d86:	0705                	addi	a4,a4,1
     d88:	fff5c683          	lbu	a3,-1(a1)
     d8c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d90:	fee79ae3          	bne	a5,a4,d84 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d94:	60a2                	ld	ra,8(sp)
     d96:	6402                	ld	s0,0(sp)
     d98:	0141                	addi	sp,sp,16
     d9a:	8082                	ret
    dst += n;
     d9c:	00c50733          	add	a4,a0,a2
    src += n;
     da0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     da2:	fec059e3          	blez	a2,d94 <memmove+0x2a>
     da6:	fff6079b          	addiw	a5,a2,-1
     daa:	1782                	slli	a5,a5,0x20
     dac:	9381                	srli	a5,a5,0x20
     dae:	fff7c793          	not	a5,a5
     db2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     db4:	15fd                	addi	a1,a1,-1
     db6:	177d                	addi	a4,a4,-1
     db8:	0005c683          	lbu	a3,0(a1)
     dbc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dc0:	fef71ae3          	bne	a4,a5,db4 <memmove+0x4a>
     dc4:	bfc1                	j	d94 <memmove+0x2a>

0000000000000dc6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dc6:	1141                	addi	sp,sp,-16
     dc8:	e406                	sd	ra,8(sp)
     dca:	e022                	sd	s0,0(sp)
     dcc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dce:	ca0d                	beqz	a2,e00 <memcmp+0x3a>
     dd0:	fff6069b          	addiw	a3,a2,-1
     dd4:	1682                	slli	a3,a3,0x20
     dd6:	9281                	srli	a3,a3,0x20
     dd8:	0685                	addi	a3,a3,1
     dda:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ddc:	00054783          	lbu	a5,0(a0)
     de0:	0005c703          	lbu	a4,0(a1)
     de4:	00e79863          	bne	a5,a4,df4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     de8:	0505                	addi	a0,a0,1
    p2++;
     dea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dec:	fed518e3          	bne	a0,a3,ddc <memcmp+0x16>
  }
  return 0;
     df0:	4501                	li	a0,0
     df2:	a019                	j	df8 <memcmp+0x32>
      return *p1 - *p2;
     df4:	40e7853b          	subw	a0,a5,a4
}
     df8:	60a2                	ld	ra,8(sp)
     dfa:	6402                	ld	s0,0(sp)
     dfc:	0141                	addi	sp,sp,16
     dfe:	8082                	ret
  return 0;
     e00:	4501                	li	a0,0
     e02:	bfdd                	j	df8 <memcmp+0x32>

0000000000000e04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e04:	1141                	addi	sp,sp,-16
     e06:	e406                	sd	ra,8(sp)
     e08:	e022                	sd	s0,0(sp)
     e0a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e0c:	00000097          	auipc	ra,0x0
     e10:	f5e080e7          	jalr	-162(ra) # d6a <memmove>
}
     e14:	60a2                	ld	ra,8(sp)
     e16:	6402                	ld	s0,0(sp)
     e18:	0141                	addi	sp,sp,16
     e1a:	8082                	ret

0000000000000e1c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e1c:	4885                	li	a7,1
 ecall
     e1e:	00000073          	ecall
 ret
     e22:	8082                	ret

0000000000000e24 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e24:	4889                	li	a7,2
 ecall
     e26:	00000073          	ecall
 ret
     e2a:	8082                	ret

0000000000000e2c <wait>:
.global wait
wait:
 li a7, SYS_wait
     e2c:	488d                	li	a7,3
 ecall
     e2e:	00000073          	ecall
 ret
     e32:	8082                	ret

0000000000000e34 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e34:	4891                	li	a7,4
 ecall
     e36:	00000073          	ecall
 ret
     e3a:	8082                	ret

0000000000000e3c <read>:
.global read
read:
 li a7, SYS_read
     e3c:	4895                	li	a7,5
 ecall
     e3e:	00000073          	ecall
 ret
     e42:	8082                	ret

0000000000000e44 <write>:
.global write
write:
 li a7, SYS_write
     e44:	48c1                	li	a7,16
 ecall
     e46:	00000073          	ecall
 ret
     e4a:	8082                	ret

0000000000000e4c <close>:
.global close
close:
 li a7, SYS_close
     e4c:	48d5                	li	a7,21
 ecall
     e4e:	00000073          	ecall
 ret
     e52:	8082                	ret

0000000000000e54 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e54:	4899                	li	a7,6
 ecall
     e56:	00000073          	ecall
 ret
     e5a:	8082                	ret

0000000000000e5c <exec>:
.global exec
exec:
 li a7, SYS_exec
     e5c:	489d                	li	a7,7
 ecall
     e5e:	00000073          	ecall
 ret
     e62:	8082                	ret

0000000000000e64 <open>:
.global open
open:
 li a7, SYS_open
     e64:	48bd                	li	a7,15
 ecall
     e66:	00000073          	ecall
 ret
     e6a:	8082                	ret

0000000000000e6c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e6c:	48c5                	li	a7,17
 ecall
     e6e:	00000073          	ecall
 ret
     e72:	8082                	ret

0000000000000e74 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e74:	48c9                	li	a7,18
 ecall
     e76:	00000073          	ecall
 ret
     e7a:	8082                	ret

0000000000000e7c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e7c:	48a1                	li	a7,8
 ecall
     e7e:	00000073          	ecall
 ret
     e82:	8082                	ret

0000000000000e84 <link>:
.global link
link:
 li a7, SYS_link
     e84:	48cd                	li	a7,19
 ecall
     e86:	00000073          	ecall
 ret
     e8a:	8082                	ret

0000000000000e8c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e8c:	48d1                	li	a7,20
 ecall
     e8e:	00000073          	ecall
 ret
     e92:	8082                	ret

0000000000000e94 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e94:	48a5                	li	a7,9
 ecall
     e96:	00000073          	ecall
 ret
     e9a:	8082                	ret

0000000000000e9c <dup>:
.global dup
dup:
 li a7, SYS_dup
     e9c:	48a9                	li	a7,10
 ecall
     e9e:	00000073          	ecall
 ret
     ea2:	8082                	ret

0000000000000ea4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ea4:	48ad                	li	a7,11
 ecall
     ea6:	00000073          	ecall
 ret
     eaa:	8082                	ret

0000000000000eac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     eac:	48b1                	li	a7,12
 ecall
     eae:	00000073          	ecall
 ret
     eb2:	8082                	ret

0000000000000eb4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     eb4:	48b5                	li	a7,13
 ecall
     eb6:	00000073          	ecall
 ret
     eba:	8082                	ret

0000000000000ebc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ebc:	48b9                	li	a7,14
 ecall
     ebe:	00000073          	ecall
 ret
     ec2:	8082                	ret

0000000000000ec4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ec4:	1101                	addi	sp,sp,-32
     ec6:	ec06                	sd	ra,24(sp)
     ec8:	e822                	sd	s0,16(sp)
     eca:	1000                	addi	s0,sp,32
     ecc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ed0:	4605                	li	a2,1
     ed2:	fef40593          	addi	a1,s0,-17
     ed6:	00000097          	auipc	ra,0x0
     eda:	f6e080e7          	jalr	-146(ra) # e44 <write>
}
     ede:	60e2                	ld	ra,24(sp)
     ee0:	6442                	ld	s0,16(sp)
     ee2:	6105                	addi	sp,sp,32
     ee4:	8082                	ret

0000000000000ee6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ee6:	7139                	addi	sp,sp,-64
     ee8:	fc06                	sd	ra,56(sp)
     eea:	f822                	sd	s0,48(sp)
     eec:	f426                	sd	s1,40(sp)
     eee:	f04a                	sd	s2,32(sp)
     ef0:	ec4e                	sd	s3,24(sp)
     ef2:	0080                	addi	s0,sp,64
     ef4:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ef6:	c299                	beqz	a3,efc <printint+0x16>
     ef8:	0805c063          	bltz	a1,f78 <printint+0x92>
  neg = 0;
     efc:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     efe:	fc040313          	addi	t1,s0,-64
  neg = 0;
     f02:	869a                	mv	a3,t1
  i = 0;
     f04:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     f06:	00000817          	auipc	a6,0x0
     f0a:	5ca80813          	addi	a6,a6,1482 # 14d0 <digits>
     f0e:	88be                	mv	a7,a5
     f10:	0017851b          	addiw	a0,a5,1
     f14:	87aa                	mv	a5,a0
     f16:	02c5f73b          	remuw	a4,a1,a2
     f1a:	1702                	slli	a4,a4,0x20
     f1c:	9301                	srli	a4,a4,0x20
     f1e:	9742                	add	a4,a4,a6
     f20:	00074703          	lbu	a4,0(a4)
     f24:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     f28:	872e                	mv	a4,a1
     f2a:	02c5d5bb          	divuw	a1,a1,a2
     f2e:	0685                	addi	a3,a3,1
     f30:	fcc77fe3          	bgeu	a4,a2,f0e <printint+0x28>
  if(neg)
     f34:	000e0c63          	beqz	t3,f4c <printint+0x66>
    buf[i++] = '-';
     f38:	fd050793          	addi	a5,a0,-48
     f3c:	00878533          	add	a0,a5,s0
     f40:	02d00793          	li	a5,45
     f44:	fef50823          	sb	a5,-16(a0)
     f48:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     f4c:	fff7899b          	addiw	s3,a5,-1
     f50:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     f54:	fff4c583          	lbu	a1,-1(s1)
     f58:	854a                	mv	a0,s2
     f5a:	00000097          	auipc	ra,0x0
     f5e:	f6a080e7          	jalr	-150(ra) # ec4 <putc>
  while(--i >= 0)
     f62:	39fd                	addiw	s3,s3,-1
     f64:	14fd                	addi	s1,s1,-1
     f66:	fe09d7e3          	bgez	s3,f54 <printint+0x6e>
}
     f6a:	70e2                	ld	ra,56(sp)
     f6c:	7442                	ld	s0,48(sp)
     f6e:	74a2                	ld	s1,40(sp)
     f70:	7902                	ld	s2,32(sp)
     f72:	69e2                	ld	s3,24(sp)
     f74:	6121                	addi	sp,sp,64
     f76:	8082                	ret
    x = -xx;
     f78:	40b005bb          	negw	a1,a1
    neg = 1;
     f7c:	4e05                	li	t3,1
    x = -xx;
     f7e:	b741                	j	efe <printint+0x18>

0000000000000f80 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f80:	715d                	addi	sp,sp,-80
     f82:	e486                	sd	ra,72(sp)
     f84:	e0a2                	sd	s0,64(sp)
     f86:	f84a                	sd	s2,48(sp)
     f88:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f8a:	0005c903          	lbu	s2,0(a1)
     f8e:	1a090a63          	beqz	s2,1142 <vprintf+0x1c2>
     f92:	fc26                	sd	s1,56(sp)
     f94:	f44e                	sd	s3,40(sp)
     f96:	f052                	sd	s4,32(sp)
     f98:	ec56                	sd	s5,24(sp)
     f9a:	e85a                	sd	s6,16(sp)
     f9c:	e45e                	sd	s7,8(sp)
     f9e:	8aaa                	mv	s5,a0
     fa0:	8bb2                	mv	s7,a2
     fa2:	00158493          	addi	s1,a1,1
  state = 0;
     fa6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fa8:	02500a13          	li	s4,37
     fac:	4b55                	li	s6,21
     fae:	a839                	j	fcc <vprintf+0x4c>
        putc(fd, c);
     fb0:	85ca                	mv	a1,s2
     fb2:	8556                	mv	a0,s5
     fb4:	00000097          	auipc	ra,0x0
     fb8:	f10080e7          	jalr	-240(ra) # ec4 <putc>
     fbc:	a019                	j	fc2 <vprintf+0x42>
    } else if(state == '%'){
     fbe:	01498d63          	beq	s3,s4,fd8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     fc2:	0485                	addi	s1,s1,1
     fc4:	fff4c903          	lbu	s2,-1(s1)
     fc8:	16090763          	beqz	s2,1136 <vprintf+0x1b6>
    if(state == 0){
     fcc:	fe0999e3          	bnez	s3,fbe <vprintf+0x3e>
      if(c == '%'){
     fd0:	ff4910e3          	bne	s2,s4,fb0 <vprintf+0x30>
        state = '%';
     fd4:	89d2                	mv	s3,s4
     fd6:	b7f5                	j	fc2 <vprintf+0x42>
      if(c == 'd'){
     fd8:	13490463          	beq	s2,s4,1100 <vprintf+0x180>
     fdc:	f9d9079b          	addiw	a5,s2,-99
     fe0:	0ff7f793          	zext.b	a5,a5
     fe4:	12fb6763          	bltu	s6,a5,1112 <vprintf+0x192>
     fe8:	f9d9079b          	addiw	a5,s2,-99
     fec:	0ff7f713          	zext.b	a4,a5
     ff0:	12eb6163          	bltu	s6,a4,1112 <vprintf+0x192>
     ff4:	00271793          	slli	a5,a4,0x2
     ff8:	00000717          	auipc	a4,0x0
     ffc:	48070713          	addi	a4,a4,1152 # 1478 <malloc+0x242>
    1000:	97ba                	add	a5,a5,a4
    1002:	439c                	lw	a5,0(a5)
    1004:	97ba                	add	a5,a5,a4
    1006:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1008:	008b8913          	addi	s2,s7,8
    100c:	4685                	li	a3,1
    100e:	4629                	li	a2,10
    1010:	000ba583          	lw	a1,0(s7)
    1014:	8556                	mv	a0,s5
    1016:	00000097          	auipc	ra,0x0
    101a:	ed0080e7          	jalr	-304(ra) # ee6 <printint>
    101e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1020:	4981                	li	s3,0
    1022:	b745                	j	fc2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1024:	008b8913          	addi	s2,s7,8
    1028:	4681                	li	a3,0
    102a:	4629                	li	a2,10
    102c:	000ba583          	lw	a1,0(s7)
    1030:	8556                	mv	a0,s5
    1032:	00000097          	auipc	ra,0x0
    1036:	eb4080e7          	jalr	-332(ra) # ee6 <printint>
    103a:	8bca                	mv	s7,s2
      state = 0;
    103c:	4981                	li	s3,0
    103e:	b751                	j	fc2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1040:	008b8913          	addi	s2,s7,8
    1044:	4681                	li	a3,0
    1046:	4641                	li	a2,16
    1048:	000ba583          	lw	a1,0(s7)
    104c:	8556                	mv	a0,s5
    104e:	00000097          	auipc	ra,0x0
    1052:	e98080e7          	jalr	-360(ra) # ee6 <printint>
    1056:	8bca                	mv	s7,s2
      state = 0;
    1058:	4981                	li	s3,0
    105a:	b7a5                	j	fc2 <vprintf+0x42>
    105c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    105e:	008b8c13          	addi	s8,s7,8
    1062:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1066:	03000593          	li	a1,48
    106a:	8556                	mv	a0,s5
    106c:	00000097          	auipc	ra,0x0
    1070:	e58080e7          	jalr	-424(ra) # ec4 <putc>
  putc(fd, 'x');
    1074:	07800593          	li	a1,120
    1078:	8556                	mv	a0,s5
    107a:	00000097          	auipc	ra,0x0
    107e:	e4a080e7          	jalr	-438(ra) # ec4 <putc>
    1082:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1084:	00000b97          	auipc	s7,0x0
    1088:	44cb8b93          	addi	s7,s7,1100 # 14d0 <digits>
    108c:	03c9d793          	srli	a5,s3,0x3c
    1090:	97de                	add	a5,a5,s7
    1092:	0007c583          	lbu	a1,0(a5)
    1096:	8556                	mv	a0,s5
    1098:	00000097          	auipc	ra,0x0
    109c:	e2c080e7          	jalr	-468(ra) # ec4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10a0:	0992                	slli	s3,s3,0x4
    10a2:	397d                	addiw	s2,s2,-1
    10a4:	fe0914e3          	bnez	s2,108c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    10a8:	8be2                	mv	s7,s8
      state = 0;
    10aa:	4981                	li	s3,0
    10ac:	6c02                	ld	s8,0(sp)
    10ae:	bf11                	j	fc2 <vprintf+0x42>
        s = va_arg(ap, char*);
    10b0:	008b8993          	addi	s3,s7,8
    10b4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10b8:	02090163          	beqz	s2,10da <vprintf+0x15a>
        while(*s != 0){
    10bc:	00094583          	lbu	a1,0(s2)
    10c0:	c9a5                	beqz	a1,1130 <vprintf+0x1b0>
          putc(fd, *s);
    10c2:	8556                	mv	a0,s5
    10c4:	00000097          	auipc	ra,0x0
    10c8:	e00080e7          	jalr	-512(ra) # ec4 <putc>
          s++;
    10cc:	0905                	addi	s2,s2,1
        while(*s != 0){
    10ce:	00094583          	lbu	a1,0(s2)
    10d2:	f9e5                	bnez	a1,10c2 <vprintf+0x142>
        s = va_arg(ap, char*);
    10d4:	8bce                	mv	s7,s3
      state = 0;
    10d6:	4981                	li	s3,0
    10d8:	b5ed                	j	fc2 <vprintf+0x42>
          s = "(null)";
    10da:	00000917          	auipc	s2,0x0
    10de:	36690913          	addi	s2,s2,870 # 1440 <malloc+0x20a>
        while(*s != 0){
    10e2:	02800593          	li	a1,40
    10e6:	bff1                	j	10c2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    10e8:	008b8913          	addi	s2,s7,8
    10ec:	000bc583          	lbu	a1,0(s7)
    10f0:	8556                	mv	a0,s5
    10f2:	00000097          	auipc	ra,0x0
    10f6:	dd2080e7          	jalr	-558(ra) # ec4 <putc>
    10fa:	8bca                	mv	s7,s2
      state = 0;
    10fc:	4981                	li	s3,0
    10fe:	b5d1                	j	fc2 <vprintf+0x42>
        putc(fd, c);
    1100:	02500593          	li	a1,37
    1104:	8556                	mv	a0,s5
    1106:	00000097          	auipc	ra,0x0
    110a:	dbe080e7          	jalr	-578(ra) # ec4 <putc>
      state = 0;
    110e:	4981                	li	s3,0
    1110:	bd4d                	j	fc2 <vprintf+0x42>
        putc(fd, '%');
    1112:	02500593          	li	a1,37
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	dac080e7          	jalr	-596(ra) # ec4 <putc>
        putc(fd, c);
    1120:	85ca                	mv	a1,s2
    1122:	8556                	mv	a0,s5
    1124:	00000097          	auipc	ra,0x0
    1128:	da0080e7          	jalr	-608(ra) # ec4 <putc>
      state = 0;
    112c:	4981                	li	s3,0
    112e:	bd51                	j	fc2 <vprintf+0x42>
        s = va_arg(ap, char*);
    1130:	8bce                	mv	s7,s3
      state = 0;
    1132:	4981                	li	s3,0
    1134:	b579                	j	fc2 <vprintf+0x42>
    1136:	74e2                	ld	s1,56(sp)
    1138:	79a2                	ld	s3,40(sp)
    113a:	7a02                	ld	s4,32(sp)
    113c:	6ae2                	ld	s5,24(sp)
    113e:	6b42                	ld	s6,16(sp)
    1140:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1142:	60a6                	ld	ra,72(sp)
    1144:	6406                	ld	s0,64(sp)
    1146:	7942                	ld	s2,48(sp)
    1148:	6161                	addi	sp,sp,80
    114a:	8082                	ret

000000000000114c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    114c:	715d                	addi	sp,sp,-80
    114e:	ec06                	sd	ra,24(sp)
    1150:	e822                	sd	s0,16(sp)
    1152:	1000                	addi	s0,sp,32
    1154:	e010                	sd	a2,0(s0)
    1156:	e414                	sd	a3,8(s0)
    1158:	e818                	sd	a4,16(s0)
    115a:	ec1c                	sd	a5,24(s0)
    115c:	03043023          	sd	a6,32(s0)
    1160:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1164:	8622                	mv	a2,s0
    1166:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    116a:	00000097          	auipc	ra,0x0
    116e:	e16080e7          	jalr	-490(ra) # f80 <vprintf>
}
    1172:	60e2                	ld	ra,24(sp)
    1174:	6442                	ld	s0,16(sp)
    1176:	6161                	addi	sp,sp,80
    1178:	8082                	ret

000000000000117a <printf>:

void
printf(const char *fmt, ...)
{
    117a:	711d                	addi	sp,sp,-96
    117c:	ec06                	sd	ra,24(sp)
    117e:	e822                	sd	s0,16(sp)
    1180:	1000                	addi	s0,sp,32
    1182:	e40c                	sd	a1,8(s0)
    1184:	e810                	sd	a2,16(s0)
    1186:	ec14                	sd	a3,24(s0)
    1188:	f018                	sd	a4,32(s0)
    118a:	f41c                	sd	a5,40(s0)
    118c:	03043823          	sd	a6,48(s0)
    1190:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1194:	00840613          	addi	a2,s0,8
    1198:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    119c:	85aa                	mv	a1,a0
    119e:	4505                	li	a0,1
    11a0:	00000097          	auipc	ra,0x0
    11a4:	de0080e7          	jalr	-544(ra) # f80 <vprintf>
}
    11a8:	60e2                	ld	ra,24(sp)
    11aa:	6442                	ld	s0,16(sp)
    11ac:	6125                	addi	sp,sp,96
    11ae:	8082                	ret

00000000000011b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11b0:	1141                	addi	sp,sp,-16
    11b2:	e406                	sd	ra,8(sp)
    11b4:	e022                	sd	s0,0(sp)
    11b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11bc:	00000797          	auipc	a5,0x0
    11c0:	33c7b783          	ld	a5,828(a5) # 14f8 <freep>
    11c4:	a02d                	j	11ee <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11c6:	4618                	lw	a4,8(a2)
    11c8:	9f2d                	addw	a4,a4,a1
    11ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11ce:	6398                	ld	a4,0(a5)
    11d0:	6310                	ld	a2,0(a4)
    11d2:	a83d                	j	1210 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11d4:	ff852703          	lw	a4,-8(a0)
    11d8:	9f31                	addw	a4,a4,a2
    11da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11dc:	ff053683          	ld	a3,-16(a0)
    11e0:	a091                	j	1224 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11e2:	6398                	ld	a4,0(a5)
    11e4:	00e7e463          	bltu	a5,a4,11ec <free+0x3c>
    11e8:	00e6ea63          	bltu	a3,a4,11fc <free+0x4c>
{
    11ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ee:	fed7fae3          	bgeu	a5,a3,11e2 <free+0x32>
    11f2:	6398                	ld	a4,0(a5)
    11f4:	00e6e463          	bltu	a3,a4,11fc <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f8:	fee7eae3          	bltu	a5,a4,11ec <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    11fc:	ff852583          	lw	a1,-8(a0)
    1200:	6390                	ld	a2,0(a5)
    1202:	02059813          	slli	a6,a1,0x20
    1206:	01c85713          	srli	a4,a6,0x1c
    120a:	9736                	add	a4,a4,a3
    120c:	fae60de3          	beq	a2,a4,11c6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1210:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1214:	4790                	lw	a2,8(a5)
    1216:	02061593          	slli	a1,a2,0x20
    121a:	01c5d713          	srli	a4,a1,0x1c
    121e:	973e                	add	a4,a4,a5
    1220:	fae68ae3          	beq	a3,a4,11d4 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1224:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1226:	00000717          	auipc	a4,0x0
    122a:	2cf73923          	sd	a5,722(a4) # 14f8 <freep>
}
    122e:	60a2                	ld	ra,8(sp)
    1230:	6402                	ld	s0,0(sp)
    1232:	0141                	addi	sp,sp,16
    1234:	8082                	ret

0000000000001236 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1236:	7139                	addi	sp,sp,-64
    1238:	fc06                	sd	ra,56(sp)
    123a:	f822                	sd	s0,48(sp)
    123c:	f04a                	sd	s2,32(sp)
    123e:	ec4e                	sd	s3,24(sp)
    1240:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1242:	02051993          	slli	s3,a0,0x20
    1246:	0209d993          	srli	s3,s3,0x20
    124a:	09bd                	addi	s3,s3,15
    124c:	0049d993          	srli	s3,s3,0x4
    1250:	2985                	addiw	s3,s3,1
    1252:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1254:	00000517          	auipc	a0,0x0
    1258:	2a453503          	ld	a0,676(a0) # 14f8 <freep>
    125c:	c905                	beqz	a0,128c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    125e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1260:	4798                	lw	a4,8(a5)
    1262:	09377a63          	bgeu	a4,s3,12f6 <malloc+0xc0>
    1266:	f426                	sd	s1,40(sp)
    1268:	e852                	sd	s4,16(sp)
    126a:	e456                	sd	s5,8(sp)
    126c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    126e:	8a4e                	mv	s4,s3
    1270:	6705                	lui	a4,0x1
    1272:	00e9f363          	bgeu	s3,a4,1278 <malloc+0x42>
    1276:	6a05                	lui	s4,0x1
    1278:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    127c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1280:	00000497          	auipc	s1,0x0
    1284:	27848493          	addi	s1,s1,632 # 14f8 <freep>
  if(p == (char*)-1)
    1288:	5afd                	li	s5,-1
    128a:	a089                	j	12cc <malloc+0x96>
    128c:	f426                	sd	s1,40(sp)
    128e:	e852                	sd	s4,16(sp)
    1290:	e456                	sd	s5,8(sp)
    1292:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1294:	00000797          	auipc	a5,0x0
    1298:	2d478793          	addi	a5,a5,724 # 1568 <base>
    129c:	00000717          	auipc	a4,0x0
    12a0:	24f73e23          	sd	a5,604(a4) # 14f8 <freep>
    12a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12aa:	b7d1                	j	126e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    12ac:	6398                	ld	a4,0(a5)
    12ae:	e118                	sd	a4,0(a0)
    12b0:	a8b9                	j	130e <malloc+0xd8>
  hp->s.size = nu;
    12b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12b6:	0541                	addi	a0,a0,16
    12b8:	00000097          	auipc	ra,0x0
    12bc:	ef8080e7          	jalr	-264(ra) # 11b0 <free>
  return freep;
    12c0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    12c2:	c135                	beqz	a0,1326 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12c6:	4798                	lw	a4,8(a5)
    12c8:	03277363          	bgeu	a4,s2,12ee <malloc+0xb8>
    if(p == freep)
    12cc:	6098                	ld	a4,0(s1)
    12ce:	853e                	mv	a0,a5
    12d0:	fef71ae3          	bne	a4,a5,12c4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    12d4:	8552                	mv	a0,s4
    12d6:	00000097          	auipc	ra,0x0
    12da:	bd6080e7          	jalr	-1066(ra) # eac <sbrk>
  if(p == (char*)-1)
    12de:	fd551ae3          	bne	a0,s5,12b2 <malloc+0x7c>
        return 0;
    12e2:	4501                	li	a0,0
    12e4:	74a2                	ld	s1,40(sp)
    12e6:	6a42                	ld	s4,16(sp)
    12e8:	6aa2                	ld	s5,8(sp)
    12ea:	6b02                	ld	s6,0(sp)
    12ec:	a03d                	j	131a <malloc+0xe4>
    12ee:	74a2                	ld	s1,40(sp)
    12f0:	6a42                	ld	s4,16(sp)
    12f2:	6aa2                	ld	s5,8(sp)
    12f4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    12f6:	fae90be3          	beq	s2,a4,12ac <malloc+0x76>
        p->s.size -= nunits;
    12fa:	4137073b          	subw	a4,a4,s3
    12fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1300:	02071693          	slli	a3,a4,0x20
    1304:	01c6d713          	srli	a4,a3,0x1c
    1308:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    130a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    130e:	00000717          	auipc	a4,0x0
    1312:	1ea73523          	sd	a0,490(a4) # 14f8 <freep>
      return (void*)(p + 1);
    1316:	01078513          	addi	a0,a5,16
  }
}
    131a:	70e2                	ld	ra,56(sp)
    131c:	7442                	ld	s0,48(sp)
    131e:	7902                	ld	s2,32(sp)
    1320:	69e2                	ld	s3,24(sp)
    1322:	6121                	addi	sp,sp,64
    1324:	8082                	ret
    1326:	74a2                	ld	s1,40(sp)
    1328:	6a42                	ld	s4,16(sp)
    132a:	6aa2                	ld	s5,8(sp)
    132c:	6b02                	ld	s6,0(sp)
    132e:	b7f5                	j	131a <malloc+0xe4>
