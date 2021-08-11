//
//  LebooEnums.h
//  LebooSDK
//
//  Created by lebong on 2021/7/15.
//

#ifndef LebooEnums_h
#define LebooEnums_h






typedef NS_ENUM(NSInteger, LebooBrushTime) {
    ///120秒
    LebooBrushTime_120,
    ///150秒
    LebooBrushTime_150,
    ///180秒
    LebooBrushTime_180
};



typedef NS_ENUM(NSInteger, LebooBrushMode) {
    LebooBrushMode_clean
};

typedef NS_ENUM(NSInteger, LebooBrushChildMode) {
    LebooBrushChildMode_morning
};


typedef NS_ENUM(NSInteger, LebooBrushForce) {
   
    LebooBrushForce_level1,
    LebooBrushForce_level2,
    LebooBrushForce_level3,
    LebooBrushForce_level4
};



#endif /* LebooEnums_h */
