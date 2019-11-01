//
//  MHTextPosition.m
//  MHOTCView
//
//  Created by xueminghao on 2019/11/1.
//

#import "MHTextPosition.h"

@implementation MHTextPosition

+ (instancetype)textPositionWithIndex:(NSUInteger)index {
    MHTextPosition *position = [MHTextPosition new];
    position.index = index;
    return position;
}

@end
