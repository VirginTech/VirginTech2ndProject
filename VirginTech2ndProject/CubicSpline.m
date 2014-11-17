#import "CubicSpline.h"

@implementation CubicSpline

float nan_;

/**
 * Default ctor.
 */
- (id) init {
  if (self = [super init]) {
    _lastIndex = 0;
    nan_ = NAN;
    
  }
  return self;
}


/**
 * Construct and call Fit.
 * 	 
 * 	 @param x Input. X coordinates to fit.
 * 	 @param y Input. Y coordinates to fit.
 * 	 @param startSlope Optional slope constraint for the first point. Single.NaN means no constraint.
 * 	 @param endSlope Optional slope constraint for the final point. Single.NaN means no constraint.
 * 	 @param debug Turn on console output. Default is false.
 */
- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope {
  if (self = [self init:x y:y startSlope:startSlope endSlope:endSlope debug:NO]) {
  }
  return self;
}

- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope {
  if (self = [self init:x y:y startSlope:startSlope endSlope:nan_ debug:NO]) {
  }
  return self;
}

- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y {
  if (self = [self init:x y:y startSlope:nan_ endSlope:nan_ debug:NO]) {
  }
  return self;
}

- (id) init:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug {
  if (self = [super init]) {
    _lastIndex = 0;
    [self Fit:x y:y startSlope:startSlope endSlope:endSlope debug:debug];
  }
  return self;
}


/**
 * Throws if Fit has not been called.
 */
- (void) CheckAlreadyFitted {
  if (a == nil) {
      @throw [NSException exceptionWithName:@"Exception"
                                     reason:@"Fit must be called before you can evaluate."
                                   userInfo:nil];
  }
}


/**
 * Find where in xOrig the specified x falls, by simultaneous traverse.
 * 	 This allows xs to be less than x[0] and/or greater than x[n-1]. So allows extrapolation.
 * 	 This keeps state, so requires that x be sorted and xs called in ascending order, and is not multi-thread safe.
 */
- (int) GetNextXIndex:(float)x {
  if (x < [xOrig[_lastIndex] floatValue]) {
      @throw [NSException exceptionWithName:@"IllegalArgumentException"
                                     reason:@"The X values to evaluate must be sorted."
                                   userInfo:nil];
  }

  while ((_lastIndex < xOrig.count - 2) && (x > [xOrig[_lastIndex + 1] floatValue])) {
    _lastIndex++;
  }

  return _lastIndex;
}


/**
 * Evaluate the specified x value using the specified spline.
 * 	 
 * 	 @param x The x value.
 * 	 @param j Which spline to use.
 * 	 @param debug Turn on console output. Default is false.
 * 	 @return The y value.
 */
- (float) EvalSpline:(float)x j:(int)j {
  return [self EvalSpline:x j:j debug:NO];
}

- (float) EvalSpline:(float)x j:(int)j debug:(BOOL)debug {
  float dx = [xOrig[j + 1] floatValue] - [xOrig[j] floatValue];
  float t = (x - [xOrig[j] floatValue]) / dx;
  float y = (1 - t) * [yOrig[j] floatValue] + t * [yOrig[j + 1] floatValue] + t * (1 - t) * ([a[j] floatValue] * (1 - t) + [b[j] floatValue] * t);
  //if (debug) {
  //    NSLog(@"xs=%f, j=%d, t=%f \r\n", x, j, t);
  //}
  return y;
}


/**
 * Fit x,y and then eval at points xs and return the corresponding y's.
 * 	 This does the "natural spline" style for ends.
 * 	 This can extrapolate off the ends of the splines.
 * 	 You must provide points in X sort order.
 * 	 
 * 	 @param x Input. X coordinates to fit.
 * 	 @param y Input. Y coordinates to fit.
 * 	 @param xs Input. X coordinates to evaluate the fitted curve at.
 * 	 @param startSlope Optional slope constraint for the first point. Single.NaN means no constraint.
 * 	 @param endSlope Optional slope constraint for the final point. Single.NaN means no constraint.
 * 	 @param debug Turn on console output. Default is false.
 * 	 @return The computed y values for each xs.
 */
- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope {
  return [self FitAndEval:x y:y xs:xs startSlope:startSlope endSlope:endSlope debug:NO];
}

- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope {
  return [self FitAndEval:x y:y xs:xs startSlope:startSlope endSlope:nan_ debug:NO];
}

- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs {
  return [self FitAndEval:x y:y xs:xs startSlope:nan_ endSlope:nan_ debug:NO];
}

