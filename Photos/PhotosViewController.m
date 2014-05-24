//
//  PhotosViewController.m
//  Photos
//
//  Created by Ricardo Michel Reyes Martínez on 2/20/14.
//  Copyright (c) 2014 Online Studio Productions LLC. All rights reserved.
//

@import Dispatch;
@import CoreImage;

#import "PhotosViewController.h"
#import "PhotosCell.h"
#import "Photo.h"

@interface PhotosViewController ()<UICollectionViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *plist;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) dispatch_queue_t queue;

@property (strong, nonatomic) NSString *path;

@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) CIFilter *filter;

@end

@implementation PhotosViewController

//Lazy instantiation


- (NSString *)path
{
    if (!_path)
    {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _path = [documentsPath stringByAppendingPathComponent:@"URLs.plist"];
    }
    return _path;
}

- (NSMutableArray *)plist
{
    if (!_plist)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.path])
        {
            _plist = [[NSMutableArray alloc] initWithContentsOfFile:self.path];
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
            
            _plist = [[NSMutableArray alloc] initWithContentsOfFile:path];
        }
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

- (CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}

- (CIFilter *)filter
{
    if (!_filter) _filter = [CIFilter filterWithName:@"CISepiaTone"];
    return _filter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", [CIFilter filterNamesInCategory:kCICategoryStillImage]);

    [self refreshData];
}

- (void)refreshData
{
    [self.photos removeAllObjects];
    
    [self.plist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [self photoWithString:obj andIndex:idx];
     }];
}

- (void)photoWithString:(NSString *)string andIndex:(NSUInteger)index
{
    Photo *photo = [[Photo alloc] initWithName:[NSString stringWithFormat:@"FOTO %lu", index + 1] summary:nil url:[NSURL URLWithString:string] andIDNumber:[NSNumber numberWithUnsignedInteger:index]];
    
    dispatch_async(self.queue, ^
                   {
                       CIImage *image = [CIImage imageWithCGImage:[[Photo imageFromServer:photo.url ] CGImage]];
                       
                       [self.filter setValue:@1.0f  forKey:kCIInputIntensityKey];
                       [self.filter setValue:image forKey:kCIInputImageKey];
                       
                       CIImage *output = [self.filter valueForKey:kCIOutputImageKey];
                       
                       CGImageRef render = [self.context createCGImage:output fromRect:[output extent]];
                       
                       UIImage *renderedOutput = [UIImage imageWithCGImage:render];
                       
                       CFRelease(render);
                       
                       NSLog(@"Image %@", renderedOutput);
                       
                       if (renderedOutput)
                       {
                           [self.photos addObject:renderedOutput];
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self.collectionView reloadData];
                                      });
                   });
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
- (IBAction)showAlert:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Image" message:@"You can add a new image here :)" delegate:self cancelButtonTitle:@"No, thanks." otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *text = textField.text;
        
        if ([NSURL URLWithString:text])
        {
            [self.plist addObject:text];
            [self.plist writeToFile:self.path atomically:YES];
            
            [self photoWithString:text andIndex:[self.plist count] - 1];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid URL" message:@"Please check you URL's format" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
