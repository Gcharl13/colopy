/*
 * txt.c — Colonization "@SECTION" .TXT resource parser (see txt.h).
 */
#define _POSIX_C_SOURCE 200809L   /* strdup, strtok_r */
#include "txt.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *trim(char *s)
{
    while (*s && isspace((unsigned char)*s)) s++;
    char *end = s + strlen(s);
    while (end > s && isspace((unsigned char)end[-1])) *--end = 0;
    return s;
}

txt_doc *txt_parse(const char *text, size_t len)
{
    txt_doc *d = calloc(1, sizeof *d);
    if (!d)
        return NULL;

    /* Work on a mutable, NUL-terminated copy. */
    char *buf = malloc(len + 1);
    if (!buf) { free(d); return NULL; }
    memcpy(buf, text, len);
    buf[len] = 0;

    size_t cap = 0;
    char *cur_content = NULL;   /* accumulating buffer for current section */
    size_t cur_len = 0, cur_cap = 0;
    txt_section *cur = NULL;

    char *save = NULL;
    for (char *line = strtok_r(buf, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
        /* strip trailing CR */
        size_t l = strlen(line);
        if (l && line[l - 1] == '\r') line[l - 1] = 0;

        char *t = line;
        while (*t == ' ' || *t == '\t') t++;   /* leading ws only for marker test */

        if (t[0] == ';')
            continue;                          /* comment */

        if (t[0] == '@') {
            /* close previous section */
            if (cur) cur->content = cur_content ? cur_content : calloc(1, 1);
            cur_content = NULL; cur_len = cur_cap = 0;

            /* open new section */
            if (d->count == cap) {
                cap = cap ? cap * 2 : 16;
                d->sections = realloc(d->sections, cap * sizeof *d->sections);
            }
            cur = &d->sections[d->count++];
            char *key = trim(t + 1);
            cur->name = strdup(key);
            cur->content = NULL;
            continue;
        }

        if (!cur)
            continue;                          /* content before first section */

        /* append the raw line + '\n' to current content */
        size_t add = strlen(line) + 1;
        if (cur_len + add + 1 > cur_cap) {
            cur_cap = (cur_len + add + 1) * 2;
            cur_content = realloc(cur_content, cur_cap);
        }
        memcpy(cur_content + cur_len, line, add - 1);
        cur_len += add - 1;
        cur_content[cur_len++] = '\n';
        cur_content[cur_len] = 0;
    }
    if (cur) cur->content = cur_content ? cur_content : calloc(1, 1);

    free(buf);
    return d;
}

txt_doc *txt_load(const char *path)
{
    FILE *f = fopen(path, "rb");
    if (!f)
        return NULL;
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    rewind(f);
    if (sz < 0) { fclose(f); return NULL; }
    char *buf = malloc((size_t)sz + 1);
    if (!buf) { fclose(f); return NULL; }
    size_t got = fread(buf, 1, (size_t)sz, f);
    fclose(f);
    txt_doc *d = txt_parse(buf, got);
    free(buf);
    return d;
}

void txt_free(txt_doc *d)
{
    if (!d)
        return;
    for (size_t i = 0; i < d->count; i++) {
        free(d->sections[i].name);
        free(d->sections[i].content);
    }
    free(d->sections);
    free(d);
}

const char *txt_get(const txt_doc *d, const char *name)
{
    if (!d)
        return NULL;
    if (name[0] == '@')
        name++;
    for (size_t i = 0; i < d->count; i++)
        if (strcmp(d->sections[i].name, name) == 0)
            return d->sections[i].content;
    return NULL;
}

size_t txt_lines(const char *content, char ***out_lines, char **backing)
{
    *out_lines = NULL;
    *backing = NULL;
    if (!content)
        return 0;

    char *copy = strdup(content);
    if (!copy)
        return 0;

    size_t n = 0, cap = 0;
    char **arr = NULL;
    char *save = NULL;
    for (char *line = strtok_r(copy, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
        char *t = trim(line);
        if (!*t)
            continue;
        if (n == cap) {
            cap = cap ? cap * 2 : 16;
            arr = realloc(arr, cap * sizeof *arr);
        }
        arr[n++] = t;
    }
    *out_lines = arr;
    *backing = copy;
    return n;
}

char *txt_first_field(const char *line, char *buf, int bufsz)
{
    int i = 0;
    while (line[i] && line[i] != ',' && i < bufsz - 1) {
        buf[i] = line[i];
        i++;
    }
    buf[i] = 0;
    /* trim */
    char *t = trim(buf);
    if (t != buf)
        memmove(buf, t, strlen(t) + 1);
    return buf;
}
