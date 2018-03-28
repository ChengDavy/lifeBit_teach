
#import "NSDate+Categories.h"

#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd")

@implementation NSDate(Categories)

-(NSString *)normalizeDateString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    if ([components day] >= 3) {
        return [self.class stringFromDate:self format:@"yyyy-MM-dd"];
    } else if ([components day] >= 2) {
        return @"前天";
    } else if ([components day] >= 1) {
        return @"昨天";
    } else if ([components hour] > 0) {
        return [NSString stringWithFormat:@"%d小时前", [components hour]];
    } else if ([components minute] > 0) {
        return [NSString stringWithFormat:@"%d分钟前", [components minute]];
    } else if ([components second] > 0) {
        return [NSString stringWithFormat:@"%d秒前", [components second]];
    } else {
        return @"刚刚";
    }
}

/**
 *  返回聊天室的时间
 *
 *  @return
 */
-(NSString *)chatRoomDataString{
    NSString *dateText = @"";
    NSString *timeText = @"";
    
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterday];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        //dateText = NSLocalizedString(@"今天", @"今天");
    } else if (dateComponents.year == yesterdayComponents.year && dateComponents.month == yesterdayComponents.month && dateComponents.day == yesterdayComponents.day) {
        dateText = NSLocalizedString(@"昨天", @"昨天");
    } else {
        dateText = [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
    timeText = [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    return  [NSString stringWithFormat:@"%@ %@",dateText,timeText];
    
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
//    if ([components day] >= 2) {
//        return [self.class stringFromDate:self format:@"yyyy/MM/dd"];
//    }  else if ([components day] >= 1) {
//        return [NSString stringWithFormat:@"昨天 %@",[NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]] ;
//    } else { 
//        return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
//    }
}

/**
 *  返回相册的时间
 *
 *  @return
 */
-(NSString *)photoAlbumDateString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    
    NSString *strTime = [self.class stringFromDate:self format:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([components day] >= 2) {
        return [self.class stringFromDate:self format:@"yyyy/MM/dd"];
    }  else if ([components day] >= 1) {
        return [NSString stringWithFormat:@"昨天 %@",[strTime substringWithRange:NSMakeRange(11, 5)]];
    } else {
        NSDate* currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self];
        if (timeInterval < 60*5) {
             return [NSString stringWithFormat:@"刚刚"];
        }
        
        return [NSString stringWithFormat:@"今天 %@",[strTime substringWithRange:NSMakeRange(11, 5)]];
    }
}

+ (NSDate *)dateForTodayInClock:(NSInteger)clock
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit) fromDate:[NSDate date]];
    [todayComponents setHour:clock];
    NSDate *theDate = [gregorian dateFromComponents:todayComponents];
    return theDate;
}

#pragma  mark - 日期格式处理

#define DEFAULTDATEFORMATTER @"yyyy-MM-dd"
#define DAYSECENDS 86400.0
static NSDateFormatter *CommonShareDateFormatter = nil;
+(id)shareDateFormater
{
    if (CommonShareDateFormatter == nil) {
        CommonShareDateFormatter = [[NSDateFormatter alloc]  init];
    }
    
    return CommonShareDateFormatter;
}
/*
 *日期转换为字符串函数
 *参数：DateFormatter 的格式如 2012-02-05  这种日期使用  yyyy-MM-dd
 */
+ (NSDate *)StringConvertToDateWithString:(NSString * )dateString  DateFormatter:(NSString*)formatter
{
    if (!dateString) {
        return nil;
    }
    NSDateFormatter * dateFormatter = [self.class shareDateFormater];
    if (formatter == nil) {
        formatter = DEFAULTDATEFORMATTER;
    }
    [dateFormatter setDateFormat: formatter];
    NSDate *date = nil;
    
     date=[dateFormatter dateFromString:dateString];
    
//    if ([dateFormatter getObjectValue:&date forString:dateString range:nil error:nil]) {
//        //NIF_ERROR(@"%@",error);
//    }
    
    return date;
}

+ (NSString *)DateConvertToStringWithDate:(NSDate *)date  DateFormatter:(NSString*)formatter
{
    
    NSDateFormatter * dateFormatter = [self.class shareDateFormater];
    if (formatter == nil) {
        formatter = DEFAULTDATEFORMATTER;
    }
    [dateFormatter setDateFormat: formatter];
    NSString *dateString = [dateFormatter stringFromDate:date ];
    return dateString;
}

