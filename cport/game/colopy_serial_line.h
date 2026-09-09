/* Serial line framing for the board shells (2026-09-09, adopted from the
 * sibling port's cport/debug/colopy_serial_line.h with its host test).
 *
 * The rule: NEVER execute a clipped prefix of an over-long line, nor a
 * line that carried a control byte (a pasted escape sequence, a dropped
 * character) -- the old P4 reader silently truncated at 63 bytes and ran
 * what was left, which for `s <name>` writes a differently-named save.
 * CR, LF and CRLF all terminate; an empty line is reported as nothing.
 *
 * Header-only and platform-free (no Arduino, no I/O) so the host can
 * prove it: cport/host/serial_line_test.c, `make serial-framing`. */
#ifndef COLOPY_SERIAL_LINE_H
#define COLOPY_SERIAL_LINE_H
#include <stddef.h>

#define COLOPY_SERIAL_LINE_CAP 160

typedef struct {
    char text[COLOPY_SERIAL_LINE_CAP];
    size_t length;
    unsigned char rejected;
} colopy_serial_line;

/* When another input owner (a touch answering a modal, a screen change)
 * takes over midway through a typed command, keep rejecting the rest of
 * that line until its terminator -- never reinterpret the suffix as a
 * fresh command. A no-op on an idle line. */
static inline void colopy_serial_abandon_partial(colopy_serial_line *line) {
    if (line->length) line->rejected = 1;
}

/* Feed one byte.  Returns 1 when a complete, accepted line is in
 * `text` (valid until the next non-terminator byte), -1 when a line was
 * REJECTED at its terminator (too long, control byte, or abandoned --
 * nothing of it must run), 0 otherwise (still collecting, or an empty
 * terminator).  A zeroed struct is the initial state. */
static inline int colopy_serial_feed(colopy_serial_line *line, unsigned char ch) {
    if (ch == '\r' || ch == '\n') {
        int status = line->rejected ? -1 : line->length ? 1 : 0;
        line->text[line->length] = 0;
        line->length = 0;
        line->rejected = 0;
        return status;
    }
    if (line->rejected) return 0;
    if ((ch < 32 && ch != '\t') || ch == 127 ||
        line->length >= sizeof(line->text) - 1) {
        line->rejected = 1;
        return 0;
    }
    line->text[line->length++] = (char)ch;
    return 0;
}

#endif
