//
//  LeaderboardView.h
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/02/10.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface LeaderboardView : UINavigationController <GKLeaderboardViewControllerDelegate>

- (void) showLeaderboard;

@end
