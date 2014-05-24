//
//  Photo.h
//  Photos
//
//  Created by Ricardo Michel Reyes Martínez on 2/20/14.
//  Copyright (c) 2014 Online Studio Productions LLC. All rights reserved.
//

@import UIKit;
@import Foundation;

@interface Photo : NSObject

@property (strong) NSNumber *idNumber;
@property (strong) NSString *name;
@property (strong) NSString *summary;
@property (strong) NSURL *url;

+ (UIImage *)imageFromServer:(NSURL *)url;

- (instancetype)initWithName:(NSString *)name summary:(NSString *)summary url:(NSURL *)url andIDNumber:(NSNumber *)idNumber;

@end
