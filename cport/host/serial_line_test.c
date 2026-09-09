/* Serial framing contract (cport/game/colopy_serial_line.h): a clipped or
 * corrupted line must never execute as its valid-looking prefix.  Adopted
 * with the header from the sibling port, 2026-09-09.  `make serial-framing`. */
#include <stdio.h>
#include <string.h>
#include "../game/colopy_serial_line.h"

static int checks, failures;
#define CHECK(x) do { checks++; if (!(x)) { failures++; \
    fprintf(stderr, "FAIL line %d: %s\n", __LINE__, #x); } } while (0)

static void feed(colopy_serial_line *s, const char *text) {
    while (*text) colopy_serial_feed(s, (unsigned char)*text++);
}

int main(void) {
    colopy_serial_line s = {{0}, 0, 0};
    CHECK(colopy_serial_feed(&s, '\n') == 0);              /* empty line */
    feed(&s, "l COLONY00.SAV");
    CHECK(colopy_serial_feed(&s, '\r') == 1);              /* CR terminates */
    CHECK(strcmp(s.text, "l COLONY00.SAV") == 0);
    CHECK(colopy_serial_feed(&s, '\n') == 0);              /* the LF of CRLF */
    feed(&s, "s GOOD.SAV");
    for (int i = 0; i < 200; ++i) colopy_serial_feed(&s, ' ');
    CHECK(colopy_serial_feed(&s, '\n') == -1);             /* valid prefix NEVER executes */
    CHECK(colopy_serial_feed(&s, '\r') == 0);
    feed(&s, "d");
    CHECK(colopy_serial_feed(&s, '\n') == 1);
    CHECK(strcmp(s.text, "d") == 0);
    for (int i = 0; i < COLOPY_SERIAL_LINE_CAP - 1; ++i) colopy_serial_feed(&s, 'a');
    CHECK(colopy_serial_feed(&s, '\n') == 1);              /* exactly full: fine */
    CHECK(strlen(s.text) == COLOPY_SERIAL_LINE_CAP - 1);
    for (int i = 0; i < COLOPY_SERIAL_LINE_CAP; ++i) colopy_serial_feed(&s, 'a');
    CHECK(colopy_serial_feed(&s, '\n') == -1);             /* one over: rejected */
    feed(&s, "g"); colopy_serial_feed(&s, 0); feed(&s, "unsafe suffix");
    CHECK(colopy_serial_feed(&s, '\n') == -1);             /* control byte poisons the line */
    feed(&s, "k\tSpace");
    CHECK(colopy_serial_feed(&s, '\n') == 1);              /* TAB is plain text */
    CHECK(strcmp(s.text, "k\tSpace") == 0);
    feed(&s, "k ");
    colopy_serial_abandon_partial(&s);                     /* a touch took the input */
    feed(&s, "s UNINTENDED.SAV");
    CHECK(colopy_serial_feed(&s, '\n') == -1);
    feed(&s, "i");
    CHECK(colopy_serial_feed(&s, '\n') == 1);              /* usable again */
    CHECK(strcmp(s.text, "i") == 0);
    colopy_serial_abandon_partial(&s);                     /* idle: a no-op */
    feed(&s, "w");
    CHECK(colopy_serial_feed(&s, '\n') == 1);
    colopy_serial_feed(&s, 0);                             /* corrupt first byte */
    colopy_serial_abandon_partial(&s);
    feed(&s, "s UNINTENDED.SAV");
    CHECK(colopy_serial_feed(&s, '\n') == -1);
    printf("Serial framing: %d/%d PASS\n", checks - failures, checks);
    return failures ? 1 : 0;
}
