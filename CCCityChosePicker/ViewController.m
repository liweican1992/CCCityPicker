//
//  ViewController.m
//  CCCityChosePicker
//
//  Created by CC on 16/6/15.
//  Copyright © 2016年 ssrj. All rights reserved.
//

#import "ViewController.h"
#import "CCCityPickerView.h"
#import "CCCityPickerJsonView.h"
@interface ViewController ()<CCCityPickerViewDelegate,CCCityPickerJsonViewDelegate>
@property (strong, nonatomic) CCCityPickerView * pickerView;
@property (strong, nonatomic) CCCityPickerJsonView * jsonPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView = [[CCCityPickerView alloc]init];
    self.pickerView.delegate = self;
    
    self.jsonPickerView = [[CCCityPickerJsonView alloc]init];
    self.jsonPickerView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonAction:(id)sender {
    
    [self.pickerView showPickerView];
}

- (IBAction)jsonButtonAction:(id)sender {
    [self.jsonPickerView showPickerView];
}

- (void)didSelectedAddress:(NSString *)address{
    [self.addressButton setTitle:address forState:0];
}
- (void)didSelectedAddress:(NSString *)address areaId:(NSNumber *)idNum{
    [self.addressButton2 setTitle:[NSString stringWithFormat:@"%@id=%d",address,idNum.intValue] forState:0];
}

@end
