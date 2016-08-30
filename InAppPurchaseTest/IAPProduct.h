//
//  IAPProduct.h
//  InAppPurchaseTest
//
//  Created by FrankLiu on 16/8/30.
//  Copyright © 2016年 FrankLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAPHelper.h"

@interface IAPProduct : NSObject

@property (nonatomic, strong) NSString        *m_productTip;
@property (nonatomic        ) EIAPProductType  m_buyType;

@end
