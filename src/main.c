// Platform-specific dependencies
#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
/* #include <math.h> */
#include <stdbool.h>
#include <unistd.h>
#include <stdarg.h>
/* #include <limits.h> */

#include "error.h"
#include "toniefile.h"


static char *get_cwd(char *buffer, size_t size);
static void print_usage(char *argv[]);

static void eprintf(const char *format, ...)
{
    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
}

int main(int argc, char *argv[])
{
    error_t error = 0;

    if (argc > 1)
    {
       if (argc != 3 && argc != 4)
       {
           print_usage(argv);
           return -1;
       }
       char *source = argv[1];
       char *taf_file = argv[2];
       size_t skip_seconds = 0;
       if (argc == 4)
       {
           skip_seconds = atoi(argv[3]);
       }

       ffmpeg_convert(source, taf_file, skip_seconds);

       return 1;
    }
    print_usage(argv);
    return error;
}

static void print_usage(char *argv[])
{
    printf(
        "Usage: %s <source> <taf_file> [skip_secondes]\r\n",
        argv[0]);
}
