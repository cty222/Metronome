//
//  MetronomeBottomSubViewIphone.m
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeBottomSubViewIphone.h"

@implementation MetronomeBottomSubViewIphone
{
    NSArray * _CurrentDataTable;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self.SelectGrooveBar removeFromSuperview];
        self.SelectGrooveBar = [[MetronomeSelectBar alloc] initWithFrame:self.SelectGrooveBar.frame];
        self.SelectGrooveBar.delegate = self;
        [self addSubview:self.SelectGrooveBar];
        
        // Back ground
        self.backgroundColor = [UIColor whiteColor];
       
        [self.AccentCircleVolumeButton removeFromSuperview];
        self.AccentCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.AccentCircleVolumeButton.frame];
        [self addSubview:self.AccentCircleVolumeButton];

        [self.QuarterCircleVolumeButton removeFromSuperview];
        self.QuarterCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.QuarterCircleVolumeButton.frame];
        [self addSubview:self.QuarterCircleVolumeButton];

        [self.EighthNoteCircleVolumeButton removeFromSuperview];
        self.EighthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.EighthNoteCircleVolumeButton.frame];
        [self addSubview:self.EighthNoteCircleVolumeButton];

        [self.SixteenthNoteCircleVolumeButton removeFromSuperview];
        self.SixteenthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.SixteenthNoteCircleVolumeButton.frame];
        [self addSubview:self.SixteenthNoteCircleVolumeButton];

        [self.TrippleNoteCircleVolumeButton removeFromSuperview];
        self.TrippleNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.TrippleNoteCircleVolumeButton.frame];
        [self addSubview:self.TrippleNoteCircleVolumeButton];


        [self.VoiceTypeCircleButton removeFromSuperview];
        self.VoiceTypeCircleButton = [[CircleButton alloc] initWithFrame:self.VoiceTypeCircleButton.frame];
        [self addSubview:self.VoiceTypeCircleButton];

        
    }
    return self;
}


- (void) SetVolumeBarVolume : (TempoCell *)Cell
{
    self.AccentCircleVolumeButton.IndexValue = [Cell.accentVolume floatValue];
    self.QuarterCircleVolumeButton.IndexValue = [Cell.quarterNoteVolume floatValue];
    self.EighthNoteCircleVolumeButton.IndexValue = [Cell.eighthNoteVolume floatValue];
    self.SixteenthNoteCircleVolumeButton.IndexValue = [Cell.sixteenNoteVolume floatValue];
    self.TrippleNoteCircleVolumeButton.IndexValue = [Cell.trippleNoteVolume floatValue];
}

- (void) CopyGrooveLoopListToSelectBar : (NSArray *) CellDataTable
{
    NSMutableArray * GrooveLoopList = [[NSMutableArray alloc]init];
    for (TempoCell *Cell in CellDataTable)
    {
        [GrooveLoopList addObject:[Cell.loopCount stringValue]];
    }
    self.SelectGrooveBar.GrooveCellList = GrooveLoopList;
}

// =================================
// Property
//
- (NSArray *) GetCurrentDataTable
{
    return _CurrentDataTable;
}
- (void) SetCurrentDataTable : (NSArray *) NewValue
{
    int _FocusIndex = 0;
    
    _CurrentDataTable = NewValue;
    
    // Set Select Loop bar
    [self CopyGrooveLoopListToSelectBar: _CurrentDataTable];

    _FocusIndex = [self GetFocusIndex];
    
    if (_FocusIndex >= 0 && _FocusIndex < _CurrentDataTable.count)
    {
        [self SetVolumeBarVolume: _CurrentDataTable[_FocusIndex]];
    }
    else
    {
        // First Initailize will give wrong Index
        // NSLog(@"Wrong Index");
    }

}

- (int) GetFocusIndex
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(GetFocusIndex)])
        {
            return [self.delegate GetFocusIndex];
        }
    }

    return 0;
}

- (void) SetFocusIndex:(int) NewValue
{
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetFocusIndex:)])
        {
            [self.delegate SetFocusIndex: NewValue];
        }
    }
    
    // UI 自動動作
    [self SetVolumeBarVolume: _CurrentDataTable[[self GetFocusIndex]]];
}

- (void) ChangeSelectBarForcusIndex: (int) NewValue
{
    self.SelectGrooveBar.FocusIndex = NewValue;
}
//
// =================================


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
