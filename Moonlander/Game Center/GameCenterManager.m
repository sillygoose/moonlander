//
//  GameCenterManager.m
//  LANDER Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "GameCenterManager.h"
#import <GameKit/GameKit.h>



@implementation GameCenterManager

@synthesize earnedAchievementCache;
@synthesize delegate;

@synthesize storedScoresFilename, storedScores;
@synthesize storedAchievementsFilename, storedAchievements;


#pragma mark -
#pragma mark Initialization

- (id)init
{
	self = [super init];
	if (self) {
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        storedAchievementsFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedAchievements.plist", path, [GKLocalPlayer localPlayer].playerID];
        
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        storedScoresFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedScores.plist",path, [GKLocalPlayer localPlayer].playerID];
        
        writeLock = [[NSLock alloc] init];
	}
	return self;
}

- (void)dealloc
{
    self.earnedAchievementCache = nil;
}



#pragma mark -
#pragma mark Game Center interface

+ (BOOL)isGameCenterAvailable
{
	// Check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// Check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (void)authenticateLocalPlayer
{
	if ([GKLocalPlayer localPlayer].authenticated == NO) {
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
			[self callDelegateOnMainThread:@selector(processedAuthorization:error:) withArg:[GKLocalPlayer localPlayer] error:error];
		}];
	}
}


#pragma mark -
#pragma mark Delegate management

// NOTE:  GameCenter does not guarantee that callback blocks will be execute on the main thread. 
// As such, your application needs to be very careful in how it handles references to view
// controllers.  If a view controller is referenced in a block that executes on a secondary queue,
// that view controller may be released (and dealloc'd) outside the main queue.  This is true
// even if the actual block is scheduled on the main thread.  In concrete terms, this code
// snippet is not safe, even though viewController is dispatching to the main queue:
//
//	[object doSomethingWithCallback:  ^()
//	{
//		dispatch_async(dispatch_get_main_queue(), ^(void)
//		{
//			[viewController doSomething];
//		});
//	}];
//
// UIKit view controllers should only be accessed on the main thread, so the snippet above may
// lead to subtle and hard to trace bugs.  Many solutions to this problem exist.  In this sample,
// I'm bottlenecking everything through  "callDelegateOnMainThread" which calls "callDelegate". 
// Because "callDelegate" is the only method to access the delegate, I can ensure that delegate
// is not visible in any of my block callbacks.

- (void)callDelegate:(SEL)selector withArg:(id)arg error:(NSError *)err
{
	assert([NSThread isMainThread]);
	if ([delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		if (arg != nil) {
            [delegate performSelector:selector withObject:arg withObject:err];
		}
		else {
			[delegate performSelector:selector withObject:err];
		}
#pragma clang diagnostic pop
	}
	else {
		NSLog(@"Missed Method");
        assert(0);
	}
}

- (void)callDelegateOnMainThread:(SEL)selector withArg:(id)arg error:(NSError *)err
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
	   [self callDelegate:selector withArg:arg error:err];
	});
}


#pragma mark -
#pragma mark Leaderboards

- (void)reportScore:(int64_t)score forCategory:(NSString *)category 
{
	GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];	
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *errorObject) {
        // Update the delegate
        [self callDelegateOnMainThread: @selector(scoreReported:) withArg:nil error:errorObject];
        
        // Check if failed and we should cache the locally for a later update
        if (errorObject || [errorObject code] || [errorObject domain]) {
            // Store score for next authentication 
            [self storeScore:scoreReporter];
        }
        else {
            // Score submitted correctly, resubmit any other we may have
            [self resubmitStoredScores];
        }
    }];
}

- (void)reloadHighScoresForCategory:(NSString *)category
{
	GKLeaderboard *leaderBoard = [[GKLeaderboard alloc] init];
	leaderBoard.category = category;
	leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
	leaderBoard.range = NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
		[self callDelegateOnMainThread:@selector(reloadScoresComplete:error:) withArg:leaderBoard error:error];
	}];
}

- (void)submitScore:(GKScore *)score 
{
    // Try to submit score, store on failure
    if ([GKLocalPlayer localPlayer].authenticated) {
        // Store the scores if there is an error
        [score reportScoreWithCompletionHandler:^(NSError *error) {
            if (error || [error code] || [error domain]) {
                // Store score for next authentication 
                [self storeScore:score];
            }
        }];
    } 
}

