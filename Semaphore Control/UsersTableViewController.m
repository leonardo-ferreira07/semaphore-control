//
//  AppDelegate.m
//  Semaphore Control
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 29/09/15.
//  Copyright © 2015 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

#import "UsersTableViewController.h"
#import <Parse/Parse.h>

@implementation UsersTableViewController

#pragma mark Data

- (instancetype)initWithClassName:(NSString *)className {
    
    self = [super initWithClassName:className];
    if (self) {
        self.pullToRefreshEnabled = YES;
        self.objectsPerPage = 15;
        self.paginationEnabled = YES;
    }
    return self;
}
- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByAscending:@"username"];
    return query;
}

-(void) closeView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad {
    
    self.title=@"Users";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeView)];
    
    [self loadObjects];
}

#pragma mark TableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    static NSString *cellIdentifier = @"UserCell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell ==nil) {
        
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = object[@"username"];
    cell.detailTextLabel.text = object[@"email"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self showMealsControllerForIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation



@end