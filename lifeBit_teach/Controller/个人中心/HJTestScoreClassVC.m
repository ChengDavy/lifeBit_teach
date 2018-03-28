//
//  HJTestScoreClassVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJTestScoreClassVC.h"
#import "HJTestScoreCell.h"

@interface HJTestScoreClassVC ()
@property (weak, nonatomic) IBOutlet HJPageView *pageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *studentArr;

@property (nonatomic,strong)NSMutableArray *showStudentArr;

@end

@implementation HJTestScoreClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



-(void)initialize{
    [self setNavigationBarTitleTextColor:@"学生成绩详情"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [self.pageView setTapPageClickBlock:^(NSInteger selectIndex, UIButton *selectBtn) {
        [weakSelf refreshStudentWithSex:selectIndex];
    }];
    self.pageView.pageItemArr = @[@"全部学生",@"男生",@"女生"];
}

-(NSMutableArray *)studentArr{
    if (_studentArr == nil) {
        _studentArr = [NSMutableArray array];
        NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentSecoreWith:self.classInfo.cClassId withRecordDate:self.classInfo.cStartTime];
        for (ScoreModel*scoreModel in classStudentArr) {
            HJStudentInfo *studentInfo = [HJStudentInfo createScoreInfoWithScoreModel:scoreModel];
            [_studentArr addObject:studentInfo];
        }
        // 指定排序的比较方法
//        NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
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
-(void)refreshStudentWithSex:(NSInteger)sexIndex{
    [self.showStudentArr removeAllObjects];
    if (sexIndex == 1) {
        
//        NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
//        NSArray *descs = @[studentNoDesc];
//        NSArray *array2 = [self.studentArr sortedArrayUsingDescriptors:descs];
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
            if ([studentInfo.sSex intValue] == 1) {
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
        
    }else if (sexIndex ==3){
        
        for (HJStudentInfo*studentInfo in self.studentArr) {
            if ([studentInfo.sSex intValue] == 2) {
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
    if (self.showStudentArr.count <= 0) {
        HJEmptyCell *emptyCell = [[[NSBundle mainBundle] loadNibNamed:@"HJEmptyCell" owner:nil options:nil] lastObject];
        
        return emptyCell;
    }
    HJTestScoreCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"HJTestScoreCell" owner:nil options:nil] lastObject];
    HJStudentInfo * studentInfo = self.showStudentArr[indexPath.row];
    [cell updateSelfUi:studentInfo];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showStudentArr.count <= 0) {
        return self.tableView.bounds.size.height;
    }
    
    return 73;
}

@end