- (void)resubmitStoredScores
{
    // Submit stored scores and remove from stored scores array
    if (storedScores) {
        // Keeping an index prevents new entries to be added when the network is down 
        int index = [storedScores count] - 1;
        if (index >= 0) {
            while (index >= 0) {
                GKScore *score = [storedScores objectAtIndex:index];
                [self submitScore:score];
                [storedScores removeObjectAtIndex:index];
                index--;
            }
            [self writeStoredScore];
        }
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
    NSData *archivedScore = [NSKeyedArchiver archivedDataWithRootObject:storedScores];
    NSError *error;
    [archivedScore writeToFile:storedScoresFilename options:NSDataWritingFileProtectionNone error:&error];
    if (error) {
        // Error saving file, handle accordingly 
        NSLog(@"writeStoredScore: %@", error);
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


#pragma mark -
#pragma mark Achievements

- (void)loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        // Create the local cache of achievements
        NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity:[achievements count]];
        for (GKAchievement *achievement in achievements) {
            [tempCache setObject:achievement forKey:achievement.identifier];
        }
        self.earnedAchievementCache = tempCache;
        
        // Update the delegate on the action
        [self callDelegateOnMainThread:@selector(achievementsLoaded:error:) withArg:achievements error:error];
    }];
}

- (GKAchievement *)getAchievement:(NSString *)identifier
{
    GKAchievement *achievement = nil;
	if (self.earnedAchievementCache != nil) {
		achievement = [self.earnedAchievementCache objectForKey:identifier];
    }
    return achievement;
}

- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete
{
	// GameCenter check for duplicate achievements when the achievement is submitted, but if you only want to report 
	// new achievements to the user, then you need to check if it's been earned 
	// before you submit.  Otherwise you'll end up with a race condition between loadAchievementsWithCompletionHandler
	// and reportAchievementWithCompletionHandler.  To avoid this, we fetch the current achievement list once,
	// then cache it and keep it updated with any new achievements.
	if (self.earnedAchievementCache == nil) {
		[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
			if (error == nil) {
				NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity:[achievements count]];
				for (GKAchievement *achievement in achievements) {
					[tempCache setObject:achievement forKey:achievement.identifier];
				}
				self.earnedAchievementCache = tempCache;
				[self submitAchievement:identifier percentComplete:percentComplete];
			}
			else {
				// Something broke loading the achievement list.  Error out, and we'll try again the next time achievement submit
				[self callDelegateOnMainThread:@selector(achievementSubmitted:error:) withArg:nil error:error];
			}
		}];
	}
	else {
		 // Search the list for the ID we're using...
		GKAchievement* achievement = [self.earnedAchievementCache objectForKey:identifier];
		if (achievement != nil) {
			if ((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)) {
				// Achievement has already been earned so we're done
				achievement = nil;
			}
			achievement.percentComplete = percentComplete;
		}
		else {
			achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
			achievement.percentComplete = percentComplete;
            
			// Add achievement to achievement cache...
			[self.earnedAchievementCache setObject:achievement forKey:achievement.identifier];
		}
        
        // Update the achievement on GC
		if (achievement != nil) {
            achievement.showsCompletionBanner = YES;
            if (achievement.percentComplete > 100.0) achievement.percentComplete = 100.0;
			[achievement reportAchievementWithCompletionHandler:^(NSError *error) {
				 [self callDelegateOnMainThread:@selector(achievementSubmitted:error:) withArg:achievement error:error];
			}];
		}
	}
}

- (void)resetAchievements
{
	self.earnedAchievementCache = nil;
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) {
		 [self callDelegateOnMainThread:@selector(achievementResetResult:) withArg:nil error:error];
	}];
}

- (void)mapPlayerIDtoPlayer:(NSString *)playerID
{
	[GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error) {
		GKPlayer *player = nil;
		for (GKPlayer *tempPlayer in playerArray) {
			if ([tempPlayer.playerID isEqualToString:playerID]) {
				player = tempPlayer;
				break;
			}
		}
		[self callDelegateOnMainThread: @selector(mappedPlayerIDToPlayer:error:) withArg:player error:error];
	}];
}

@end
