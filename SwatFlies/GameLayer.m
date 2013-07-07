//
//  GameLayer.m
//  SwatFlies
//
//  Created by Bill on 13-7-6.
//  Copyright (c) 2013年 GetToSet. All rights reserved.
//

#import "GameLayer.h"

@implementation GameLayer

@synthesize flies;

CGSize winSize;

+(CCScene*)scene{
    CCScene *scene=[CCScene node];
    GameLayer *layer=[GameLayer node];
    [scene addChild:layer];
    
    return scene;
}

-(id)init{
    if(self=[super init]){
        
        self.touchEnabled=YES;
        
        flies=[[NSMutableArray alloc]init];
        
        winSize=[[CCDirector sharedDirector]winSize];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flies.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"blood.plist"];
        
        CCSprite *background=[CCSprite spriteWithFile:@"background.png"];
        background.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:background];
        
        for(int i=0;i<5;i++){
            CCSprite *fly=[CCSprite spriteWithSpriteFrameName:@"fly_1.png"];
            [fly setScale:0.375];
            fly.position=ccp(50*i,50*i);
            [self addChild:fly];
            [flies addObject:fly];
        }
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint touchLocation=[self locationFromTouches:touches];
    
    for(CCSprite *fly in flies){
        if(CGRectContainsPoint(fly.boundingBox, touchLocation)){
            [fly removeFromParent];
            CCSprite *blood=[CCSprite spriteWithSpriteFrameName:@"blood1.png"];
            blood.anchorPoint=ccp(0.5,0.5);
            [blood setScale:0.375];
            blood.position=ccp(fly.position.x,fly.position.y);
            [self addChild:blood];
        }
    }
}

-(CGPoint)locationFromTouches:(NSSet*)touches{
    UITouch *touch=[touches anyObject];
    CGPoint touchLocation=[touch locationInView:[touch view]];
    return [[CCDirector sharedDirector]convertToGL:touchLocation];
}

@end
