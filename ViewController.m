//
//  ViewController.m
//  ButtonCategory
//
//  Created by Chris on 16/8/3.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+JPBtnClickDelay.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *delayBtn;
@property (weak, nonatomic) IBOutlet UITextView *logTF;
/** 打印文字 */
@property(nonatomic, strong)NSString *logTextString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logTextString = @"";
    self.logTF.text = self.logTextString;
    
    [self.normalBtn addTarget:self action:@selector(normalBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.delayBtn addTarget:self action:@selector(delayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.delayBtn.jp_acceptEventInterval = 1.0f;
}

-(void)normalBtnClick{
    self.logTextString = [self.logTextString stringByAppendingString:[NSString stringWithFormat:@"\n%@", @"正常按钮点击"]];
    self.logTF.attributedText = [self getAttrString];
}

-(void)delayBtnClick{
    self.logTextString = [self.logTextString stringByAppendingString:[NSString stringWithFormat:@"\n%@", @"延迟按钮点击"]];
    self.logTF.attributedText = [self getAttrString];
}


-(NSAttributedString *)getAttrString{
    NSString *pattern = @"延迟按钮点击";
    
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc]initWithString:self.logTextString attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray<NSTextCheckingResult *> * results = [regular matchesInString:self.logTextString options:NSMatchingReportProgress range:NSMakeRange(0, self.logTextString.length)];
    
    for (NSTextCheckingResult *result in results) {
        
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"延迟按钮点击" attributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
        [attrStringM replaceCharactersInRange:result.range withAttributedString:attr];
    }
    return [attrStringM copy];
}
@end
