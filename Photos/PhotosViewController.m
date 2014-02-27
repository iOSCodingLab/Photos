//
//  PhotosViewController.m
//  Photos
//
//  Created by Ricardo Michel Reyes Martínez on 2/20/14.
//  Copyright (c) 2014 Online Studio Productions LLC. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotosCell.h"
#import "Photo.h"

@interface PhotosViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *plist;
@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation PhotosViewController

//Lazy instantiation

- (NSArray *)plist
{
    if (!_plist)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
        
        _plist = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    return _plist;
}

- (NSMutableArray *)photos
{
    if (!_photos)
    {
        _photos = [NSMutableArray new];
    }
    
    return _photos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.plist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        Photo *photo = [[Photo alloc] initWithName:[NSString stringWithFormat:@"FOTO %d", idx + 1] summary:nil url:[NSURL URLWithString:obj] andIDNumber:[NSNumber numberWithUnsignedInteger:idx]];
        UIImage *image = [photo imageFromServer];
        
        if (image)
        {
            [self.photos addObject:image];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
