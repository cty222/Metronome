//
//  MetronomeEngine.m
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "MetronomeEngine.h"
#import "GlobalServices.h"

@interface MetronomeEngine ()

@property GlobalServices * globalServices;
@property NotesTool * noteCallbackInterface;

@end

@implementation MetronomeEngine
@synthesize globalServices = _globalServices;

- (id) initWithGlobalServices: (GlobalServices *) globalServices
{
    self = [super init];
    if (self){
        self.noteCallbackInterface = [[NotesTool alloc] init];
        self.noteCallbackInterface.delegate = self;
        
        // 2. Initialize player: gPlayUnit
        self.playUnit = [[AudioPlay alloc] init];
        
        // 3. Initilize Click Voice: gClickVoiceList
        [self resetVoiceList];
        
        self.globalServices = globalServices;
    }
    return self;
}

// =========================
// delegate
//
- (void) HumanVoiceDynamicFirstBeat
{
    switch (self.timeSignatureCounter) {
        case 0:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetFirstBeatVoice]];
            break;
        case 1:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetTwoBeatVoice]];
            break;
        case 2:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetThreeBeatVoice]];
            break;
        case 3:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetFourBeatVoice]];
            break;
        case 4:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetFiveBeatVoice]];
            break;
        case 5:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetSixBeatVoice]];
            break;
        case 6:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetSevenBeatVoice]];
            break;
        case 7:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetEightBeatVoice]];
            break;
        case 8:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetNineBeatVoice]];
            break;
        case 9:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetTenBeatVoice]];
            break;
        case 10:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetElevenBeatVoice]];
            break;
        case 11:
            [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                                : [self.currentVoice GetTwelveBeatVoice]];
            break;
    }
}

- (void) FirstBeatFunc
{
    // Accent
    if ( self.accentCounter == 0 || self.accentCounter >= [self decodeTimeSignatureToValue:self.currentTimeSignature]){
        [self.playUnit playSound: [self.currentCell.accentVolume floatValue]/ MAX_VOLUME
                            : [self.currentVoice GetAccentVoice]];
        
        if ([self.currentCell.accentVolume floatValue] > 0){
            [self.globalServices.notificationCenter makeCircleButtonTwickLing:AccentCircle_Button];
        }
        self.accentCounter = 0;
    }
    
    // TODO: Change Voice
    if ([@"HumanVoice" isEqualToString:NSStringFromClass([self.currentVoice class])]){
        [self HumanVoiceDynamicFirstBeat];
    }
    else{
        [self.playUnit playSound: [self.currentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                            : [self.currentVoice GetFirstBeatVoice]];
    }
    if ([self.currentCell.quarterNoteVolume floatValue] > 0){
        [self.globalServices.notificationCenter makeCircleButtonTwickLing:QuarterCircle_Button];
        //[self.cellParameterSettingSubController.VolumeSetsControl.QuarterCircleVolumeButton TwickLing];
    }
    self.accentCounter++;
}

- (void) EBeatFunc
{
    [self.playUnit playSound: [self.currentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.currentVoice GetEbeatVoice]];
    if ([self.currentCell.sixteenNoteVolume floatValue] > 0){
            [self.globalServices.notificationCenter makeCircleButtonTwickLing:SixteenthNoteCircle_Button];
        //[self.cellParameterSettingSubController.VolumeSetsControl.SixteenthNoteCircleVolumeButton TwickLing];
    }
}

- (void) AndBeatFunc
{
    [self.playUnit playSound: [self.currentCell.eighthNoteVolume floatValue] / MAX_VOLUME
                        : [self.currentVoice GetAndBeatVoice]];
    if ([self.currentCell.eighthNoteVolume floatValue] > 0){
        [self.globalServices.notificationCenter makeCircleButtonTwickLing:EighthNoteCircle_Button];
        //[self.cellParameterSettingSubController.VolumeSetsControl.EighthNoteCircleVolumeButton TwickLing];
    }
}

- (void) ABeatFunc
{
    [self.playUnit playSound: [self.currentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.currentVoice GetAbeatVoice]];
    if ([self.currentCell.sixteenNoteVolume floatValue] > 0){
        [self.globalServices.notificationCenter makeCircleButtonTwickLing:SixteenthNoteCircle_Button];
        //[self.cellParameterSettingSubController.VolumeSetsControl.SixteenthNoteCircleVolumeButton TwickLing];
    }
}

- (void) TicBeatFunc
{
    if ([self.currentTempoList.privateProperties.shuffleEnable boolValue]){
        return;
    }
    
    [self.playUnit playSound: [self.currentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.currentVoice GetTicbeatVoice]];
    
    if ([self.currentCell.trippleNoteVolume floatValue] > 0){
        [self.globalServices.notificationCenter makeCircleButtonTwickLing:TrippleNoteCircle_Button];
        //[self.cellParameterSettingSubController.VolumeSetsControl.TrippleNoteCircleVolumeButton TwickLing];
    }
}

- (void) TocBeatFunc
{
    [self.playUnit playSound: [self.currentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.currentVoice GetTocbeatVoice]];
    if ([self.currentCell.trippleNoteVolume floatValue] > 0){
        [self.globalServices.notificationCenter makeCircleButtonTwickLing:TrippleNoteCircle_Button];
        //[self.cellParameterSettingSubController.VolumeSetsControl.TrippleNoteCircleVolumeButton TwickLing];
    }
}

//
// =========================

// ============================
// temp
//

- (void) resetVoiceList
{
    if (self.clickVoiceList){
        [self.clickVoiceList removeAllObjects];
    }else{
        self.clickVoiceList = [[NSMutableArray alloc] init];
    }
    
    [self.clickVoiceList addObject: [[NormalHiClickVoice alloc] init]];
    [self.clickVoiceList addObject: [[BlockVoice alloc] init]];
    [self.clickVoiceList addObject: [[HumanVoice alloc] init]];
    [self.clickVoiceList addObject: [[DrumVoice1 alloc] init]];
}

- (void) triggerMetronomeSounds
{
    [NotesTool NotesFunc:self.currentPlayingNoteCounter :self.noteCallbackInterface];
}

- (int) decodeTimeSignatureToValue : (NSString *)timeSignatureString
{
    
    if ([timeSignatureString isEqualToString:@"1/4"])
    {
        return 1;
    }
    else if ([timeSignatureString isEqualToString:@"2/4"])
    {
        return 2;
    }
    else if ([timeSignatureString isEqualToString:@"3/4"])
    {
        return 3;
    }
    else if ([timeSignatureString isEqualToString:@"4/4"])
    {
        return 4;
    }
    else if ([timeSignatureString isEqualToString:@"5/4"])
    {
        return 5;
    }
    else if ([timeSignatureString isEqualToString:@"6/4"])
    {
        return 6;
    }
    else if ([timeSignatureString isEqualToString:@"7/4"])
    {
        return 7;
    }
    else if ([timeSignatureString isEqualToString:@"8/4"])
    {
        return 8;
    }
    else if ([timeSignatureString isEqualToString:@"9/4"])
    {
        return 9;
    }
    else if ([timeSignatureString isEqualToString:@"10/4"])
    {
        return 10;
    }
    else if ([timeSignatureString isEqualToString:@"11/4"])
    {
        return 11;
    }
    else if ([timeSignatureString isEqualToString:@"12/4"])
    {
        return 12;
    }
    return 4;
}

@end
