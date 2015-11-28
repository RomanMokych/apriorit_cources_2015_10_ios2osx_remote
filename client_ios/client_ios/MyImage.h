//
//  MyImage.h
//  client_ios
//
//  Created by Admin on 18.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyImage : NSObject

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) unsigned char* masImage;
@property long size;
@property int width, height;
@property int changeX, changeY;
@property UIImage *img;

-(void)setMasImage:(unsigned char *)mas withRect:(int*)rect;
-(id)init;
-(id)initWithWidth:(int)widtn andHeigth:(int)heigth;
-(void) imageFromTexturePixels;
-(void) ConvertBetweenBGRAandRGBA:(unsigned char*)img withWidth:(int)width andHeight:(int)height;



@end
