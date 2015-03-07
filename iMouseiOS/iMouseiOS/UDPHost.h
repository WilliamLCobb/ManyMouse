//
//  UDPHost.h
//  Downhill Penguin
//
//  Created by Will Cobb on 3/11/14.
//  Copyright (c) 2014 Will Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

@interface UDPHost : NSObject
{
    struct sockaddr_in server_addr , client_addr;
    int sock;
    int addr_len, bytes_read;
    char recv_data[1024];
}

-(NSString *) recieveData;
-(id) initWithPort: (int) port;
@end
