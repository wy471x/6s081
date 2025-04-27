// sleep.c: current process sleep
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"

int main(int argv, char *argc[]) {
    if (argv < 2) {
        fprintf(2, "Usage: sleep\n");
        exit(1);
    }
    int pid = fork();
    if (pid == 0) {
        // Child process
        sleep(atoi(argc[1])); // Sleep for 5 seconds
        exit(0);
    } else if (pid > 0) {
        // Parent process
        wait(0); // Wait for the child to finish
    } else {
        // Fork failed
        fprintf(2, "Fork failed\n");
    }
    exit(0);
}