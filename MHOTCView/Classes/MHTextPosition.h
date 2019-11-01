//
//  MHTextPosition.h
//  MHOTCView
//
//  Created by xueminghao on 2019/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHTextPosition : UITextPosition

/**
  字符索引。从0开始
 */
@property (nonatomic, assign) NSUInteger index;

+ (instancetype)textPositionWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
