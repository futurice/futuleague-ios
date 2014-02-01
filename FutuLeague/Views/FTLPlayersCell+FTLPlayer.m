//
//  FTLPlayersCell+FTLPlayer.m
//  FutuLeague
//
//  Created by Evangelos Sismanidis on 31/01/14.
//  Copyright (c) 2014 Futurice. All rights reserved.
//

#import "FTLPlayersCell+FTLPlayer.h"
#import "FTLPlayer.h"

@implementation FTLPlayersCell (FTLPlayer)

- (void)updateWithPlayer:(FTLPlayer *)player rank:(NSInteger)rank
{
    self.nameLabel.text = [NSString stringWithFormat:@"%d. %@", rank, player.name];
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", player.rating];
}

@end
