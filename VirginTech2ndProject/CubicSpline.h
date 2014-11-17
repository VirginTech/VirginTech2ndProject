
/**
 * Cubic spline interpolation.
 *  Call Fit (or use the corrector constructor) to compute spline coefficients, then Eval to evaluate the spline at other X coordinates.
 *  
 *  
 *  <p>
 *  This is implemented based on the wikipedia article:
 *  http://en.wikipedia.org/wiki/Spline_interpolation
 *  I'm not sure I have the right to include a copy of the article so the equation numbers referenced in 
 *  comments will end up being wrong at some point.
 *  </p>
 *  <p>
 *  This is not optimized, and is not MT safe.
 *  This can extrapolate off the ends of the splines.
 *  You must provide points in X sort order.
 *  </p>
 */


//#import <Cocoa/Cocoa.h>
#import "TriDiagonalMatrixF.h"

@interface CubicSpline : NSObject {
  NSMutableArray * a;
  NSMutableArray * b;
  NSMutableArray * xOrig;
  NSMutableArray * yOrig;
  int _lastIndex;
}

- (id) init;
- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope;
- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope;
- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y;
- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug;
- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope;
- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope;
- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs;
- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug;
- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope;
- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope;
- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y;
- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug;
- (NSMutableArray *) Eval:(NSMutableArray *)x;
- (NSMutableArray *) Eval:(NSMutableArray *)x debug:(BOOL)debug;
- (NSMutableArray *) EvalSlope:(NSMutableArray *)x;
- (NSMutableArray *) EvalSlope:(NSMutableArray *)x debug:(BOOL)debug;
+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope;
+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope;
+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs;
+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug;
+ (void) FitGeometric:(NSMutableArray *)x y:(NSMutableArray *)y nOutputPoints:(int)nOutputPoints xs:(NSMutableArray * __strong *)xs ys:(NSMutableArray *  __strong *)ys;

+ (void) FitGeometric:(NSMutableArray *)pin nOutputPoints:(int)nOutputPoints pout:(NSMutableArray * __strong *)pout;
@end
