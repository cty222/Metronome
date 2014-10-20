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
        case F_GI_CLICK:
            [TargetNotesTool FrontGiBeatFunc];
            break;
        case GI_CLICK:
            [TargetNotesTool GiBeatFunc];
            break;
        case GA_CLICK:
            [TargetNotesTool GaBeatFunc];
            break;
        case AF_GA_CLICK:
            [TargetNotesTool AfterGaBeatFunc];
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

- (void) FrontGiBeatFunc;
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(FrontGiBeatFunc)])
        {
            [self.delegate FrontGiBeatFunc];
        }
    }
}
- (void) GiBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(GiBeatFunc)])
        {
            [self.delegate GiBeatFunc];
        }
    }
}

- (void) GaBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(GaBeatFunc)])
        {
            [self.delegate GaBeatFunc];
        }
    }
}

- (void) AfterGaBeatFunc
{
    // For Override
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(AfterGaBeatFunc)])
        {
            [self.delegate AfterGaBeatFunc];
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
