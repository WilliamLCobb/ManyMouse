//
//  UDPClient.h
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
#include <netdb.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

@interface UDPClient : NSObject
    {
    int sock;
    struct sockaddr_in server_addr;
    struct hostent *host;
    }

- (id) initWithHost:(NSString*) host Port: (int) port;
- (void) sendData: (NSString *) data;
@end