//
//  LoopCellEditerView.m
//  Groove
//
//  Created by C-ty on 2014/12/8.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LoopCellEditerView.h"
#import "GlobalConfig.h"

@interface LoopCellEditerView ()

@property (getter = GetCanDelete, setter = SetCanDelete:) BOOL CanDelete;

@end

@implementation LoopCellEditerView
{
    // Override
    UINib* _ThisNib;
    dispatch_once_t _ThisNibToken;
    
    //
    BOOL _CanDelete;
}

- (UINib*) ThisNib
{
    NSNumber * DeviceType = [GlobalConfig DeviceType];
    if (DeviceType.intValue == IPHONE_4S)
    {
        dispatch_once(&_ThisNibToken, ^{
            _ThisNib = [UINib nibWithNibName:@"LoopCellEditerView4S" bundle:nil];
        });
        
        return _ThisNib;
    }
    else
    {
        return [super ThisNib];
    }
    
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    NSNumber * DeviceType = [GlobalConfig DeviceType];
    if (DeviceType.intValue == IPHONE_4S)
    {
        self.CellDeleteButton = self.CellDeleteButton4S;
        self.DeleteUnLock = self.DeleteUnLock4S;
        self.ValueScrollView = self.ValueScrollView4S;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self.ValueScrollView removeFromSuperview];
        self.ValueScrollView = [[ValueScrollView alloc] initWithFrame:self.ValueScrollView.frame];
        // Important !!!
        [self.ContentScrollView addSubview:self.ValueScrollView];
        self.ValueScrollView.delegate = self;
       
        self.CanDelete = YES;
        self.DeleteUnLock.userInteractionEnabled = YES;
        UITapGestureRecognizer *TabUnlockSwitch =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CellDeleteUnlock:)];
        [self.DeleteUnLock addGestureRecognizer:TabUnlockSwitch];
/*
        NSNumber * DeviceType = [GlobalConfig DeviceType];
        switch (DeviceType.intValue) {
            case IPHONE_4S:
                self.BackgroundView.image = [UIImage imageNamed:@"PropertyDialog_4S"];
                break;
            case IPHONE_5S:
                break;
            default:
                break;
        }*/
    }
    return self;
}

- (void) SetHidden:(BOOL)hidden
{
    super.hidden = hidden;
    self.CanDelete = NO;
}

- (void) SetValue : (id) Picker
{
    [self ChangeValue:self :self.ValueScrollView];
}

- (BOOL) GetCanDelete
{
    return _CanDelete;
}

- (void) SetCanDelete : (BOOL) NewValue
{
    _CanDelete = NewValue;
    if (_CanDelete)
    {
        self.DeleteUnLock.image  = [UIImage imageNamed:@"SwitchButtonUnLock"];
        self.CellDeleteButton.enabled = YES;
        [self.CellDeleteButton setBackgroundImage:[UIImage imageNamed:@"DeleteCellRed"] forState:UIControlStateNormal];

    }
    else
    {
        self.DeleteUnLock.image  = [UIImage imageNamed:@"SwitchButtonLock"];
        self.CellDeleteButton.enabled = NO;
        [self.CellDeleteButton setBackgroundImage:[UIImage imageNamed:@"DeleteCellGray"] forState:UIControlStateNormal];
    }
}

- (IBAction)CellDeleteChange:(id)sender {
    [self ChangeValue:self :sender];
}

- (IBAction)CellDeleteUnlock:(id)sender {
    self.CanDelete = !self.CanDelete;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
