#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

static void print_usage(void);

int main(int argc, const char *argv[]) {
  int tab_width = 8;
  int c, i;

  if (argc < 2) {
    print_usage();
  }

  while ((c = getopt(argc, argv, "t:")) != -1) {
    switch (c) {
    case 't':
      tab_width = atoi(optarg);
      if (tab_width <= 0) {
        print_usage();
      }
      break;
    default:
      print_usage();
    }
  }

  printf("tab_width: %d\n", tab_width);

  int ch;
  FILE *fp;
  for (i = optind; i < argc; i++) {
    fp = fopen(argv[i], "r");
    if (fp == NULL) {
      fprintf(stderr, "can't open file %s\n", argv[i]);
      exit(EXIT_FAILURE);
    } else {
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

static void print_usage(void) {
  fprintf(stderr, "Usage: expand [-t number] [file ...]\n");
  exit(EXIT_FAILURE);
}
