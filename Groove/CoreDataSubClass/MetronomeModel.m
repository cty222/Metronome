//
//  MetronomeModel.m
//  Groove
//
//  Created by C-ty on 2014/9/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeModel.h"

@implementation MetronomeModel
{
    NSManagedObjectContext * _ManagedObjectContext;
    NSManagedObjectModel * _ManagedObjectModel;
    NSNumber * _DbVersion;
}

- (void) InitializeCoreData : (NSManagedObjectContext *) ManagedObjectContext
         ManagedObjectModel : (NSManagedObjectModel *) ManagedObjectModel
                  DbVersion : (NSNumber *) DbVersion
{

    Boolean IsItNeedToInsertDBValue = NO;
    _ManagedObjectContext = ManagedObjectContext;
    _ManagedObjectModel = ManagedObjectModel;
    _DbVersion = DbVersion;
    
    // CheckVersion
    self.DbVersionDataTable = [self FetchDbConfigWhereDbVersion : _DbVersion];
    if (self.DbVersionDataTable.count == 0)
    {
        IsItNeedToInsertDBValue = YES;
    }
    
    // If need to set default
    if (IsItNeedToInsertDBValue)
    {
        NSLog(@"Reset Db");
        
        // *****************
        // TODO: Delete all data
        // *****************
        
        // Create
        [self ResetToDefaultDb: _DbVersion];
    }

    // Fetch All Data
    // Select TimeSignatureType
    self.TimeSignatureTypeDataTable = [self FetchTimeSignatureType];
    
    // Select TempoList
    self.TempoListDataTable = [self FetchTempoList];
    
    // Select TempoCell
    self.TempoCellDataTable = [self FetchTempoCell];
    
#if DEBUG_CLOSE
    // Debug Test
    for (TempoCell* Cell in self.TempoCellDataTable) {
        NSLog(@"%@", Cell);
    }
#endif
    
}

// ==============================
// Reset to Default
//
- (void) ResetToDefaultDb : (NSNumber *)DBVersion
{
    // Create TempoList
    NSLog(@"01 Create TempoList");
    [self CreateDefaultTempoList];
    
    // Create TimeSignature
    NSLog(@"02 Create TimeSignature");
    [self CreateDefaultTimeSignatureType];
    
    // Create VoiceType
    NSLog(@"03 Create VoiceType");
    [self CreateDefaultVoiceType];
    
    // Create TempoCell
    NSLog(@"04 Create TempoCell");
    [self CreateDefaultTempoCell];
    
    // Update DbVersion
    NSLog(@"04 Update DbVersion");
    [self UpdateDbVersion:DBVersion];
}

- (void) UpdateDbVersion : (NSNumber *)NewDBVersion
{
    DbConfig* NewDbConfig = [NSEntityDescription
                             insertNewObjectForEntityForName:NSStringFromClass([DbConfig class]) inManagedObjectContext:_ManagedObjectContext];
    NewDbConfig.dbVersion = NewDBVersion;
    [_ManagedObjectContext save:nil];
}

- (void) CreateDefaultTempoList
{
    for (int Index=0;Index <3; Index++)
    {
        TempoList* NewTempoList = [NSEntityDescription
                                   insertNewObjectForEntityForName:NSStringFromClass([TempoList class]) inManagedObjectContext:_ManagedObjectContext];
        NewTempoList.tempoListName = [NSString stringWithFormat:@"Default%d", Index];
        NewTempoList.focusCellIndex = @0;
        NewTempoList.sortIndex = [NSNumber numberWithInt:Index];
    }
    [_ManagedObjectContext save:nil];
}

- (void) CreateDefaultTimeSignatureType
{
    NSArray *TimeSignatureArray =[NSArray arrayWithObjects:@"1/4",@"2/4",@"3/4",@"4/4",@"5/4",@"6/4",@"7/4",@"8/4", nil];
    for (int Index=0;Index <TimeSignatureArray.count; Index++)
    {
        TimeSignatureType* NewTimeSignatureType = [NSEntityDescription
                                                   insertNewObjectForEntityForName:NSStringFromClass([TimeSignatureType class]) inManagedObjectContext:_ManagedObjectContext];
        NewTimeSignatureType.timeSignature = (NSString *)TimeSignatureArray[Index];
        NewTimeSignatureType.sortIndex = [NSNumber numberWithInt:Index];
        NSLog(@"%@", NewTimeSignatureType);
    }
    [_ManagedObjectContext save:nil];
}

