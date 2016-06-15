//
//  ViewController.m
//  CCCityChosePicker
//
//  Created by CC on 16/6/15.
//  Copyright © 2016年 ssrj. All rights reserved.
//

#import "ViewController.h"
#import "CCCityPickerView.h"

@interface ViewController ()<CCCityPickerViewDelegate>
@property (strong, nonatomic) CCCityPickerView * pickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView = [[CCCityPickerView alloc]init];
    self.pickerView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonAction:(id)sender {
    
    [self.pickerView showPickerView];
}
- (void)didSelectedAddress:(NSString *)address{
    [self.addressButton setTitle:address forState:0];
}
@end
