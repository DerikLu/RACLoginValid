//
//  ViewController.h
//  ReactiveCocoaPractice
//
//  Created by Derik on 2015/4/7.
//  Copyright (c) 2015年 Derik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *txtUserName;
@property (nonatomic, weak) IBOutlet UITextField *txtPwd;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;

@property (nonatomic, weak) IBOutlet UILabel *lblUserNameMark;
@property (nonatomic, weak) IBOutlet UILabel *lblPwdMark;

- (IBAction)login:(id)sender;

@end