- (NSMutableArray *) FitAndEval:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug {
  [self Fit:x y:y startSlope:startSlope endSlope:endSlope debug:debug];
  return [self Eval:xs debug:debug];
}


/**
 * Compute spline coefficients for the specified x,y points.
 * 	 This does the "natural spline" style for ends.
 * 	 This can extrapolate off the ends of the splines.
 * 	 You must provide points in X sort order.
 * 	 
 * 	 @param x Input. X coordinates to fit.
 * 	 @param y Input. Y coordinates to fit.
 * 	 @param startSlope Optional slope constraint for the first point. Single.NaN means no constraint.
 * 	 @param endSlope Optional slope constraint for the final point. Single.NaN means no constraint.
 * 	 @param debug Turn on console output. Default is false.
 */
- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope {
  [self Fit:x y:y startSlope:startSlope endSlope:endSlope debug:NO];
}

- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope {
  [self Fit:x y:y startSlope:startSlope endSlope:nan_ debug:NO];
}

- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y {
  [self Fit:x y:y startSlope:nan_ endSlope:nan_ debug:NO];
}

- (void) Fit:(NSMutableArray *)x y:(NSMutableArray *)y startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug {
  if ( isfinite(startSlope)|| isfinite(endSlope)) {
      @throw [NSException exceptionWithName:@"Exception"
                                     reason:@"startSlope and endSlope cannot be infinity."
                                   userInfo:nil];
  }
  xOrig = x;
  yOrig = y;
  int n = (int)x.count;
  NSMutableArray * r = [NSMutableArray arrayWithCapacity:n];
    for (int i= 0; i < n; i++) {
        [r addObject: [NSNumber numberWithFloat:0]];
    }
  TriDiagonalMatrixF * m = [[TriDiagonalMatrixF alloc] initWithN:n];
  float dx1, dx2, dy1, dy2;
  if (startSlope != startSlope) {
    dx1 = [x[1] floatValue] - [x[0] floatValue];
    m.C[0] = [NSNumber numberWithFloat:1.0f / dx1];
    m.B[0] = [NSNumber numberWithFloat:2.0f * [m.C[0] floatValue]];
    r[0] =  [NSNumber numberWithFloat:3 * ([y[1] floatValue] - [y[0] floatValue]) / (dx1 * dx1)];
  }
   else {
    m.B[0] = [NSNumber numberWithFloat:1];
    r[0] = [NSNumber numberWithFloat:startSlope];
  }

  for (int i = 1; i < n - 1; i++) {
    dx1 = [x[i] floatValue] - [x[i - 1] floatValue];
    dx2 = [x[i + 1] floatValue] - [x[i] floatValue];
    m.A[i] = [NSNumber numberWithFloat: 1.0f / dx1 ];
    m.C[i] = [NSNumber numberWithFloat: 1.0f / dx2 ];
    m.B[i] = [NSNumber numberWithFloat: 2.0f * ([m.A[i] floatValue] + [m.C[i] floatValue])];
    dy1 = [y[i] floatValue]- [y[i - 1] floatValue];
    dy2 = [y[i + 1] floatValue] - [y[i] floatValue];
    r[i] = [NSNumber numberWithFloat: 3 * (dy1 / (dx1 * dx1) + dy2 / (dx2 * dx2))];
  }

  if (endSlope != endSlope) {
    dx1 = [x[n - 1] floatValue] - [x[n - 2] floatValue];
    dy1 = [y[n - 1] floatValue] - [y[n - 2] floatValue];
    m.A[n - 1] = [NSNumber numberWithFloat: 1.0f / dx1];
    m.B[n - 1] = [NSNumber numberWithFloat: 2.0f * [m.A[n - 1] floatValue]];
    r[n - 1] = [NSNumber numberWithFloat: 3 * (dy1 / (dx1 * dx1))];
  }
   else {
    m.B[n - 1] = [NSNumber numberWithFloat: 1];
    r[n - 1] = [NSNumber numberWithFloat: endSlope];
  }

  /*if (debug) {
      NSLog(@"Tri-diagonal matrix:\r\n" );
      NSLog(@" %@" , [m ToDisplayString]);
  }
  if (debug) {
      NSLog(@"Array r:\r\n" );
      for (int i = 0; i < r.count; i++) {
          NSLog(@"%f ,", [r[i] floatValue]);
      }
  }*/
  NSMutableArray * k = [m Solve:r];
  /*if (debug) {
      NSLog(@"Array k:\r\n" );
      for (int i = 0; i < k.count; i++) {
          NSLog(@"%f ,", [k[i] floatValue]);
      }
  }*/
  a = [NSMutableArray arrayWithCapacity:n-1];
  b = [NSMutableArray arrayWithCapacity:n-1];
    for (int i= 0; i < n - 1; i++) {
        [a addObject: [NSNumber numberWithFloat:0]];
        [b addObject: [NSNumber numberWithFloat:0]];
    }

  for (int i = 1; i < n; i++) {
    dx1 = [x[i] floatValue] - [x[i - 1] floatValue];
    dy1 = [y[i] floatValue] - [y[i - 1] floatValue];
    a[i - 1] = [NSNumber numberWithFloat: [k[i-1] floatValue] * dx1 -dy1];
    b[i - 1] = [NSNumber numberWithFloat: -[k[i] floatValue] * dx1 + dy1];
  }

  /*if (debug) {
      NSLog(@"Array a:\r\n" );
      for (int i = 0; i < a.count; i++) {
          NSLog(@"%f ,", [a[i] floatValue]);
      }
  }
  if (debug) {
      NSLog(@"Array b:\r\n" );
      for (int i = 0; i < b.count; i++) {
          NSLog(@"%f ,", [b[i] floatValue]);
      }
  }*/
}


