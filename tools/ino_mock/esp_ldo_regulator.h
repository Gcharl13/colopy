#pragma once
#include "esp_err.h"
typedef struct esp_ldo_channel_t *esp_ldo_channel_handle_t;
typedef struct { int chan_id; int voltage_mv; } esp_ldo_channel_config_t;
esp_err_t esp_ldo_acquire_channel(const esp_ldo_channel_config_t *, esp_ldo_channel_handle_t *);
