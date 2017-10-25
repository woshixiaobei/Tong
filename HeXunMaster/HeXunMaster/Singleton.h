
#define singleton_h(name) + (instancetype)share##name; 
#if __has_feature(objc_arc) // ARC
#define singleton_m(name) \
static id _instance = nil; \
+ (instancetype)share##name {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    return _instance;\
} \
+ (id)copyWithZone:(struct _NSZone *)zone { \
    return _instance; \
}
#else  // 非ARC
#define singleton_m(name) \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)share##name { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[super alloc] init]; \
}); \
return _instance; \
} \
\
- (oneway void)release { \
\
} \
\
- (instancetype)autorelease { \
return self; \
} \
\
- (instancetype)retain { \
return self; \
} \
\
- (NSUInteger)retainCount { \
return 1; \
} \
\
+ (id)copyWithZone:(struct _NSZone *)zone { \
return _instance; \
}

#endif
//+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
//    static dispatch_once_t onceToken;\
//    dispatch_once(&onceToken, ^{\
//        _instance = [super allocWithZone:zone];\
//    });\
//    return _instance;\
//}\
//\

