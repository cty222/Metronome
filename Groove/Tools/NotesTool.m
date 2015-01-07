//
//  NotesTool.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/7/7.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "NotesTool.h"

@implementation NotesTool

+ (void) NotesFunc : (CURRENT_PLAYING_NOTE) InputNote : (NotesTool *) TargetNotesTool
{
    switch (InputNote) {
        case FIRST_CLICK:
            [TargetNotesTool FirstBeatFunc];
            break;
        case E_CLICK:
            [TargetNotesTool EBeatFunc];
            break;
        case AND_CLICK:
            [TargetNotesTool AndBeatFunc];
            break;
        case A_CLICK:
            [TargetNotesTool ABeatFunc];
            break;
        case F_TIC_CLICK:
            [TargetNotesTool FrontTicBeatFunc];
            break;
        case TIC_CLICK:
            [TargetNotesTool TicBeatFunc];
            break;
        case TOC_CLICK:
            [TargetNotesTool TocBeatFunc];
            break;
        case AF_TOC_CLICK:
            [TargetNotesTool AfterTocBeatFunc];
            break;
        default:
            [TargetNotesTool DefaultFunc];
            break;
    }
}

- (void) FirstBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(FirstBeatFunc)])
        {
           [self.delegate FirstBeatFunc];
        }
    }
}

- (void) EBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(EBeatFunc)])
        {
            [self.delegate EBeatFunc];
        }
    }
}

- (void) AndBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(AndBeatFunc)])
        {
            [self.delegate AndBeatFunc];
        }
    }
}

- (void) ABeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(ABeatFunc)])
        {
            [self.delegate ABeatFunc];
        }
    }
}

- (void) FrontTicBeatFunc;
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(FrontTicBeatFunc)])
        {
            [self.delegate FrontTicBeatFunc];
        }
    }
}

- (void) TicBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(TicBeatFunc)])
        {
            [self.delegate TicBeatFunc];
        }
    }
}

- (void) TocBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(TocBeatFunc)])
        {
            [self.delegate TocBeatFunc];
        }
    }
}

- (void) AfterTocBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(AfterTocBeatFunc)])
        {
            [self.delegate AfterTocBeatFunc];
        }
    }
}

- (void) DefaultFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(DefaultFunc)])
        {
            [self.delegate DefaultFunc];
        }
    }
}
@end
