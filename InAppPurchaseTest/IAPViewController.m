//
//  IAPViewController.m
//  DrawChartTest
//
//  Created by FrankLiu on 16/7/6.
//  Copyright © 2016年 FrankLiu. All rights reserved.
//

#import "IAPViewController.h"
//#import "UIView+SetRect.h"
//#import "WxHxD.h"
#import "IAPTableViewCell.h"
#import "IAPHelper.h"
#import "IAPProduct.h"

@interface IAPViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *m_tableView;
@property (nonatomic, strong) NSMutableArray *m_productArray;
@property (nonatomic, strong) IAPHelper      *m_iapHelper;

@end

@implementation IAPViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.m_iapHelper = [IAPHelper new];
    
    self.m_tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.m_tableView];
    
    self.m_tableView.delegate   = self;
    self.m_tableView.dataSource = self;
    
    [self.m_tableView registerClass:[IAPTableViewCell class] forCellReuseIdentifier:IAPCellIdentifier];
    
    [self loadData];
}

- (void)loadData {

    if ([self.m_iapHelper canMakePayments]) {
        
        IAPProduct *product1 = [IAPProduct new];
        
        product1.m_buyType = kCoin1;
        product1.m_productTip = @"1元=1000金币";
        
        IAPProduct *product2 = [IAPProduct new];
        
        product2.m_buyType = kCoin2;
        product2.m_productTip = @"7天试用";
        
        IAPProduct *product3 = [IAPProduct new];
        
        product3.m_buyType = kTemp1;
        product3.m_productTip = @"8元=10000金币";
        
        IAPProduct *product4 = [IAPProduct new];
        
        product4.m_buyType = kFreeVIP;
        product4.m_productTip = @"免费会员";
        
        IAPProduct *product5 = [IAPProduct new];
        
        product5.m_buyType = kLevel101;
        product5.m_productTip = @"杂志会员";
        
        IAPProduct *product6 = [IAPProduct new];
        
        product6.m_buyType = kVIP1;
        product6.m_productTip = @"杂志会员2";
        
        IAPProduct *product7 = [IAPProduct new];
        
        product7.m_buyType = kVIP2;
        product7.m_productTip = @"第101关";
        
        self.m_productArray = [NSMutableArray arrayWithObjects:product1,product2,product3,product4,product5,product6,product7, nil];
        [self.m_tableView reloadData];
        
    } else {
        
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的手机没有打开程序内付费购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView show];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.m_productArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IAPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IAPCellIdentifier];
    
    IAPProduct *product = self.m_productArray[indexPath.row];
    
    cell.textLabel.text = product.m_productTip;
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    IAPProduct *product = self.m_productArray[indexPath.row];
    
    self.m_iapHelper.m_buyType = product.m_buyType;
    
    [self.m_iapHelper requestProducts];
}

@end
