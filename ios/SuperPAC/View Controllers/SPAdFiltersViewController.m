//
//  SPAdFiltersViewController.m
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPAdFiltersViewController.h"
#import "SPAdFilterCell.h"
#import "UIViewFactory.h"
#import "Constants.h"

@interface SPAdFiltersViewController ()

- (void)deselectAllTagFilters;
- (void)setBoxForRow:(NSInteger)row checked:(BOOL)checked;

@end

@implementation SPAdFiltersViewController
@synthesize dismissSettingsButton = _dismissSettingsButton;
@synthesize filtersTable = _filtersTable;
@synthesize filterSettings = _filterSettings;
@synthesize filterDelegate = _filterDelegate;
@synthesize clearFiltersButton = _clearFiltersButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

//close modal and update filters in filter delegate (the ad view)
- (IBAction)dismissFilters:(id)sender{
    [self.filterDelegate updateFilters:self.filterSettings];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clearFilters:(id)sender{
    self.filterSettings = [NSMutableSet set];
    [self.filtersTable reloadData];
}


- (void)deselectAllTagFilters
{
    [self.filterSettings removeObject:kAdFilterTypeFail];
    [self.filterSettings removeObject:kAdFilterTypeFair];
    [self.filterSettings removeObject:kAdFilterTypeLoved];
    [self.filterSettings removeObject:kAdFilterTypeFishy];
    
    [self setBoxForRow:TypeFilterFail checked:NO];
    [self setBoxForRow:TypeFilterFair checked:NO];
    [self setBoxForRow:TypeFilterLoved checked:NO];
    [self setBoxForRow:TypeFilterFishy checked:NO];

}

- (void)setBoxForRow:(NSInteger)row checked:(BOOL)checked
{
    SPAdFilterCell *cell = (SPAdFilterCell*)[self.filtersTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    NSString *imageName = checked ? @"checked_box" : @"unchecked_box";
    [cell.filterCheckbox setImage:[UIImage imageNamed:imageName]];
}

#pragma mark - Table View Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"SPAdFilterCell"; 
    
    SPAdFilterCell *cell = (SPAdFilterCell*)[self.filtersTable dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell =  (SPAdFilterCell *)[SPAdFilterCell view]; 
        cell.filterLabel.textColor = kSPDarkBlueTextColor;
        

    }
    NSString *filterString;
    switch (indexPath.row){
        case TypeFilterRecent:
            cell.filterLabel.text = @"Recent";
            filterString = kAdFilterTypeRecent;
            break;
        case TypeFilterPopular:
            cell.filterLabel.text = @"Popular";
            filterString = kAdFilterTypePopular;
            break;
        case TypeFilterProObama:
            cell.filterLabel.text = @"Support Obama";
            filterString = kAdFilterTypeProObama;
            break;
        case TypeFilterProRomney:
            cell.filterLabel.text = @"Support Romney";
            filterString = kAdFilterTypeProRomney;
            break;
        case TypeFilterAntiObama:
            cell.filterLabel.text = @"Oppose Obama";
            filterString = kAdFilterTypeAntiObama;
            break;
        case TypeFilterAntiRomney:
            cell.filterLabel.text = @"Oppose Romney";
            filterString = kAdFilterTypeAntiRomney;
            break;
        case TypeFilterLoved:
            cell.filterLabel.text = @"Love";
            filterString = kAdFilterTypeLoved;
            break;
        case TypeFilterFair:
            cell.filterLabel.text = @"Fair";
            filterString = kAdFilterTypeFair;
            break;
        case TypeFilterFishy:
            cell.filterLabel.text = @"Fishy";
            filterString = kAdFilterTypeFishy;
            break;
        case TypeFilterFail:
            cell.filterLabel.text = @"Fail";            
            filterString = kAdFilterTypeFail;
            break;
    }
    
    if( [self.filterSettings member:filterString]){
        [cell.filterCheckbox setImage:[UIImage imageNamed:@"checked_box"]];
    }
    else{
        [cell.filterCheckbox setImage:[UIImage imageNamed:@"unchecked_box"]];
    }
    [self.filtersTable deselectRowAtIndexPath:indexPath animated:YES];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return nFilterTypes;
}

#pragma mark - Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPAdFilterCell *cell = (SPAdFilterCell*)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isTagFilter = NO;
    
    NSString *filterString;
    switch (indexPath.row){
        case TypeFilterRecent:
            filterString = kAdFilterTypeRecent;
            break;
        case TypeFilterPopular:
            filterString = kAdFilterTypePopular;
            break;
        case TypeFilterProObama:
            filterString = kAdFilterTypeProObama;
            [self.filterSettings removeObject:kAdFilterTypeProRomney];
            [self.filterSettings removeObject:kAdFilterTypeAntiObama];
            [self setBoxForRow:TypeFilterProRomney checked:NO];
            [self setBoxForRow:TypeFilterAntiObama checked:NO];
            break;
        case TypeFilterProRomney:
            filterString = kAdFilterTypeProRomney;
            [self.filterSettings removeObject:kAdFilterTypeProObama];
            [self.filterSettings removeObject:kAdFilterTypeAntiRomney];
            [self setBoxForRow:TypeFilterProObama checked:NO];
            [self setBoxForRow:TypeFilterAntiRomney checked:NO];
            break;
        case TypeFilterAntiObama:
            filterString = kAdFilterTypeAntiObama;
            [self.filterSettings removeObject:kAdFilterTypeProObama];
            [self.filterSettings removeObject:kAdFilterTypeAntiRomney];
            [self setBoxForRow:TypeFilterProObama checked:NO];
            [self setBoxForRow:TypeFilterAntiRomney checked:NO];
            break;
        case TypeFilterAntiRomney:
            filterString = kAdFilterTypeAntiRomney;
            [self.filterSettings removeObject:kAdFilterTypeProRomney];
            [self.filterSettings removeObject:kAdFilterTypeAntiObama];
            [self setBoxForRow:TypeFilterProRomney checked:NO];
            [self setBoxForRow:TypeFilterAntiObama checked:NO];
            break;
        case TypeFilterLoved:
            filterString = kAdFilterTypeLoved;
            isTagFilter = YES;
            break;
        case TypeFilterFair:
            filterString = kAdFilterTypeFair;
            isTagFilter = YES;
            break;
        case TypeFilterFishy:
            filterString = kAdFilterTypeFishy;
            isTagFilter = YES;
            break;
        case TypeFilterFail:
            filterString = kAdFilterTypeFail;
            isTagFilter = YES;
            break;
    }
    if([self.filterSettings containsObject:filterString]){
        [self.filterSettings removeObject:filterString];
        [cell.filterCheckbox setImage:[UIImage imageNamed:@"unchecked_box"]];
    }
    else{
        if (isTagFilter)
            [self deselectAllTagFilters];
        
        [self.filterSettings addObject:filterString];
        [cell.filterCheckbox setImage:[UIImage imageNamed:@"checked_box"]];
    }
}

@end
