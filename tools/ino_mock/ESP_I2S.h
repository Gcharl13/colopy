#pragma once
#include <stdint.h>
#include <stddef.h>
enum { I2S_MODE_STD, I2S_DATA_BIT_WIDTH_16BIT, I2S_SLOT_MODE_STEREO, I2S_SLOT_MODE_MONO, I2S_STD_SLOT_BOTH, I2S_STD_SLOT_LEFT, I2S_STD_SLOT_RIGHT };
class I2SClass {
 public:
  void setPins(int, int, int) {}
  bool begin(int, int, int, int, int) { return true; }
  size_t write(const uint8_t *, size_t n) { return n; }
  void end() {}
};
