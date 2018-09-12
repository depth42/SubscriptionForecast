//
//  Subscription.m
//  SubscriptionForecast
//
//  Created by Frank Illenberger on 07.09.17.
//  Copyright © 2017 Frank Illenberger. All rights reserved.
//

#import "Subscription.h"
#import "Forecast.h"

@implementation Subscription

- (NSInteger) runningDuration
{
    return self.forecast.currentMonth - self.startMonth;
}

- (BOOL)needsToRenew
{
    return (self.runningDuration % self.period) == 0;
}

- (BOOL)wantsToCancel
{
    if(!self.needsToRenew || self.runningDuration == 0)
        return NO;
    
    double prob = self.cancelProbability;
    if(prob == 0.0)
        return NO;
    
    return drand48() <= prob;
}

- (BOOL) isInSecondYear
{
    return self.runningDuration > 12;
}

- (double) provisionFraction
{
    if(self.subscriptionType == SubscriptionTypeApple)
        return self.isInSecondYear ? 0.15 : 0.3;
    else
        return self.forecast.directSalesProvision;
}

- (double) revenue
{
    if(!self.needsToRenew)
        return 0.0;
    else
        return self.price * (1.0 - self.provisionFraction);
}

@end
