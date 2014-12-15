//
//  AppDelegate.m
//  Space Jam
//
//  Created by Danny on 12/2/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "DataStore.h" //holds list of preloaded sounds
#import "Sound.h"
NSString * const kBUILDING_DATA = @"sounds";

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)loadData{
    NSDictionary *jsonDictionary;
    NSString *path = [[NSBundle mainBundle] pathForResource:kBUILDING_DATA ofType:@"json"];
    NSError *error;
    NSData *jsonData =[NSData dataWithContentsOfFile:path options: NSDataReadingUncached error: &error];
    
    if(error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading JSON file" message:[error description] delegate:self cancelButtonTitle:nil otherButtonTitles:@":-(", nil];
        
        [alert show];
    }else{
        jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error parsing JSON file" message:[error description] delegate:self cancelButtonTitle:nil otherButtonTitles:@":-(", nil];
            
            [alert show];
        }else{
            //Must set Mutable Array to a mutable array type of object
            NSMutableArray *soundData = [jsonDictionary[@"response"][@"docs"] mutableCopy];
            
            // sort mutable array alphabetically
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = @[sortDescriptor];
            [soundData sortUsingDescriptors:sortDescriptors];
            
            //create an new array full of RIT Buildings to be used
            NSMutableArray *allBuildings = [[NSMutableArray alloc] init];
            
            /* Loading RITBuildings into DatasStore */
            for(NSDictionary *dictionary in soundData){
                //create RITBuilding
                Sound *building = [[Sound alloc] initWithDictionary:dictionary];
                //add building to allBuildings
                [allBuildings addObject:building];
            }
            //fill datastore's allItems array
            [DataStore sharedStore].allItems = allBuildings;
        }
    }

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
