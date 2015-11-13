//
//  MyScreenStream.hpp
//  server
//
//  Created by Evgeniy on 09.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#ifndef MyScreenStream_hpp
#define MyScreenStream_hpp

#include <stdio.h>

#include <OpenGL/OpenGL.h>
#include <GLUT/glut.h>
#include <CoreGraphics/CoreGraphics.h>

#include "MySocket.hpp"
#include <fcntl.h>
#include <semaphore.h>

#endif /* MyScreenStream_hpp */


class  MyScreenStream
{
private:
    dispatch_queue_t q;
    CGDisplayStreamRef stream;
    CGDirectDisplayID display_id;
    CGDisplayModeRef mode;
    size_t pixelWidth; 
    size_t pixelHeight;
    MySocket *my_sock;
    
    
public:
    MyScreenStream();
    virtual ~MyScreenStream();
    void StartScreenStream();
    void StopScreenStream();
};