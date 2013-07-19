//
//  GameLayer.h
//  SwatFlies
//
//  Created by Bill on 13-7-6.
//  Copyright (c) 2013年 GetToSet. All rights reserved.
//

#import "cocos2d.h"

@interface GameLayer : CCLayer{
    NSMutableArray *flies;
    
    CGSize winSize;
    
    BOOL doingAnimation;
    
    CCSprite *flySwatter;
    
    int timeRemain;
    int score;
    
    CCLabelBMFont *timeLabel;
    CCLabelBMFont *scoreLabel;
}

@property(retain,nonatomic)NSMutableArray *flies;
@property(assign,nonatomic)CGSize winSize;
@property(retain,nonatomic)CCSprite *flySwatter;
@property(assign,nonatomic)BOOL doingAnimation;
@property(assign,nonatomic)int timeRemain;
@property(assign,nonatomic)int score;
@property(retain,nonatomic)CCLabelBMFont *timeLabel;
@property(retain,nonatomic)CCLabelBMFont *scoreLabel;

+(CCScene*)scene;

@end
