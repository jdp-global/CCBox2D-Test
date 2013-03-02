#import "CCWorldLayer.h"
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#include <Box2D/Box2D.h>
#include "GLES-Render.h"
#import "CCBox2DPrivate.h"
#include <cstdlib>
#import "iPhoneTest.h"

@class CCBodySprite;



@interface CCTestLayer : CCLayer <ContactListenizer>
{

    b2World* m_world;	// cocos2d specific
    Settings* settings;
    
    b2Body* m_groundBody;
    ContactPoint m_points[k_maxContactPoints];
    int32 m_pointCount;
    GLESDebugDraw m_debugDraw;
    int32 m_textLine;
    b2MouseJoint* m_mouseJoint;
    b2Vec2 m_mouseWorld;
    int32 m_stepCount;
    
    BOOL isZooming;
    
    
}

-(CCBodySprite*) createGround:(CGSize)size;
-(void) createCartesianBounds;
@end
