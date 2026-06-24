#include "arp_parser.h"
#include <stdint.h>
#include <stddef.h>

struct arp_packet;
void print_arp(const struct arp_packet *packet);
int parse_arp(const uint8_t *data, size_t len, struct arp_packet *packet);

static const uint8_t test_arp_packet[] = {
    0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
    0x08, 0x00, 0x27, 0x12, 0x34, 0x56, 0xC0, 0xA8,
    0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0xC0, 0xA8, 0x01, 0x02
};

int main() {
    struct arp_packet packet = {0};
    int res = parse_arp(test_arp_packet, ARP_TARGET_LEN, &packet);
    if (res == ARP_OK) print_arp(&packet);
    return 0;
}