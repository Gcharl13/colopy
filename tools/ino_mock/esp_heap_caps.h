#pragma once
#include <cstddef>
#define MALLOC_CAP_SPIRAM 1
void *heap_caps_malloc(size_t, unsigned);
#define MALLOC_CAP_INTERNAL 2
#define MALLOC_CAP_8BIT     4
size_t heap_caps_get_free_size(unsigned);
size_t heap_caps_get_total_size(unsigned);
size_t heap_caps_get_largest_free_block(unsigned);
size_t heap_caps_get_minimum_free_size(unsigned);
