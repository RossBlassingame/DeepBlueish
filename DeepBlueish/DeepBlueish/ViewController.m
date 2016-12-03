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
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //Set image
    self.photo.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)importImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
@end