- (void) CreateDefaultVoiceType
{

    NSArray *VoiceTypeArray =[NSArray arrayWithObjects:@"NomalHiClickVoice", @"NomalLowClickVoice", @"HumanVoice", nil];
    for (int Index=0;Index <VoiceTypeArray.count; Index++)
    {
        VoiceType* NewVoiceType = [NSEntityDescription
                                                   insertNewObjectForEntityForName:NSStringFromClass([VoiceType class]) inManagedObjectContext:_ManagedObjectContext];
        NewVoiceType.voiceType = (NSString *)VoiceTypeArray[Index];
        NewVoiceType.sortIndex = [NSNumber numberWithInt:Index];
    }
    [_ManagedObjectContext save:nil];

}

- (void) CreateDefaultTempoCell
{
    // Select TimeSignatureType
    self.TimeSignatureTypeDataTable = [self FetchTimeSignatureType];
    
    // Select TempoList
    self.TempoListDataTable = [self FetchTempoList];
    
    for (int Row = 0; Row < self.TempoListDataTable.count; Row++)
    {
        for (int Index = 0 ;Index < 3; Index++)
        {
            TempoCell* NewTempoList = [NSEntityDescription
                                       insertNewObjectForEntityForName:NSStringFromClass([TempoCell class])  inManagedObjectContext:_ManagedObjectContext];
            NewTempoList.bpmValue = [NSNumber numberWithInt:(50 + (Index + Row) *10)];
            NewTempoList.loopCount = @1;
            NewTempoList.accentVolume = @10.0;
            NewTempoList.quarterNoteVolume = @10.0;
            NewTempoList.eighthNoteVolume = @7.0;
            NewTempoList.sixteenNoteVolume = @0;
            NewTempoList.trippleNoteVolume = @0;
            NewTempoList.timeSignatureType = self.TimeSignatureTypeDataTable[3];
            NewTempoList.listOwner = self.TempoListDataTable[Row];
            NewTempoList.sortIndex = [NSNumber numberWithInt:Index];
        }
    }
    [_ManagedObjectContext save:nil];
}

- (MusicBindingInfo *) CreateNewMusicInfo
{
    MusicBindingInfo *NewInfo = [NSEntityDescription
                                insertNewObjectForEntityForName:NSStringFromClass([MusicBindingInfo class])  inManagedObjectContext:_ManagedObjectContext];
    [_ManagedObjectContext save:nil];
    return NewInfo;
}

//
// ==============================


// ==============================
// Fetch
//

- (NSArray *) FetchDbConfigWhereDbVersion : (NSNumber *) DbVersion
{
    if (self.DbConfigEntityFetch == nil)
    {
        NSEntityDescription *Entity;
        Entity = [NSEntityDescription entityForName:NSStringFromClass([DbConfig class]) inManagedObjectContext:_ManagedObjectContext];
        
        self.DbConfigEntityFetch = [_ManagedObjectModel fetchRequestFromTemplateWithName:@"FetchDbVersion" substitutionVariables:[NSDictionary dictionaryWithObject:DbVersion forKey:@"DbVersion"]];
        [self.DbConfigEntityFetch setEntity:Entity];
    }
    
    return [_ManagedObjectContext executeFetchRequest:self.DbConfigEntityFetch error:nil];
}

- (NSArray *) FetchTempoList
{
    if (self.TempoListEntityFetch == nil)
    {
        NSEntityDescription *Entity;
        self.TempoListEntityFetch = [[NSFetchRequest alloc] init];
        Entity = [NSEntityDescription entityForName:NSStringFromClass([TempoList class]) inManagedObjectContext:_ManagedObjectContext];
        [self.TempoListEntityFetch setEntity:Entity];
        
        // Sort
        NSSortDescriptor *Sort = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
        NSArray *SortArray = [[NSArray alloc] initWithObjects:Sort, nil];
        [self.TempoListEntityFetch setSortDescriptors:SortArray];
    }
    return [_ManagedObjectContext executeFetchRequest:self.TempoListEntityFetch error:nil];
}

- (NSArray *) FetchTimeSignatureType
{
    NSEntityDescription *Entity;
    
    if (self.TimeSignatureTypeEntityFetch == nil)
    {
        self.TimeSignatureTypeEntityFetch = [[NSFetchRequest alloc] init];
        Entity = [NSEntityDescription entityForName:NSStringFromClass([TimeSignatureType class]) inManagedObjectContext:_ManagedObjectContext];
        [self.TimeSignatureTypeEntityFetch setEntity:Entity];
        
        // Sort
        NSSortDescriptor *Sort = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
        NSArray *SortArray = [[NSArray alloc] initWithObjects:Sort, nil];
        [self.TimeSignatureTypeEntityFetch setSortDescriptors:SortArray];
    }
    return [_ManagedObjectContext executeFetchRequest:self.TimeSignatureTypeEntityFetch error:nil];
}

