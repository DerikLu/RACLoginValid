//
//  ViewController.m
//  ReactiveCocoaPractice
//
//  Created by Derik on 2015/4/7.
//  Copyright (c) 2015年 Derik. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)initView {
    self.lblStatus.text = @"Login Service";
    
    //UserName signal (6 characters)
    @weakify(self)
    RACSignal *validUsernameSignal = [[self.txtUserName.rac_textSignal filter:^BOOL(NSString *text) {
        return text.length > 0;
    }] map:^id(NSString *text) {
        @strongify(self)
        return @([self isValidUserName:text]);
    }];
    
    RAC(self.lblUserNameMark, text) = [validUsernameSignal map:^id(NSNumber *value) {
        if ([value boolValue]) {
            return @"v";
        } else {
            return @"x";
        }
    }];
    
    RAC(self.lblUserNameMark, textColor) = [validUsernameSignal map:^id(NSNumber *value) {
        if ([value boolValue]) {
            return [UIColor greenColor];
        } else {
            return [UIColor redColor];
        }
    }];
    
    //Password signal (more than 8 characters)
    RACSignal *validPwdSignal = [[self.txtPwd.rac_textSignal filter:^BOOL(NSString *text) {
        return text.length > 0;
    }] map:^id(NSString *text) {
        @strongify(self)
        return @([self isValidPassword:text]);
    }];
    
    RAC(self.lblPwdMark, text) = [validPwdSignal map:^id(NSNumber *value) {
        if ([value boolValue]) {
            return @"v";
        } else {
            return @"x";
        }
    }];
    
    RAC(self.lblPwdMark, textColor) = [validPwdSignal map:^id(NSNumber *value) {
        if ([value boolValue]) {
            return [UIColor greenColor];
        } else {
            return [UIColor redColor];
        }
    }];
    
    //Combine UserName and Password signal
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPwdSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    //Login button binding
    RAC(self.btnLogin, enabled) = [signUpActiveSignal map:^id(NSNumber *valid) {
        return valid;
    }];
    
    [[[[self.btnLogin
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        doNext:^(id x) {
            @strongify(self)
            self.btnLogin.enabled = NO;
            self.txtUserName.enabled = NO;
            self.txtPwd.enabled = NO;
            self.lblStatus.text = @"Connecting...";
        }]
        flattenMap:^id(id x) {
            @strongify(self)
            return [self signInSignal];
        }]
        subscribeNext:^(NSNumber *signedIn) {
            @strongify(self)
            [self performSelector:@selector(successLogin:) withObject:signedIn afterDelay:3.0];
        }];
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //Request login service and feedback
        [subscriber sendNext:@(YES)];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (void)successLogin:(NSNumber *)signedIn {
    self.btnLogin.enabled = YES;
    self.txtUserName.enabled = YES;
    self.txtPwd.enabled = YES;
    
    BOOL success = [signedIn boolValue];
    
    if (success) {
        self.lblStatus.text = @"Success!";
    } else {
        self.lblStatus.text = @"Failed!";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isValidUserName:(NSString *)text {
    return text.length == 6;
}

- (BOOL)isValidPassword:(NSString *)text {
    return text.length > 8;
}

@end