//放回有好字符串描述
//比如  最后一天，上一周等
+(NSString *)DateConvertToFriendlyStringWithDate:(NSDate *)date
{
    
    NSDate * currentDate=[NSDate date];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=kCFCalendarUnitMinute|kCFCalendarUnitHour|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    
    NSDateComponents * currentConponent= [cal components:unitFlags fromDate:currentDate];
    NSDateComponents * oldConponent = [cal components:unitFlags fromDate:date];
    
    NSDateFormatter *outputFormatter = [self.class shareDateFormater];
    
    
    //    NSInteger oldMonth = [oldConponent month];
    //    NSInteger oldHour = [oldConponent hour];
    //    NSInteger oldMinute = [oldConponent minute];
    NSInteger oldWeekday = [oldConponent weekday];
    NSInteger currentWeekday = [currentConponent weekday];
    
    NSString *week;
    //NSString *weekday;
    NSInteger spanDays = (NSInteger)(([currentDate timeIntervalSince1970] - [date timeIntervalSince1970])/DAYSECENDS);
    
    NSString * nsDateString;
    switch (oldWeekday) {
        case 1:
            week = @"星期天";
            //weekday = @"Sunday";
            break;
        case 2:
            week = @"星期一";
            // weekday = @"Monday";
            break;
        case 3:
            week = @"星期二";
            //weekday = @"Tuesday";
            break;
        case 4:
            week = @"星期三";
            // weekday = @"Wednesday";
            break;
        case 5:
            week = @"星期四";
            //weekday = @"Thursday";
            break;
        case 6:
            week = @"星期五";
            //weekday = @"Friday";
            break;
        case 7:
            week = @"星期六";
            //weekday = @"Saturday";
            break;
        default:
            break;
    }
    
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    
    
    if (spanDays == 0)
    {
        nsDateString = [NSString stringWithFormat:@"%@",newDateString];
    }
    else if (spanDays  == 1)
    {
        
        nsDateString = [NSString stringWithFormat:@"昨天 %@",newDateString];
    }
    else if (( 1 < spanDays ) &&  (spanDays < 7))
    {
        NSInteger newCurrentWeekday = currentWeekday == 1 ? 8 : currentWeekday;
        NSInteger newOldWeekday = oldWeekday == 1 ? 8 : oldWeekday;
        
        if (newCurrentWeekday <= newOldWeekday) {
            [outputFormatter setDateFormat:@"MM月dd日"];
            nsDateString = [NSString stringWithFormat:@"%@ %@ %@",[outputFormatter stringFromDate:date],week,newDateString];//处理结果，  星期一、上星期二
        }else{
            nsDateString = [NSString stringWithFormat:@"%@ %@",week,newDateString];
        }
    }
    
    else // if(time>=7  )
    {
        [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        nsDateString = [outputFormatter stringFromDate:date];
    }
    
    
    return nsDateString;
}


+(NSDate *)dateFromString:(NSString *)string format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    //  [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
	[formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    
	return date;
}

+(NSDate *)tDate

{
    
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSLog(@"%@", localeDate);
    return localeDate;
}


+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    
	return dateString;
}
 
+(NSString*)dateWithStringDate:(NSString*)dateStr format:(NSString*)format{
    NSDate* date = [NSDate dateFromString:dateStr format:@"yyyymmdd"];
    return  [NSDate stringFromDate:date format:format];
}
/**
 *  返回周字符串
 *
 *  @param date 日期
 *
 *  @return
 */
+(NSString *)DateConvertToWeekStringWithDate:(NSDate *)date{
    NSDate * currentDate=[NSDate date];
    NSString *str = [self stringFromDate:currentDate format:kDEFAULT_DATE_TIME_FORMAT];
    NSDate *tmpDate = [self dateFromString:str format:kDEFAULT_DATE_TIME_FORMAT];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSInteger spanDays = (NSInteger)(([tmpDate timeIntervalSince1970] - [date timeIntervalSince1970])/DAYSECENDS);
    
    NSString * nsDateString;
    
    if (spanDays == 0){
        nsDateString = @"今天";
    }else if (spanDays  == -1){
        nsDateString = @"明天";
    }else if ( -2 == spanDays){
        nsDateString = @"后天";
    }else{
        NSUInteger unitFlags=kCFCalendarUnitMinute|kCFCalendarUnitHour|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * oldConponent = [cal components:unitFlags fromDate:date];
        NSInteger oldWeekday = [oldConponent weekday];
        switch (oldWeekday) {
            case 1:
                nsDateString = @"周日";
                break;
            case 2:
                nsDateString = @"周一";
                break;
            case 3:
                nsDateString = @"周二";
                break;
            case 4:
                nsDateString = @"周三";
                break;
            case 5:
                nsDateString = @"周四";
                break;
            case 6:
                nsDateString = @"周五";
                break;
            case 7:
                nsDateString = @"周六";
                break;
            default:
                break;
        }

    }
 
    return nsDateString;
}
 
+(NSString*)DateCurrentIntervalSince1970:(NSTimeInterval)secs{
//    secs = secs/1000;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:kDateTimeFormat];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    
    return [formatter stringFromDate:date];
}


+(NSString*)DateCurrentIntervalWithNumberDays:(NSString*)dateString{
   NSDate* date = [NSDate dateFromString:dateString format:kDEFAULT_DATE_TIME_FORMAT];
   NSDate* currentDate = [NSDate date];
   NSInteger timeIndex = [currentDate timeIntervalSinceDate:date];
//    NSString* str = nil;
//    if (timeIndex > 0) {
//        str = @"前";
//    }else{
//        str = @"后";
//    }
    timeIndex = labs(timeIndex);
   NSInteger numberDays = 60*60*24;
   NSInteger days = timeIndex/numberDays;
   NSInteger remainingSeconds = timeIndex%numberDays;
   NSInteger hours = remainingSeconds/(60*60);
   remainingSeconds = remainingSeconds%(60*60);
    
   NSInteger minutes = remainingSeconds/60;
   remainingSeconds = remainingSeconds%60;
 
    return [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",(long)days,(long)hours,(long)minutes,(long)remainingSeconds];
}

// 根据日期返回于当前的时间对比的时间戳
+(NSInteger)dataCurrentIntervalWithTimeStamp:(NSString*)dateString{
    NSDate* date = [NSDate dateFromString:dateString format:kDEFAULT_DATE_TIME_FORMAT];
    NSDate* currentDate = [NSDate date];
    NSInteger timeIndex = [currentDate timeIntervalSinceDate:date];
    return labs(timeIndex);
}

// 市区转换
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}


+(NSInteger)dataCurrentFromaWeek{
    NSDate *date1 = [NSDate date];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags =kCFCalendarUnitMinute|kCFCalendarUnitHour|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * oldConponent = [cal components:unitFlags fromDate:date1];
    NSInteger oldWeekday = [oldConponent weekday];
    return oldWeekday - 1;
}
@end
