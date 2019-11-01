//
//  MHTextRange.m
//  MHOTCView
//
//  Created by xueminghao on 2019/11/1.
//

#import "MHTextRange.h"

@implementation MHTextRange

+ (instancetype)textRangeWithStartPosition:(MHTextPosition *)startPosition endIndex:(MHTextPosition *)endPosition {
    MHTextRange *range = [MHTextRange new];
    range.startPosition = startPosition;
    range.endPosition = endPosition;
    return range;
}

#pragma mark - Convience methods

- (NSUInteger)startIndex {
    return self.startPosition.index;
}

- (NSUInteger)endIndex {
    return self.endPosition.index;
}

- (NSUInteger)length {
    return MAX(self.endIndex - self.startIndex + 1, 0);
}

#pragma mark - Overrides

- (UITextPosition *)start {
    return self.startPosition;
}

- (UITextPosition *)end {
    return self.endPosition;
}

- (BOOL)isEmpty {
    return self.endIndex < self.startIndex;
}


@end
