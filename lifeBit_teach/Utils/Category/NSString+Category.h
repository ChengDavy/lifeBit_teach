
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kDateTimeSecFormat @"yyyy-MM-dd HH:mm:ss"
#define kDateTimeFormat @"yyyy-MM-dd HH:mm"
#define kDateFormat @"yyyy-MM-dd"

@interface NSString (Category) 

-(NSString*)encodeURL;

- (NSString *)stringToUTF8;
- (NSString *)stringToGb2312;
- (NSString *)stringFormatNumber;
- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions) options;

- (NSString *)MD5;
- (NSString *)trim;

- (BOOL)isAllDigits;
+(NSString*)stringAwayFromNSNULL:(NSString *)str;

// 获取一个随机整数，范围在[from,to），包括from，不包括to
+(int)getRandomNumber:(int)from to:(int)to;

#pragma mark - 路径获取
+ (NSString*) GetDocumentsPath;
+(NSString*)GetCachesPath;

+(NSString*)DateCurrentIntervalSince1970:(NSTimeInterval)secs;


+ (long long) fileSizeAtPath:(NSString*) filePath;

+ (float ) folderSizeAtPath:(NSString*) folderPath;


//根据字符串计算其所占的空间
+(CGSize)sizeWithString:(NSString *)str;
//根据字符串计算其所占的空间
+(CGSize)sizeWithString:(NSString *)str cs:(CGSize)cs;

+ (BOOL) isMobile:(NSString *)mobileNumbel;


//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string;
//正则表达式 判断 英文和数字
+ (BOOL) validateABC123Char:(NSString *)text;
@end
