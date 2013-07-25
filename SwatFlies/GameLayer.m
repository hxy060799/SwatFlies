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
@synthesize winSize;
@synthesize flySwatter;
@synthesize doingAnimation;
@synthesize timeRemain;
@synthesize timeLabel;
@synthesize scoreLabel;
@synthesize score;

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
        
        doingAnimation=NO;
        
        timeRemain=5;
        score=0;
        
        flies=[[NSMutableArray alloc]init];
        
        winSize=[[CCDirector sharedDirector]winSize];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flies.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"blood.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flySwatterTest.plist"];
        
        timeLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Time:%i",timeRemain] fntFile:@"English.fnt"];
        timeLabel.anchorPoint=ccp(0,1);
        timeLabel.position=ccp(0,winSize.height);
        [self addChild:timeLabel z:5];
        
        scoreLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Score:%i",score] fntFile:@"English.fnt"];
        scoreLabel.anchorPoint=ccp(1,1);
        scoreLabel.position=ccp(winSize.width,winSize.height);
        [self addChild:scoreLabel z:5];
        
        CCSprite *background=[CCSprite spriteWithFile:@"background.png"];
        background.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:background z:1];
        
        flySwatter=[CCSprite spriteWithSpriteFrameName:@"苍蝇拍.png"];
        flySwatter.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:flySwatter z:4];
        
        [self schedule:@selector(tryAddFly) interval:0.2f];
        [self schedule:@selector(timeGoes) interval:1.0f];
    }
    return self;
}

-(void)timeGoes{
    timeRemain-=1;
    if(log10(timeRemain+1)==(int)log10(timeRemain+1)==0){
        timeLabel.position=ccp(0,winSize.height);
    }
    [timeLabel setString:[NSString stringWithFormat:@"Time:%i",timeRemain]];
    if(timeRemain==0){
        [self unschedule:@selector(timeGoes)];
        [self unschedule:@selector(tryAddFly)];
        [flySwatter removeFromParent];
        while(flies.count>0){
            [self removeFlyAddBloodWithAction:nil Fly:[flies objectAtIndex:0]];
        }
    }
}

-(void)tryAddFly{
    if([flies count]<15){
        int t=arc4random()%3+1;
        if(t!=3){
            [self addFly];
        }
    }
}

-(void)addFly{
    
    int width=winSize.width;
    int height=winSize.height;
    
    int flyId=arc4random()%7+1;
    
    CCSprite *fly=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"fly_%i.png",flyId]];
    
    BOOL posision_OK=NO;
    
    CGPoint flyPosition;
    
    
    //保证苍蝇不重叠（苍蝇数量较多时这种算法比较耗资源）
    while(posision_OK==NO){
        posision_OK=YES;
        flyPosition=ccp(arc4random()%(width+1),arc4random()%(height+1));
        fly.position=flyPosition;
        for(CCSprite *fly_ in flies){
            if(CGRectIntersectsRect(fly_.boundingBox,fly.boundingBox)){
                posision_OK=NO;
            }
        }
    }
    
    [self addChild:fly z:3];
    [flies addObject:fly];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(doingAnimation){
        return;
    }
    
    CGPoint touchLocation=[self locationFromTouches:touches];
    
    for(CCSprite *fly in flies){
        if(CGRectContainsPoint(fly.boundingBox,touchLocation)){
            
            //移动苍蝇拍->拍下苍蝇拍->抬起苍蝇拍->苍蝇消除->血出现->星星粒子->血消失
            //     此过程不对用户的点击做出反应        过程由另一个函数执行
            
            CGPoint targetPosition=ccp(fly.position.x+118,fly.position.y-36);
            
            float s=distanceBetweenPoints(flySwatter.position, targetPosition);
            float v=480.0f;
            float t=s/v;
            
            id changeAnimationStateF=[CCCallFunc actionWithTarget:self selector:@selector(changeAnimationState)];
            id moveSwatter=[CCMoveTo actionWithDuration:t position:targetPosition];
            id swatFly=[CCCallBlock actionWithBlock:
                        ^(void){
                            [flySwatter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"苍蝇拍拍下.png"]];
                        }
                        ];
            id delay=[CCDelayTime actionWithDuration:0.3f];
            id pickSwatter=[CCCallBlock actionWithBlock:
                            ^(void){
                                [flySwatter setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"苍蝇拍.png"]];
                            }
                            ];
            id removeFly=[CCCallFuncND actionWithTarget:self selector:@selector(removeFlyAddBloodWithAction:Fly:) data:fly];
            [flySwatter runAction:[CCSequence actions:changeAnimationStateF,moveSwatter,swatFly,delay,pickSwatter,removeFly,changeAnimationStateF, nil]];
            
            return;
        }
    }
}

-(void)changeAnimationState{
    if(doingAnimation){
        doingAnimation=NO;
    }else{
        doingAnimation=YES;
    }
}

float distanceBetweenPoints(CGPoint first,CGPoint second){
    float deltaX=second.x-first.x;
    float deltaY=second.y-first.y;
    return sqrt(deltaX*deltaX+deltaY*deltaY);
};

-(void)removeFlyAddBloodWithAction:(CCAction*)actoin Fly:(CCSprite*)fly{
    
    score+=1;
    [scoreLabel setString:[NSString stringWithFormat:@"Score:%i",score]];
    if(log10(score)==(int)log10(score)){
        //1也被包括
        scoreLabel.position=ccp(winSize.width,winSize.height);
    }
    
    CGPoint flyPosition=fly.position;
    [flies removeObject:fly];
    [fly removeFromParent];
    
    int bloodId=arc4random()%4+1;
    CCSprite *blood=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"blood%i.png",bloodId]];
    //blood.anchorPoint=ccp(0.5,0.5);
    blood.position=flyPosition;
    blood.rotation=arc4random()*(180+1);
    
    id delay=[CCDelayTime actionWithDuration:arc4random()%3+1];
    id fadeout=[CCFadeOut actionWithDuration:1.0];
    
    [blood runAction:[CCSequence actions:delay,fadeout,nil]];
    
    [self addChild:blood z:2];
    
    CCParticleSystemQuad *particle=[CCParticleSystemQuad particleWithFile:@"swatFlyStars.plist"];
    particle.position=ccp(flyPosition.x,flyPosition.y);
    [self addChild:particle z:3];
}

-(CGPoint)locationFromTouches:(NSSet*)touches{
    UITouch *touch=[touches anyObject];
    CGPoint touchLocation=[touch locationInView:[touch view]];
    return [[CCDirector sharedDirector]convertToGL:touchLocation];
}

@end
