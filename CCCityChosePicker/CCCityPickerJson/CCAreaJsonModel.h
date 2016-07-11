//
//  CCAreaModel.h
//  CCCityChosePicker
//
//  Created by CC on 16/7/8.
//  Copyright © 2016年 ssrj. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol CCAreaJsonModel <NSObject>
@end

@interface CCAreaJsonModel : JSONModel
@property (strong, nonatomic) NSNumber * id;
@property (strong, nonatomic) NSString<Ignore> * areaName;
@property (strong, nonatomic) NSString * addRess;
@property (strong, nonatomic) NSNumber * pid;
@property (strong, nonatomic) NSString<Ignore> * treePath;
@property (strong, nonatomic) NSArray<CCAreaJsonModel,Optional> *child;
@end
