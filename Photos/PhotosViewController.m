//
//  PhotosViewController.m
//  Photos
//
//  Created by Ricardo Michel Reyes Martínez on 2/20/14.
//  Copyright (c) 2014 Online Studio Productions LLC. All rights reserved.
//

@import Dispatch;

#import "PhotosViewController.h"
#import "PhotosCell.h"
#import "Photo.h"

@interface PhotosViewController ()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *plist;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) dispatch_queue_t queue;

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

- (dispatch_queue_t)queue
{
    if (!_queue)
    {
        _queue = dispatch_queue_create("queue", 0);
    }
    return _queue;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.plist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        Photo *photo = [[Photo alloc] initWithName:[NSString stringWithFormat:@"FOTO %d", idx + 1] summary:nil url:[NSURL URLWithString:obj] andIDNumber:[NSNumber numberWithUnsignedInteger:idx]];
        dispatch_async(self.queue, ^
        {
            UIImage *image = [photo imageFromServer];
            
            NSLog(@"Image %@", image);
            
            if (image)
            {
                [self.photos addObject:image];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.collectionView reloadData];
            });
        });
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosCell" forIndexPath:indexPath];
    cell.imageView.image = self.photos[indexPath.item];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
