
#import "CCCityPickerJsonView.h"
#define BackViewHeight 240
#define ToolViewHeight 40
#define PickerViewHeight 200
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#import "AppDelegate.h"

@interface CCCityPickerJsonView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) UIView * toolView;
@property (strong, nonatomic) UIButton * saveButton;
@property (strong, nonatomic) UIView * backView;
@property (strong, nonatomic) CCAreaJsonModel * selectProvince;
@property (strong, nonatomic) CCAreaJsonModel * selectCity;
@property (strong, nonatomic) CCAreaJsonModel * selectArae;
@property (strong, nonatomic) NSMutableArray * dataArray;

@end

@implementation CCCityPickerJsonView

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
        
        
        
        NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
        NSData *jdata = [[NSData alloc]initWithContentsOfFile:jsonPath];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jdata options:0 error:nil];
        NSArray *arr = [dic objectForKey:@"areaTree"];
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            CCAreaJsonModel *model = [[CCAreaJsonModel alloc]initWithDictionary:dic error:nil];
            [self.dataArray  addObject:model];
        }
        
        self.selectProvince = self.dataArray[0];
        self.selectCity = self.selectProvince.child[0];
        self.selectArae = self.selectCity.child.count?self.selectCity.child[0]:nil;
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
        
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT - BackViewHeight, self.backView.frame.size.width, self.backView.frame.size.height);
    }];
}
- (void)hidePickerView{
    [UIView animateWithDuration:.2 animations:^{
        
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT, self.backView.frame.size.width, self.backView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}
- (void)saveButtonAction:(UIButton *)sender{
    if (self.delegate) {
        NSString *str = [NSString stringWithFormat:@"%@%@",self.selectProvince.addRess,self.selectCity.addRess];
        NSNumber *number = self.selectCity.id;
        if (self.selectArae) {
            str = [str stringByAppendingFormat:@"%@",self.selectArae.addRess];
            number = self.selectArae.id;
        }
        [self.delegate didSelectedAddress:str areaId:number];
        [self hidePickerView];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
            case 0:
            return self.dataArray.count;
            break;
            case 1:
        {
            return self.selectProvince.child.count;
            
        }
            break;
            case 2:
        {
            
            NSInteger row1 =[pickerView selectedRowInComponent:1];
            if (row1 != -1) {
                CCAreaJsonModel *model = self.selectProvince.child[row1];
                return model.child.count;
            }
            return 0;
            
            
        }
            break;
        default:
            
            break;
    }
    return 0;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.selectProvince = self.dataArray[row];
        self.selectCity = self.selectProvince.child.count?self.selectProvince.child[0]:nil;
        self.selectArae = self.selectCity.child.count?self.selectCity.child[0]:nil;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if(component == 1){
        self.selectCity = self.selectProvince.child[row];
        self.selectArae = self.selectCity.child.count?self.selectCity.child[0]:nil;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else {
        self.selectArae = self.selectCity.child.count?self.selectCity.child[row]:nil;
    }
    //    NSLog(@"%@/%@/%@",self.selectProvince.addRess,self.selectCity.addRess,self.selectArae.addRess);
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component ==0) {
        CCAreaJsonModel *model = self.dataArray[row];
        return model.addRess;
        
    }else if (component == 1){
        CCAreaJsonModel *model = self.selectProvince.child[row];
        return model.addRess;
    }
    CCAreaJsonModel *model = self.selectCity.child[row];
    return model.addRess;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10/3, 40)];
//        pickerLabel.font = GetFont(14);
        pickerLabel.font = [UIFont systemFontOfSize:14];
        pickerLabel.numberOfLines = 2;
        //        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    
    return SCREEN_WIDTH/3;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

@end
