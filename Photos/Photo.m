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
    NSData *data = [NSData dataWithContentsOfURL:self.url];
    
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

@end