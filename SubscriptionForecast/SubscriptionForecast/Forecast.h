//
//  Forecast.h
//  SubscriptionForecast
//
//  Created by Frank Illenberger on 07.09.17.
//  Copyright © 2017 Frank Illenberger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Simple Monte Carlo simulation of the cash flow of app subscriptions created by customers via our own
// store and the Apple Mac App Store.
@interface Forecast : NSObject

// The simulation iterates over months. This property receives the number of months the simulation should run.
@property NSInteger numberOfMonths;

// Array needs to be configured with the expected number of new subscriptions per month which are sold without
// any discount for existing customers directly via our on store.
// If there are less numbers than last number will be used repeatedly until the end of the simulation.
@property NSArray<NSNumber*>* directNewSubscriptionsPerMonth;

// Array needs to be configured with the expected number of new subscriptions per month which are sold to existing
// customers with a discount directly via our on store. This corresponds with the -yearlyIntoductoryPrice.
// If there are less numbers than last number will be used repeatedly until the end of the simulation.
@property NSArray<NSNumber*>* directDiscountSubscriptionsPerMonth;

// Array needs to be configured with the expected number of new subscriptions per month which are sold without
// any discount for existing customers directly via the Mac App Store.
// If there are less numbers than last number will be used repeatedly until the end of the simulation.
@property NSArray<NSNumber*>* appleNewSubscriptionsPerMonth;

// Array needs to be configured with the expected number of new subscriptions per month which are sold to existing
// customers with a discount directly via the Mac App Store.
// This corresponds with the -yearlyIntoductoryPrice
// If there are less numbers than last number will be used repeatedly until the end of the simulation.
@property NSArray<NSNumber*>* appleDiscountSubscriptionsPerMonth;

// These properties need to add up to 1.0. They define which fraction of the created subscriptions will have
// the said period.
@property double yearlyFraction;
@property double halfYearlyFraction;
@property double quarterlyFraction;
@property double monthlyFraction;

// These properties need to be configured with the average net selling prices (without VAT).
@property double yearlyPrice;
@property double halfYearlyPrice;
@property double quarterlyPrice;
@property double monthlyPrice;

// The discounted price for existing customers.
// Corresponds to -directDiscountSubscriptionsPerMonth and -appleDiscountSubscriptionsPerMonth
@property double yearlyIntoductoryPrice;

// Numbers between 0.0 and 1.0 which configure the chance of a customer cancelling after the end of a period.
@property double yearlyCancelProbability;
@property double halfYearlyCancelProbability;
@property double quarterlyCancelProbability;
@property double monthlyCancelProbability;

// The provision for the billing provider for direct sales in our own store.
// The provisions for the Mac App Store are hard-coded to 0.3 for subscriptions in the first year,
// and 0.15 for subscriptions which are active for more than one year.
@property double directSalesProvision;

// Needs to be configured with the current cash in the bank account.
@property double bankAccount;

// Needs to be configured with average other cost per month.
@property double fixedCostPerMonth;

// Array needs to be configured with the fixed income amount per month.
// If there are less numbers than last number will be used repeatedly until the end of the simulation.
@property NSArray<NSNumber*>* fixedIncomePerMonth;

// Starts the simulation
- (void)run;

@property (readonly) NSInteger     currentMonth;

@end

NS_ASSUME_NONNULL_END
