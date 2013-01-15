//
//  PlayerModel.h
//  ROCKET Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <GameKit/GameKit.h>

@interface PlayerModel : NSObject 
{
	NSLock *writeLock;
}

@property (readonly, nonatomic, strong) NSString *storedScoresFilename;
@property (readonly, nonatomic) NSMutableArray * storedScores;

@property (readonly, nonatomic) NSString *storedAchievementsFilename;
@property (readonly, nonatomic) NSMutableDictionary *storedAchievements;


#pragma mark -
#pragma mark Leaderboard methods

- (void)resubmitStoredScores;
- (void)loadStoredScores;
- (void)writeStoredScore;
- (void)storeScore:(GKScore *)score;
- (void)submitScore:(GKScore *)score;


#pragma mark -
#pragma mark Achievement methods

- (void)resubmitStoredAchievements;
- (void)loadStoredAchievements;
- (void)writeStoredAchievements;
- (void)submitAchievement:(GKAchievement *)achievement;
- (void)storeAchievement:(GKAchievement *)achievement;
- (void)resetAchievements;

@end
