#pragma once
typedef int gpio_num_t;
typedef struct sdmmc_card_t sdmmc_card_t;
typedef struct { int slot; int max_freq_khz; } sdmmc_host_t;
typedef struct { gpio_num_t clk, cmd, d0; int width; unsigned flags; } sdmmc_slot_config_t;
#define SDMMC_HOST_DEFAULT() (sdmmc_host_t){0, 20000}
#define SDMMC_HOST_SLOT_0 0
#define SDMMC_SLOT_CONFIG_DEFAULT() (sdmmc_slot_config_t){0,0,0,4,0}
#define SDMMC_SLOT_FLAG_INTERNAL_PULLUP 1
