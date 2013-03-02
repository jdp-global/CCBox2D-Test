#import "CCApplyForce.h"
#import "CCBodySprite.h"
#import "CCJointSprite.h"
#import "CCSpringSprite.h"


@implementation CCApplyForce{
    
};
#define BODY_TAG 10000000
-(id) init
{

    self = [super init];
    
    if  (self!=nil){

        m_world->SetGravity(b2Vec2(0.0f, 0.0f));
        [self createCartesianBounds];
        
        CCBodySprite *centerBody = [[CCBodySprite spriteWithFile:@"Icon.png"]retain];
        centerBody.tag = BODY_TAG;
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        [centerBody configureSpriteForWorld:m_world bodyDef:bodyDef];
        centerBody.position = ccp(0,0);
        [self addChild:centerBody z:-100];
        kirbyCounter = 0;
        [self generateNodesWithParent:centerBody];
        

    }
    return self;
}
-(void)dealloc{
    [ground release];
    [super dealloc];
}
-(void)removeRandomNodes{
    float j = RandomFloat(0,5);
    
    if (j == 0) {
        if (kirbyCounter>30){
            float kill = RandomFloat(1,25);
            int i=0;
            for (i =0; i<kill; i++) {
                CCBodySprite *p = (CCBodySprite*)[self getChildByTag:kirbyCounter];
                [p removeFromParentAndCleanup:YES];
               // [self removeChildByTag:kirbyCounter];
                kirbyCounter--;
            }
        }
    }
   
}
-(void)generateNodesWithParent:(CCBodySprite*)parentSprite{
    b2PolygonShape shape;
    //shape.SetAsBox(2, 2);
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    fd.friction = 0.3f;
    
    BG_WEAKSELF;
    
    for (int i = 0; i < 2; ++i)
    {
        CGPoint pt;
        if (parentSprite.tag ==BODY_TAG) {
         pt  = ccp(parentSprite.position.x,parentSprite.position.y+i);
        }else{
          pt  = ccp(parentSprite.position.x*PTM_RATIO,parentSprite.position.y*PTM_RATIO+i);
        }
         
        NSLog(@"pt.x:%f",pt.x);
        NSLog(@"pt.y:%f",pt.y);
        
        CCBodySprite *kirby = [[CCBodySprite spriteWithFile:@"Kirby.png"]retain];
        //kirby.color = ccMAGENTA;
        kirby.tag = kirbyCounter+1;
        kirbyCounter ++;
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.awake = YES;
        bodyDef.allowSleep = YES;
        [kirby configureSpriteForWorld:m_world bodyDef:bodyDef];
        kirby.position = pt;
        [self addChild:kirby]; //add the kirby image into canvas
        
        
      
        CCShape *circle = [CCShape circleWithCenter:ccp(5,5) radius:20];
        circle.restitution = RandomFloat(1,5);
        [kirby addShape:circle named:@"circle"];
       // float scale =1.0f/15;
        [kirby setScale:0.8];

        kirby.onTouchDownBlock = ^{
            NSLog(@"onTouchDownBlock");
            
            //CCBodySprite *p = (CCBodySprite*)[self getChildByTag:kirbyCounter];
            if (parentSprite.tag ==BODY_TAG) {
                 [weakSelf generateNodesWithParent:kirby];
            }else{
                float r = RandomFloat(1,25);
                if (r>20){
                    CCArray *arr = [parentSprite children];
                    for (CCSpringSprite *n in arr) {
                        //CCShape *circle = [n shapeNamed:@"circle"];
                        n.color  = ccMAGENTA;
                    }
                    [parentSprite removeFromParentAndCleanup:YES];
                }else{
                    [weakSelf generateNodesWithParent:kirby];  
                }
                
            }
 
            
            
        };
        
        
        float32 gravity = 10.0f;
        float32 I = [kirby inertia];
        float32 mass = [kirby mass];
        
        // For a circle: I = 0.5 * m * r * r ==> r = sqrt(2 * I / m)
        float radius = b2Sqrt(2.0f * I / mass);
        
        //b2FrictionJointDef jd;
        b2FrictionJointDef jd;
        
        jd.localAnchorA.SetZero();
        jd.localAnchorB.SetZero();
        jd.bodyA = parentSprite.body;
        jd.bodyB = kirby.body;
        jd.collideConnected = true;
        jd.maxForce = mass * gravity;
        jd.maxTorque = mass * radius * gravity;
        m_world->CreateJoint(&jd);
        
        
        
    }
}



@end