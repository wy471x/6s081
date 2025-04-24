#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int is_prime(int n);

int main(int argc, char *argv[]) {
    int p[2];
    pipe(p);
    for (int i = 1; i <= 35; i++) {
        if (fork() == 0) {
            close(p[1]);
            read(p[0], &i, sizeof(i));
            if (is_prime(i) == 0) {
                int p[2];
                pipe(p);
                if (fork() == 0) {
                    close(p[1]);
                    int prime;
                    read(p[0], &prime, sizeof(prime));
                    printf("prime %d\n", prime);
                    close(p[0]);
                    exit(0);
                } else {
                    close(p[0]);
                    write(p[1], &i, sizeof(i));
                    close(p[1]);
                    wait(0);
                }
            }
            close(p[0]);
            exit(0);
        } else {
            close(p[0]);
            close(p[1]);
            wait(0);
        }
    }
    exit(0);
}

int is_prime(int n) {
    if (n <= 1) return -1;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) return -1;
    }
    return 0;
}