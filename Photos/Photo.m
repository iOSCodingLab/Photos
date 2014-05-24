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


+ (UIImage *)imageFromServer:(NSURL *)url
{
    //Carpeta de library
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    //Carpeta de caches
    NSString *cachesPath = [libraryPath stringByAppendingPathComponent:@"Caches"];
    //Path de la imagen
    NSString *path = [cachesPath stringByAppendingPathComponent:[url lastPathComponent]];
    
    UIImage *image = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        image = [UIImage imageWithContentsOfFile:path];
    }
    else
    {
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        
        if (data)
        {
            [data writeToFile:path atomically:YES];
            image = [[UIImage alloc] initWithData:data];
        }

    }
    
    return image;
}

@end