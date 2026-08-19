/* Mock of arduino-esp32's BLEDevice.h — only the surface the sketch
 * touches, with the same signatures, so the gate can syntax-check the
 * COLOPY_BLE_MOUSE=1 path without the real core. */
#pragma once
#include <string>
#include <map>
#include <stdint.h>
#include <stddef.h>

class BLEUUID {
public:
  BLEUUID() {}
  BLEUUID(uint16_t) {}
  bool equals(BLEUUID) { return false; }
};
class BLEAddress {
public:
  BLEAddress(std::string) {}
  BLEAddress(const char *) {}
  std::string toString() { return std::string(); }
};
class BLERemoteCharacteristic;
typedef void (*notify_callback)(BLERemoteCharacteristic *, uint8_t *, size_t,
                                bool);
class BLERemoteCharacteristic {
public:
  BLEUUID getUUID() { return BLEUUID(); }
  bool canNotify() { return false; }
  void registerForNotify(notify_callback) {}
};
class BLERemoteService {
public:
  std::map<std::string, BLERemoteCharacteristic *> *getCharacteristics() {
    return nullptr;
  }
};
class BLEClient {
public:
  bool connect(BLEAddress) { return false; }
  void disconnect() {}
  BLERemoteService *getService(BLEUUID) { return nullptr; }
};
class BLEAdvertisedDevice {
public:
  bool isAdvertisingService(BLEUUID) { return false; }
  std::string getName() { return std::string(); }
  BLEAddress getAddress() { return BLEAddress(""); }
};
class BLEScanResults {
public:
  int getCount() { return 0; }
  BLEAdvertisedDevice getDevice(int) { return BLEAdvertisedDevice(); }
};
class BLEScan {
public:
  void setActiveScan(bool) {}
  BLEScanResults *start(uint32_t, bool) { return nullptr; }
  void clearResults() {}
};
class BLEDevice {
public:
  static void init(std::string) {}
  static BLEScan *getScan() { return nullptr; }
  static BLEClient *createClient() { return nullptr; }
};
