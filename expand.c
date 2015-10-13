#include <stdlib.h>
#include <stdio.h>
#include <getopt.h>

static void usage(void);

int main(int argc, const char *argv[]) {
  if (argc < 2) {
    usage();
  }

  struct option long_options[] = {{"tabs", required_argument, 0, 't'},
                                  {0, 0, 0, 0}};

  int tab_width = 8;
  int option_index = 0;
  int c;

  while ((c = getopt_long(argc, argv, "t:", long_options, &option_index)) !=
         -1) {
    switch (c) {
    case 't':
      tab_width = atoi(optarg);
      if (tab_width <= 0) {
        usage();
      }
      break;
    default:
      usage();
    }
  }

  FILE *fp;
  for (size_t i = optind; i < argc; i++) {
    fp = fopen(argv[i], "r");
    if (fp == NULL) {
      fprintf(stderr, "can't open file %s\n", argv[i]);
      exit(EXIT_FAILURE);
    } else {
      int ch;
      while ((ch = fgetc(fp)) != EOF) {
        if (ch == '\t') {
          for (size_t j = 0; j < tab_width; j++) {
            putchar(' ');
          }
        } else {
          putchar(ch);
        }
      }
      fclose(fp);
    }
  }

  return 0;
}

static void usage(void) {
  fprintf(stderr, "Usage: expand [-t number] [file ...]\n");
  exit(EXIT_FAILURE);
}
