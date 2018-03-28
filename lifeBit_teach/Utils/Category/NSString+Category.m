
#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>


@implementation  NSString (Category)

- (NSString*)encodeURL
{
    NSString *newString = [self stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    if (newString) {
        return newString;
    }
    return @"";
}

- (NSString *)stringToUTF8{

	NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																				  NULL, /* allocator */
																				  (CFStringRef)self,
																				  NULL, /* charactersToLeaveUnescaped */
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8));
	return escaped_value ;
}

// Encode Chinese to GB2312 in URL
- (NSString *)stringToGb2312{
	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
	NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingGB_18030_2000));
	NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000))  ;
 	return newStr;
}

- (NSString *)stringFormatNumber{
    @try{
        if (self.length < 3)
        {
            return self;
        }
        NSString *numStr = self;
        NSArray *array = [numStr componentsSeparatedByString:@"."];
        NSString *numInt = [array objectAtIndex:0];
        if (numInt.length <= 3)
        {
            return self;
        }
        NSString *suffixStr = @"";
        if ([array count] > 1)
        {
            suffixStr = [NSString stringWithFormat:@".%@",[array objectAtIndex:1]];
        }
        
        NSMutableArray *numArr = [[NSMutableArray alloc] init];
        while (numInt.length > 3)
        {
            NSString *temp = [numInt substringFromIndex:numInt.length - 3];
            numInt = [numInt substringToIndex:numInt.length - 3];
            [numArr addObject:[NSString stringWithFormat:@",%@",temp]];//得到的倒序的数据
        }
        
        for (int i = 0; i < numArr.count; i++)
        {
            numInt = [numInt stringByAppendingFormat:@"%@",[numArr objectAtIndex:(numArr.count -1 -i)]];
        }
        numStr = [NSString stringWithFormat:@"%@%@",numInt,suffixStr];
     
        return numStr;
    }
    @catch (NSException *exception)
    {
        return self;
    }
    @finally
    {}
}


- (BOOL) containsString:(NSString *) string
                options:(NSStringCompareOptions) options
{
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL) containsString:(NSString *) string
{
    return [self containsString:string options:0];
}

- (NSString *)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString *)trim
{
    NSArray* words = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [words componentsJoinedByString:@""];
}

- (BOOL)isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange range = [self rangeOfCharacterFromSet:nonNumbers];
    return range.location == NSNotFound;
}



// 判断字符是否为空
+(NSString*)stringAwayFromNSNULL:(NSString *)str{
    if (![str isEqual:[NSNull null]] && str) {
        return [NSString stringWithFormat:@"%@",str];
    }else{
        return @"";
    }
}




// 获取一个随机整数，范围在[from,to），包括from，不包括to
+(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}


#pragma mark - 路径获取
+ (NSString*) GetDocumentsPath
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}
#pragma mark - 路径获取
+(NSString*)GetCachesPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}



+(NSString*)DateCurrentIntervalSince1970:(NSTimeInterval)secs{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:kDateTimeFormat];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    
    return [formatter stringFromDate:date];
}


+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}



//根据字符串计算其所占的空间
+(CGSize)sizeWithString:(NSString *)str{
    return [self sizeWithString:str cs:CGSizeMake((kScreenWidth* 10), (kScreenHeitht *10))];
}

//根据字符串计算其所占的空间
+(CGSize)sizeWithString:(NSString *)str cs:(CGSize)cs{
    CGSize tmpcs = CGSizeMake(0, 0);
    if (str.length >0) {
        tmpcs = [str boundingRectWithSize:cs options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size;
    }
    return tmpcs;
}


/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}




//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//正则表达式 判断 英文和数字
+ (BOOL) validateABC123Char:(NSString *)text
{
    NSString *textRegex = @"^[A-Za-z0-9%&',;=?]+$";
    NSPredicate *textTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",textRegex];
    return [textTest evaluateWithObject:text];
}



@end
