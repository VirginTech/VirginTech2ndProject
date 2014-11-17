#import "TriDiagonalMatrixF.h"

@implementation TriDiagonalMatrixF

@synthesize n;
@synthesize A;
@synthesize B;
@synthesize C;

/**
 * The width and height of this matrix.
 */
- (int) n {
    
  return (A != nil ? (int)[A count] : 0);
}


/**
 * Indexer. Setter throws an exception if you try to set any not on the super, main, or sub diagonals.
 */
- (float) getItem:(int)row col:(int)col {
  int di = row - col;
  if (di == 0) {
      return [[B objectAtIndex:row] floatValue];
  }
   else if (di == -1) {
    NSAssert(row < [self n] - 1, @"assert failed");
    return [[C objectAtIndex:row] floatValue];
  }
   else if (di == 1) {
    NSAssert(row > 0, @"assert failed");
    return [[A objectAtIndex:row] floatValue];;
  }
   else {
    return 0;
  }
}

- (void) setItem:(int)row col:(int)col value:(float)value {
  int di = row - col;
  if (di == 0) {
      [B replaceObjectAtIndex:row withObject:[NSNumber numberWithFloat:value]];
  }
   else if (di == -1) {
    NSAssert(row < [self n] - 1, @"assert failed");
    [C replaceObjectAtIndex:row withObject:[NSNumber numberWithFloat:value]];
  }
   else if (di == 1) {
    NSAssert(row > 0, @"assert failed");
    [A replaceObjectAtIndex:row withObject:[NSNumber numberWithFloat:value]];
  }
   else {
       @throw [NSException exceptionWithName:@"IllegalArgumentException"
                                      reason:@"Only the main, super, and sub diagonals can be set."
                                    userInfo:nil];
  }
}


/**
 * Construct an NxN matrix.
 */
- (id) initWithN:(int)num {
  if (self = [super init]) {
    A = [NSMutableArray  arrayWithCapacity: num];
    B = [NSMutableArray  arrayWithCapacity: num];
    C = [NSMutableArray  arrayWithCapacity: num];
      n=num;
      for (int i = 0; i < num; i++) {
          [A addObject:[NSNumber numberWithFloat:0]];
          [B addObject:[NSNumber numberWithFloat:0]];
          [C addObject:[NSNumber numberWithFloat:0]];
      }
  }
  return self;
}


/**
 * Produce a string representation of the contents of this matrix.
 */

- (NSString *) ToDisplayString{
  if ([self n] > 0) {
    NSMutableString * s = [NSMutableString stringWithCapacity:0 ];
    
    for (int r = 0; r < [self n]; r++) {
      [s appendString:@"["];
        
      for (int c = 0; c < [self n]; c++) {
        [s appendFormat:@"%f" , [self getItem:r col:c]];
        [s appendString:@"]"];
        if (c < [self n] - 1) {
          [s appendString:@", "];
        }
      }

      [s appendString:@"\r\n"];
    }

    return [s description];
  }
   else {
    return [@" " stringByAppendingString:@"0x0 Matrix"];
  }
}


/**
 * Solve the system of equations this*x=d given the specified d.
 * 	 
 * 	 
 * 	 Uses the Thomas algorithm described in the wikipedia article: http://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm
 * 	 Not optimized. Not destructive.
 * 	 
 * 	 @param d Right side of the equation.
 */
- (NSMutableArray *) Solve:(NSMutableArray *)d {
  int num = [self n];
  if (d.count != num) {
      @throw [NSException exceptionWithName:@"IllegalArgumentException"
                                     reason:@"The input d is not the same size as this matrix."
                                   userInfo:nil];
      
  }
  NSMutableArray * cPrime = [NSMutableArray  arrayWithCapacity: num];
    for (int i = 0; i < num; i++) {
        [cPrime addObject:[NSNumber numberWithFloat:0]];
    }
  //cPrime[0] = C[0] / B[0];
    cPrime[0] =[NSNumber numberWithFloat:[C[0] floatValue] / [B[0] floatValue]];
  
  for (int i = 1; i < num; i++) {
    //cPrime[i] = C[i] / (B[i] - cPrime[i - 1] * A[i]);
      cPrime[i] = [NSNumber numberWithFloat:[C[i] floatValue] / [B[i] floatValue] - [cPrime[i-1] floatValue] * [A[i] floatValue]];
  }

  NSMutableArray * dPrime = [NSMutableArray  arrayWithCapacity: num];
    for (int i = 0; i < num; i++) {
        [dPrime addObject:[NSNumber numberWithFloat:0]];
    }
  //dPrime[0] = d[0] / B[0];
  [dPrime replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:[[d objectAtIndex:0] floatValue] / [[B objectAtIndex:0] floatValue]]];
    
  for (int i = 1; i < num; i++) {
    //dPrime[i] = (d[i] - dPrime[i - 1] * A[i]) / (B[i] - cPrime[i - 1] * A[i]);
      dPrime[i] = [NSNumber numberWithFloat:([d[i] floatValue] - [dPrime[i-1] floatValue] * [A[i] floatValue])/([B[i] floatValue] - [cPrime[i-1] floatValue] * [A[i] floatValue])];
  }

  NSMutableArray * x = [NSMutableArray  arrayWithCapacity: num];
    for (int i = 0; i < num; i++) {
        [x addObject:[NSNumber numberWithFloat:0]];
    }
  x[n - 1] = dPrime[num - 1];
    

  for (int i = num - 2; i >= 0; i--) {
    //x[i] = dPrime[i] - cPrime[i] * x[i + 1];
      x[i] = [NSNumber numberWithFloat:[dPrime[i] floatValue] - [cPrime[i] floatValue]*[x[i+1] floatValue]];
  }

  return x;
}


@end
