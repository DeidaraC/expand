#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

static void print_usage(void);

int main(int argc, const char *argv[]) {
  size_t tab_width = 8;
  int c;

  if (argc < 2) {
    print_usage();
  }

  while ((c = getopt(argc, argv, "t:")) != -1) {
    switch (c) {
      case 't':
        tab_width = atoi(optarg);
        break;
      default:
        print_usage();
    }
  }

  printf("tab_width: %lu\n", tab_width);

  for (size_t i = optind; i < argc; i++) {
    printf("%s\n", argv[i]);
  }

  return 0;
}

static void print_usage(void) {
  fprintf(stderr, "Usage: expand [-t tablist] [file ...]\n");
  exit(EXIT_FAILURE);
}
