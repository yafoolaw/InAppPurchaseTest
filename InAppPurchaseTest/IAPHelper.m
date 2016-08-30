//
//  IAPHelper.m
//  DrawChartTest
//
//  Created by FrankLiu on 16/7/5.
//  Copyright © 2016年 FrankLiu. All rights reserved.
//

#import "IAPHelper.h"

@interface IAPHelper ()

@property (nonatomic, strong) SKProductsRequest *m_request;

@end

@implementation IAPHelper

- (instancetype)init {
    
    self = [super init];
    if (self) {
       
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (BOOL)canMakePayments {

    return [SKPaymentQueue canMakePayments];
}

- (void)requestProducts {

    NSArray *product = nil;
    switch (self.m_buyType) {
        case kCoin1:
            product=[[NSArray alloc] initWithObjects:ProductID_COIN1,nil];
            break;
            
        case kCoin2:
            product=[[NSArray alloc] initWithObjects:ProductID_COIN2,nil];
            break;
            
        case kTemp1:
            product=[[NSArray alloc] initWithObjects:ProductID_TEMP1,nil];
            break;
            
        case kFreeVIP:
            product=[[NSArray alloc] initWithObjects:ProductID_FREEVIP,nil];
            break;
            
        case kLevel101:
            product=[[NSArray alloc] initWithObjects:ProductID_LEVEL101,nil];
            break;
            
        case kVIP1:
            product=[[NSArray alloc] initWithObjects:ProductID_VIP1,nil];
            break;
            
        case kVIP2:
            product=[[NSArray alloc] initWithObjects:ProductID_VIP2,nil];
            break;
            
        default:
            break;
    }
    
    NSSet *set = [NSSet setWithArray:product];
    
    self.m_request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    self.m_request.delegate = self;
    [self.m_request start];
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.m_request = nil;
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    }
}

#pragma mark - SKRequestDelegate
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{

    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}


-(void)requestDidFinish:(SKRequest *)request {
    
}

//交易结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"购买成功"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
                [alerView show];
                
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            { [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}
- (void)completeTransaction: (SKPaymentTransaction *)transaction {
    
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

#pragma mark - 交易处理

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

-(void)failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    if (queue.transactions.count) {
        
        SKPaymentTransaction *transaction = queue.transactions[0];
        
        NSLog(@"!!!!!!!%@---%@",transaction.transactionIdentifier,transaction.transactionDate);
    }
    
}

-(void)restoreTransaction: (SKPaymentTransaction *)transaction {
    
    NSLog(@" 交易恢复处理");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void)paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

- (void)dealloc {
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听    
}


@end
