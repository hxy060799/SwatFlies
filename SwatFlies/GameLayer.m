//
//  GameLayer.m
//  SwatFlies
//
//  Created by Bill on 13-7-6.
//  Copyright (c) 2013年 GetToSet. All rights reserved.
//

#import "GameLayer.h"

@implementation GameLayer

CCSprite *fly;
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
        
        winSize=[[CCDirector sharedDirector]winSize];
        
        CCSprite *background=[CCSprite spriteWithFile:@"background.png"];
        background.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:background];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flies.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"blood.plist"];
        
        fly=[CCSprite spriteWithSpriteFrameName:@"fly_1.png"];
        fly.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:fly];
        
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [fly removeFromParent];
    CCSprite *blood=[CCSprite spriteWithSpriteFrameName:@"blood1.png"];
    blood.position=ccp(winSize.width/2,winSize.height/2);
    [self addChild:blood];
}

@end
