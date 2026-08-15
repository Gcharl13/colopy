/* Generated — INTERFACE LAYOUT ONLY (pulldown menus). The sim
 * never reads these; the render layer (cport/render) does. */
#ifndef COLOPY_UI_H
#define COLOPY_UI_H

#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
#include <stddef.h>

#define DAT_MENUS_COUNT 6
typedef struct {
  const char *title;
  const char *accel;
  int32_t row_start;
  int32_t row_count;
} dat_menus_t;
extern const dat_menus_t dat_menus[6];
#define DAT_MENU_ROWS_COUNT 62
typedef struct {
  const char *label;
  const char *accel;
  uint8_t disabled;
} dat_menu_rows_t;
extern const dat_menu_rows_t dat_menu_rows[62];

#ifdef __cplusplus
}
#endif
#endif
