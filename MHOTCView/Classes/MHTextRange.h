//
//  MHTextRange.h
//  MHOTCView
//
//  Created by xueminghao on 2019/11/1.
//

#import "MHTextPosition.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHTextRange : UITextRange

@property (nonatomic, strong) MHTextPosition *startPosition;
@property (nonatomic, strong) MHTextPosition *endPosition;

@property (nonatomic, readonly) NSUInteger startIndex;
@property (nonatomic, readonly) NSUInteger endIndex;
@property (nonatomic, readonly) NSUInteger length;

+ (instancetype)textRangeWithStartPosition:(MHTextPosition *)startPosition endIndex:(MHTextPosition *)endPosition;

@end

NS_ASSUME_NONNULL_END
