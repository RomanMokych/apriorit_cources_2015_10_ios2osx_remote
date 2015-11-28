//
//  MyImage.m
//  client_ios
//
//  Created by Admin on 18.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "MyImage.h"

@implementation MyImage

@synthesize masImage=_masImage;
@synthesize size=_size;
@synthesize width=_width;
@synthesize height=_height;
@synthesize changeX=_changeX;
@synthesize changeY=_changeY;
@synthesize img=_img;

-(void)setMasImage:(unsigned char *)mas withRect:(int*)rect
{
    
    
    //long size = (rect[2]-rect[0])*(rect[3]-rect[1])*4;
    
    
    int LeftUpX = rect[0];
    int LeftUpY = rect[1];
    int RightDownX = rect[2];
    int RightDownY = rect[3] - 1;
    int i= (LeftUpX+(LeftUpY)*_width)*4;
    
    //long size = (rect[2]-rect[0])*(rect[3]-rect[1])*4;
    
    int k=0;
   
    while (i < (RightDownX + (RightDownY) * _width) *4 )
    {
        
        
        for (int j=i ; j < i+(rect[2]- rect[0])*4; j++)
        {
            _masImage[j]=mas[k];
            k++;
        }
        i += _width*4;
    }
    
    
    
    

    [self imageFromTexturePixels];
    
}


-(id)init
{
    _size=0;
    _width=0;
    _height=0;
    _changeX=0;
    _changeY=0;
    _masImage=(unsigned char*)malloc(_size);
    _img=NULL;
    return self;
}

-(id)initWithWidth:(int)widtn andHeigth:(int)height
{
    _width=widtn;
    _height=height;
    _size=widtn*height*4;
    _changeX=0;
    _changeY=0;
    _masImage=(unsigned char*)malloc(_size);
    _img=NULL;
    return self;
}

-(void) ConvertBetweenBGRAandRGBA:(unsigned char*)img withWidth:(int)width andHeight:(int)height
{
    unsigned char tmp;
    int offset=0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            tmp = img[offset];
            img[offset] = img[offset+2];
            img[offset+2]=tmp;
            offset += 4;
        }
    }
}

-(void) imageFromTexturePixels
{
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGDataProviderRef dataProviderRef;
    CGColorSpaceRef colorSpaceRef;
    CGImageRef imageRef;
    
    @try
    {
        GLubyte *rawImageDataBuffer = _masImage;
        
        dataProviderRef = CGDataProviderCreateWithData(NULL, rawImageDataBuffer, _size, nil);
        colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        imageRef = CGImageCreate(_width, _height, 8, 8 * 4, _width * 4, colorSpaceRef, bitmapInfo, dataProviderRef, NULL, NO, renderingIntent);
        _img= [[UIImage alloc] initWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
    }
    @finally
    {
        CGDataProviderRelease(dataProviderRef);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
    }
}

@end

