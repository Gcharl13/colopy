/* ============================================================================
 * viceroy.h — convenience master include
 * ============================================================================ */
#ifndef VICEROY_H
#define VICEROY_H

#include "viceroy_types.h"
#include "globals.h"
#include "colony.h"
#include "unit.h"
#include "iolib.h"

/* ----------------------------------------------------------------------------
 * Commodity ids (the canonical Colonization 0..14 mapping; 15 = Muskets is
 *                used by units but not by the colony stockpile loop)
 * ---------------------------------------------------------------------------- */
#define COMMODITY_FOOD          0
#define COMMODITY_SUGAR         1
#define COMMODITY_TOBACCO       2
#define COMMODITY_COTTON        3
#define COMMODITY_FURS          4
#define COMMODITY_LUMBER        5
#define COMMODITY_ORE           6
#define COMMODITY_SILVER        7
#define COMMODITY_HORSES        8
#define COMMODITY_RUM           9
#define COMMODITY_CIGARS        10
#define COMMODITY_CLOTH         11
#define COMMODITY_COATS         12
#define COMMODITY_TRADE_GOODS   13
#define COMMODITY_TOOLS         14
#define COMMODITY_MUSKETS       15

/* ----------------------------------------------------------------------------
 * Production chain pairs (from colony_turn_update @ 0xA3E1)
 * ---------------------------------------------------------------------------- */
struct production_chain {
    uint8_t raw;        /* input commodity */
    uint8_t finished;   /* output commodity */
    uint8_t slot;       /* which colony slot does the production */
};

extern const struct production_chain k_production_chains[5];
/*  = { {SUGAR,RUM,1}, {TOBACCO,CIGARS,2}, {COTTON,CLOTH,3},
 *      {FURS,COATS,4}, {ORE,TOOLS,6} } — see src/data/production.c */

#endif /* VICEROY_H */
