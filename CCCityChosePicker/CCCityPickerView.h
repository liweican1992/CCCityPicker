//
//  CCCityPickerView.h
//  ssrj
//
//  Created by CC on 16/6/12.
//  Copyright © 2016年 ssrj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CCCityPickerViewDelegate <NSObject>
- (void)didSelectedAddress:(NSString *)address;
@end

@interface CCCityPickerView : UIView
@property (assign, nonatomic) id<CCCityPickerViewDelegate> delegate;
@property (strong, nonatomic) UIPickerView * pickerView;

- (void)showPickerView;
- (void)hidePickerView;
@end



@interface CCProvinceModel : NSObject
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSArray * cityArray;
@property (strong, nonatomic) NSDictionary * dic;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface CCCityModel : NSObject
@property (strong, nonatomic) NSString * cityName;
@property (strong, nonatomic) NSArray * areasArray;
@property (strong, nonatomic) NSDictionary * dic;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface CCAreaModel : NSObject
@property (strong, nonatomic) NSString * areaName;
-(instancetype)initWithName:(NSString *)name;
@end