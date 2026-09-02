/* colopy_core.h — the ONLY interface between the game core and any front
 * end (host test harness now; Teensy display/input layer later).
 *
 * Contract, fixed in the Teensy-port plan:
 *   - The core is a pure turn-based state machine. It never draws, never
 *     reads input devices, never allocates (all state is static), never
 *     touches an OS. Time does not exist inside it: it advances only when
 *     colopy_run() is called.
 *   - Game-triggered messages (popups, woodcuts, king demands, combat
 *     results) are GAME LOGIC. The core queues them as typed events carrying
 *     their GAME.TXT key + parameters; presentation is the front end's
 *     problem. A question event BLOCKS the machine until colopy_answer().
 *   - Determinism: everything random flows from the one seed given to
 *     colopy_init(). Same (seed, save, command sequence) => identical state
 *     forever. This is what the JS<->C parity oracle tests.
 */
#ifndef COLOPY_CORE_H
#define COLOPY_CORE_H

#include <stddef.h>
#include <stdint.h>

#include "colopy_records.h"

#ifdef __cplusplus
extern "C" {
#endif

/* ---- status ----------------------------------------------------------- */
typedef enum {
    COLOPY_OK = 0,
    COLOPY_ERR_BAD_SAV,        /* not a COLONIZE save / truncated */
    COLOPY_ERR_CAPACITY,       /* save exceeds the static pools (never truncated) */
    COLOPY_ERR_BAD_COMMAND,    /* command invalid in the current state */
    COLOPY_ERR_NOT_WAITING,    /* answer() with no pending question */
    COLOPY_ERR_BUFFER,         /* save buffer too small */
} colopy_status;

/* ---- lifecycle -------------------------------------------------------- */
void          colopy_init(uint32_t seed);
colopy_status colopy_new_game(uint8_t nation, uint8_t difficulty,
                              const char *leader_name);
colopy_status colopy_load_sav(const uint8_t *buf, size_t len);
/* Returns bytes written, or 0 with status via colopy_last_error(). */
size_t        colopy_save_sav(uint8_t *buf, size_t cap);
colopy_status colopy_last_error(void);

/* ---- the run loop ----------------------------------------------------- */
/* Advance the machine until it needs the outside world. */
typedef enum {
    COLOPY_WAIT_UNIT,      /* a unit awaits orders: see colopy_active_unit() */
    COLOPY_WAIT_QUESTION,  /* a queued event has .question set: answer it */
    COLOPY_WAIT_END_TURN,  /* all units moved; front end confirms end of turn */
    COLOPY_GAME_OVER,
} colopy_wait;

colopy_wait   colopy_run(void);
int16_t       colopy_active_unit(void);          /* index, -1 if none */

/* ---- commands (player intent, no pixels) ------------------------------ */
typedef enum {
    /* unit orders — map screen */
    COLOPY_CMD_MOVE,           /* a = direction 0..7 (N,E,S,W,NW,NE,SE,SW) */
    COLOPY_CMD_SKIP,           /* space — done for this turn */
    COLOPY_CMD_SENTRY,
    COLOPY_CMD_FORTIFY,
    COLOPY_CMD_BUILD_COLONY,
    COLOPY_CMD_PLOW,           /* plow / clear forest (engine: same order) */
    COLOPY_CMD_ROAD,
    COLOPY_CMD_GOTO,           /* a = x, b = y */
    COLOPY_CMD_DISBAND,
    COLOPY_CMD_UNLOAD_ALL,     /* ashore / unload at colony */
    COLOPY_CMD_WAIT,           /* defer unit to end of queue */
    /* colony screen */
    COLOPY_CMD_SET_OCCUPATION, /* a = colonist idx, b = job, c = tile/bldg */
    COLOPY_CMD_SET_BUILD,      /* a = building id (construction target) */
    COLOPY_CMD_RUSH_BUY,
    COLOPY_CMD_LOAD_CARGO,     /* a = unit, b = good, c = amount */
    COLOPY_CMD_UNLOAD_CARGO,
    COLOPY_CMD_ABANDON_COLONY,
    /* Europe */
    COLOPY_CMD_SAIL_EUROPE,
    COLOPY_CMD_SAIL_NEWWORLD,
    COLOPY_CMD_MARKET_BUY,     /* a = good, b = amount */
    COLOPY_CMD_MARKET_SELL,
    COLOPY_CMD_RECRUIT,        /* a = pool slot */
    COLOPY_CMD_TRAIN,          /* a = jobtrain index */
    COLOPY_CMD_PURCHASE,       /* a = purchasable index (ships/artillery) */
    /* turn */
    COLOPY_CMD_END_TURN,
    /* endgame */
    COLOPY_CMD_DECLARE_INDEPENDENCE,
} colopy_cmd_kind;

typedef struct {
    colopy_cmd_kind kind;
    int32_t a, b, c;
} colopy_cmd;

colopy_status colopy_command(const colopy_cmd *cmd);

/* ---- events (game -> front end) --------------------------------------- */
/* .key is the GAME.TXT section key ("LANDFALL", "PRICEUP", woodcut number
 * via "WOODCUT" + p0, ...). Parameters mirror the %NUMBER0/%STRING0
 * substitutions the JS port feeds fillTemplate(); the front end owns
 * rendering the text (dat_events_* tables carry the bodies). */
typedef struct {
    char        key[20];
    int32_t     p[4];          /* %NUMBER0..3 */
    const char *s[2];          /* %STRING0..1 (point into core state/tables) */
    uint8_t     question;      /* 1 => machine blocks until colopy_answer() */
    uint8_t     n_choices;     /* for option questions; 0 = free number/text */
} colopy_event;

/* Drain notices; returns 0 when the queue is empty. */
int           colopy_next_event(colopy_event *out);

/* ---- sound cues (game -> the shell's audio backend) --------------------
 * The engine's `mov ax,id; lcall 0x181F:0x4C0` play sites and the sound
 * layer's verbs, queued at the sim/UI site that fires them (each site is
 * cited where it is emitted; the inventory is spec/ui/options_dialogs.md
 * §10).  Presentation only: absent from colopy_digest(), drained by the
 * shell after each command/key.  A pack-backed shell routes them to
 * au_cmd()/au_queue_tune()/au_class_*(); the COLDIG fallback plays the
 * SND_PLAY ids it has samples for and ignores the rest. */
enum {
    SND_PLAY = 0,        /* gated play, func_00518E (0x181F:0x4C0) */
    SND_QUEUE_TUNE = 1,  /* func_0050BC (0x181F:0x48E) */
    SND_CLASS_ONESHOT = 2, /* func_00513C (0x181F:0x4B6) */
    SND_CLASS_REQUEST = 3, /* func_005108 (0x181F:0x4AC) */
    SND_CLASS_SET = 4,   /* func_0050F0 (0x181F:0x498) */
    SND_PICK = 5,        /* Pick Music: [0x96] = id, then the gated play */
    SND_SWITCHES = 6     /* Sound Options closed: arg = the [0x5386] bits;
                          * stop (cmd 1) when any switch is off @0x23327 */
};
typedef struct {
    uint8_t  verb;             /* SND_* */
    uint16_t arg;              /* id / class / switch bits */
} colopy_sound;
int           colopy_next_sound(colopy_sound *out);
/* Resolve the blocking question: option index, or number, or text (any
 * unused argument ignored; text may be NULL). */
colopy_status colopy_answer(int32_t choice, const char *text);

/* ---- state queries (read-only views into the static pools) ------------ */
typedef struct {
    uint16_t turn;             /* engine turn counter */
    int16_t  year;
    uint8_t  season;           /* 0 spring / 1 autumn (post-1600 split) */
    uint8_t  human_power;
    uint8_t  difficulty;
    uint16_t n_units;
    uint16_t n_colonies;
    uint16_t n_settlements;
    uint8_t  tax_rate;
    uint8_t  declared;         /* War of Independence underway */
} colopy_overview;

void                    colopy_get_overview(colopy_overview *out);
const ColonyRecord     *colopy_colony(int i);
const UnitRecord       *colopy_unit(int i);
const PowerRecord      *colopy_power(int i);
const NativeSettlement *colopy_settlement(int i);
const uint8_t          *colopy_map_tiles(void);   /* DAT_MAP_W x DAT_MAP_H */

/* Canonical state digest — the parity oracle's unit of comparison, and the
 * Teensy serial shell's per-turn output. FNV-1a over the record pools +
 * map + RNG state, so host and hardware can be compared by eye. */
uint32_t colopy_digest(void);

#ifdef __cplusplus
}
#endif
#endif /* COLOPY_CORE_H */
