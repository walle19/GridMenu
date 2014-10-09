//  GridMenu
//  MainViewController.m
//
//  Copyright (c) 2014 nikhil. All rights reserved.
//

#import "MainViewController.h"
#import "ControllerInterface.h"

#define SLIDING_SIZE_VALUE 10
#define SLIDING_LEFT_VALUE 200
#define SLIDING_RIGTH_VALUE 200

#define ADDING_ANIMATION_DURATION 1.5f
#define PINCH_ANIMATION_DURATION 2.0f
#define TAP_ANIMATION_DURATION 1.2f
#define BUTTON_REMOVAL_DURATION 0.7f
#define VC_REMOVAL_DURATION 1.0f

//For iPhone 5 and 5S device
#define MENU_ITEM_WIDTH 80
#define MENU_ITEM_HEIGTH 100

#define X 30
#define Y 40

#define PADDING_X 80
#define PADDING_Y 50

@interface MainViewController ()
{
    //Gesture's
    UIPinchGestureRecognizer *pinch;
    
    //Frame for animation
    CGRect originalFrame;
    
    //Check for pan gesture is performed or not
    BOOL isPinchEnabled;
    BOOL isTapEnabled;

    //Current VC that is shown on self main VC
    NSInteger currentVCIndex;

    //Menu Item represented by button with image in background.
    UIButton *itemBtn;
    
    //For setting frame as per device usage.
    CGRect _frame;
    CGFloat _paddingX;
    CGFloat _paddingY;
}
@property (nonatomic,strong) ControllerInterface *interfaceObj;

//To get all viewController's object to present as item or selected view.
@property (nonatomic,strong) NSArray *viewControllerArray;

//Containing title's for all menu item in menu screen.
@property (nonatomic,strong) NSArray *itemTitleArray;

//Setting background image for menu screen background.
@property (nonatomic,retain) UIImage *menuBackgroundImage;

//Set text color of title's of menu item.
@property (nonatomic,weak) UIColor *itemTitleColor;

//Provide icon to be shown on menu item or else default screenshot of view of respective viewController would be shown as icon.
@property (nonatomic,strong) NSArray *itemIconArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initiateArrays];

    [self initialiseFrameForItems];
    
    //Initiate currentVC with default value.
    currentVCIndex = -1;
    
    //Original initiated
    originalFrame = self.view.frame;
    
    //Pinch Gesture to go from current selected View to menu item View.
    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinch];
    
    [self setupBackgroundImage];

    //Adding all viewController's view into mainView along with tap gesture for selection detection.
    [self addMenuItems];
}

- (void)initiateArrays {
    self.interfaceObj = [ControllerInterface sharedInterface];
    
    self.viewControllerArray = self.interfaceObj.viewControllerArray;
    self.itemTitleArray = self.interfaceObj.itemTitleArray;
    self.itemTitleColor = self.interfaceObj.itemTitleColor?self.interfaceObj.itemTitleColor:[UIColor blackColor];
    self.itemIconArray = self.interfaceObj.itemIconArray;
    
    [self.interfaceObj setFlag:false];
}

//Setting frame depending upon IPhone type(5/5S/6/6Plus)
- (void)initialiseFrameForItems {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (screenRect.size.width == 414) {     //6 plus
        [self logWithString:@"6 plus"];
        _frame = CGRectMake(X+20, Y+20, MENU_ITEM_WIDTH+35, MENU_ITEM_HEIGTH+40);
        _paddingX = PADDING_X+20;
        _paddingY = PADDING_Y+20;
        
    } else if (screenRect.size.width == 375) {  //6
        [self logWithString:@"6"];

        _frame = CGRectMake(X+10, Y+10, MENU_ITEM_WIDTH+20, MENU_ITEM_HEIGTH+30);
        _paddingX = PADDING_X+10;
        _paddingY = PADDING_Y+10;
        
    } else if (screenRect.size.width == 320) {  // 5 or 5S
        [self logWithString:@"5/5S"];

        _frame = CGRectMake(X+10, Y, MENU_ITEM_WIDTH, MENU_ITEM_HEIGTH);
        _paddingX = PADDING_X;
        _paddingY = PADDING_Y;
        
    }
}

