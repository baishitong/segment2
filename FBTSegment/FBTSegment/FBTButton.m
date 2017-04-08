//
//  FBTButton.m
//  FBTSegment
//
//  Created by zsw on 2017/4/8.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "FBTButton.h"

@implementation FBTButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
    return self;
}

@end
