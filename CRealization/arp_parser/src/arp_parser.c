#include "arp_parser.h"

// Big endian conversion
// Need nullptr-check before call
static uint16_t read_BE16(const uint8_t* data) {
    return ((uint16_t)data[0] << 8) | data[1];
}

// Realization of parser
int parse_arp(const uint8_t *data, size_t len, struct arp_packet *packet) {
    if (data == NULL || packet == NULL) return ARP_NULLPTR;
    if (len < ARP_TARGET_LEN) {
        *packet = (struct arp_packet){0};
        return ARP_SHORTDATA;
    }

    const uint8_t* offset_ptr = data;

    packet->htype = read_BE16(offset_ptr);
    offset_ptr += 2;

    packet->ptype = read_BE16(offset_ptr);
    offset_ptr += 2;

    if (*offset_ptr != 6) {
        *packet = (struct arp_packet){0};
        return ARP_INVALID_ADDRESS_SIZE;
    }
    packet->hsize = *offset_ptr;
    offset_ptr += 1;

    if (*offset_ptr != 4) {
        *packet = (struct arp_packet){0};
        return ARP_INVALID_ADDRESS_SIZE;
    }
    packet->psize = *offset_ptr;
    offset_ptr += 1;

    packet->op = read_BE16(offset_ptr);
    offset_ptr += 2;

    // Parsing of arrays
    memcpy(packet->sha, offset_ptr, 6);
    offset_ptr += 6;

    memcpy(packet->spa, offset_ptr, 4);
    offset_ptr += 4;

    memcpy(packet->tha, offset_ptr, 6);
    offset_ptr += 6;

    memcpy(packet->tpa, offset_ptr, 4);

    return ARP_OK;
}

// MAC printer
static void print_MAC(const uint8_t* mac) {
    if (mac == NULL) printf("Bad pointer to MAC\n");
    else printf("%02X:%02X:%02X:%02X:%02X:%02X\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
}

// IP printer
static void print_IP(const uint8_t* ip) {
    if (ip == NULL) printf("Bad pointer to IP\n");
    else printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
}

// arp_packet structure printer
void print_arp(const struct arp_packet *packet) {
    if (packet == NULL) printf("Bad pointer to packet");
    else {
        printf("ARP Packet:\n");
        // Функция вывода структуры
        printf("Hardware type: %u\n", (unsigned int)packet->htype);
        printf("Protocol type: %u\n", (unsigned int)packet->ptype);
        printf("Hardware size: %u\n", (unsigned int)packet->hsize);
        printf("Protocol size: %u\n", (unsigned int)packet->psize);
        printf("Opcode: %u\n", (unsigned int)packet->op);
        printf("Sender MAC: "); print_MAC(packet->sha);
        printf("Sender IP: "); print_IP(packet->spa);
        printf("Target MAC: "); print_MAC(packet->tha);
        printf("Target IP: "); print_IP(packet->tpa);
    }
}