#pragma mark - Screenshot Method
//To take screenshot of all viewController's and return a image for button background.
-(UIImage *) screenshotWithView:(UIView *)view {
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Log Utility
- (void)logWithString:(NSString *)str {
    NSLog(@"%@",str);
}

#pragma mark - Menu Screen Method
- (void)setupBackgroundImage {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
#warning Uncomment below line of codes.
    if(self.menuBackgroundImage) {
        backgroundImageView.image = self.menuBackgroundImage;
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
    }
}

- (void)addMenuItems {
    isPinchEnabled = false;
    
    CATransition *animationLeft = [CATransition animation];
    [animationLeft setDuration:1.2];
    [animationLeft setType:kCATransitionMoveIn];
    [animationLeft setSubtype:kCATransitionFromLeft];
    [animationLeft setSpeed:3.0];
    
    CATransition *animationRight = [CATransition animation];
    [animationRight setDuration:1.2];
    [animationRight setType:kCATransitionMoveIn];
    [animationRight setSubtype:kCATransitionFromRight];
    [animationRight setSpeed:3.0];
    
    CAAnimation *animation ;
    
    for(int i=0; i< self.viewControllerArray.count; i++) {
        
        int tagValue = i+1;
        
        if ((tagValue == 1) | (tagValue == 3)| (tagValue == 5)){
            animationLeft.duration = animationLeft.duration + 1.5;
            animation = animationLeft;
        }else{
            animationRight.duration = animationRight.duration + 1.5;
            animation = animationRight;
        }
        if(currentVCIndex != i) {
            UIButton *button = [self createMenuItemWithTag:i andAnimation:animation];
            [self.view addSubview:button];
            if(isPinchEnabled)
                [self.view sendSubviewToBack:button];
        }
    }
}

#pragma mark - Create Menu Item Method
//This method is to create and return a button which would be added to self(parent) view  as a menu item.
//Also button would be having screenshot of specific viewCon object as background image.
//Moreover, animation is added to button layer which would resemble to sliding animation half from right and other half from left.
- (UIButton *)createMenuItemWithTag:(NSInteger)tag andAnimation:(CAAnimation *)animation {
    if(tag != currentVCIndex) {
        itemBtn = [[UIButton alloc] initWithFrame:[self frameForViewWithTag:tag+1]];
        [itemBtn.layer addAnimation:animation forKey:kCATransition];
    }
    else
        itemBtn = [[UIButton alloc] init];
    [itemBtn setBackgroundImage:[self getIconForItemWithTag:tag] forState:UIControlStateNormal];

    if(self.itemTitleArray.count>0 && self.itemTitleArray.count == 6){
        UIColor *titleColor = self.itemTitleColor;
        [itemBtn setTitle:[self.itemTitleArray objectAtIndex:tag] forState:UIControlStateNormal];
        [itemBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [itemBtn setTintColor:[UIColor redColor]];
    }
    
    [itemBtn addTarget:self action:@selector(tapDetected:) forControlEvents:UIControlEventTouchUpInside];
    itemBtn.tag = tag+1;
    return itemBtn;
}

//Return the blur image for itemButton background
- (UIImage *)getIconForItemWithTag:(NSInteger)index {
   UIImageView *imageView = [[UIImageView alloc] init];

    //If images are provided for menu item then that would be set as icon.
    if(self.itemIconArray.count>0 && self.itemIconArray.count == 6)
        imageView = [[UIImageView alloc] initWithImage:[self.itemIconArray objectAtIndex:index]];
    //Else default screenshot of respective viewcontroller would be shown as icon.
    else
        imageView = [[UIImageView alloc] initWithImage:[self blur:[self screenshotWithView:[[self.viewControllerArray objectAtIndex:index] view]]]];
    return imageView.image;
}

//Below method is to return frame's for the menu item grid as per tag passed to it as argument.
- (CGRect)frameForViewWithTag:(NSInteger)tag {
    CGRect frame = CGRectZero;
    
    switch (tag) {
        case 1:
            frame = CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);
            break;
        case 2:
            frame = CGRectMake(_frame.origin.x + _frame.size.width + _paddingX, _frame.origin.y, _frame.size.width, _frame.size.height);
            break;
        case 3:
            frame = CGRectMake(_frame.origin.x, _frame.origin.y + _frame.size.height + _paddingY, _frame.size.width, _frame.size.height);
            break;
        case 4:
            frame = CGRectMake(_frame.origin.x + _frame.size.width + _paddingX, _frame.origin.y + _frame.size.height + _paddingY, _frame.size.width, _frame.size.height);
            break;
        case 5:
            frame = CGRectMake(_frame.origin.x, _frame.origin.y + 2 * (_frame.size.height + _paddingY), _frame.size.width, _frame.size.height);
            break;
        case 6:
            frame = CGRectMake(_frame.origin.x + _frame.size.width + _paddingX, _frame.origin.y + 2 * (_frame.size.height + _paddingY), _frame.size.width, _frame.size.height);
            break;
        default:
            break;
    }
    return frame;
}

#pragma mark - Blur Image Method
//Return blur image for item background.
- (UIImage*) blur:(UIImage*)theImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:2.5f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return returnImage;
}

