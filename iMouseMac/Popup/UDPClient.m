//
//  UDPClient.m
//  Downhill Penguin
//
//  Created by Will Cobb on 3/11/14.
//  Copyright (c) 2014 Will Cobb. All rights reserved.
//

#import "UDPClient.h"

@implementation UDPClient

-(id) initWithHost:(NSString*) address Port: (int) port
{
        if ((self = [super init]))
        {
            
            
        host= (struct hostent *) gethostbyname([address UTF8String]);


        if ((sock = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
        {
            perror("socket");
            exit(1);
        }

        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(port);
        server_addr.sin_addr = *((struct in_addr *)host->h_addr);
        bzero(&(server_addr.sin_zero),8);
        
        }
    return self;
}

-(void) sendData:(NSString*) data
{
    sendto(sock, [data UTF8String], strlen([data UTF8String]), 0, (struct sockaddr *)&server_addr, sizeof(struct sockaddr));
}
@end