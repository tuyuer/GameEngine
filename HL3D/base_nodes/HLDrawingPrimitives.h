
#import "HLNode.h"

/** Initializes the drawing primitives */
void hlDrawInit(void);

/** draws a point given x and y coordinate measured in points. */
void hlDrawPoint( CGPoint point );

/** draws a line given the origin and destination point measured in points. */
void hlDrawLine( CGPoint origin, CGPoint destination );

/** draws a rectangle given the origin and destination point measured in points. */
void hlDrawRect( CGPoint origin, CGPoint destination );

/** set the drawing color with 4 unsigned bytes
 @since v2.0
 */
void hlDrawColor4B( GLubyte r, GLubyte g, GLubyte b, GLubyte a );

/** set the drawing color with 4 floats
 @since v2.0
 */
void hlDrawColor4F( GLfloat r, GLfloat g, GLfloat b, GLfloat a );

/** set the point size in points. Default 1.
 @since v2.0
 */
void ccPointSize( GLfloat pointSize );