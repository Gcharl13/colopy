// ili9341.hpp -- minimal ILI9341 320x240 SPI driver (no library deps beyond
// the Arduino SPI core). Landscape orientation, 16-bit RGB565 writes.
// Pins are the PJRC-standard wiring; change the constants to match yours.
#pragma once
#include <Arduino.h>
#include <SPI.h>

class Ili9341 {
public:
    static constexpr uint8_t PIN_CS = 10, PIN_DC = 9, PIN_RST = 8;
    static constexpr uint32_t SPI_HZ = 40000000;   // tune down if unstable

    void begin() {
        pinMode(PIN_CS, OUTPUT);
        pinMode(PIN_DC, OUTPUT);
        pinMode(PIN_RST, OUTPUT);
        digitalWrite(PIN_CS, HIGH);
        digitalWrite(PIN_RST, LOW);
        delay(20);
        digitalWrite(PIN_RST, HIGH);
        delay(120);
        SPI.begin();
        // standard ILI9341 init (power/gamma defaults, 16bpp, landscape)
        cmd(0x01); delay(120);                     // soft reset
        cmd(0x28);                                 // display off
        cmd(0x3A); dat(0x55);                      // 16 bits/pixel
        cmd(0x36); dat(0x28);                      // MADCTL: landscape, BGR
        cmd(0x11); delay(120);                     // sleep out
        cmd(0x29);                                 // display on
    }

    void set_window(int x, int y, int w, int h) {
        cmd(0x2A); dat16(x); dat16(x + w - 1);     // column range
        cmd(0x2B); dat16(y); dat16(y + h - 1);     // row range
        cmd(0x2C);                                 // memory write
        digitalWrite(PIN_DC, HIGH);
        digitalWrite(PIN_CS, LOW);
        SPI.beginTransaction(SPISettings(SPI_HZ, MSBFIRST, SPI_MODE0));
        in_stream_ = true;
    }

    void push_pixels(const uint16_t* px, int n) {
        for (int i = 0; i < n; ++i) SPI.transfer16(px[i]);
    }

    void end_window() {
        if (!in_stream_) return;
        SPI.endTransaction();
        digitalWrite(PIN_CS, HIGH);
        in_stream_ = false;
    }

    void fill(uint16_t c) {
        set_window(0, 0, 320, 240);
        for (int i = 0; i < 320 * 240; ++i) SPI.transfer16(c);
        end_window();
    }

    // a crude 8x8 block banner for boot errors (no font dependency)
    void text_banner(const char* msg) {
        fill(0x0000);
        set_window(0, 112, 320, 16);
        // alternating bars signal "look at the serial console"
        for (int y = 0; y < 16; ++y)
            for (int x = 0; x < 320; ++x)
                SPI.transfer16(((x >> 3) & 1) ? 0xF800 : 0xFFFF);
        end_window();
        Serial.println(msg);
    }

private:
    bool in_stream_ = false;
    void cmd(uint8_t c) {
        end_window();
        SPI.beginTransaction(SPISettings(SPI_HZ, MSBFIRST, SPI_MODE0));
        digitalWrite(PIN_DC, LOW);
        digitalWrite(PIN_CS, LOW);
        SPI.transfer(c);
        digitalWrite(PIN_CS, HIGH);
        SPI.endTransaction();
    }
    void dat(uint8_t d) {
        SPI.beginTransaction(SPISettings(SPI_HZ, MSBFIRST, SPI_MODE0));
        digitalWrite(PIN_DC, HIGH);
        digitalWrite(PIN_CS, LOW);
        SPI.transfer(d);
        digitalWrite(PIN_CS, HIGH);
        SPI.endTransaction();
    }
    void dat16(uint16_t d) { dat(d >> 8); dat(d & 0xFF); }
};
