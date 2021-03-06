//
//  ViewController.m
//  PushNotificationsApp
//
//  (c) Pushwoosh 2012


#import "ViewController.h"
#import "PushNotificationManager.h"

@implementation ViewController
@synthesize aliasField, favNumField, statusLabel;

- (void) startTracking {
	NSLog(@"Start tracking");
	PushNotificationManager * pushManager = [PushNotificationManager pushManager];
	[pushManager startLocationTracking];
}

- (void) stopTracking {
	NSLog(@"Stop tracking");
	PushNotificationManager * pushManager = [PushNotificationManager pushManager];
	[pushManager stopLocationTracking];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if (textField == aliasField) {
		[favNumField becomeFirstResponder];
	} else if (textField == favNumField) {
		[self submitAction:favNumField];
	}
	
	return YES;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	[self startTracking];
}

- (void) submitAction:(id)sender {
	NSLog(@"Submitting");
	[aliasField resignFirstResponder];
	[favNumField resignFirstResponder];
	
	NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys:
						  [aliasField text], @"Alias",
						  [NSNumber numberWithInt:[favNumField.text intValue]], @"FavNumber",
						  nil];
	
	[[PushNotificationManager pushManager] setTags:tags];
	statusLabel.text = @"Tags sent";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

//succesfully registered for push notifications
- (void) onDidRegisterForRemoteNotificationsWithDeviceToken:(NSString *)token {
	statusLabel.text = [NSString stringWithFormat:@"Registered with push token: %@", token];
}

//failed to register for push notifications
- (void) onDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	statusLabel.text = [NSString stringWithFormat:@"Failed to register: %@", [error description]];
}

//user pressed OK on the push notification
- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification {
	[PushNotificationManager clearNotificationCenter];
	
	statusLabel.text = [NSString stringWithFormat:@"Received push notification: %@", pushNotification];
}


- (void) dealloc {
	self.aliasField = nil;
	self.favNumField = nil;
	self.statusLabel = nil;

	[super dealloc];
}
@end
