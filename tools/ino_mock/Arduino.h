#pragma once
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <cstdint>
struct SerialCls {
    void begin(long);
    int available();
    int read();
    void printf(const char *, ...);
    void print(const char *);
    void println(const char *);
    operator bool();
};
extern SerialCls Serial;
unsigned long millis();
unsigned long micros();
void delay(unsigned long);
unsigned int esp_random();

/* GPIO stubs (the real Arduino.h has these) */
#define HIGH 1
#define LOW 0
#define OUTPUT 1
#define INPUT 0
inline void pinMode(int, int) {}
inline void digitalWrite(int, int) {}
inline int  digitalRead(int) { return 0; }

/* FreeRTOS bits the sketch uses for its stack readout */
typedef unsigned int UBaseType_t;
typedef unsigned int StackType_t;
static inline UBaseType_t uxTaskGetStackHighWaterMark(void *t) { (void)t; return 0; }

/* FreeRTOS bits the audio task uses (real API on the ESP32 core) */
typedef void *TaskHandle_t;
static inline int xTaskCreate(void (*fn)(void *), const char *n,
                              unsigned stack, void *arg, unsigned pri,
                              TaskHandle_t *out) {
    (void)fn;(void)n;(void)stack;(void)arg;(void)pri;(void)out; return 1; }
