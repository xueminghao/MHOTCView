//
//  MHOTPView.m
//  ClubFactory
//
//  Created by xueminghao on 2019/10/28.
//  Copyright © 2019 xueminghao. All rights reserved.
//

#import "MHOTPView.h"

#import "MHTextPosition.h"
#import "MHTextRange.h"

/** HEX颜色 */
#define MHColorHex(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]
#define MHColorHexA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:(a)]

@interface MHOTPView ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) CALayer *cursor;

@end

@implementation MHOTPView

#pragma mark - Life cycles

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        _numberOfBits = 6;
        _spacing = 12;
        if (@available(iOS 12.0, *)) {
            self.textContentType = UITextContentTypeOneTimeCode;
        }
    }
    return self;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [self layoutCursor];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.height = 44;
    return size;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canResignFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
    return [super resignFirstResponder];
    
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self becomeFirstResponder];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // params
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    NSUInteger cursorPosition = self.text.length;
    // draw lines
    CGFloat lineWidth = floor((width - self.spacing * (self.numberOfBits - 1)) / self.numberOfBits);
    CGFloat lineHeight = 1;
    
    CGFloat lineY = height - lineHeight;
    CGFloat lineStep = lineWidth + self.spacing;
    CGContextSetLineWidth(ctx, lineHeight);
    
    for (NSUInteger i = 0; i < self.numberOfBits; i++) {
        CGFloat lineStart = i * lineStep;
        CGFloat lineEnd = lineStart + lineWidth;
        CGContextMoveToPoint(ctx, lineStart, lineY);
        CGContextAddLineToPoint(ctx, lineEnd, lineY);
        if (i < cursorPosition || (i == cursorPosition && self.isFirstResponder)) {
            [MHColorHex(0x333333) setStroke];
        } else {
            [MHColorHex(0xCCCCCC) setStroke];
        }
        CGContextStrokePath(ctx);
    }
    // draw text
    CGFloat textCenterY = floor((height - lineHeight) / 2);
    for (NSUInteger i = 0; i < MIN(self.text.length, self.numberOfBits); i++) {
        NSString *number = [self.text substringWithRange:NSMakeRange(i, 1)];
        NSDictionary *attributes = @{NSForegroundColorAttributeName: MHColorHex(0x333333), NSFontAttributeName: [UIFont boldSystemFontOfSize: 24]};
        CGSize numberSize = [number sizeWithAttributes:attributes];
        CGFloat textCenterX = i * lineStep + floor(lineWidth / 2);
        
        CGFloat x = floor(textCenterX - numberSize.width / 2);
        CGFloat y = floor(textCenterY - numberSize.height / 2);
        [number drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
    }
}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.text.length > 0;
}

- (void)insertText:(NSString *)text {
    NSString *ret = self.text ?: @"";
    ret = [ret stringByAppendingString:text];
    ret = [ret substringToIndex:MIN(ret.length, self.numberOfBits)];
    self.text = ret;
}

- (void)deleteBackward {
    self.text = [self.text substringToIndex:self.text.length - 1];
}

#pragma mark - UITextInput