- (NSArray *) FetchVoiceType
{
    NSEntityDescription *Entity;
    if (self.VoiceTypeEntityFetch == nil)
    {
        self.VoiceTypeEntityFetch = [[NSFetchRequest alloc] init];
        Entity = [NSEntityDescription entityForName:NSStringFromClass([VoiceType class]) inManagedObjectContext:_ManagedObjectContext];
        [self.VoiceTypeEntityFetch setEntity:Entity];
        
        // Sort
        NSSortDescriptor *Sort = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
        NSArray *SortArray = [[NSArray alloc] initWithObjects:Sort, nil];
        [self.VoiceTypeEntityFetch setSortDescriptors:SortArray];
    }
    return [_ManagedObjectContext executeFetchRequest:self.VoiceTypeEntityFetch error:nil];
}

- (NSArray *) FetchTempoCell
{
    if (self.TempoCellEntityFetch == nil)
    {
        NSEntityDescription *Entity;
        self.TempoCellEntityFetch = [[NSFetchRequest alloc] init];
        Entity = [NSEntityDescription entityForName:NSStringFromClass([TempoCell class]) inManagedObjectContext:_ManagedObjectContext];
        [self.TempoCellEntityFetch setEntity:Entity];
    }
    return [_ManagedObjectContext executeFetchRequest:self.TempoCellEntityFetch error:nil];
}

- (NSArray *) FetchTempoCellWhereListName : (TempoList *) listOwner
{
    if (self.TempoCellEntitySigleOwnerFetch == nil)
    {
        NSEntityDescription *Entity;
        Entity = [NSEntityDescription entityForName:NSStringFromClass([TempoCell class]) inManagedObjectContext:_ManagedObjectContext];
        
        self.TempoCellEntitySigleOwnerFetch = [_ManagedObjectModel fetchRequestFromTemplateWithName:@"FetchCellFromSigleOwner" substitutionVariables:[NSDictionary dictionaryWithObject:listOwner forKey:@"listOwner"]];
        [self.TempoCellEntitySigleOwnerFetch setEntity:Entity];
        
        // Sort
        NSSortDescriptor *Sort = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
        NSArray *SortArray = [[NSArray alloc] initWithObjects:Sort, nil];
        [self.TempoCellEntitySigleOwnerFetch setSortDescriptors:SortArray];
    }
    
    NSError *Error;
    NSArray *ReturnArray = [_ManagedObjectContext executeFetchRequest:self.TempoCellEntitySigleOwnerFetch error:&Error];
    if (Error)
    {
        NSLog(@"%@", Error);
    }
    return ReturnArray;
}

- (TempoList *) FetchCurrentTempoListFromModel : (NSNumber * ) TempoListIndex
{
    TempoList * ReturnTempoList = nil;
    
    NSNumber *LastTempoListIndex = TempoListIndex;
    
    NSArray* TempoListDataTable = gMetronomeModel.TempoListDataTable;
    
    if (TempoListDataTable.count > [LastTempoListIndex intValue])
    {
        ReturnTempoList = TempoListDataTable[[LastTempoListIndex intValue]];
    }
   
    return ReturnTempoList;
}

//
// ==============================

// ==============================
//
//

- (void) Save
{
    [_ManagedObjectContext save:nil];
}

- (void) AddNewTempoCell : (TempoList *) CellOwner : (int) SortIndex
{
    TempoCell* NewTempoList = [NSEntityDescription
                               insertNewObjectForEntityForName:NSStringFromClass([TempoCell class])  inManagedObjectContext:_ManagedObjectContext];
    NewTempoList.bpmValue = [NSNumber numberWithInt:(120)];
    NewTempoList.loopCount = @1;
    NewTempoList.accentVolume = @10.0;
    NewTempoList.quarterNoteVolume = @10.0;
    NewTempoList.eighthNoteVolume = @0;
    NewTempoList.sixteenNoteVolume = @0;
    NewTempoList.trippleNoteVolume = @0;
    NewTempoList.timeSignatureType = self.TimeSignatureTypeDataTable[3];
    NewTempoList.listOwner = CellOwner;
    NewTempoList.sortIndex = [NSNumber numberWithInt:SortIndex];

    [self Save];
}

- (void) DeleteTargetTempoCell : (TempoCell *) TargetCell
{
    [_ManagedObjectContext deleteObject:TargetCell];
    
    [self Save];
}
//
// ==============================

@end
