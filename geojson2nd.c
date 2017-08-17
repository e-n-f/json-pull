#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include "jsonpull.h"

int fail = EXIT_SUCCESS;

void process(FILE *fp, const char *fname) {
	json_pull *jp = json_begin_file(fp);

	while (1) {
		json_object *j = json_read(jp);
		if (j == NULL) {
			if (jp->error != NULL) {
				fprintf(stderr, "%s:%d: %s\n", fname, jp->line, jp->error);
			}

			json_free(jp->root);
			break;
		}

		json_object *type = json_hash_get(j, "type");
		if (type == NULL || type->type != JSON_STRING) {
			continue;
		}

		if (strcmp(type->string, "Feature") == 0) {
			char *s = json_stringify(j);
			printf("%s\n", s);
			free(s);
			json_free(j);
		} else if (strcmp(type->string, "FeatureCollection") == 0) {
			json_free(j);
		}
	}

	json_end(jp);
}

int main(int argc, char **argv) {
	extern int optind;
	int i;

	while ((i = getopt(argc, argv, "")) != -1) {
		switch (i) {
		default:
			fprintf(stderr, "Unexpected option -%c\n", i);
			exit(EXIT_FAILURE);
		}
	}

	if (optind >= argc) {
		process(stdin, "standard input");
	} else {
		int i;
		for (i = optind; i < argc; i++) {
			FILE *f = fopen(argv[i], "r");
			if (f == NULL) {
				perror(argv[i]);
				exit(EXIT_FAILURE);
			}

			process(f, argv[i]);
			fclose(f);
		}
	}

	return fail;
}
