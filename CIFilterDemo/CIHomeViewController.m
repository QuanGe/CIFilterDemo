//
//  CIHomeViewController.m
//  CIFilterDemo
//
//  Created by zhangruquan on 15/5/10.
//  Copyright (c) 2015年 com.quange. All rights reserved.
//

#import "CIHomeViewController.h"
#import "Masonry.h"
#import "UIAlertView+Blocks.h"
#import "GPUImage.h"
@interface CIHomeViewController ()
@property (nonatomic) UIImageView * imageView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UIPopoverController *popover;
@property (nonatomic) UIImage *inputImage;
@end

@implementation CIHomeViewController

- (void)loadView
{
    [super loadView];
    
    UIView * customBarButtonBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    {
        UIButton * inputImageBtn = [[UIButton alloc] init];
        [inputImageBtn setTitle:@"获取图片" forState:UIControlStateNormal];
        [inputImageBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        inputImageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [customBarButtonBox addSubview:inputImageBtn];
        [inputImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo( 40);
            make.width.mas_equalTo(70);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-10);
        }];
        [inputImageBtn addTarget:self action:@selector(aletInputImage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customBarButtonBox];
        [self.navigationItem setRightBarButtonItem:rightBtn];
        
        
    }
    
    self.imageView = [[UIImageView alloc] init];
    {
        [self.view addSubview:self.imageView];
        self.imageView.layer.borderColor= [UIColor blackColor].CGColor;
        self.imageView.layer.borderWidth = 1;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIView *topView = (id)self.topLayoutGuide;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-100);
        }];
        
    }
    
    
    UIScrollView * effectBox = [[UIScrollView alloc] init];
    {
        [self.view addSubview:effectBox];
        [effectBox setContentSize:CGSizeMake(1300, 100)];
       
        [effectBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        for (int i = 0; i<13; i++) {
            UIButton * effectBtn = [[UIButton alloc] init];
            {
                [effectBox addSubview:effectBtn];
                effectBtn.tag = 100+i;
                //effectBtn.enabled = NO;
                [effectBtn setTitle:[NSString stringWithFormat: @"effect%@",@(i)] forState:UIControlStateNormal];
                [effectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [effectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(100*i);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(100);
                }];
                
            }
            
            [effectBtn addTarget:self action:@selector(addEffect:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)addEffect:(UIButton *)btn
{
    if(!self.inputImage)
    {
        [UIAlertView showWithTitle:@"提示" message:@"请先选取图片" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    NSArray * effectNames =  @[@"CIPhotoEffectChrome",
                               @"CIPhotoEffectInstant",
                               @"CIPhotoEffectMono",
                               @"CIPhotoEffectNoir",
                               @"CIPhotoEffectProcess",
                               @"CIPhotoEffectTonal",
                               @"CIPhotoEffectTransfer",
                               @"CIGaussianBlur",
                               @"CIColorCube",
                               @"CIColorControls",
                               @"GPUImageEmbossFilter",
                               @"GPUImagePixellateFilter",
                               @"GPUImageSmoothToonFilter"];
    NSString * filterName = effectNames[btn.tag-100];
    if([filterName isEqualToString:@"CIColorControls"])
    {
        GPUImageSketchFilter *stillImageFilter2 = [[GPUImageSketchFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:self.inputImage];
        [self.imageView setImage:quickFilteredImage];
    }
    else if([filterName isEqualToString:@"GPUImageEmbossFilter"])
    {
        GPUImageEmbossFilter *stillImageFilter2 = [[GPUImageEmbossFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:self.inputImage];
        [self.imageView setImage:quickFilteredImage];
    }
    else if([filterName isEqualToString:@"GPUImagePixellateFilter"])
    {
        GPUImagePixellateFilter *stillImageFilter2 = [[GPUImagePixellateFilter alloc] init];
        stillImageFilter2.fractionalWidthOfAPixel = 0.01;
        UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:self.inputImage];
        [self.imageView setImage:quickFilteredImage];
    }
    else if([filterName isEqualToString:@"GPUImageSmoothToonFilter"])
    {
        GPUImageSmoothToonFilter *stillImageFilter2 = [[GPUImageSmoothToonFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:self.inputImage];
        [self.imageView setImage:quickFilteredImage];
    }
    else
    {
        CIContext *context = [CIContext contextWithOptions: nil];
        
        

        CIFilter * filter = [CIFilter filterWithName:filterName];
        [filter setDefaults];
        [filter setValue:[CIImage imageWithCGImage:self.inputImage.CGImage] forKey:kCIInputImageKey];
        // 得到过滤后的图片
        CIImage *outputImage = [filter outputImage];
        
        // 转换图片
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        // 显示图片
        [self.imageView setImage:newImg];
        
    }
    
}

- (void)aletInputImage
{
    self.imagePickerController =  [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    [UIAlertView showWithTitle:@"提示" message:@"请选择要从哪里获取取图片" cancelButtonTitle:@"取消" otherButtonTitles:@[@"相机",@"相册"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1:
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                }else{
                    NSLog(@"模拟器无法打开相机");
                }
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
                break;
            case 2:
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.imagePickerController setAllowsEditing:NO];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    self.popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
                    self.popover.delegate = self;
                    
                    [self.popover presentPopoverFromRect:CGRectMake(384, 600, 30, 30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                }
                else
                    [self presentViewController:self.imagePickerController animated:YES completion:nil];
                break;
            default:
                break;
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"美图相机";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --相机
- (UIImage *)scaleToSize:(UIImage *)img size:(float)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width*size,img.size.height*size));
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, img.size.width*size, img.size.height*size)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    if(image)
    {
        float scaleSize = 1.0;
        if(image.size.height>1920)
            scaleSize = 1920.0/image.size.height;
        if(image.size.width>1920)
            scaleSize = scaleSize * (1920.0/image.size.width);
        
        image = [self scaleToSize:image size:scaleSize];
        self.inputImage = image;
        self.imageView.image = image;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self.popover dismissPopoverAnimated:YES];
        else
            [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

@end
