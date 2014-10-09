//  GridMenu
//  ControllerInterface.h
//
//  Copyright (c) 2014 nikhil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ControllerInterface : NSObject

#warning Required Property
//To get all viewController's object to present as item or selected view.
@property (nonatomic,strong) NSArray *viewControllerArray;

//To set title of all item's present in menu screen.
@property (nonatomic,strong) NSArray *itemTitleArray;

#warning Optional Property
//Setting background image for menu screen background.
@property (nonatomic,retain) UIImage *menuBackgroundImage;

//Setting item title text color if nil then default black is set as color.
@property (nonatomic,weak) UIColor *itemTitleColor;

//Provide icon to be shown on menu item or else default screenshot of view of respective viewController would be shown as icon.
@property (nonatomic,strong) NSArray *itemIconArray;

//Property to indicate whether to render code in viewDidload or viewDidAppear method of respective viewController which is active.
@property (readonly) BOOL isMenuScreenActive;

//Method for returning singleton object
+ (id)sharedInterface;

//For changing flag which is used for all VC in order to render code or not in their respective viewDidload or viewDidAppear.
//Do not use this method.
- (void)setFlag:(BOOL)value;
@end
