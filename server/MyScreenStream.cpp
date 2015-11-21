//
//  MyScreenStream.cpp
//  server
//
//  Created by Evgeniy on 09.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#include "MyScreenStream.hpp"
/*
uint64_t last_time = 0;

void (^handleStream)(CGDisplayStreamFrameStatus, uint64_t, IOSurfaceRef, CGDisplayStreamUpdateRef) =  ^(CGDisplayStreamFrameStatus status, uint64_t displayTime, IOSurfaceRef frameSurface, CGDisplayStreamUpdateRef updateRef)
{
    
    sem_t *sem = sem_open("/my_sem", O_CREAT, 0, 1);
    
    if(displayTime - last_time < 500000000)
        return;
    
    MySocket *my_sock = new MySocket();
    my_sock->Listening();
    my_sock->Conection();
    
    
    
    last_time = displayTime;
    
    printf("\tstatus: ");
    switch(status)
    {
        case kCGDisplayStreamFrameStatusFrameComplete:
            printf("Complete\n");
            break;
            
        case kCGDisplayStreamFrameStatusFrameIdle:
            printf("Idle\n");
            break;
            
        case kCGDisplayStreamFrameStatusFrameBlank:
            printf("Blank\n");
            break;
            
        case kCGDisplayStreamFrameStatusStopped:
            printf("Stopped\n");
            break;
    }
    
    printf("\ttime: %lld\n", displayTime);
    
    CGRect uRect;
    
    const CGRect * rects;
    
    size_t num_rects;
    
    
    CGDirectDisplayID displayID = CGMainDisplayID();
    CGRect mainMonitor = CGDisplayBounds(displayID);
    CGFloat displayHeight = CGRectGetHeight(mainMonitor);
    CGFloat displayWidth = CGRectGetWidth(mainMonitor);
    CGImageRef testImage;
    CGDataProviderRef provider;
    CFDataRef imageData;
    long dataLenght;
    unsigned char *data;
 
    while (true)
    {
    rects = CGDisplayStreamUpdateGetRects(updateRef, kCGDisplayStreamUpdateDirtyRects, &num_rects);
    
    printf("\trectangles: %zd\n", num_rects);
    
    uRect = *rects;
        
   
        for (size_t i = 0; i < num_rects; i++)
        {
            printf("\t\t(%f,%f),(%f,%f)\n\n",
               (rects+i)->origin.x,
               (rects+i)->origin.y,
               (rects+i)->origin.x + (rects+i)->size.width,
                   
               (rects+i)->origin.y + (rects+i)->size.height);
        
                uRect = CGRectUnion(uRect, *(rects+i));
   
        }
    
    
        printf("\t\tUnion: (%f,%f),(%f,%f)\n\n",
           uRect.origin.x,
           uRect.origin.y,
           uRect.origin.x + uRect.size.width,
           uRect.origin.y + uRect.size.height);
    
    
        testImage = CGDisplayCreateImageForRect (displayID, uRect);
  
    
        provider = CGImageGetDataProvider(testImage);
        imageData = CGDataProviderCopyData(provider);
    
        dataLenght = CFDataGetLength(imageData);
    
        data = new  unsigned char[dataLenght];
        
        CFDataGetBytes(imageData, CFRangeMake(0,dataLenght), data);
    
        int infoRect[4];
        infoRect[0]=uRect.origin.x;
        infoRect[1]=uRect.origin.y;
        infoRect[2]=uRect.origin.x + uRect.size.width;
        infoRect[3]=uRect.origin.y + uRect.size.height;
    
        my_sock->Send(data, dataLenght, infoRect);
        //delete[] data;
    
    
   // sleep(5000);
    }
    sem_post(sem);
    
};


MyScreenStream::MyScreenStream()
{
    q = dispatch_queue_create("herp.derp.mcgerp", NULL);
    
    display_id = CGMainDisplayID();
    
    mode = CGDisplayCopyDisplayMode(display_id);
    pixelWidth = CGDisplayModeGetPixelWidth(mode);
    pixelHeight = CGDisplayModeGetPixelHeight(mode);
    
    CGDisplayModeRelease(mode);
    
    stream = CGDisplayStreamCreateWithDispatchQueue(display_id, pixelWidth, pixelHeight, 'BGRA', NULL, q, handleStream);
    
    StartScreenStream();
}

MyScreenStream::~MyScreenStream()
{
    
}

void MyScreenStream::StartScreenStream()
{
    CGDisplayStreamStart(stream);
}

void MyScreenStream::StopScreenStream()
{
    
    CGDisplayStreamStop(stream);
}
*/