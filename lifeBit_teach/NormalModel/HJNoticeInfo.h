//
//  HJNoticeInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/19.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface HJNoticeInfo : BaseModel
//消息id
@property (nonatomic,strong)NSString* nNoticeId;
//消息标题
@property (nonatomic,strong)NSString* nNoticeTitle;
//消息内容
@property (nonatomic,strong)NSString* nNoticeContent;
//消息简介
@property (nonatomic,strong)NSString* nNoticeIntroduction;
//消息类型
@property (nonatomic,strong)NSString* nNoticeType;
//消息正文URL
@property (nonatomic,strong)NSString* nNoticeURL;
//消息记录人
@property (nonatomic,strong)NSString* nNoticeRecMan;
//消息记录时间
@property (nonatomic,strong)NSString* nNoticeRecDate;
//消息状态
@property (nonatomic,strong)NSString* nNoticeState;

//消息学校ID
@property (nonatomic,strong)NSString* nNoticeSchoolId;

//消息发送时间
@property (nonatomic,strong)NSString* nNoticeTime;
@end
