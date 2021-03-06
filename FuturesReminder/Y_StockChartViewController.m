//
//  YStockChartViewController.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartViewController.h"
#import "Masonry.h"
#import "Y_StockChartView.h"
#import "Y_StockChartView.h"
#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
@interface Y_StockChartViewController ()<Y_StockChartViewDataSource>

@property (nonatomic, strong) Y_StockChartView *stockChartView;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@end

@implementation Y_StockChartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIndex = -1;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of  nmthat can be recreated.
}

-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"getInnerFuturesMiniKLine15m";
        }
            break;
        case 1:
        {
            type = @"getInnerFuturesMiniKLine15m";
        }
            break;
        case 2:
        {
            type = @"getInnerFuturesMiniKLine15m";
        }
            break;
        case 3:
        {
            type = @"getInnerFuturesMiniKLine5m";
        }
            break;
        case 4:
        {
            type = @"getInnerFuturesMiniKLine30m";
        }
            break;
        case 5:
        {
            type = @"getInnerFuturesMiniKLine60m";
        }
            break;
        case 6:
        {
            type = @"getInnerFuturesDailyKLine";
        }
            break;
        case 7:
        {
            type = @"getInnerFuturesMiniKLine15m";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type])
    {
        [self reloadData];
    } else {
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}

- (void)reloadData
{
    /*
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"symbol"] = @"huobibtccny";
    param[@"size"] = @"300";
    NSString *urlStr = @"https://www.btc123.com/kline/klineapi";
     
    [NetWorking requestWithApi:urlStr param:param thenSuccess:^(NSDictionary *responseObject) {
        if ([responseObject[@"isSuc"] boolValue]) {
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"datas"]];
            
            self.groupModel = groupModel;
            [self.modelsDict setObject:groupModel forKey:self.type];
            NSLog(@"%@",groupModel);
            [self.stockChartView reloadData];
        }
        
    } fail:^{
        
    }];
    */
    
    NSDictionary *params = @{@"symbol":@"BU0"};
    //http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFuturesMiniKLine5m
    //http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFuturesMiniKLine30m
    //http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFuturesMiniKLine60m
    //http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFuturesDailyKLine
    
    NSString *urlStr = @"http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService";//15分钟
    urlStr = [urlStr stringByAppendingString:@"."];
    urlStr = [urlStr stringByAppendingString:self.type];
    [NetWorking requestWithApi:urlStr param:params thenSuccess:^(NSDictionary *responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)responseObject;
            NSArray *sortArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                NSArray *arr1 = obj1;
                NSArray *arr2 = obj2;
                NSComparisonResult result = [[arr1 objectAtIndex:0] compare:[arr2 objectAtIndex:0]];
                return result == NSOrderedDescending;
                
            }];
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:sortArray];
            
            self.groupModel = groupModel;
            [self.modelsDict setObject:groupModel forKey:self.type];
            NSLog(@"%@",groupModel);
            [self.stockChartView reloadData];
        }
        
    } fail:^{
        
    }];
}
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"60分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"日线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"周线" type:Y_StockChartcenterViewTypeKline],
 
                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tap];
    }
    return _stockChartView;
}
- (void)dismiss
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.isEable = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
@end
