#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/param.h"

#define MAXLEN 512

int main(int argc, char *argv[])
{
    char buf[MAXLEN];
    char *args[MAXARG];
    int i, n;

    // 检查是否提供了命令
    if (argc < 2)
    {
        fprintf(2, "Usage: xargs <command>\n");
        exit(1);
    }

    if (argc >= 2)
    {
        args[0] = argv[1];
        int eq_flag = strcmp(args[0], "-n");
        i =  eq_flag == 0? 3 : 1;
        // 处理 -n 参数
        for (; i < argc && i < MAXARG - 1; i++)
        {
            if (eq_flag == 0) {
                args[i - 3] = argv[i];
            } else {
                args[i - 1] = argv[i];
            }
            
        }
    }

    // 从标准输入读取参数
    while ((n = read(0, buf, sizeof(buf))) > 0)
    {
        buf[n] = '\0'; // 确保字符串以 '\0' 结尾
        char *p = buf;
        char *end = buf + n;
        int arg_index = i - 1;

        // 分割输入为单独的参数
        while (p < end)
        {
            // 跳过空白字符
            while (p < end && (*p == ' ' || *p == '\n'))
            {
                p++;
            }
            if (p >= end)
            {
                break;
            }

            // 记录参数的起始位置
            args[arg_index++] = p;

            // 找到参数的结束位置
            while (p < end && *p != ' ' && *p != '\n')
            {
                p++;
            }

            // 用 '\0' 替换空白字符，分隔参数
            if (p < end)
            {
                *p++ = '\0';
            }

            // 检查参数数量是否超出限制
            if (arg_index >= MAXARG - 1)
            {
                fprintf(2, "xargs: too many arguments\n");
                exit(1);
            }
        }

        // 终止参数列表
        args[arg_index] = 0;

        // 执行命令
        if (fork() == 0)
        {
            exec(args[0], args);
            fprintf(2, "xargs: exec %s failed\n", args[0]);
            exit(1);
        }
        else
        {
            wait(0);
        }
    }

    if (n < 0)
    {
        fprintf(2, "xargs: read error\n");
        exit(1);
    }

    exit(0);
}