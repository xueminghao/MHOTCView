//
//  MHOTPView.h
//  ClubFactory
//
//  Created by xueminghao on 2019/10/28.
//  Copyright © 2019 xueminghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MHOTPView;

@protocol MHOTPView <NSObject>

- (void)optViewHasBennFullfilled:(MHOTPView *)optView;

@end

@interface MHOTPView : UIView<UITextInput>

@property (nonatomic, weak) id<MHOTPView> delegate;

/**
 位数
 */
@property (nonatomic, assign) int numberOfBits;

/**
 间隔
 */
@property (nonatomic, assign) CGFloat spacing;

#pragma mark - UITextInput props

@property (nonatomic, copy) NSString *textContentType;
@property (nullable, nonatomic, weak) id <UITextInputDelegate> inputDelegate;

@end

NS_ASSUME_NONNULL_END
