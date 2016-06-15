
#import "CCCityPickerView.h"
#define BackViewHeight 240
#define ToolViewHeight 40
#define PickerViewHeight 200
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#import "AppDelegate.h"
@interface CCCityPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) NSMutableArray * provinceArray;
@property (strong, nonatomic) NSMutableArray * cityArray;
@property (strong, nonatomic) NSMutableArray * areaArray;
@property (strong, nonatomic) UIView * toolView;
@property (strong, nonatomic) UIButton * saveButton;
@property (strong, nonatomic) UIView * backView;
@property (strong, nonatomic) CCProvinceModel * selectProvince;
@property (strong, nonatomic) CCCityModel * selectCity;
@property (strong, nonatomic) CCAreaModel * selectArae;

@end


@implementation CCCityPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BackViewHeight, SCREEN_WIDTH, BackViewHeight)];
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ToolViewHeight, SCREEN_WIDTH, PickerViewHeight)];
        self.backgroundColor = [UIColor colorWithRed:10/255.0f
                                                        green:10 / 255.0f
                                                        blue:10 / 255.0f
                                                        alpha:.6];
        self.toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ToolViewHeight)];
        self.toolView.backgroundColor = [UIColor lightGrayColor];
        self.saveButton = [UIButton buttonWithType:0];
        
        [self.saveButton setTitle:@"完成" forState:0];
        [self.saveButton setTitleColor:[UIColor blackColor] forState:0];
        self.saveButton.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 40, 40);
        [self.toolView addSubview:self.saveButton];
        [self.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview: self.toolView];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:self.pickerView];
        
        [self addSubview:_backView];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        NSArray *provinceArray = [[NSArray alloc]initWithContentsOfFile:path];
        self.provinceArray = [NSMutableArray array];
        for (NSDictionary *dic in provinceArray) {
            CCProvinceModel *model = [[CCProvinceModel alloc]initWithDictionary:dic];
            [self.provinceArray addObject:model];
        }
        self.selectProvince = self.provinceArray[0];
        self.selectCity = self.selectProvince.cityArray[0];
        self.selectArae = self.selectCity.areasArray.count?self.selectCity.areasArray[0]:nil;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.y>=SCREEN_HEIGHT-BackViewHeight) {
        return;
    }
    [self hidePickerView];
}
- (void)showPickerView{
    [[AppDelegate shareInstance].window addSubview:self];
    self.backView.frame = CGRectMake(0, SCREEN_HEIGHT, self.backView.frame.size.width, self.backView.frame.size.height);
    [UIView animateWithDuration:.2 animations:^{
//        self.backView.origin = CGPointMake(0, SCREEN_HEIGHT - BackViewHeight);
          self.backView.frame = CGRectMake(0, SCREEN_HEIGHT - BackViewHeight, self.backView.frame.size.width, self.backView.frame.size.height);
    }];
}
- (void)hidePickerView{
    [UIView animateWithDuration:.2 animations:^{
//        self.backView.origin = CGPointMake(0, SCREEN_HEIGHT);
    self.backView.frame = CGRectMake(0, SCREEN_HEIGHT, self.backView.frame.size.width, self.backView.frame.size.height);


    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
    
}
- (void)saveButtonAction:(UIButton *)sender{
    if (self.delegate) {
        NSString *str = [NSString stringWithFormat:@"%@/%@",self.selectProvince.name,self.selectCity.cityName];
        if (self.selectArae) {
            str = [str stringByAppendingFormat:@"/%@",self.selectArae.areaName];
        }
        [self.delegate didSelectedAddress:str];
        [self hidePickerView];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return self.provinceArray.count;
            break;
        case 1:
        {
            return self.selectProvince.cityArray.count;

        }
            break;
        case 2:
        {

            NSInteger row1 =[pickerView selectedRowInComponent:1];
            CCCityModel *model = self.selectProvince.cityArray[row1];
            return model.areasArray.count;

        }
            break;
        default:
            
            break;
    }
    return 0;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.selectProvince = self.provinceArray[row];
        self.selectCity = self.selectProvince.cityArray[0];
        self.selectArae = self.selectCity.areasArray.count?self.selectCity.areasArray[0]:nil;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if(component == 1){
        self.selectCity = self.selectProvince.cityArray[row];
        self.selectArae = self.selectCity.areasArray.count?self.selectCity.areasArray[0]:nil;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else {
        self.selectArae = self.selectCity.areasArray.count?self.selectCity.areasArray[row]:nil;
    }
    NSLog(@"%@/%@/%@",self.selectProvince.name,self.selectCity.cityName,self.selectArae.areaName);
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component ==0) {
        CCProvinceModel *model = self.provinceArray[row];
        return model.name;
    }else if (component == 1){
        CCCityModel *model = self.selectProvince.cityArray[row];
        return model.cityName;
    }
    CCAreaModel *model = self.selectCity.areasArray[row];
    return model.areaName;

}
@end

@implementation CCProvinceModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _dic = dictionary;
        self.name = _dic[@"name"];
        NSArray *arr = dictionary[@"cities"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            CCCityModel *model = [[CCCityModel alloc]initWithDictionary:dic];
            [mutableArray addObject:model];
        }
        self.cityArray = [mutableArray copy];
        
    }
    return self;
}

@end



@implementation CCCityModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _dic = dictionary;
        self.cityName = dictionary[@"city"];
        NSArray *arr = dictionary[@"areas"];
        NSMutableArray *muatableArr = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSString *name in arr) {
            CCAreaModel *model = [[CCAreaModel alloc]initWithName:name];
            [muatableArr addObject:model];
        }
        self.areasArray = [muatableArr copy];
    }
    return self;
}


@end

@implementation CCAreaModel

- (instancetype)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        self.areaName = name;
    }
    return self;
}
@end
