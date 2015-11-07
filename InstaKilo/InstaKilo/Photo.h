//
//  Photo.h
//  InstaKilo
//
//  Created by Benson Huynh on 2015-11-04.
//  Copyright © 2015 Benson Huynh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Photo : NSObject


@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *subject;



-(instancetype)initWithImage: (UIImage *) image location: (NSString *) location subject: (NSString *)subject;

@end
