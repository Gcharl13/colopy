#pragma once
#include "esp_err.h"
typedef struct { bool format_if_mount_failed; int max_files; unsigned allocation_unit_size; bool disk_status_check_enable; bool use_one_fat; } esp_vfs_fat_sdmmc_mount_config_t;
struct sdmmc_card_t; struct sdmmc_host_t2;
#include "driver/sdmmc_host.h"
esp_err_t esp_vfs_fat_sdmmc_mount(const char *, const sdmmc_host_t *, const void *, const esp_vfs_fat_sdmmc_mount_config_t *, sdmmc_card_t **);
