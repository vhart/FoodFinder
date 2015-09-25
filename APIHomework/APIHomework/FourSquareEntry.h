//
//  FourSquareEntry.h
//  APIHomework
//
//  Created by Varindra Hart on 9/24/15.
//  Copyright © 2015 Varindra Hart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FourSquareEntry : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *lat;
@property (nonatomic) NSString *lng;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSArray *formattedAddress;
@property (nonatomic) NSString *menuUrl;

@end
