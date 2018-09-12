//
//  main.m
//  SubscriptionForecast
//
//  Created by Frank Illenberger on 07.09.17.
//  Copyright © 2017 Frank Illenberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forecast.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        Forecast* forecast = [[Forecast alloc] init];
        [forecast run];
    }
    return 0;
}
