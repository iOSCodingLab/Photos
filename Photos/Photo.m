//
//  Photo.m
//  Photos
//
//  Created by Ricardo Michel Reyes Martínez on 2/20/14.
//  Copyright (c) 2014 Online Studio Productions LLC. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithName:(NSString *)name summary:(NSString *)summary url:(NSURL *)url andIDNumber:(NSNumber *)idNumber
{
    self = [super init];
    
    if (self)
    {
        self.name = name;
        self.summary = summary;
        self.url = url;
        self.idNumber = idNumber;
    }
    
    return self;
}


- (UIImage *)imageFromServer
{
    NSLog(@"Download started");
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:self.url];
    
    NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    NSLog(@"Image: %@", image);
    
    return image;
}

@end