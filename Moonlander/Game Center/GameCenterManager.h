//
//  GameCenterManager.h
//  LANDER Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@protocol GameCenterManagerDelegate <NSObject>
@optional
- (void)processedAuthorization:(GKLocalPlayer *)localPlayer error:(NSError *)error;
- (void)achievementsLoaded:(NSArray *)achievements error:(NSError *)error;
- (void)scoreReported:(NSError *)error;
- (void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error;
- (void)achievementSubmitted:(GKAchievement *)achievement error:(NSError *)error;
- (void)achievementResetResult:(NSError *)error;
- (void)mappedPlayerIDToPlayer:(GKPlayer *)player error:(NSError *)error;
@end

@interface GameCenterManager : NSObject
{
	NSMutableDictionary         *earnedAchievementCache;
    NSLock                      *writeLock;

	id <GameCenterManagerDelegate, NSObject> __unsafe_unretained delegate;
}

@property (atomic) NSMutableDictionary* earnedAchievementCache;

@property (nonatomic, unsafe_unretained) id <GameCenterManagerDelegate> delegate;

@property (readonly, nonatomic, strong) NSString *storedScoresFilename;
@property (readonly, nonatomic, strong) NSMutableArray *storedScores;

@property (readonly, nonatomic, strong) NSString *storedAchievementsFilename;
@property (readonly, nonatomic, strong) NSMutableDictionary *storedAchievements;


+ (BOOL)isGameCenterAvailable;

- (void)authenticateLocalPlayer;

- (void)reportScore:(int64_t)score forCategory:(NSString *)category;
- (void)reloadHighScoresForCategory: (NSString*) category;
- (void)loadStoredScores;

- (void)loadAchievements;
- (GKAchievement *)getAchievement:(NSString *)identifier;
- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete;
- (void)resetAchievements;

- (void)mapPlayerIDtoPlayer:(NSString *)playerID;

@end
