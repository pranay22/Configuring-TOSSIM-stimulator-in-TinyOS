#ifndef TEST_NETWORK_H
#define TEST_NETWORK_H

#include <AM.h>
#include "MyTestNetworkC.h"

typedef nx_struct MyTestNetworkMsg {
  nx_am_addr_t source;
  nx_uint16_t seqno;
  nx_am_addr_t parent;
  nx_uint16_t metric;
  nx_uint16_t data;
  nx_uint8_t hopcount;
  nx_uint16_t sendCount;
  nx_uint16_t sendSuccessCount;
} MyTestNetworkMsg;

#endif
