#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    int p1[2], p2[2];
    pipe(p1);
    pipe(p2);
    char buf[1] = "o";
    int len = sizeof(buf);

    if (fork() == 0) {
        close(p1[1]);
        close(p2[0]);
        if(read(p1[0], buf, len) != len) {
            fprintf(2, "child: read error\n");
            exit(1);
        }
        printf("%d: received ping\n", getpid());
        write(p2[1], buf, len);
        exit(0);
    } else {
        close(p1[0]);
        close(p2[1]);
        write(p1[1], buf, len);
        if(read(p2[0], buf, len) != len) {
            fprintf(2, "parent: read error\n");
            exit(1);
        }
        printf("%d: received pong\n", getpid());
        wait(0);
    }

    exit(0);
}