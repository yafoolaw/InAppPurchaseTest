//
//  IAPHelper.h
//  DrawChartTest
//
//  Created by FrankLiu on 16/7/5.
//  Copyright © 2016年 FrankLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import StoreKit;

#define ProductID_COIN1    @"FrankLiu.DrawChartTest.coin1"
#define ProductID_COIN2    @"FrankLiu.DrawChartTest.coin2"
#define ProductID_TEMP1    @"FrankLiu.DrawChartTest.temp1"
#define ProductID_FREEVIP  @"FrankLiu.DrawChartTest.freevip"
#define ProductID_LEVEL101 @"FrankLiu.DrawChartTest.level101"
#define ProductID_VIP1     @"FrankLiu.DrawChartTest.vip1"
#define ProductID_VIP2     @"FrankLiu.DrawChartTest.vip2"

typedef enum : NSUInteger {
    
    kCoin1=1000,
    kCoin2,
    kTemp1,
    kFreeVIP,
    kLevel101,
    kVIP1,
    kVIP2,
    
} EIAPProductType;

@interface IAPHelper : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>

//@property (nonatomic, strong) NSSet             *m_productIdentifiers;
//@property (nonatomic, strong) NSArray           *m_products;
//@property (nonatomic, strong) NSMutableSet      *m_purchasedProducts;

@property (nonatomic)         EIAPProductType    m_buyType;

- (void)requestProducts;
- (BOOL)canMakePayments;

@end
