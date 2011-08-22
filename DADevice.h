//
//  DADevice.m
//  iOS5_UDID
//
//  Created by David Schiefer on 20.08.11.
//  Copyright © 2011 WriteIt! Studios Limited. All rights reserved.
//  You may use this class in any project you like as long as you leave this header intact.

#import <Foundation/Foundation.h>

#define kShouldAlwaysGenerateCustomUDID 0

/*!
 @param Defines whether a custom UDID should always be returned or not. NO by default. This will alter -uniqueDeviceIdentifier's behavior.
*/

@interface UIDevice (UIDevice)

- (NSString *)uniqueDeviceIdentifier;

/*!
 @method uniqueDeviceIdentifier
 @abstract
 Returns a string that is unique to relevant device.
 @discussion
 Checks the host's iOS version and returns a custom UDID if iOS 5 is detected. If a version prior to iOS 5 is detected, the standard, Apple generated string is returned.
*/
 

@end
