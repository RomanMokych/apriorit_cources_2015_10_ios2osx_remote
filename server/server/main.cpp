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

MySocket *my_sock;
CGDisplayStreamRef stream;
bool doubleClick=false;
bool move=false, down=false, up=true;
int moveCount=0;

void ConvertCoord(CGFloat &x, CGFloat &y)
{
    x*=(1920.0/1024.0);
    y*=(940.0/761.0);
}


void simulateMouseEvent(CGEventType eventType, CGPoint point)
{
    // Create and post the event
    CGEventRef event = CGEventCreateMouseEvent(CGEventSourceCreate(kCGEventSourceStateHIDSystemState), eventType, point, kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}
void DoubleClick(CGPoint point)
{
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, point, kCGMouseButtonLeft);
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 2);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseDown);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
}

dispatch_queue_t displayStreamQueue;
dispatch_queue_t sendQueue;
dispatch_queue_t eventQueue;
dispatch_semaphore_t sem;void (^handleStream)(CGDisplayStreamFrameStatus, uint64_t, IOSurfaceRef, CGDisplayStreamUpdateRef) =  ^(CGDisplayStreamFrameStatus status, uint64_t displayTime, IOSurfaceRef frameSurface, CGDisplayStreamUpdateRef updateRef)
{
    
    dispatch_async(eventQueue,
                   ^{
                       double *mas = new double[3];
                       mas = my_sock->Recv();
                       CGPoint p;
                       p.x = mas[1];
                       p.y = mas[2];
                       ConvertCoord(p.x, p.y);
                       if (mas[0]==1)
                       {
                           //if(up==true)
                           {
                               up=false;
                               down=true;
                           }
                       }
                       if (mas[0]==2)
                       {
                           if(down==true)
                           {
                               moveCount++;
                               move=true;
                               if(doubleClick==true)
                               {
                                   simulateMouseEvent(kCGEventLeftMouseDown, p);
                                   doubleClick=false;
                               }
                               simulateMouseEvent(kCGEventLeftMouseDragged, p);
                           }
                       }
                       if (mas[0]==3)
                       {
                           if(move==false)
                           {
                               simulateMouseEvent(kCGEventLeftMouseDown, p);
                               simulateMouseEvent(kCGEventLeftMouseUp, p);
                           }
                           else
                           {
                               simulateMouseEvent(kCGEventLeftMouseUp, p);
                           }
                           moveCount=0;
                           up=true;
                           move=false;
                       }
                       if (mas[0]==4)
                       {
                           doubleClick=true;
                       }
                       if (mas[0] == 5)
                           DoubleClick(p);
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          delete[] mas;
                                      });
                   });
    
    
    
    
    
    
    
    
    
    
    CGRect uRect;
    
    const CGRect * rects;
    
    size_t num_rects;
    
    
    CGDirectDisplayID displayID = CGMainDisplayID();
    CGImageRef testImage;
    
    
    rects = CGDisplayStreamUpdateGetRects(updateRef, kCGDisplayStreamUpdateDirtyRects, &num_rects);
    
    
    uRect = *rects;
    for (size_t i = 0; i < num_rects; i++)
    {
        uRect = CGRectUnion(uRect, *(rects+i));
        
    }
    
    testImage = CGDisplayCreateImageForRect (displayID, uRect);
    
    
    int width = CGImageGetWidth(testImage);
    int height = CGImageGetHeight(testImage);
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       width,
                                                       height,
                                                       8,
                                                       width * 4,
                                                       CGColorSpaceCreateDeviceRGB(),
                                                       kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(bitmapContext,
                       CGRectMake(0,0,width,height),
                       testImage);
    
    
    //bitmap = new unsigned char[width * height * sizeof(unsigned char*) * 4];
    
    unsigned char *bitmap = (unsigned char*)CGBitmapContextGetData(bitmapContext);
    dispatch_async(sendQueue,
                   ^(void){
                       int infoRect[4];
                       infoRect[0]=uRect.origin.x;
                       infoRect[1]=uRect.origin.y;
                       infoRect[2]=uRect.origin.x + uRect.size.width;
                       infoRect[3]=uRect.origin.y + uRect.size.height;
                       
                       if (my_sock->Send(bitmap, width * height * sizeof(unsigned char) * 4, infoRect) == -1)
                       {
                           
                           dispatch_sync(dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL), ^{
                               dispatch_suspend(sendQueue);
                               CGDisplayStreamStop(stream);
                               dispatch_semaphore_signal(sem);
                           });
                       }
                   });
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       delete[] rects;
                       delete[] bitmap;
                   });
    //delete[] bitmap;
};

int main(){
    
    
    
    CGDirectDisplayID display_id = CGMainDisplayID();
    CGDisplayModeRef mode = CGDisplayCopyDisplayMode(display_id);
    size_t pixelWidth = CGDisplayModeGetPixelWidth(mode);
    size_t pixelHeight = CGDisplayModeGetPixelHeight(mode);
    CGDisplayModeRelease(mode);
    
    my_sock = new MySocket();
    my_sock->Listening();
    sem = dispatch_semaphore_create(0);
    sendQueue = dispatch_queue_create("SEND_QUEUE", DISPATCH_QUEUE_SERIAL);
    displayStreamQueue = dispatch_queue_create("MLDESKTOP_QUEUE", DISPATCH_QUEUE_SERIAL);
    eventQueue = dispatch_queue_create("EVENT_QUEUE", DISPATCH_QUEUE_SERIAL);
    
    stream = CGDisplayStreamCreateWithDispatchQueue(display_id,
                                                    pixelWidth,
                                                    pixelHeight,
                                                    'BGRA',
                                                    NULL,
                                                    displayStreamQueue,
                                                    handleStream);
    
    
    
    CGDisplayStreamStart(stream);
    
    
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    CGDisplayStreamStop(stream);
    
    printf("Done!\n");
    
    //MyScreenStream *MSS = new MyScreenStream();
    //MSS->StartScreenStream();
    
    //for(;;);
    return 0;
}