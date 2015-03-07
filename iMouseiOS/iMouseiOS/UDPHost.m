//
//  UDPHost.m
//  Downhill Penguin
//
//  Created by Will Cobb on 3/11/14.
//  Copyright (c) 2014 Will Cobb. All rights reserved.
//

#import "UDPHost.h"

@implementation UDPHost
-(id) initWithPort:(int) port
{

    if ((self = [super init]))
    {

        if ((sock = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
        {
            perror("Socket");
            exit(1);
        }

        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(port);
        server_addr.sin_addr.s_addr = INADDR_ANY;
        bzero(&(server_addr.sin_zero),8);


        if (bind(sock,(struct sockaddr *)&server_addr,
            sizeof(struct sockaddr)) == -1)
        {
            perror("Bind");
            exit(1);
        }
        NSLog(@"BOUND to %i", port);
        addr_len = sizeof(struct sockaddr);
    }
    return self;

}

-(NSString *) recieveData
{
    bytes_read = recvfrom(sock,recv_data,1024,0,
	                    (struct sockaddr *)&client_addr, &addr_len);
    recv_data[bytes_read] = '\0';
    return [NSString stringWithFormat:@"%s", recv_data];
}
@end
