//
//  PlayerModel.m
//  ROCKET Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "PlayerModel.h"

@implementation PlayerModel

@synthesize storedScoresFilename, storedScores;
@synthesize storedAchievementsFilename, storedAchievements;


- (id)init
{
    self = [super init];
    if (self) {
		NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        storedAchievementsFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedAchievements.plist", path ,[GKLocalPlayer localPlayer].playerID];
        //###NSLog(@"%@", storedAchievementsFilename);

        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        storedScoresFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedScores.plist",path,[GKLocalPlayer localPlayer].playerID];
        
        writeLock = [[NSLock alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Leaderboard

- (void)resubmitStoredScores
{
    // Submit stored scores and remove from stored scores array
    if (storedScores) {
        // Keeping an index prevents new entries to be added when the network is down 
        int index = [storedScores count] - 1;
        while (index >= 0) {
            GKScore *score = [storedScores objectAtIndex:index];
            [self submitScore:score];
            [storedScores removeObjectAtIndex:index];
            index--;
        }
        [self writeStoredScore];
    }
}

- (void)loadStoredScores
{
    // Load stored scores from disk
    NSArray *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:storedScoresFilename];
    if (unarchivedObj) {
        storedScores = [[NSMutableArray alloc] initWithArray:unarchivedObj];
        [self resubmitStoredScores];
    }
    else {
        storedScores = [[NSMutableArray alloc] init];
    }
}

- (void)writeStoredScore
{
    // Save stores on disk
    [writeLock lock];
    NSData * archivedScore = [NSKeyedArchiver archivedDataWithRootObject:storedScores];
    NSError * error;
    [archivedScore writeToFile:storedScoresFilename options:NSDataWritingFileProtectionNone error:&error];
    if (error) {
        //###  Error saving file, handle accordingly 
        assert(0);
    }
    [writeLock unlock];
}

- (void)storeScore:(GKScore *)score 
{
    // Store score for submission at a later time
    [storedScores addObject:score];
    [self writeStoredScore];
}

- (void)submitScore:(GKScore *)score 
{
    // Try to submit score, store on failure
    if ([GKLocalPlayer localPlayer].authenticated) {
        if (!score.value) {
            //### Unable to validate data
            assert(0);
            return;
        }
        
        // Store the scores if there is an error
        [score reportScoreWithCompletionHandler:^(NSError *error) {
            if (!error || (![error code] && ![error domain])) {
                // Score submitted correctly, resubmit others
                [self resubmitStoredScores];
            }
            else {
                // Store score for next authentication 
                [self storeScore:score];
            }
        }];
    } 
}


#pragma mark -
#pragma mark Achievements

- (void)resubmitStoredAchievements
{
    // Try to submit stored achievements to update any achievements that were not successful 
    if (storedAchievements) {
        for (NSString *key in storedAchievements) {
            GKAchievement *achievement = [storedAchievements objectForKey:key];
            [storedAchievements removeObjectForKey:key];
            [self submitAchievement:achievement];
        } 
		[self writeStoredAchievements];
    }
}
 
- (void)loadStoredAchievements
{
    if (!storedAchievements) {
        // Load stored achievements and attempt to submit them
        NSDictionary *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:storedAchievementsFilename];
        if (unarchivedObj) {
            storedAchievements = [[NSMutableDictionary alloc] initWithDictionary:unarchivedObj];
            [self resubmitStoredAchievements];
        }
        else {
            storedAchievements = [[NSMutableDictionary alloc] init];
        }
    }    
}

- (void)writeStoredAchievements
{
    // Store achievements to disk to submit at a later time
    [writeLock lock];
    NSData *archivedAchievements = [NSKeyedArchiver archivedDataWithRootObject:storedAchievements];
    NSError *error;
    [archivedAchievements writeToFile:storedAchievementsFilename options:NSDataWritingFileProtectionNone error:&error];
    if (error) {
        //### Error saving file, handle accordingly
        //###NSLog(@"%@", error);
        assert(0);
    }
    [writeLock unlock];
}

- (void)submitAchievement:(GKAchievement *)achievement 
{
    // Submit an achievement to the server and store if submission fails
    if (achievement) {
        // Submit the achievement to Game Center
        [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
            if (error) {
                // Store achievement to be submitted at a later time
                [self storeAchievement:achievement];
            }
            else {
                if ([storedAchievements objectForKey:achievement.identifier]) {
                    // Achievement is reported, remove from the local store
                    [storedAchievements removeObjectForKey:achievement.identifier];
                } 
                [self resubmitStoredAchievements];
            }
        }];
    }
}

- (void)storeAchievement:(GKAchievement *)achievement 
{
    // Create an entry for an achievement that hasn't been submitted to the server 
    GKAchievement *currentStorage = [storedAchievements objectForKey:achievement.identifier];
    if (!currentStorage || (currentStorage && currentStorage.percentComplete < achievement.percentComplete)) {
        [storedAchievements setObject:achievement forKey:achievement.identifier];
        [self writeStoredAchievements];
    }
}

- (void)resetAchievements
{
    // Reset all the achievements for local player 
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) {
        if (!error) {
            // overwrite any previously stored file
            [self writeStoredAchievements];              
            storedAchievements = [[NSMutableDictionary alloc] init];
        }
        else {
            //### Error clearing achievements
            assert(0);
         }
     }];
}

@end
