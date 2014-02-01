//
//  FTLRankingsViewController.m
//  FutuLeague
//
//  Created by Martin Richter on 31/01/14.
//  Copyright (c) 2014 Futurice. All rights reserved.
//

#import "FTLRankingsViewController.h"
#import "FTLRankingsViewModel.h"
#import "FTLNewMatchViewController.h"
#import "FTLPlayersCell+FTLPlayer.h"

static NSString * const FTLRankingsTableCellIdentifier = @"FTLRankingsTableCellIdentifier";

@interface FTLRankingsViewController ()

@property (nonatomic, strong) FTLRankingsViewModel *viewModel;

@end

@implementation FTLRankingsViewController

#pragma mark - Setup

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;

    _viewModel = [[FTLRankingsViewModel alloc] init];

    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[FTLPlayersCell class] forCellReuseIdentifier:FTLRankingsTableCellIdentifier];
    self.tableView.allowsSelection = NO;
    

    @weakify(self);
    [RACObserve(self.viewModel, model) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];

    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
        item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                FTLNewMatchViewController *newMatchViewController = [[FTLNewMatchViewController alloc]
                                                                     initWithPlayers:self.viewModel.model];
                
                UINavigationController *navigationViewController = [[UINavigationController alloc]
                                                                    initWithRootViewController:newMatchViewController];
                [self presentViewController:navigationViewController animated:YES completion:^{
                    [subscriber sendCompleted];
                }];

                return nil;
            }];
        }];
        item;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    self.viewModel.active = NO;
}

#pragma mark - User Interaction

- (void)newMatchButtonTapped
{

}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTLPlayersCell *cell = [tableView dequeueReusableCellWithIdentifier:FTLRankingsTableCellIdentifier
                                                           forIndexPath:indexPath];

    UIColor *evenColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *oddColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.88 alpha:1.0];

    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = oddColor;
    }
    else
    {
        cell.backgroundColor = evenColor;
    }

    NSInteger playerRank = indexPath.row + 1;
    [cell updateWithPlayer:[self playerAtIndexPath:indexPath] rank:playerRank];

    return cell;
}

- (FTLPlayer *)playerAtIndexPath:(NSIndexPath *)indexPath
{
    return self.viewModel.model[indexPath.row];
}

@end