/**
 * Evaluate the spline at the specified x coordinates.
 * 	 This can extrapolate off the ends of the splines.
 * 	 You must provide X's in ascending order.
 * 	 The spline must already be computed before calling this, meaning you must have already called Fit() or FitAndEval().
 * 	 
 * 	 @param x Input. X coordinates to evaluate the fitted curve at.
 * 	 @param debug Turn on console output. Default is false.
 * 	 @return The computed y values for each x.
 */
- (NSMutableArray *) Eval:(NSMutableArray *)x {
  return [self Eval:x debug:NO];
}

- (NSMutableArray *) Eval:(NSMutableArray *)x debug:(BOOL)debug {
  [self CheckAlreadyFitted];
  int n = (int)x.count;
    NSMutableArray * y = [NSMutableArray arrayWithCapacity:n];
    for (int i= 0; i < n; i++) {
        [y addObject: [NSNumber numberWithFloat:0]];
    }
  _lastIndex = 0;

  for (int i = 0; i < n; i++) {
    int j = [self GetNextXIndex:[x[i] floatValue]];
      y[i] = [NSNumber numberWithFloat:[self EvalSpline:[x[i] floatValue] j:j debug:debug]];
  }

  return y;
}


/**
 * Evaluate (compute) the slope of the spline at the specified x coordinates.
 * 	 This can extrapolate off the ends of the splines.
 * 	 You must provide X's in ascending order.
 * 	 The spline must already be computed before calling this, meaning you must have already called Fit() or FitAndEval().
 * 	 
 * 	 @param x Input. X coordinates to evaluate the fitted curve at.
 * 	 @param debug Turn on console output. Default is false.
 * 	 @return The computed y values for each x.
 */
- (NSMutableArray *) EvalSlope:(NSMutableArray *)x {
  return [self EvalSlope:x debug:NO];
}

- (NSMutableArray *) EvalSlope:(NSMutableArray *)x debug:(BOOL)debug {
  [self CheckAlreadyFitted];
  int n = (int)x.count;
    NSMutableArray * qPrime = [NSMutableArray arrayWithCapacity:n];
    for (int i= 0; i < n; i++) {
        [qPrime addObject: [NSNumber numberWithFloat:0]];
    }
  _lastIndex = 0;

  for (int i = 0; i < n; i++) {
    int j = [self GetNextXIndex:[x[i] floatValue]];
    float dx = [xOrig[j + 1] floatValue] - [xOrig[j] floatValue];
    float dy = [yOrig[j + 1] floatValue] - [yOrig[j] floatValue];
    float t = ([x[i] floatValue] - [xOrig[j] floatValue]) / dx;
    qPrime[i] = [NSNumber numberWithFloat: dy / dx + (1 - 2 * t) * ([a[j] floatValue] * (1 - t) + [b[j] floatValue] * t) / dx + t * (1 - t) * ([b[j] floatValue] - [a[j] floatValue]) / dx];
    
    if (debug) {
        //NSLog(@"[%d]: xs=%f, j=%d, t=%f", i, [x[i] floatValue], j , t);
    }
  }

  return qPrime;
}


/**
 * Static all-in-one method to fit the splines and evaluate at X coordinates.
 * 	 
 * 	 @param x Input. X coordinates to fit.
 * 	 @param y Input. Y coordinates to fit.
 * 	 @param xs Input. X coordinates to evaluate the fitted curve at.
 * 	 @param startSlope Optional slope constraint for the first point. Single.NaN means no constraint.
 * 	 @param endSlope Optional slope constraint for the final point. Single.NaN means no constraint.
 * 	 @param debug Turn on console output. Default is false.
 * 	 @return The computed y values for each xs.
 */
