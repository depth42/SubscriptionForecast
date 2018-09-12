//
//  Forecast.m
//  SubscriptionForecast
//
//  Created by Frank Illenberger on 07.09.17.
//  Copyright © 2017 Frank Illenberger. All rights reserved.
//

#import "Forecast.h"
#import "Subscription.h"

NS_ASSUME_NONNULL_BEGIN

@interface Forecast ()
@property NSInteger     currentMonth;
@property double        currentSubscriptionsRevenue;
@property NSInteger     currentCanceledSubscriptions;
@end

#pragma mark -

@implementation Forecast
{
    NSMutableSet<Subscription*>* _subscriptions;
}

+ (void) initialize
{
    if(self == Forecast.class)
        srand48(time(0));
}

- (instancetype) init
{
    self = [super init];
    
    _subscriptions  = [[NSMutableSet alloc] init];
    
    [self configureDefaults];
    
    return self;
}

- (void)configureDefaults
{
    self.numberOfMonths                         = 48;
    
    self.directDiscountSubscriptionsPerMonth    = @[ @200, @200, @150, @150,  @100,  @50, @0 ];
    self.directNewSubscriptionsPerMonth         = @[ @300, @200, @200, @200, @150 ];
    self.appleNewSubscriptionsPerMonth          = @[  @50,  @50,  @100, @100, @50 ];
    self.appleDiscountSubscriptionsPerMonth     = @[ @0];
    
    self.yearlyFraction                         = 0.4;
    self.halfYearlyFraction                     = 0.0;
    self.quarterlyFraction                      = 0.0;
    self.monthlyFraction                        = 0.6;
    
    self.yearlyPrice                            = 149.99;
    self.halfYearlyPrice                        = 89.99;
    self.quarterlyPrice                         = 49.99;
    self.monthlyPrice                           = 24.99;
    
    self.yearlyIntoductoryPrice                 = 99.99;
    
    self.yearlyCancelProbability                = 0.35;
    self.halfYearlyCancelProbability            = 0.4;
    self.quarterlyCancelProbability             = 0.25;
    self.monthlyCancelProbability               = 0.2;
    
    self.directSalesProvision                   = 0.05;
    
    self.bankAccount                            = 200000.0;
    self.fixedCostPerMonth                      = 50000.0;
    self.fixedIncomePerMonth                    = @[ @5000 ];
}

- (void)run
{
    for(NSUInteger iMonth = 0; iMonth < self.numberOfMonths; iMonth++)
    {
        self.currentMonth = iMonth;
        [self updateSubscriptions];
        [self updateBankAccount];
        [self logStatus];
    }
}

- (void)updateSubscriptions
{
    [self cancelSubscriptions];
    
    [self createNewSubscriptions:self.currentDirectNewSubscriptionsCount
                          ofType:SubscriptionTypeDirect];
    
    [self createNewSubscriptions:self.currentAppleNewSubscriptionsCount
                          ofType:SubscriptionTypeApple];
    
    [self createNewSubscriptions:self.currentDirectDiscountSubscriptionsCount
                          ofType:SubscriptionTypeDirect
               cancelProbability:self.yearlyCancelProbability * 0.5
                           price:self.yearlyIntoductoryPrice
                          period:12];

    [self createNewSubscriptions:self.currentAppleDiscountSubscriptionsCount
                          ofType:SubscriptionTypeApple
               cancelProbability:self.yearlyCancelProbability * 0.5
                           price:self.yearlyIntoductoryPrice
                          period:12];
}

- (void)createNewSubscriptions:(NSUInteger)count
                        ofType:(SubscriptionType)subscriptionType
{
    [self createNewSubscriptions:(double)count * self.yearlyFraction
                          ofType:subscriptionType
               cancelProbability:self.yearlyCancelProbability
                           price:self.yearlyPrice
                          period:12];

    [self createNewSubscriptions:(double)count * self.halfYearlyFraction
                          ofType:subscriptionType
               cancelProbability:self.halfYearlyCancelProbability
                           price:self.halfYearlyPrice
                          period:6];

    [self createNewSubscriptions:(double)count * self.quarterlyFraction
                          ofType:subscriptionType
               cancelProbability:self.quarterlyCancelProbability
                           price:self.quarterlyPrice
                          period:3];

    [self createNewSubscriptions:(double)count * self.monthlyFraction
                          ofType:subscriptionType
               cancelProbability:self.monthlyCancelProbability
                           price:self.monthlyPrice
                          period:1];
}

- (void)createNewSubscriptions:(NSUInteger)count
                        ofType:(SubscriptionType)subscriptionType
             cancelProbability:(double)cancelProbability
                         price:(double)price
                        period:(NSInteger)period
{
    for(NSUInteger index=0; index<count; index++)
    {
        Subscription* subscription = [[Subscription alloc] init];
        subscription.subscriptionType   = subscriptionType;
        subscription.cancelProbability  = cancelProbability;
        subscription.period             = period;
        subscription.price              = price;
        subscription.startMonth         = self.currentMonth;
        subscription.forecast           = self;
        [_subscriptions addObject:subscription];
    }
}

- (void)cancelSubscriptions
{
    NSMutableArray<Subscription*>* cancelledSubscriptions = [[NSMutableArray alloc] init];
    
    for(Subscription* iSub in _subscriptions)
        if(iSub.wantsToCancel)
            [cancelledSubscriptions addObject:iSub];

    for(Subscription* iSub in cancelledSubscriptions)
        [_subscriptions removeObject:iSub];
    
    self.currentCanceledSubscriptions = cancelledSubscriptions.count;
}

- (NSInteger)currentDirectNewSubscriptionsCount
{
    return self.directNewSubscriptionsPerMonth[MIN(self.directNewSubscriptionsPerMonth.count-1, self.currentMonth)].integerValue;
}

- (NSInteger)currentDirectDiscountSubscriptionsCount
{
    return self.directDiscountSubscriptionsPerMonth[MIN(self.directDiscountSubscriptionsPerMonth.count-1, self.currentMonth)].integerValue;
}

- (NSInteger)currentAppleNewSubscriptionsCount
{
    return self.appleNewSubscriptionsPerMonth[MIN(self.appleNewSubscriptionsPerMonth.count-1, self.currentMonth)].integerValue;
}

- (NSInteger)currentAppleDiscountSubscriptionsCount
{
    return self.appleDiscountSubscriptionsPerMonth[MIN(self.appleDiscountSubscriptionsPerMonth.count-1, self.currentMonth)].integerValue;
}

- (double)currentFixedIncome
{
    return self.fixedIncomePerMonth[MIN(self.fixedIncomePerMonth.count-1, self.currentMonth)].integerValue;
}

- (void)updateBankAccount
{
    self.bankAccount += self.currentFixedIncome;
    self.bankAccount -= self.fixedCostPerMonth;
    
    double subscriptionsRevenue = 0.0;
    for(Subscription* iSub in _subscriptions)
        subscriptionsRevenue += iSub.revenue;
    self.currentSubscriptionsRevenue = subscriptionsRevenue;
    self.bankAccount += subscriptionsRevenue;
}

- (void)logStatus
{
    NSLog(@"month: %ld\tsubscriptions: %ld cancelled: %ld subRev: %ld, account: %ld",
          self.currentMonth + 1,
          _subscriptions.count,
          self.currentCanceledSubscriptions,
          (NSInteger)self.currentSubscriptionsRevenue,
          (NSInteger)self.bankAccount);
}

@end

NS_ASSUME_NONNULL_END
