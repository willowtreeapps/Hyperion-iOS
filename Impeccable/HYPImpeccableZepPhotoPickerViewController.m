//
//  HYPImpeccableZepPhotoPickerViewController.m
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPImpeccableZepPhotoPickerViewController.h"
#import "HYPImpeccableZepAPIManager.h"
#import "HYPImpeccableAsset.h"

@interface HYPImpeccableZepPhotoPickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *imagePickerTableView;
@property (nonatomic) NSArray <HYPImpeccableAsset *> *assets;
@property (nonatomic) HYPImpeccableZepAPIManager *manager;

@end

@implementation HYPImpeccableZepPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imagePickerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];

    self.imagePickerTableView.delegate = self;
    self.imagePickerTableView.dataSource = self;
    [self.view addSubview:self.imagePickerTableView];

    [self.imagePickerTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imagePickerTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.imagePickerTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.imagePickerTableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.imagePickerTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    
    self.manager = [[HYPImpeccableZepAPIManager alloc] init];
    [self.manager getWithURL:nil withSize:[[[UIApplication sharedApplication] keyWindow] frame].size Assets:^(NSArray<HYPImpeccableAsset *> *assets) {
        self.assets = assets;
        [self.imagePickerTableView reloadData];
    }];

    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assets count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    cell.textLabel.text = self.assets[indexPath.row].assetName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[NSURLSession sharedSession] dataTaskWithURL:self.assets[indexPath.row].assetURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate screenSelected:[UIImage imageWithData:data]];
        });
    }] resume];

}

@end