+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope {
  return [self Compute:x y:y xs:xs startSlope:startSlope endSlope:endSlope debug:NO];
}

+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope {
  return [self Compute:x y:y xs:xs startSlope:startSlope endSlope:nan_ debug:NO];
}

+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs {
  return [self Compute:x y:y xs:xs startSlope:nan_ endSlope:nan_ debug:NO];
}

+ (NSMutableArray *) Compute:(NSMutableArray *)x y:(NSMutableArray *)y xs:(NSMutableArray *)xs startSlope:(float)startSlope endSlope:(float)endSlope debug:(BOOL)debug {
  CubicSpline * spline = [[CubicSpline alloc] init];
    return [spline FitAndEval:x y:y xs:xs startSlope:startSlope endSlope:endSlope debug:debug];
}


/**
 * Fit the input x,y points using a 'geometric' strategy so that y does not have to be a single-valued
 * 	 function of x.
 *
 * 	 @param x Input x coordinates.
 * 	 @param y Input y coordinates, do not need to be a single-valued function of x.
 * 	 @param nOutputPoints How many output points to create.
 * 	 @param xs Output (interpolated) x values.
 * 	 @param ys Output (interpolated) y values.
 */
+ (void) FitGeometric:(NSMutableArray *)x y:(NSMutableArray *)y nOutputPoints:(int)nOutputPoints xs:(NSMutableArray * __strong*)xs ys:(NSMutableArray * __strong*)ys {
    int n = (int)x.count;
    NSMutableArray * dists = [NSMutableArray arrayWithCapacity:n];
    for (int i = 0; i < n ; i++) {
        [dists addObject:[NSNumber numberWithFloat:0]];
    }
    
    float totalDist = 0;
    
    for (int i = 1; i < n; i++) {
        float dx = [x[i] floatValue] - [x[i - 1] floatValue];
        float dy = [y[i] floatValue] - [y[i - 1] floatValue];
        float dist = sqrtf(dx * dx + dy * dy);
        totalDist += dist;
        dists[i] = [NSNumber numberWithFloat:totalDist];
    }
    
    float dt = totalDist / (nOutputPoints - 1);
    NSMutableArray * times = [NSMutableArray  arrayWithCapacity:nOutputPoints];
    for (int i= 0; i < nOutputPoints; i++) {
        [times addObject: [NSNumber numberWithFloat:0]];
    }
    for (int i = 1; i < nOutputPoints; i++) {
        times[i] = [NSNumber numberWithFloat: [times[i - 1] floatValue] + dt];
    }
    
    CubicSpline * xSpline = [[CubicSpline alloc] init];
    //xs = [xSpline FitAndEval:dists y:x xs:times];
    *xs = [xSpline FitAndEval:dists y:x xs:times startSlope:nan_ endSlope:nan_ debug:YES];
    CubicSpline * ySpline = [[CubicSpline alloc] init];
    *ys = [ySpline FitAndEval:dists y:y xs:times];
    //NSLog(@"xs count: %lu, ys count: %lu", [*xs count], [*ys count]);
}


/**
 * Fit the input points using a 'geometric' strategy 
 *
 * 	 @param pin Input coordinates.
 * 	 @param nOutputPoints How many output points to create.
 * 	 @param pout Output (interpolated) coordinates.
 */
+ (void) FitGeometric:(NSMutableArray *)pin nOutputPoints:(int)nOutputPoints pout:(NSMutableArray * __strong*)pout {
    int n = (int)pin.count;
    NSMutableArray * xin = [NSMutableArray arrayWithCapacity:n];
    NSMutableArray * yin = [NSMutableArray arrayWithCapacity:n];
    NSMutableArray * xout = [NSMutableArray array];
    NSMutableArray * yout = [NSMutableArray array];
    
    for (int i = 0; i < n ; i++) {
        CGPoint p = [pin[i] CGPointValue];
        [xin addObject:[NSNumber numberWithFloat:p.x]];
        [yin addObject:[NSNumber numberWithFloat:p.y]];
    }
    
    [self FitGeometric:xin y:yin nOutputPoints:nOutputPoints xs:&xout ys:&yout];
    
    for (int i = 0; i < yout.count ; i++) {
        CGPoint p = CGPointMake([xout[i] floatValue], [yout[i] floatValue]);
        [*pout addObject: [NSValue valueWithCGPoint:p]];
    }
    
}

@end
