//
//  iTunesLibrary.m
//  iTunesMatchHelper
//
//  Created by Nathan Villaescusa on 9/8/12.
//
//

#import "iTunesLibrary.h"
#import "iTunes.h"

@implementation iTunesLibrary

+ (iTunesLibraryPlaylist *)primaryPlaylist {
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    SBElementArray *sources = [iTunes sources];
    iTunesSource *libsource;
    
    for (iTunesSource *source in sources) {
        if ([source kind] == 'kLib') {
            NSLog(@"Found library");
            libsource = source;
            break;
        }
    }
    
    SBElementArray *libPlaylists = [libsource libraryPlaylists];
    
    return libPlaylists[0];
}

+ (NSNumber *)fileTrackId:(iTunesFileTrack *)track {
    if (!([[track kind] isEqualToString:@"Matched AAC audio file"])) {
        return nil;
    }
    
    NSData *file = [NSData dataWithContentsOfURL:[track location]];
    if (file == nil) {
        NSLog(@"Could not read file.");
        return nil;
        
    }

    NSRange range = [file rangeOfData:[@"song" dataUsingEncoding:NSUTF8StringEncoding] options:0 range:NSMakeRange(0, 700)];
    if (range.location == NSNotFound) {
        NSLog(@"SONG ID NOT FOUND!!!");
        return nil;
    }
    
    NSData *iTunesIDData = [file subdataWithRange:NSMakeRange(range.location+4, 4)];
    int value = CFSwapInt32BigToHost(*(int*)([iTunesIDData bytes]));
    
    return @(value);
}

@end