#pragma mark - Pinch detect method
//Gesture to return back to menu screen with all items along with animation.
- (void)pinchDetected:(UIPinchGestureRecognizer *)gesture {
    [self.interfaceObj setFlag:false];
    
    if(isPinchEnabled && gesture.velocity < 0) {
        isPinchEnabled = false;
        [UIView animateKeyframesWithDuration:PINCH_ANIMATION_DURATION delay:0.1 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            [self removecurrentVC];

        } completion:^(BOOL finished){
            [self addMenuItems];
            isTapEnabled= true;
        }];
    }
}

#pragma mark - Tap detect method
//Gesture for selecting a menu item from mainVC
- (void)tapDetected:(UIButton *)button {
    isTapEnabled = false;
    UIButton *btn = (UIButton *)[button viewWithTag:[button tag]];

    [UIView animateWithDuration:TAP_ANIMATION_DURATION delay:0.1 options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            currentVCIndex = [button tag]-1;
            
            for(UIButton *btnRemove in self.view.subviews){
                if(btnRemove.tag != btn.tag && [btnRemove isKindOfClass:[UIButton class]]){
                    [self removeMenuItemsWithButton:btnRemove];
                }
            }
            [btn setFrame:originalFrame];

    } completion:^(BOOL finished){

        //Removing all the buttonItems from parentView(self).
        for (UIView *btnView in self.view.subviews) {
            if([btnView isKindOfClass:[UIButton class]])  //Condition for button removal and to avoid backgroundImage removal.
                [btnView removeFromSuperview];
        }
        
        //Removing the last menuItem presented from the parentView(self).
        [[[self childViewControllers] lastObject] removeFromParentViewController];
        
        //Adding the selected VC into the parentView(self) and setting it's frame to parent frame.
        [self addChildViewController:[self.viewControllerArray objectAtIndex:[button tag]-1]];
        [self.view addSubview:[[self.viewControllerArray objectAtIndex:[button tag]-1] view]];
        
        [[[self.viewControllerArray objectAtIndex:[button tag]-1] view] setFrame:originalFrame];
        [self.interfaceObj setFlag:true];
        [[self.viewControllerArray objectAtIndex:[button tag]-1] viewDidLoad];
        isPinchEnabled = true;
    }];
}

#pragma mark - Remove current VC
//Method to remove the view of current VC and replace it with a itemBtn.
//itemBtn is set to original frame and aniamted to it's respective item frame with help of currentVC index
- (void)removecurrentVC {
    itemBtn = [self createMenuItemWithTag:currentVCIndex andAnimation:nil];
    [self.view addSubview:itemBtn];
    [UIView animateWithDuration:VC_REMOVAL_DURATION animations:^{
        [[[self.viewControllerArray objectAtIndex:currentVCIndex] view] removeFromSuperview];

        [itemBtn setFrame:originalFrame];
        [self.view bringSubviewToFront:itemBtn];
        [itemBtn setFrame:[self frameForViewWithTag:currentVCIndex+1]];
        [self.view bringSubviewToFront:itemBtn];

    }];
}

#pragma mark - Remove UnSelected Menu Item
// Remove rest of unselected items with animation.
- (void)removeMenuItemsWithButton:(UIButton *)btn {
    [UIView animateWithDuration:BUTTON_REMOVAL_DURATION animations:^{
        CGRect slideFrame = btn.frame;
        slideFrame.size.width = slideFrame.size.height = SLIDING_SIZE_VALUE;
        
        if (slideFrame.origin.x < self.view.frame.size.width/2) {
            slideFrame.origin.x = slideFrame.origin.x-SLIDING_LEFT_VALUE;
        }
        else{
            slideFrame.origin.x = slideFrame.origin.x+SLIDING_RIGTH_VALUE;
        }
        [btn setFrame:slideFrame];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
