#include <cinttypes>
#include <span>

typedef struct {
    uint32_t nameSize;
    uint32_t descSize;
    uint32_t type;
    uint8_t* data;
} ElfNoteSection_t;

// g_note_build_id is set by the linker to a fixed address.
extern const ElfNoteSection_t g_note_build_id;

auto print_build_id() {
    const uint8_t* idData = &g_note_build_id.data[g_note_build_id.nameSize];
	return std::span(idData, g_note_build_id.descSize);
}