//
//  MHViewController.m
//  MHOTCView
//
//  Created by xueminghao on 10/29/2019.
//  Copyright (c) 2019 xueminghao. All rights reserved.
//

#import "MHViewController.h"

#import <Masonry/Masonry.h>
#import <MHOTCView/MHOTPView.h>

/** HEX颜色 */
#define MHColorHex(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]
#define MHColorHexA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:(a)]


@interface MHViewController ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *statusLbl;

@property (nonatomic, strong) MHOTPView *optView;

@end

@implementation MHViewController

#pragma mark - Life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildSubViews];
    self.statusLbl.attributedText = [self generateStatusMessage];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - MHOTPViewDelegate

- (void)optViewHasBeenFullfilled:(MHOTPView *)inputView {
    [self.view endEditing:YES];
    [self startCheckOTP];
}

#pragma mark - Target action methods

- (void)switchPwdBtnClicked {
}

#pragma mark - Private methods

- (void)buildSubViews {
    [self.view addSubview:self.titleLbl];
    [self.view addSubview:self.statusLbl];
    [self.view addSubview:self.optView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(44);
        make.leading.equalTo(self.view).offset(36);
        make.trailing.equalTo(self.view).offset(-36);
    }];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
    }];
    [self.optView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLbl);
        make.top.equalTo(self.statusLbl.mas_bottom).offset(40);
    }];
}

- (NSAttributedString *)generateStatusMessage {
    NSMutableAttributedString *ret = [NSMutableAttributedString new];
    {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"A text with a verification code has been sent to ", nil) attributes:@{NSForegroundColorAttributeName: MHColorHex(0x666666), NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        [ret appendAttributedString:str];
    }
    {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"+91 123456789", nil) attributes:@{NSForegroundColorAttributeName: MHColorHex(0x333333), NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        [ret appendAttributedString:str];
    }
    {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"  Sending...", nil) attributes:@{NSForegroundColorAttributeName: MHColorHex(0xCCCCCC), NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        [ret appendAttributedString:str];
    }
    return [ret copy];
}

- (void)startCheckOTP {
}

#pragma mark - Lazy load properties

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.text = NSLocalizedString(@"Verify Mobile Number", nil);
        _titleLbl.font = [UIFont boldSystemFontOfSize:22];
        _titleLbl.textColor = MHColorHex(0x333333);
    }
    return _titleLbl;
}

- (UILabel *)statusLbl {
    if (!_statusLbl) {
        _statusLbl = [UILabel new];
        _statusLbl.numberOfLines = 0;
    }
    return _statusLbl;
}

- (MHOTPView *)optView {
    if (!_optView) {
        _optView = [MHOTPView new];
        _optView.delegate = self;
    }
    return _optView;
}

@end
