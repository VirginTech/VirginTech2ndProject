
/**
 * A tri-diagonal matrix has non-zero entries only on the main diagonal, the diagonal above the main (super), and the
 *  diagonal below the main (sub).
 *  
 *  
 *  <p>
 *  This is based on the wikipedia article: http://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm
 *  </p>
 *  <p>
 *  The entries in the matrix on a particular row are A[i], B[i], and C[i] where i is the row index.
 *  B is the main diagonal, and so for an NxN matrix B is length N and all elements are used.
 *  So for row 0, the first two values are B[0] and C[0].
 *  And for row N-1, the last two values are A[N-1] and B[N-1].
 *  That means that A[0] is not actually on the matrix and is therefore never used, and same with C[N-1].
 *  </p>
 */

//#import <Cocoa/Cocoa.h>
#import<Foundation/Foundation.h>

@interface TriDiagonalMatrixF : NSObject {
}

@property(nonatomic, readonly) int n;

/**
 * The values for the sub-diagonal. A[0] is never used.
 */
@property(nonatomic) NSMutableArray * A;

/**
 * The values for the main diagonal.
 */
@property(nonatomic) NSMutableArray * B;

/**
 * The values for the super-diagonal. C[C.Length-1] is never used.
 */
@property(nonatomic) NSMutableArray * C;
- (float) getItem:(int)row col:(int)col;
- (void) setItem:(int)row col:(int)col value:(float)value;
- (id) initWithN:(int)n;
- (NSString *) ToDisplayString;
- (NSMutableArray *) Solve:(NSMutableArray *)d;
@end
