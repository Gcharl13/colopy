#pragma once
namespace esp_panel { namespace drivers {
struct TouchPoint { int x = -1, y = -1, strength = -1; };
class Touch { public: int readPoints(TouchPoint points[], int num, int timeout_ms); };
class LCD { public: bool drawBitmap(int, int, int, int, const unsigned char *, int timeout_ms = 0); };
} namespace board {
class Board { public: bool init(); bool begin(); drivers::LCD *getLCD(); drivers::Touch *getTouch(); };
} }
