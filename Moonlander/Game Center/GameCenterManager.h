//
//  GameCenterManager.h
//  Moonlander Classic
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
- (void)achievementSubmitted:(GKAchievement *)achievement error:(NSError *)error;
- (void)achievementResetResult:(NSError *)error;
    @end

@interface GameCenterManager : NSObject
{
    NSMutableDictionary                                             *earnedAchievementCache;
    
    id <GameCenterManagerDelegate, NSObject> __unsafe_unretained    delegate;
}

@property (atomic) NSMutableDictionary* earnedAchievementCache;
@property (nonatomic, unsafe_unretained) id <GameCenterManagerDelegate> delegate;
@property (nonatomic, readonly) NSError *lastError;
    
    
+ (BOOL)isGameCenterAvailable;
    
- (void)authenticateLocalPlayer;
    
- (void)reportScore:(int64_t)score forCategory:(NSString *)category;
    
- (GKAchievement *)getAchievement:(NSString *)identifier;
- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete;
    
- (void)resetAchievements;
    
@end
