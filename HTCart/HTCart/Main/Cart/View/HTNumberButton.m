//
//  HTNumberButton.m
//  HTCart
//
//  Created by Huiting Mao on 2017/6/8.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTNumberButton.h"

#ifdef DEBUG
#define HTLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define HTLog(...)
#endif

@interface HTNumberButton ()<UITextFieldDelegate>

/** 减按钮 */
@property (weak, nonatomic) IBOutlet UIButton *subtractButton;

/** 加按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;

/** 数字显示/输入框 */
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

/** 快速加减定时器 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HTNumberButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 界面布局
        [self awakeFromNib];
        // 设置最小值
        _minValue = 1;
        // 设置是否支持键盘输入
        _supportKeyboard = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"HTNumberButton" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    [self addCompleteButtonOnKeyboard];
}

/**
 *  在键盘上方的Toolbar上添加完成按钮
 */
- (void)addCompleteButtonOnKeyboard {
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(pickerDoneClicked)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    _numberTextField.inputAccessoryView = keyboardDoneButtonView;
}

-(void)pickerDoneClicked {
    [_numberTextField resignFirstResponder];
    [self checkNumberWhenUpdate];
}

- (void)didMoveToWindow {
    if (self.window) {
        // 注册键盘弹起和收回的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)nextResponder;
            tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - keyboardRect.size.height);
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)nextResponder;
            tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT);
        }
    }
}

#pragma mark - 输入框中的内容设置
- (NSInteger)currentNumber {
    return _numberTextField.text.integerValue;
}

- (void)setCurrentNumber:(NSInteger)currentNumber {
    _numberTextField.text = [NSString stringWithFormat:@"%ld",currentNumber];
    [self checkNumberWhenUpdate];
}

#pragma mark - 最大值设置
- (void)setMaxValue:(NSInteger)maxValue {
    _maxValue = maxValue;
    [self checkNumberWhenUpdate];
}

#pragma mark - IBAction

/**
 *  点击: 单击逐次减少,长按连续快速减少
 */
- (IBAction)subtractTouchDown:(id)sender {
    [_numberTextField resignFirstResponder];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(subtractAction) userInfo:nil repeats:YES];
    [_timer fire];
}

/**
 *  点击: 单击逐次增加,长按连续快速增加
 */
- (IBAction)addTouchDown:(id)sender {
    [_numberTextField resignFirstResponder];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(addAction) userInfo:nil repeats:YES];
    [_timer fire];
}

/**
 *  手指松开
 */
- (IBAction)touchUp:(id)sender {
    [self invalidateTimer];
}

#pragma mark - SEL

/**
 *  减运算
 */
- (void)subtractAction {
    [self checkNumberWhenUpdate];
    NSInteger number = [_numberTextField.text integerValue] - 1;
    if (number >= _minValue) {
        _numberTextField.text = [NSString stringWithFormat:@"%ld", number];
        [self buttonClickCallBackWithAddAction:NO];
    } else {
        [MBProgressHUD showHint:@"受不了了，宝贝不能再减少了哦"];
    }
}

/**
 *  加运算
 */
- (void)addAction {
    [self checkNumberWhenUpdate];
    NSInteger number = _numberTextField.text.integerValue + 1;
    if (number <= _maxValue) {
        _numberTextField.text = [NSString stringWithFormat:@"%ld", number];
        [self buttonClickCallBackWithAddAction:YES];
    } else {
        [MBProgressHUD showHint:@"亲，该宝贝不能购买更多哦"];
    }
}

/**
 *  销毁定时器
 */
- (void)invalidateTimer {
    if (_timer.isValid) {
        [_timer invalidate] ;
        _timer = nil; }
}

/**
 *  响应
 */
- (void)buttonClickCallBackWithAddAction:(BOOL)addStatus {
    _resultBlock ? _resultBlock(_numberTextField.text.integerValue, addStatus) : nil;
    if ([_delegate respondsToSelector:@selector(ht_numberButton: number: isAdd:)]) {
        [_delegate ht_numberButton:self number:_numberTextField.text.integerValue isAdd:addStatus];
    }
}

/**
 *  检查TextField中数字的合法性,并修正
 */
- (void)checkNumberWhenUpdate {
    NSString *minValueString = [NSString stringWithFormat:@"%ld",_minValue];
    NSString *maxValueString = [NSString stringWithFormat:@"%ld",_maxValue];
    
    if ([_numberTextField.text ht_isNotBlank] == NO || _numberTextField.text.integerValue < _minValue) {
        _numberTextField.text = minValueString;
    }
    _numberTextField.text.integerValue > _maxValue ? _numberTextField.text = maxValueString : nil;
}

@end

#pragma mark - NSString 分类

@implementation NSString (HTNumberButton)

- (BOOL)ht_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

@end
