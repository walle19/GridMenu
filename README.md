Introduction
========

This Library is for iOS developers(iPhone only for now) to have a ready and easy to use Grid Menu which allow user to jump to differen view back and forth.

GridMenu is combination of ControllerInterface and MainViewController class.

ControllerInterface is a interface for communication and passing data from appDelegate to the mainViewController.

Developer need to just pass array of all six different view controller's which he/she is wants on menu screen as menu items.

Menu screen or Main screen consist of six customizable menu item which in turn represent different view controller's view.

Featue of menu screen :-
  
  -> Could set background image or color.
  -> A property to let developer know if menu screen is active or not.
  
Feature of menu item :-

  -> Could set icon image or default image (screenshot of particular view controller as per index) would be set.
  -> Could set menu item's title along with title's text color.
  
The jump in and out are taken care by storing currentIndex. So when a user tap on a menu item then view controller in array related to that particular index will be present.


Example
=======

Developer need to assign MainViewController to it's rootViewController class(UIViewController).
Usage is simply and as follow :-

In AppDelegate.m class

   
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *_viewVC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"viewCon"];
    
    //.... similarly you need to instantiate all your other five view controller's
    
    //Adding all object's of view controller
    self.viewConArray = [[NSArray alloc] initWithObjects:_viewVC,_firstVC,_secVC,_thirdVC,_fourthVC,_fiveVC, nil];
    
    //Adding title's for all six menu item with respect to your view controller's usage
    self.titleArray = [[NSArray alloc] initWithObjects:@"Login",@"Profile",@"Friend",@"Setting",@"view5",@"View6", nil];
    
    //Providing title text color for menu item.
    self.color = [UIColor whiteColor];
    
    //Similarly you could create a array of icon with respect to your viewController and pass to itemIconArray in interface object.
    
    //Interface between your appDelegate and MainViewCon for passing values.
    ControllerInterface *interfaceObj = [ControllerInterface sharedInterface];
    interfaceObj.viewControllerArray = self.viewConArray;
    interfaceObj.itemTitleColor = [UIColor whiteColor];      //if not set then default black is taken.
    interfaceObj.itemTitleArray = self.titleArray;
    
    //Note:-
    //if no item icon array is provided then default screenshot of view controller's is taken.
    //if no item title array is provided then no title would be shown.
    
    //Also a warning would be shown as a remainder to indicate which property are required or optional.
    
    return YES;
}

Now after passing all values then rest is taken care by main view controller. As per feature,

  -> on SINGLE-TAP on a menu item particular view controller(as per index of array) will be presented and control will be sent to it's viewDidLoad.
  
  -> on PINCH-IN (only) you would return back to menu screen.
  
Also, just to avoid rendering of code in your viewDidLoad, viewDidAppear, etc of your view controller's, I have provided a boolean property.

  -> isMenuScreenActive - if true then indicate that menu screen is present else selected view controller will be present
  
You could use it in your view controller's as below :-

- (void)viewDidLoad {
    [super viewDidLoad];

    ControllerInterface *obj = [ControllerInterface sharedInterface];
    if(obj.isMenuScreenActive)
        NSLog(@"Menu present");       //not to render any code
    else
        NSLog(@"Menu not present");    //render your code
}

Coming Feature
==============

  -> When a view controller is present then SWIPE(left/right) to move to next view controller without pinch in to return back to menu screen.
  
  -> Making menu screen dynamic for minimum FOUR item to maximum SIX items

Note
====
Right now, menu item need's to be six else layout won't be good in look 'n' feel.

Currently supports iOS 7 and 8.

For iOS devices, only iPhone 5/5s/6/6 plus

### Author

[Nikhil Wali](https://github.com/walle19)

### License

Copyright © 2017, [Nikhil Wali](https://github.com/walle19).
