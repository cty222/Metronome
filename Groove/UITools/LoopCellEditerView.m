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
    BOOL _CanDelete;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
        
        NSNumber * DeviceType = [GlobalConfig DeviceType];
        switch (DeviceType.intValue) {
            case IPHONE_4S:
                self.BackgroundView.image = [UIImage imageNamed:@"PropertyDialog_4S"];
                break;
            case IPHONE_5S:
                break;
            default:
                break;
        }
    }
    return self;
}

- (void) SetHidden:(BOOL)hidden
{
    super.hidden = hidden;
    self.CanDelete = NO;
}

- (void) SetValue : (int) NewValue
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
    }
    else
    {
        self.DeleteUnLock.image  = [UIImage imageNamed:@"SwitchButtonLock"];
        self.CellDeleteButton.enabled = NO;
    }
}

- (IBAction)CellDeleteChange:(id)sender {
    [self ChangeValue:self :sender];
}

- (IBAction)CellDeleteUnlock:(id)sender {
    self.CanDelete = !self.CanDelete;
}


@end
