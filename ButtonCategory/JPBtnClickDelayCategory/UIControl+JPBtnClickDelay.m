/*
 * This file is part of the JPBtnClickDelayCategory package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/Chris-Pan
 * or http://www.jianshu.com/users/e2f2d779c022/latest_articles to contact me.
 */

#import "UIControl+JPBtnClickDelay.h"
#import <objc/runtime.h>

@interface UIControl ()

/** 是否忽略点击 */
@property(nonatomic)BOOL jp_ignoreEvent;

@end

@implementation UIControl (JPBtnClickDelay)

+(void)load{
    Method sys_Method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method add_Method = class_getInstanceMethod(self, @selector(jp_sendAction:to:forEvent:));
    method_exchangeImplementations(sys_Method, add_Method);
}

-(void)jp_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    if (self.jp_ignoreEvent) return;
    
    if (self.jp_acceptEventInterval > 0) {
        self.jp_ignoreEvent = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.jp_acceptEventInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.jp_ignoreEvent = NO;
        });
    }
    [self jp_sendAction:action to:target forEvent:event];
}

-(void)setJp_ignoreEvent:(BOOL)jp_ignoreEvent{
    objc_setAssociatedObject(self, @selector(jp_ignoreEvent), @(jp_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)jp_ignoreEvent{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setJp_acceptEventInterval:(NSTimeInterval)jp_acceptEventInterval{
    objc_setAssociatedObject(self, @selector(jp_acceptEventInterval), @(jp_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)jp_acceptEventInterval{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

@end
