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
        fly.anchorPoint=ccp(0,0);
        fly.position=ccp(98,172);
        [self addChild:fly z:100];
        
        flySwatter=[CCSprite spriteWithSpriteFrameName:@"苍蝇拍.png"];
        flySwatter.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:flySwatter];
        
        NSLog(@"FlySwatterX:%f,y%f",flySwatter.boundingBox.origin.x,flySwatter.boundingBox.origin.y);
        NSLog(@"FlySizeW:%f,H%f",fly.boundingBox.size.width,fly.boundingBox.size.height);
        
        //98 172
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    static BOOL swatterDown=NO;
    UITouch *touch=[touches anyObject];
    NSLog(@"%i",touch.tapCount);
    
    if(touch.tapCount%2==1){
        CGPoint touchLocation=[touch locationInView:[touch view]];
        touchLocation=[[CCDirector sharedDirector]convertToGL:touchLocation];
        //fly.position=touchLocation;
        //NSLog(@"FlyX:%f,y%f",fly.boundingBox.origin.x,fly.boundingBox.origin.y);
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
