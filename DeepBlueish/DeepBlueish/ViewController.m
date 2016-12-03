//
//  ViewController.m
//  DeepBlueish
//
//  Created by Michael Tang on 12/3/16.
//  Copyright © 2016 Michael Tang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)takePhoto:(id)sender;
- (IBAction)importImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *photo;


@end

@implementation ViewController
int redAvgg = 0;
int greenAvgg = 0;
int blueAvgg = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //Set image
    self.photo.image = chosenImage;
    UIColor *avg = [self getAverageColor];
    if([self detectBoard:avg]){
        [self drawBoard];
        self.photo.image = [UIImage imageNamed:@"white.png"];
    }else{
        [[self.view viewWithTag:1] removeFromSuperview];
        [[self.view viewWithTag:2] removeFromSuperview];
        [[self.view viewWithTag:3] removeFromSuperview];
        [[self.view viewWithTag:4] removeFromSuperview];
        
        NSLog(@"No board");
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIColor*) getAverageColor{
    
    int height = (int)(self.photo.image.size.height)-10; //offset pixel
    int width = (int)(self.photo.image.size.width)-10; //offset pixel
    
    //Analyze four corners of an image to obtain the average white-background colour
    UIColor* lc = [self getPixel:self.photo.image xCoordinate:0 yCoordinate:0];
    UIColor* rc = [self getPixel:self.photo.image xCoordinate:width yCoordinate:0];
    UIColor* lcb = [self getPixel:self.photo.image xCoordinate:0 yCoordinate:height];
    UIColor* rcb = [self getPixel:self.photo.image xCoordinate:width yCoordinate:height];
    
    //Annoying cast to CGFloats
    const CGFloat *lcSet = CGColorGetComponents(lc.CGColor);
    const CGFloat *rcSet = CGColorGetComponents(rc.CGColor);
    const CGFloat *lcbSet = CGColorGetComponents(lcb.CGColor);
    const CGFloat *rcbSet = CGColorGetComponents(rcb.CGColor);
    
    //Debug
    NSLog(@"red: %f green:%f blue:%f",lcSet[0],lcSet[1],lcSet[2]);
    NSLog(@"red: %f green:%f blue:%f",rcSet[0],rcSet[1],rcSet[2]);
    NSLog(@"red: %f green:%f blue:%f",lcbSet[0],lcbSet[1],lcbSet[2]);
    NSLog(@"red: %f green:%f blue:%f",rcbSet[0],rcbSet[1],rcbSet[2]);
    
    int redAvg = (int)(lcSet[0]+rcSet[0]+lcbSet[0]+rcbSet[0])/4;
    int greenAvg = (int)(lcSet[1]+rcSet[1]+lcbSet[1]+rcbSet[1])/4;
    int blueAvg = (int)(lcSet[2]+rcSet[2]+lcbSet[2]+rcbSet[2])/4;
    
    NSLog(@"Average color:(%d,%d,%d)",redAvg,greenAvg,blueAvg);
    UIColor *avg = [[UIColor alloc] initWithRed:redAvg green:greenAvg blue:blueAvg alpha:255];
    return avg;
}

- (BOOL) detectBoard:(UIColor*)avg{
    CGFloat red = 0.0, green=0.0, blue=0.0, alpha=0.0;
    CGFloat lred = 0.0, lgreen=0.0, lblue=0.0, lalpha=0.0;
    [avg getRed:&red green:&green blue:&blue alpha:&alpha];
    NSLog(@"Average color from detect:(%d,%d,%d)",(int)red,(int)green,(int)blue);
    
    redAvgg = (int)red;
    greenAvgg = (int)green;
    blueAvgg = (int)blue;
    
    int width = (int)[UIScreen mainScreen].bounds.size.width;
    UIColor*test = [self getPixel:self.photo.image xCoordinate:self.photo.image.size.width/3 yCoordinate:self.photo.frame.origin.y];
    [test getRed:&lred green:&lgreen blue:&lblue alpha:&lalpha];
   
    NSLog(@"Line:(%d,%d,%d)",(int)lred,(int)lgreen,(int)lblue);
    UIView *lineth = [[UIView alloc] initWithFrame: CGRectMake(width/3, self.photo.frame.origin.y, 10, 10)];
    lineth.backgroundColor = [UIColor blueColor];
    [self.view addSubview:lineth];
    
    if(((int)red - (int)lred > 80) && ((int)green - (int)lgreen > 80) && ((int)blue - (int)lblue > 80)){
        return true;
    }
    
    return false;
}

- (void)drawBoard{
    int xOrigin = self.photo.frame.origin.x;
    int yOrigin = self.photo.frame.origin.y;
    int width = (int)[UIScreen mainScreen].bounds.size.width;
    
    int lhx = width/3;
    int rhx = 2*lhx;
    
    int thy = width/3;
    int lhy = thy*2;
    
    UIView *linelh = [[UIView alloc] initWithFrame: CGRectMake(lhx, yOrigin, 5, width)];
    linelh.tag = 1;
    linelh.backgroundColor = [UIColor blackColor];
    [self.view addSubview:linelh];
    
    UIView *linerh = [[UIView alloc] initWithFrame: CGRectMake(rhx, yOrigin, 5, width)];
    linerh.tag = 2;
    linerh.backgroundColor = [UIColor blackColor];
    [self.view addSubview:linerh];
    
    UIView *lineth = [[UIView alloc] initWithFrame: CGRectMake(xOrigin, yOrigin+ thy, width, 5)];
    lineth.tag = 3;
    lineth.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineth];
    
    UIView *linebh = [[UIView alloc] initWithFrame: CGRectMake(xOrigin, yOrigin+lhy, width, 5)];
    linebh.tag = 4;
    linebh.backgroundColor = [UIColor blackColor];
    [self.view addSubview:linebh];
}


- (IBAction)importImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (UIColor*)getPixel:(UIImage *)image xCoordinate:(int)x yCoordinate:(int)y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    int red = data[pixelInfo];         // If you need this info, enable it
    int green = data[(pixelInfo + 1)]; // If you need this info, enable it
    int blue = data[pixelInfo + 2];    // If you need this info, enable it
    
    CFRelease(pixelData);
    
    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    UIColor *color = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:255];
    return color;
}

-(BOOL) charExistAt: (int)xCoor y:(int)yCoor{
    UIColor *center = [self getPixel:self.photo.image xCoordinate:xCoor yCoordinate:yCoor];
    CGFloat red = 0.0, green=0.0, blue=0.0, alpha=0.0;
    [center getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return true;
}
@end
