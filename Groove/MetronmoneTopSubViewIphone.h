//
//  MetronmoneTopSubViewIphone.h
//  Groove
//
//  Created by C-ty on 2014/9/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LargeBPMPicker.h"

@interface MetronmoneTopSubViewIphone : XibViewInterface <LargeBPMPickerProtocol>

@property (weak, nonatomic) IBOutlet UIButton *ButtonChangePage;
@property (strong, nonatomic) IBOutlet LargeBPMPicker *BPMPicker;

@property (nonatomic, assign) id<LargeBPMPickerProtocol> delegate;


@end
