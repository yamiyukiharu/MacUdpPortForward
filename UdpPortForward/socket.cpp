//
//  socket.cpp
//  UdpPortForward
//
//  Created by Soon Hao Ye  on 20/3/16.
//  Copyright © 2016 Soon Hao Ye . All rights reserved.
//

#include <iostream>
#include <sys/socket.h>
#include <string>
#include <stdint.h>
#include <algorithm>

int udpListenSocket(std::string address, int port) {
    sockaddr addr;
    addr.sa_len = (uint8_t)address.length();
    addr.sa_family = AF_INET;
    std::strcpy(addr.sa_data, address.c_str());
    int listener = socket(PF_INET, SOCK_DGRAM, SOCK_DGRAM);
    int bindResult = bind(listener, &addr, sizeof(struct sockaddr));
    if(bindResult == -1) {
        std::cout << errno << std::endl;
        return -1;
    }
    return 0;
}