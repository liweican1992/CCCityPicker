//
//  CCCityPickerJsonView.h
//  CCCityChosePicker
//
//  Created by CC on 16/7/8.
//  Copyright © 2016年 ssrj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAreaJsonModel.h"

@protocol CCCityPickerJsonViewDelegate <NSObject>
- (void)didSelectedAddress:(NSString *)address areaId:(NSNumber *)idNum;
@end
@interface CCCityPickerJsonView : UIView
@property (assign, nonatomic) id<CCCityPickerJsonViewDelegate> delegate;
@property (strong, nonatomic) UIPickerView * pickerView;

- (void)showPickerView;
- (void)hidePickerView;
@end
