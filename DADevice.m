#import "DADevice.h"
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

#define IFT_ETHER 0x6

@interface UIDevice (Private)

- (NSString *)convertToMD5:(NSString *)str;
- (NSString *)customUniqueDeviceIdentifier;
char*  getMacAddress(char* macAddress, char* ifName);

@end

@implementation UIDevice (DADevice)

char*  getMacAddress(char* macAddress, char* ifName) {
	
	int  success;
	struct ifaddrs * addrs;
	struct ifaddrs * cursor;
	const struct sockaddr_dl * dlAddr;
	const unsigned char* base;
	int i;
	
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != 0) {
			if ( (cursor->ifa_addr->sa_family == AF_LINK)
				&& (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp(ifName,  cursor->ifa_name)==0 ) {
				dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
				base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
				strcpy(macAddress, ""); 
				for (i = 0; i < dlAddr->sdl_alen; i++) {
					if (i != 0) {
						strcat(macAddress, ":");
					}
					char partialAddr[3];
					sprintf(partialAddr, "%02X", base[i]);
					strcat(macAddress, partialAddr);
					
				}
			}
			cursor = cursor->ifa_next;
		}
		
		freeifaddrs(addrs);
	}    
	return macAddress;
}

- (NSString *)customUniqueDeviceIdentifier
{
	char* macAddressString= (char*)malloc(18);
	NSString* macAddress= [[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0")
												   encoding:NSMacOSRomanStringEncoding];
	
	NSString*uniqueIdentifier = [self convertToMD5:macAddress];
	
	[macAddress release];
	
	return [uniqueIdentifier lowercaseString];
}

- (NSString *)uniqueDeviceIdentifier
{
		if (kShouldAlwaysGenerateCustomUDID == 0)
		{
			if ([[[UIDevice currentDevice] systemVersion] rangeOfString:@"5."].location != NSNotFound)
			{
				return [self customUniqueDeviceIdentifier];
			}
			
			return [self uniqueIdentifier]; //as it's a pre 5.0 device, we can use this
	        }

		return [self customUniqueDeviceIdentifier];
}

- (NSString *)convertToMD5:(NSString *)str 
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			]; 
}
	

@end
