
#import <Foundation/Foundation.h>
#define kDateTimeFormat @"yyyy-MM-dd HH:mm"

@interface NSDate (Categories)


- (NSString *)normalizeDateString;

/**
 *  返回聊天室的时间
 *
 *  @return
 */
-(NSString *)chatRoomDataString;
 
/**
 *  返回相册的时间
 *
 *  @return
 */
-(NSString *)photoAlbumDateString;

#pragma  mark - 日期格式处理
+(id)shareDateFormater;
/*
 *日期转换为字符串函数
 *参数：DateFormatter 的格式如 2012-02-05  这种日期使用  yyyy-MM-dd
 */
+(NSDate *)StringConvertToDateWithString:(NSString * )dateString  DateFormatter:(NSString*)formatter;
+(NSString *)DateConvertToStringWithDate:(NSDate *)date  DateFormatter:(NSString*)formatter;
//+ (NSDate *)tDate;
//转换有好字符串描述
//比如  最后一天，上一周等时间描述
+(NSString *)DateConvertToFriendlyStringWithDate:(NSDate *)date;

+(NSDate *)dateFromString:(NSString *)string format:(NSString *)format;

+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+(NSString*)dateWithStringDate:(NSString*)dateStr format:(NSString*)format;
 
/**
 *  从今天起3天返回（今天，明天，后天）字符串 第4天返回（周一，周二等）
 *
 *  @param date 日期
 *
 *  @return
 */
+(NSString *)DateConvertToWeekStringWithDate:(NSDate *)date;


+(NSString*)DateCurrentIntervalSince1970:(NSTimeInterval)secs;

+(NSString*)DateCurrentIntervalWithNumberDays:(NSString*)dateString;

// 根据日期返回于当前的时间对比的时间戳
+(NSInteger)dataCurrentIntervalWithTimeStamp:(NSString*)dateString;
// 市区转换
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

// 获取当前的属于周几
+(NSInteger)dataCurrentFromaWeek;
@end