- (NSString *)textInRange:(UITextRange *)range {
    if (!self.text) {
        return nil;
    }
    MHTextRange *textRange = (MHTextRange *)range;
    if (!textRange) {
        return nil;
    }
    if (textRange.startIndex >= self.text.length) {
        return nil;
    }
    return [self.text substringWithRange:NSMakeRange(textRange.startIndex, textRange.length)];
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text {
    if (!self.text) {
        return;
    }
    MHTextRange *textRange = (MHTextRange *)range;
    if (!textRange) {
        return;
    }
    if (textRange.startIndex >= self.text.length) {
        return;
    }
    NSUInteger length = MIN(textRange.length, self.text.length - textRange.startIndex);
    NSRange validRange = NSMakeRange(textRange.startIndex, length);
    self.text = [self.text stringByReplacingCharactersInRange:validRange withString:text];
}

- (UITextPosition *)beginningOfDocument {
    return [MHTextPosition textPositionWithIndex:0];
}

- (UITextPosition *)endOfDocument {
    return [MHTextPosition textPositionWithIndex:self.text.length - 1];
}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition {
    MHTextPosition *from = (MHTextPosition *)fromPosition;
    MHTextPosition *to = (MHTextPosition *)toPosition;
    if (!from || !to) {
        return nil;
    }
    return [MHTextRange textRangeWithStartPosition:from endIndex:to];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset {
    MHTextPosition *textPosition = (MHTextPosition *)position;
    if (!textPosition) {
        return nil;
    }
    return [MHTextPosition textPositionWithIndex:textPosition.index + offset];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset {
    // 不考虑布局方向
    return [self positionFromPosition:position offset:offset];
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other {
    MHTextPosition *textPosition = (MHTextPosition *)position;
    MHTextPosition *otherPosition = (MHTextPosition *)other;
    if (!textPosition || !otherPosition) {
        return NSOrderedSame;
    }
    if (textPosition.index < otherPosition.index) {
        return NSOrderedAscending;
    }
    if (textPosition.index == otherPosition.index) {
        return NSOrderedSame;
    }
    return NSOrderedDescending;
}

- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition {
    MHTextPosition *fromPosition = (MHTextPosition *)from;
    MHTextPosition *to = (MHTextPosition *)toPosition;
    if (!from || !to) {
        return 0;
    }
    return to.index - fromPosition.index;
}

#pragma mark - Other protocol methods

- (UITextRange *)selectedTextRange { return nil; }

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange {}

- (UITextRange *)markedTextRange { return nil; }

- (NSDictionary<NSAttributedStringKey,id> *)markedTextStyle { return nil; }

- (void)setMarkedTextStyle:(NSDictionary<NSAttributedStringKey,id> *)markedTextStyle {}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange {}
- (void)unmarkText {}

- (id<UITextInputTokenizer>)tokenizer { return nil; }

- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction { return nil; }
- (NSInteger)characterOffsetOfPosition:(UITextPosition *)position withinRange:(UITextRange *)range { return 0; }
- (NSWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction { return NSWritingDirectionLeftToRight; }
-(void)setBaseWritingDirection:(NSWritingDirection)writingDirection forRange:(UITextRange *)range {}
- (CGRect)firstRectForRange:(UITextRange *)range { return CGRectZero; }
-(CGRect)caretRectForPosition:(UITextPosition *)position { return CGRectZero; }
- (NSArray<UITextSelectionRect *> *)selectionRectsForRange:(UITextRange *)range { return nil; }
- (UITextPosition *)closestPositionToPoint:(CGPoint)point { return nil; }
- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range { return nil; }
- (UITextRange *)characterRangeAtPoint:(CGPoint)point { return nil; }

- (nullable UITextRange *)characterRangeByExtendingPosition:(nonnull UITextPosition *)position inDirection:(UITextLayoutDirection)direction {
    return nil;
}

+ (nonnull instancetype)appearance {
    return nil;
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait {
    return nil;
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return nil;
}

+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return nil;
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    return CGPointZero;
}

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    return CGPointZero;
}

- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    return CGRectZero;
}

- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    return CGRectZero;
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator  API_AVAILABLE(ios(9.0)){
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context  API_AVAILABLE(ios(9.0)){
    return NO;
}

- (void)updateFocusIfNeeded {
    
}

- (nonnull NSArray<id<UIFocusItem>> *)focusItemsInRect:(CGRect)rect  API_AVAILABLE(ios(10.0)){
    return nil;
}

#pragma mark - Setters

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self setNeedsDisplay];
}

- (void)setNumberOfBits:(int)numberOfBits {
    _numberOfBits = numberOfBits;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
    if (_text.length >= self.numberOfBits) {
        if ([self.delegate respondsToSelector:@selector(optViewHasBeenFullfilled:)]) {
            [self.delegate optViewHasBeenFullfilled:self];
        }
    }
}

#pragma mark - Lazy load properties

- (CALayer *)cursor {
    if (!_cursor) {
        _cursor = [CALayer new];
        _cursor.backgroundColor = MHColorHex(0x333333).CGColor;
        _cursor.cornerRadius = 1;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithInt:1.0];
        animation.toValue = [NSNumber numberWithInt:0.0];
        animation.duration = 1;
        animation.repeatCount = HUGE_VALF;
        [_cursor addAnimation:animation forKey:nil];
    }
    return _cursor;
}

#pragma mark - Private methods

- (void)layoutCursor {
    if (!self.cursor.superlayer) {
        [self.layer addSublayer:self.cursor];
    }
    if (self.text.length >= self.numberOfBits || !self.isFirstResponder) {
        self.cursor.hidden = YES;
        return;
    }
    self.cursor.hidden = NO;
    
    NSUInteger cursorPosition = self.text.length;
    
    // params
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat cursorWidth = 2;
    CGFloat cursorHeight = 26;
    
    CGFloat lineWidth = floor((width - self.spacing * (self.numberOfBits - 1)) / self.numberOfBits);
    CGFloat lineHeight = 1;
    CGFloat lineStep = lineWidth + self.spacing;
    CGFloat cursorLineStart = cursorPosition * lineStep;
    
    CGFloat x = cursorLineStart + lineWidth / 2 - cursorWidth / 2;
    CGFloat y = (height - lineHeight) / 2 - cursorHeight / 2;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.cursor.frame = CGRectMake(x, y, cursorWidth, cursorHeight);
    [CATransaction commit];
}

@end
