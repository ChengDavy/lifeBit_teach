//
//  HJClassStudentVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJClassStudentVC.h"
#import "HJClassStudentCell.h"
#import "HJStudentInfo.h"
#import "NSDate+Categories.h"

@interface HJClassStudentVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet HJPageView *pageView;
@property (nonatomic,strong)NSMutableArray *studentArr;

//显示学生数组
@property (nonatomic,strong) NSMutableArray *showStudentArr;

@property (nonatomic,strong) NSMutableArray *watchMACArr;
@end

@implementation HJClassStudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)initialize{
    [self setNavigationBarTitleTextColor:@"学生列表"];
    __weak typeof(self) weakSelf = self;
    [self.pageView setTapPageClickBlock:^(NSInteger selectIndex, UIButton *selectBtn) {
        [weakSelf refreshStudentWithSex:selectIndex];
    }];
    self.pageView.pageItemArr = @[@"全部学生",@"男生",@"女生"];
}

-(NSMutableArray *)studentArr{
    if (_studentArr == nil) {
        _studentArr = [NSMutableArray array];
        NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:self.classInfo.cClassId];
        for (StudentModel*studentModel in classStudentArr) {
            HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
            [_studentArr addObject:studentInfo];
        }
        // 指定排序的比较方法
//        NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
//        
//        NSArray *descs = @[studentNoDesc];
//        NSArray *array2 = [_studentArr sortedArrayUsingDescriptors:descs];
        NSArray *array2 = [_studentArr sortedArrayUsingComparator:
                           ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {
                               if ([NSString isPureInt:obj1.studentNo] ) {
                                   if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                       return (NSComparisonResult)NSOrderedDescending;
                                   }else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
                                       return (NSComparisonResult)NSOrderedAscending;
                                   }
                                   else
                                       return (NSComparisonResult)NSOrderedSame;
                               }
                               // 先按照姓排序
                               NSComparisonResult result = [obj1.studentNo compare:obj1.studentNo];
                               // 如果有相同的姓，就比较名字
                               if (result == NSOrderedAscending) {
                                   result = [obj1.studentNo compare:obj2.studentNo];
                               }
                               
                               return result;
                           }];
        self.showStudentArr = [array2 mutableCopy];
    }
    return _studentArr;
}

-(NSMutableArray *)watchMACArr{
    if (_watchMACArr == nil) {
        _watchMACArr = [[LifeBitCoreDataManager shareInstance] efGetAllWatchModel];
    }
    return _watchMACArr;
}

-(void)refreshStudentWithSex:(NSInteger)sexIndex{
    [self.showStudentArr removeAllObjects];
    if (sexIndex == 1) {
        
        // 利用block进行排序
        NSArray *array2 = [self.studentArr sortedArrayUsingComparator:
                           ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {
                               if ([NSString isPureInt:obj1.studentNo] ) {
                                   if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                       return (NSComparisonResult)NSOrderedDescending;
                                   }else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
                                       return (NSComparisonResult)NSOrderedAscending;
                                   }
                                   else
                                       return (NSComparisonResult)NSOrderedSame;
                               }
                               // 先按照姓排序
                               NSComparisonResult result = [obj1.studentNo compare:obj1.studentNo];
                               // 如果有相同的姓，就比较名字
                               if (result == NSOrderedAscending) {
                                   result = [obj1.studentNo compare:obj2.studentNo];
                               }  
                               
                               return result;  
                           }];
        self.showStudentArr = [array2 mutableCopy];

    }else if (sexIndex == 2) {
        
        for (HJStudentInfo*studentInfo in self.studentArr) {
            if ([studentInfo.sSex boolValue]) {
                [self.showStudentArr addObject:studentInfo];
            }
        }
        NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
        NSArray *descs = @[studentNoDesc];
        NSArray *array2 = [self.showStudentArr sortedArrayUsingDescriptors:descs];
        self.showStudentArr = [array2 mutableCopy];
        
    }else if (sexIndex ==3){
        
        for (HJStudentInfo*studentInfo in self.studentArr) {
            if (![studentInfo.sSex boolValue]) {
                [self.showStudentArr addObject:studentInfo];
            }
        }
//        NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
//        NSArray *descs = @[studentNoDesc];
//        NSArray *array2 = [self.showStudentArr sortedArrayUsingDescriptors:descs];
        NSArray *array2 = [self.showStudentArr sortedArrayUsingComparator:
                           ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {
                               if ([NSString isPureInt:obj1.studentNo] ) {
                                   if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                       return (NSComparisonResult)NSOrderedDescending;
                                   }else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
                                       return (NSComparisonResult)NSOrderedAscending;
                                   }
                                   else
                                       return (NSComparisonResult)NSOrderedSame;
                               }
                               // 先按照姓排序
                               NSComparisonResult result = [obj1.studentNo compare:obj1.studentNo];
                               // 如果有相同的姓，就比较名字
                               if (result == NSOrderedAscending) {
                                   result = [obj1.studentNo compare:obj2.studentNo];
                               }
                               
                               return result;
                           }];
        self.showStudentArr = [array2 mutableCopy];
    }
    
    [self.tableView reloadData];
    
}



#pragma --mark-- UITableViewDataSource UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.showStudentArr.count <= 0) {
        return 1;
    }
    return self.showStudentArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showStudentArr <= 0) {
        HJEmptyCell *emptyCell = [[[NSBundle mainBundle] loadNibNamed:@"HJEmptyCell" owner:nil options:nil] lastObject];
        
        return emptyCell;
        
    }
    
    HJClassStudentCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"HJClassStudentCell" owner:nil options:nil] lastObject];
    
    HJStudentInfo *studentInfo = [self.showStudentArr objectAtIndexWithSafety:indexPath.row];
    [cell updateSelfUi:studentInfo];
    
    __weak typeof(self) weakSelf = self;
    [cell setShowHeartRateClickBlock:^(HJStudentInfo *studentInfo) {
        NSLog(@"点击查看实时心率");
    }];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showStudentArr.count <= 0) {
        return self.tableView.bounds.size.height;
    }
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"查看学生详情");
}


#pragma --mark-- 根据index获取手环数据
// type为1 获取的心率数据  type为2时获取的步数数据
-(NSMutableArray*)getWatchDataAndIndex:(NSInteger)index withDataType:(NSString*)typeStr{
    if (index > self.watchMACArr.count - 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该学生未对应手表，无法同步！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return nil;
    }
    
    WatchModel *watchModel =  [self.watchMACArr objectAtIndexWithSafety:index];
    NSDate *startDate = self.classInfo.cStartTime;
    NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
    timeInterval +=[self.classInfo.cClassTime integerValue] * 60;
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    NSMutableArray * dataArr = [[LifeBitCoreDataManager shareInstance] efGetBluetoothDataModelWithStartDate:startDate WithendDate:endDate withDataType:typeStr withMAC:watchModel.watchMAC];
    
    return dataArr;
}





@end
