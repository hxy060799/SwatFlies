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
}

@property(retain,nonatomic)NSMutableArray *flies;

+(CCScene*)scene;

@end
