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
        
        [self schedule:@selector(tryAddFly:) interval:0.2];
    }
    return self;
}

-(void)tryAddFly:(ccTime)dt{
    if([flies count]<15){
        int t=arc4random()%3+1;
        if(t!=3){
            [self addFly];
        }
    }
}

-(void)addFly{
    
    int flyId=arc4random()%7+1;
    
    CCSprite *fly=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"fly_%i.png",flyId]];
    [fly setScale:0.5];
    
    BOOL posision_OK=NO;
    
    CGPoint flyPosition;
    
    //保证苍蝇不重叠（苍蝇数量较多时这种算法比较耗资源）
    while(posision_OK==NO){
        posision_OK=YES;
        flyPosition=ccp(arc4random()%(480+1),arc4random()%(320+1));
        CGRect flyRect=CGRectMake(flyPosition.x-48/2, flyPosition.y-48/2, 48, 48);
        for(CCSprite *fly in flies){
            if(CGRectIntersectsRect(fly.boundingBox,flyRect)){
                posision_OK=NO;
            }
        }
    }
    
    fly.position=flyPosition;
    [self addChild:fly];
    [flies addObject:fly];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint touchLocation=[self locationFromTouches:touches];
    
    for(CCSprite *fly in flies){
        if(CGRectContainsPoint(fly.boundingBox,touchLocation)){
            CGPoint flyPosition=fly.position;
            [flies removeObject:fly];
            [fly removeFromParent];
            
            int bloodId=arc4random()%4+1;
            CCSprite *blood=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"blood%i.png",bloodId]];
            blood.anchorPoint=ccp(0.5,0.5);
            [blood setScale:0.5];
            blood.position=flyPosition;
            blood.rotation=arc4random()*(180+1);
            
            id delay=[CCDelayTime actionWithDuration:arc4random()%3+1];
            id fadeout=[CCFadeOut actionWithDuration:1.0];
            
            [blood runAction:[CCSequence actions:delay,fadeout,nil]];
            
            [self addChild:blood];
            
            return;
        }
    }
}

-(CGPoint)locationFromTouches:(NSSet*)touches{
    UITouch *touch=[touches anyObject];
    CGPoint touchLocation=[touch locationInView:[touch view]];
    return [[CCDirector sharedDirector]convertToGL:touchLocation];
}

@end
