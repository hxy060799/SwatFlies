//
//  TestLayer.m
//  SwatFlies
//
//  Created by Bill on 13-7-9.
//  Copyright (c) 2013年 GetToSet. All rights reserved.
//

#import "TestLayer.h"

@implementation TestLayer

CCSprite *fly;
CCSprite *flySwatter;

+(CCScene*)scene{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[TestLayer node];
    [scene addChild:layer];
    
    return scene;
}

-(id)init{
    if(self=[super init]){
        self.touchEnabled=YES;
        
        CGSize winSize=[[CCDirector sharedDirector]winSize];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"flies.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"flySwatterTest.plist"];
        
        CCSprite *background=[CCSprite spriteWithFile:@"backgroundWhite.png"];
        background.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:background];
        
        fly=[CCSprite spriteWithSpriteFrameName:@"fly_1.png"];
        fly.position=ccp(10,20);
        [self addChild:fly z:1];
        
        flySwatter=[CCSprite spriteWithSpriteFrameName:@"苍蝇拍.png"];
        flySwatter.position=ccp(10+118,20-36);
        [self addChild:flySwatter z:2];
        
        //苍蝇拍和苍蝇坐标之间的关系swatter(fly.x+118,fly.y-36)(适用于320*480像素)
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    static BOOL swatterDown=NO;
    UITouch *touch=[touches anyObject];
    NSLog(@"%i",touch.tapCount);
    
    if(touch.tapCount%3==1){
        CGPoint touchLocation=[touch locationInView:[touch view]];
        touchLocation=[[CCDirector sharedDirector]convertToGL:touchLocation];
        fly.position=touchLocation;
    
    }else if(touch.tapCount%3==2){
        flySwatter.position=ccp(fly.position.x+118,fly.position.y-36);
    }else{
        if(swatterDown==NO){
            swatterDown=YES;
            [flySwatter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"苍蝇拍拍下.png"]];
        }else{
            swatterDown=NO;
            [flySwatter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"苍蝇拍.png"]];
        }
    }
    
    return;
}

@end
