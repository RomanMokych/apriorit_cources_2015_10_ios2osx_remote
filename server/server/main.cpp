#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <iostream>
#include <semaphore.h>
#include <CoreGraphics/CoreGraphics.h>
#include <OpenGL/OpenGL.h>
#include <GLUT/glut.h>
#include <fcntl.h>


//#include "MyScreenStream.hpp"
#include "MySocket.hpp"

uint64_t last_time = 0;
MySocket *my_sock = new MySocket();
dispatch_queue_t sendQueue = dispatch_queue_create("SEND_QUEUE", DISPATCH_QUEUE_SERIAL);

void (^handleStream)(CGDisplayStreamFrameStatus, uint64_t, IOSurfaceRef, CGDisplayStreamUpdateRef) =  ^(CGDisplayStreamFrameStatus status, uint64_t displayTime, IOSurfaceRef frameSurface, CGDisplayStreamUpdateRef updateRef)
{
    
    if(displayTime - last_time < 500000000)
        return;
    
    
    
    
    
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
    CGImageRef testImage;
    
    
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
    
    
    int width = CGImageGetWidth(testImage);
    int height = CGImageGetHeight(testImage);
    
    unsigned char *data = new unsigned char[width * height * sizeof(unsigned char) * 4];//malloc(width * height * sizeof(unsigned char*) * 4);
    CGContextRef bitmapContext = CGBitmapContextCreate(data,
                                                       width,
                                                       height,
                                                       8,
                                                       width * 4,
                                                       CGColorSpaceCreateDeviceRGB(),
                                                       kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(bitmapContext,
                       CGRectMake(0,0,width,height),
                       testImage);
    unsigned char *bitmap = new unsigned char[width * height * sizeof(unsigned char*) * 4];
    bitmap = (unsigned char*)CGBitmapContextGetData(bitmapContext);
    
    dispatch_async(sendQueue, ^(void){
    int infoRect[4];
    infoRect[0]=uRect.origin.x;
    infoRect[1]=uRect.origin.y;
    infoRect[2]=uRect.origin.x + uRect.size.width;
    infoRect[3]=uRect.origin.y + uRect.size.height;
    
    my_sock->Send(bitmap, width * height * sizeof(unsigned char) * 4, infoRect);
    });
    //delete[] data;
};

int main(){
    
    
    //MySocket *my_sock = new MySocket();
    my_sock->Listening();
    my_sock->Conection();
    
    
    
    dispatch_queue_t displayStreamQueue = dispatch_queue_create("MLDESKTOP_QUEUE", DISPATCH_QUEUE_SERIAL);
    CGDisplayStreamRef stream;
    
    CGDirectDisplayID display_id;
    display_id = CGMainDisplayID();
    
    CGDisplayModeRef mode = CGDisplayCopyDisplayMode(display_id);
    
    size_t pixelWidth = CGDisplayModeGetPixelWidth(mode);
    size_t pixelHeight = CGDisplayModeGetPixelHeight(mode);
    
    CGDisplayModeRelease(mode);
    stream = CGDisplayStreamCreateWithDispatchQueue(display_id,
                                                    pixelWidth,
                                                    pixelHeight,
                                                    'BGRA',
                                                    NULL,
                                                    displayStreamQueue,
                                                    handleStream);
    
    
    
    CGDisplayStreamStart(stream);
    
    
    
    usleep(50000000000);
    
    CGDisplayStreamStop(stream);
    
    
    
    printf("Done!\n");
    
    
    //MyScreenStream *MSS = new MyScreenStream();
    //MSS->StartScreenStream();
    
    //for(;;);
    return 0;
}