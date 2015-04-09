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
    //UserName signal
    RACSignal *validUsernameSignal = [[self.txtUserName.rac_textSignal filter:^BOOL(NSString *text) {
        return text.length > 0;
    }] map:^id(NSString *text) {
        return @(text.length == 6);
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
    
    //Password signal
    RACSignal *validPwdSignal = [[self.txtPwd.rac_textSignal filter:^BOOL(NSString *text) {
        return text.length > 0;
    }] map:^id(NSString *text) {
        return @(text.length > 0);
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

- (IBAction)login:(id)sender {
    NSLog(@"click");
}
@end
