/*
 * txt.h — parser for Colonization "@SECTION" .TXT resource files
 * (NAMES.TXT, MAPMENU.TXT, MAPEDIT.TXT).
 *
 * Format (CRLF or LF):
 *   ; comment line (ignored)
 *   @SECTION            <- a line beginning with '@' opens a section; the
 *   line one               section key is the text after '@' (trimmed)
 *   line two
 *   @NEXT_SECTION
 *
 * Content lines are everything between one section header and the next,
 * excluding ';' comment lines. The editor loads the same files the original
 * MAPEDIT.EXE reads, so its menus and terrain names stay authentic.
 */
#ifndef MPEDIT_TXT_H
#define MPEDIT_TXT_H

#include <stddef.h>

typedef struct {
    char  *name;       /* section key, e.g. "UNFORESTED" (no leading '@') */
    char  *content;    /* NUL-terminated content block (LF-joined)        */
} txt_section;

typedef struct {
    txt_section *sections;
    size_t       count;
} txt_doc;

txt_doc *txt_load(const char *path);
txt_doc *txt_parse(const char *text, size_t len);
void     txt_free(txt_doc *d);

/* Return the content of a section by key, or NULL if absent. */
const char *txt_get(const txt_doc *d, const char *name);

/* Split a content block into non-empty trimmed lines. Caller frees the
 * returned array (but not the strings, which point into a single malloc held
 * by *backing — free(*backing) when done). Returns line count. */
size_t txt_lines(const char *content, char ***out_lines, char **backing);

/* Parse the first CSV field of a line (text up to the first comma), trimmed.
 * Writes into buf and returns buf. */
char *txt_first_field(const char *line, char *buf, int bufsz);

#endif /* MPEDIT_TXT_H */
