//
//  UIControl+JPBtnClickDelay.m
//  ButtonCategory
//
//  Created by Chris on 16/8/3.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "UIControl+JPBtnClickDelay.h"
#import <objc/runtime.h>

@interface UIControl ()

/** 是否忽略点击 */
@property(nonatomic)BOOL jp_ignoreEvent;

@end


@implementation UIControl (JPBtnClickDelay)
-(void)jp_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    if (self.jp_ignoreEvent) return;
    
    if (self.jp_acceptEventInterval > 0) {
        self.jp_ignoreEvent = YES;
        [self performSelector:@selector(setJp_ignoreEvent:) withObject:@(NO) afterDelay:self.jp_acceptEventInterval];
    }
    [self jp_sendAction:action to:target forEvent:event];
}

-(void)setJp_ignoreEvent:(BOOL)jp_ignoreEvent{
    objc_setAssociatedObject(self, @selector(jp_ignoreEvent), @(jp_ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)jp_ignoreEvent{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


-(void)setJp_acceptEventInterval:(NSTimeInterval)jp_acceptEventInterval{
    objc_setAssociatedObject(self, @selector(jp_acceptEventInterval), @(jp_acceptEventInterval), OBJC_ASSOCIATION_ASSIGN);
}

-(NSTimeInterval)jp_acceptEventInterval{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}


+(void)load{
    Method sys_Method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    
    Method add_Method = class_getInstanceMethod(self, @selector(jp_sendAction:to:forEvent:));
    
    method_exchangeImplementations(sys_Method, add_Method);
}

@end
