#ifndef ARP_PARSER_H
#define ARP_PARSER_H

#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

#define ARP_TARGET_LEN (2+2+1+1+2+6+4+6+4)

struct arp_packet {
    uint16_t htype;
    uint16_t ptype;
    uint8_t hsize;
    uint8_t psize;
    uint16_t op;
    uint8_t sha[6];
    uint8_t spa[4];
    uint8_t tha[6];
    uint8_t tpa[4];
};

// parse_arp result codes
enum parse_arp_res {
    ARP_OK = 0,
    ARP_NULLPTR = -1,
    ARP_SHORTDATA = -2,
    ARP_INVALID_ADDRESS_SIZE = -3
};

// Architecture independent realization
int parse_arp(const uint8_t *data, size_t len, struct arp_packet *packet);

void print_arp(const struct arp_packet *packet);

#endif