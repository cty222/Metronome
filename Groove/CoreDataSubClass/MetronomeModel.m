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
    NSLog(@"CheckVersion");
    self.DbVersionDataTable = [self FetchDbConfigWhereDbVersion : _DbVersion];
    NSLog(@"%@", self.DbVersionDataTable);
    if (self.DbVersionDataTable.count == 0)
    {
        IsItNeedToInsertDBValue = YES;
    }
    NSLog(@"CheckVersion End");

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
    
    // Create TempoCell
    NSLog(@"03 Create TempoCell");
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
        for (int Index=0;Index < (3 + Row); Index++)
        {
            TempoCell* NewTempoList = [NSEntityDescription
                                       insertNewObjectForEntityForName:NSStringFromClass([TempoCell class])  inManagedObjectContext:_ManagedObjectContext];
            NewTempoList.bpmValue = [NSNumber numberWithInt:(50 + (Index + Row) *10)];
            NewTempoList.loopCount = @1;
            NewTempoList.accentVolume = @8.2;
            NewTempoList.quarterNoteVolume = @4.0;
            NewTempoList.eighthNoteVolume = @7.2;
            NewTempoList.sixteenNoteVolume = @(-0.5);
            NewTempoList.trippleNoteVolume = @0;
            NewTempoList.timeSignatureType = self.TimeSignatureTypeDataTable[3];
            NewTempoList.listOwner = self.TempoListDataTable[Row];
        }
    }
    [_ManagedObjectContext save:nil];

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
    }
    return [_ManagedObjectContext executeFetchRequest:self.TimeSignatureTypeEntityFetch error:nil];
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
    }
    
    return [_ManagedObjectContext executeFetchRequest:self.TempoCellEntitySigleOwnerFetch error:nil];
}

- (void) Save
{
    [_ManagedObjectContext save:nil];
}

//
// ==============================
@end
