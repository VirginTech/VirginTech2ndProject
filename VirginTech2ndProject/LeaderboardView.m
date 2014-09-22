//
//  LeaderboardView.m
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/02/10.
//
//

#import "LeaderboardView.h"

@implementation LeaderboardView

- (void) showLeaderboard
{
    // LeaderboardのView Controllerを生成する
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    
    // LeaderboardのView Controllerの生成に失敗した場合は処理を終了する
    if (leaderboardController == nil) {
        return;
    }
    
    // View Controllerを取得する
    LeaderboardView *viewController = (LeaderboardView *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    // delegateを設定する
    leaderboardController.leaderboardDelegate = viewController;
    
    // Leaderboardを表示する
    //[viewController presentModalViewController:leaderboardController animated:YES];
    [viewController presentViewController:leaderboardController animated:YES completion:^(void){}];
}

/*- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}*/

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

@end
