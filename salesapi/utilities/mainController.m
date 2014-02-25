//
//  mainController.m
//  dssapi
//
//  Created by Raja T S Sekhar on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "mainController.h"

enum {
    kView_First = 1,
    kView_Second,
    kView_Third
};

@implementation mainController

@synthesize tab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withReLoginMethod:(METHODCALLBACK) p_reLoginMethod
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _reLoginMethod = p_reLoginMethod;
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //self.view = self.tab.view;
    //CGRect tabViewFrame = self.view.frame;
    //NSLog(@"tabview frame x %f and y %f and width %f and height %f", tabViewFrame.origin.x, tabViewFrame.origin.y, tabViewFrame.size.width, tabViewFrame.size.height);
    [self.view addSubview:self.tab.view];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    // Tell our subview.
    /*if( currentViewController != nil ) {
     [currentViewController viewWillAppear:animated];
     }*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //int selItem = tabbar.selectedItem.tag;
    /*NSArray *viewCtlrs = [tab viewControllers];
    UIViewController *vctrl = (UIViewController*) [viewCtlrs objectAtIndex:tabSelected];
    return [vctrl shouldAutorotateToInterfaceOrientation:interfaceOrientation];*/
    return YES;
}

- (BOOL) shouldAutorotate
{
    return YES;
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //int selItem = tabbar.selectedItem.tag;
    NSArray *viewCtlrs = [tab viewControllers];
    //if (reLogin) [reLogin setForOrientation:toInterfaceOrientation];
    //if ([loginView viewWithTag:10001]!=nil) [reLogin setForOrientation:toInterfaceOrientation];
    UIViewController *vctrl = (UIViewController*) [viewCtlrs objectAtIndex:tabSelected];
    return [vctrl willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //NSLog(@"item %@ clicked ", item.title);
    tabSelected = item.tag;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UITabBar *tbar = tabBarController.tabBar;
    NSString *selitem = [tbar selectedItem].title;
    tabSelected = [tbar selectedItem].tag;
    [viewController willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0];
    if ([selitem isEqualToString:@"Sign Out"]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(logOutApplication:) userInfo:nil repeats:NO];
    }
}

-(void) logOutApplication:(NSTimer *)timer
{
    NSArray *viewCtrlrs = tab.viewControllers;
    for (UIViewController *vctrl in viewCtrlrs) {
        @try {
            //[vctrl viewDidUnload];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
    //[self viewDidUnload];
    // [self.navigationController popViewControllerAnimated:YES];
    _reLoginMethod(nil);
}

@end
