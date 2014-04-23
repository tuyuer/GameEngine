//
//  HL3Foundation.h
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import <Foundation/Foundation.h>


/** A vector in 3D space. */
typedef struct {
	GLfloat x;			/**< The X-componenent of the vector. */
	GLfloat y;			/**< The Y-componenent of the vector. */
	GLfloat z;			/**< The Z-componenent of the vector. */
} HL3Vector;



/** A HL3Vector of zero length at the origin. */
static const HL3Vector kHL3VectorZero = { 0.0, 0.0, 0.0 };

/** The null HL3Vector. It cannot be drawn, but is useful for marking an uninitialized vector. */
static const HL3Vector kHL3VectorNull = {INFINITY, INFINITY, INFINITY};

/** A HL3Vector with each component equal to one, representing the diagonal of a unit cube. */
static const HL3Vector kHL3VectorUnitCube = { 1.0, 1.0, 1.0 };

/** Unit vector pointing in the same direction as the positive X-axis. */
static const HL3Vector kHL3VectorUnitXPositive = { 1.0,  0.0,  0.0 };

/** Unit vector pointing in the same direction as the positive Y-axis. */
static const HL3Vector kHL3VectorUnitYPositive = { 0.0,  1.0,  0.0 };

/** Unit vector pointing in the same direction as the positive Z-axis. */
static const HL3Vector kHL3VectorUnitZPositive = { 0.0,  0.0,  1.0 };

/** Unit vector pointing in the same direction as the negative X-axis. */
static const HL3Vector kHL3VectorUnitXNegative = {-1.0,  0.0,  0.0 };

/** Unit vector pointing in the same direction as the negative Y-axis. */
static const HL3Vector kHL3VectorUnitYNegative = { 0.0, -1.0,  0.0 };

/** Unit vector pointing in the same direction as the negative Z-axis. */
static const HL3Vector kHL3VectorUnitZNegative = { 0.0,  0.0, -1.0 };

/** Returns a string description of the specified HL3Vector struct in the form "(x, y, z)" */
static inline NSString* NSStringFromHL3Vector(HL3Vector v) {
	return [NSString stringWithFormat: @"(%.3f, %.3f, %.3f)", v.x, v.y, v.z];
}

/**
 * Returns a string description of the specified array of HL3Vector structs.
 *
 * The vectorCount argument indicates the number of vectors in the vectors array argument.
 *
 * Each vector in the array is output on a separate line in the result.
 */
NSString* NSStringFromHL3Vectors(HL3Vector* vectors, GLuint vectorCount);

/** Returns a HL3Vector structure constructed from the vector components. */
static inline HL3Vector HL3VectorMake(GLfloat x, GLfloat y, GLfloat z) {
	HL3Vector v;
	v.x = x;
	v.y = y;
	v.z = z;
	return v;
}


/** Convenience alias macro to create HL3Vectors with less keystrokes. */
#define hl3v(X,Y,Z) HL3VectorMake((X),(Y),(Z))

/** Returns whether the two vectors are equal by comparing their respective components. */
static inline BOOL HL3VectorsAreEqual(HL3Vector v1, HL3Vector v2) {
	return v1.x == v2.x &&
    v1.y == v2.y &&
    v1.z == v2.z;
}

/** Returns whether the specified vector is equal to the zero vector, specified by kHL3VectorZero. */
static inline BOOL HL3VectorIsZero(HL3Vector v) {
	return HL3VectorsAreEqual(v, kHL3VectorZero);
}

/** Returns whether the specified vector is equal to the null vector, specified by kHL3VectorNull. */
static inline BOOL HL3VectorIsNull(HL3Vector v) {
	return HL3VectorsAreEqual(v, kHL3VectorNull);
}

/**
 * Returns the result of scaling the original vector by the corresponding scale vector.
 * Scaling can be different for each axis. This has the effect of multiplying each component
 * of the vector by the corresponding component in the scale vector.
 */
static inline HL3Vector HL3VectorScale(HL3Vector v, HL3Vector scale) {
	return hl3v(v.x * scale.x,
				v.y * scale.y,
				v.z * scale.z);
}

/**
 * Returns the result of scaling the original vector by the corresponding scale
 * factor uniformly along all axes.
 */
static inline HL3Vector HL3VectorScaleUniform(HL3Vector v, GLfloat scale) {
	return hl3v(v.x * scale,
				v.y * scale,
				v.z * scale);
}

/**
 * Returns a vector that is the negative of the specified vector in all directions.
 * For vectors that represent directions, the returned vector points in the direction
 * opposite to the original.
 */
static inline HL3Vector HL3VectorNegate(HL3Vector v) {
	return hl3v(-v.x, -v.y, -v.z);
}

/**
 * Returns a vector whose components comprise the minimum value of each of the respective
 * components of the two specfied vectors. In general, do not expect this method to return
 * one of the specified vectors, but a new vector, each of the components of which is the
 * minimum value for that component between the two vectors.
 */
static inline HL3Vector HL3VectorMinimize(HL3Vector v1, HL3Vector v2) {
	return hl3v(MIN(v1.x, v2.x),
				MIN(v1.y, v2.y),
				MIN(v1.z, v2.z));
}


/**
 * Returns a vector whose components comprise the maximum value of each of the respective
 * components of the two specfied vectors. In general, do not expect this method to return
 * one of the specified vectors, but a new vector, each of the components of which is the
 * maximum value for that component between the two vectors.
 */
static inline HL3Vector HL3VectorMaximize(HL3Vector v1, HL3Vector v2) {
	return hl3v(MAX(v1.x, v2.x),
				MAX(v1.y, v2.y),
				MAX(v1.z, v2.z));
}

/** Returns the dot-product of the two given vectors (v1 . v2). */
static inline GLfloat HL3VectorDot(HL3Vector v1, HL3Vector v2) {
	return ((v1.x * v2.x) +
			(v1.y * v2.y) +
			(v1.z * v2.z));
}

/**
 * Returns the square of the scalar length of the specified HL3Vector from the origin.
 * This is calculated as (x*x + y*y + z*z) and will always be positive.
 *
 * This function is useful for comparing vector sizes without having to run an
 * expensive square-root calculation.
 */
static inline GLfloat HL3VectorLengthSquared(HL3Vector v) { return HL3VectorDot(v, v); }

/**
 * Returns the scalar length of the specified HL3Vector from the origin.
 * This is calculated as sqrt(x*x + y*y + z*z) and will always be positive.
 */
static inline GLfloat HL3VectorLength(HL3Vector v) {
	// Avoid expensive sqrt calc if vector is unit length or zero
	GLfloat lenSq = HL3VectorLengthSquared(v);
	return (lenSq == 1.0f || lenSq == 0.0f) ? lenSq : sqrtf(lenSq);
}

/**
 * Returns a normalized copy of the specified HL3Vector so that its length is 1.0.
 * If the length is zero, the original vector (a zero vector) is returned.
 */
static inline HL3Vector HL3VectorNormalize(HL3Vector v) {
	GLfloat lenSq = HL3VectorLengthSquared(v);
	if (lenSq == 0.0f || lenSq == 1.0f) return v;
	return HL3VectorScaleUniform(v, (1.0f / sqrtf(lenSq)));
}

/**
 * Returns a HL3Vector that is the inverse of the specified vector in all directions,
 * such that scaling the original by the inverse using HL3VectorScale will result in
 * a vector of unit dimension in each direction (1.0, 1.0, 1.0). The result of this
 * function is effectively calculated by dividing each component of the original
 * vector into 1.0 (1.0/x, 1.0/y, 1.0/z). It is the responsibility of the caller to
 * ensure that none of the components of the original is zero.
 */
static inline HL3Vector HL3VectorInvert(HL3Vector v) {
	return hl3v(1.0f / v.x,
				1.0f / v.y,
				1.0f / v.z);
}

/**
 * Returns the result of adding the two specified vectors, by adding the corresponding components
 * of both vectors. This can also be thought of as a translation of the first vector by the second.
 */
static inline HL3Vector HL3VectorAdd(HL3Vector v, HL3Vector translation) {
	return hl3v(v.x + translation.x,
				v.y + translation.y,
				v.z + translation.z);
}

/**
 * Returns the difference between two vectors, by subtracting the subtrahend from the minuend,
 * which is accomplished by subtracting each of the corresponding x,y,z components.
 */
static inline HL3Vector HL3VectorDifference(HL3Vector minuend, HL3Vector subtrahend) {
	return hl3v(minuend.x - subtrahend.x,
				minuend.y - subtrahend.y,
				minuend.z - subtrahend.z);
}


/** Returns the positive scalar distance between the ends of the two specified vectors. */
static inline GLfloat HL3VectorDistance(HL3Vector start, HL3Vector end) {
	return HL3VectorLength(HL3VectorDifference(end, start));
}

/**
 * Returns the square of the scalar distance between the ends of the two specified vectors.
 *
 * This function is useful for comparing vector distances without having to run an
 * expensive square-root calculation.
 */
static inline GLfloat HL3VectorDistanceSquared(HL3Vector start, HL3Vector end) {
	return HL3VectorLengthSquared(HL3VectorDifference(end, start));
}

/**
 * Returns a vector that represents the average of the two specified vectors. This is
 * calculated by adding the two specified vectors and scaling the resulting sum vector by half.
 *
 * The returned vector represents the midpoint between a line that joins the endpoints
 * of the two specified vectors.
 */
static inline HL3Vector HL3VectorAverage(HL3Vector v1, HL3Vector v2) {
	return HL3VectorScaleUniform(HL3VectorAdd(v1, v2), 0.5);
}

/** Returns the cross-product of the two given vectors (v1 x v2). */
static inline HL3Vector HL3VectorCross(HL3Vector v1, HL3Vector v2) {
	return hl3v(v1.y * v2.z - v1.z * v2.y,
				v1.z * v2.x - v1.x * v2.z,
				v1.x * v2.y - v1.y * v2.x);
}

/**
 * Orthonormalizes the specified array of vectors, using a Gram-Schmidt process,
 * and returns the orthonormal results in the same array.
 *
 * The vectorCount argument indicates the number of vectors in the vectors array argument.
 *
 * Upon completion, each vector in the specfied array will be a unit vector that
 * is orthagonal to all of the other vectors in the array.
 *
 * The first vector in the array is used as the starting point for orthonormalization.
 * Since the Gram-Schmidt process is biased towards the starting vector, if this function
 * will be used repeatedly on the same set of vectors, it is recommended that the order
 * of the vectors in the array be changed on each call to this function, to ensure that
 * the starting bias be averaged across each of the vectors over the long term.
 */
void HL3VectorOrthonormalize(HL3Vector* vectors, GLuint vectorCount);

/**
 * Orthonormalizes the specified array of three vectors, using a Gram-Schmidt process,
 * and returns the orthonormal results in the same array.
 *
 * The number of vectors in the specified array must be exactly three.
 *
 * Upon completion, each vector in the specfied array will be a unit vector that
 * is orthagonal to all of the other vectors in the array.
 *
 * The first vector in the array is used as the starting point for orthonormalization.
 * Since the Gram-Schmidt process is biased towards the starting vector, if this function
 * will be used repeatedly on the same set of vectors, it is recommended that the order
 * of the vectors in the array be changed on each call to this function, to ensure that
 * the starting bias be averaged across each of the vectors over the long term.
 */
static inline void HL3VectorOrthonormalizeTriple(HL3Vector* triVector) { return HL3VectorOrthonormalize(triVector, 3); }

/**
 * Returns a linear interpolation between two vectors, based on the blendFactor.
 * which should be between zero and one inclusive. The returned value is calculated
 * as v1 + (blendFactor * (v2 - v1)). If the blendFactor is either zero or one
 * exactly, this method short-circuits to simply return v1 or v2 respectively.
 */
static inline HL3Vector HL3VectorLerp(HL3Vector v1, HL3Vector v2, GLfloat blendFactor) {
	if (blendFactor == 0.0f) return v1;
	if (blendFactor == 1.0f) return v2;
	return HL3VectorAdd(v1, HL3VectorScaleUniform(HL3VectorDifference(v2, v1), blendFactor));
}

/**
 * Minimum acceptable absolute value for a scale transformation component.
 *
 * This is used to ensure that scales used in transforms do not cause uninvertable matrices.
 *
 * The initial value is 1.0e-9f. Set this to another value if appropriate.
 */
static GLfloat kCC3ScaleMin = 1.0e-9f;

/**
 * Ensures the specified value can be used as a component in a scale vector. If the value is
 * greater than kCC3ScaleMin or less than -kCC3ScaleMin, it is returned unchanced, otherwise
 * either -kCC3ScaleMin or kCC3ScaleMin is returned, depending on whether the value is
 * less than zero or not, respectively.
 *
 * This is used to ensure that scales used in transforms do not cause uninvertable matrices.
 */
static inline GLfloat CC3EnsureMinScaleAxis(GLfloat val) {
	// Test in order of expected value, for fast return.
	if (val > kCC3ScaleMin) return val;
	if (val >= 0.0f) return kCC3ScaleMin;
	if (val < -kCC3ScaleMin) return val;
	return -kCC3ScaleMin;
}

/**
 * Ensures the absolute value of each of the components in the specified scale vector
 * is greater than kCC3ScaleMin. Any component between -kCC3ScaleMin and kCC3ScaleMin
 * is replaced with -kCC3ScaleMin or kCC3ScaleMin depending on whether the component
 * is less than zero or not, respectively.
 *
 * This can be used to ensure that scales used in transforms do not cause uninvertable matrices.
 */
static inline HL3Vector CC3EnsureMinScaleVector(HL3Vector scale) {
	return hl3v(CC3EnsureMinScaleAxis(scale.x),
				CC3EnsureMinScaleAxis(scale.y),
				CC3EnsureMinScaleAxis(scale.z));
}














//vector four ...

#pragma mark -
#pragma mark Cartesian vector in 4D homogeneous coordinate space structure and functions

/** A homogeneous vector in 4D graphics matrix space. */
typedef struct {
	GLfloat x;			/**< The X-componenent of the vector. */
	GLfloat y;			/**< The Y-componenent of the vector. */
	GLfloat z;			/**< The Z-componenent of the vector. */
	GLfloat w;			/**< The homogeneous ratio factor. */
} HL3Vector4;

/** A HL3Vector4 of zero length at the origin. */
static const HL3Vector4 kHL3Vector4Zero = { 0.0, 0.0, 0.0, 0.0 };

/**
 * A HL3Vector4 location at the origin.
 * As a definite location, the W component is 1.0.
 */
static const HL3Vector4 kHL3Vector4ZeroLocation = { 0.0, 0.0, 0.0, 1.0 };

/** The null HL3Vector4. It cannot be drawn, but is useful for marking an uninitialized vector. */
static const HL3Vector4 kHL3Vector4Null = {INFINITY, INFINITY, INFINITY, INFINITY};

/** Returns a string description of the specified HL3Vector4 struct in the form "(x, y, z, w)" */
static inline NSString* NSStringFromHL3Vector4(HL3Vector4 v) {
	return [NSString stringWithFormat: @"(%.3f, %.3f, %.3f, %.3f)", v.x, v.y, v.z, v.w];
}

/** Returns a HL3Vector4 structure constructed from the vector components. */
static inline HL3Vector4 HL3Vector4Make(GLfloat x, GLfloat y, GLfloat z, GLfloat w) {
	HL3Vector4 v;
	v.x = x;
	v.y = y;
	v.z = z;
	v.w = w;
	return v;
}

/** Returns a HL3Vector4 structure constructed from a 3D vector and a w component. */
static inline HL3Vector4 HL3Vector4FromHL3Vector(HL3Vector v, GLfloat w) {
	return HL3Vector4Make(v.x, v.y, v.z, w);
}

/**
 * Returns a HL3Vector4 homogeneous coordinate constructed from a 3D location.
 *
 * The W component of the returned vector is set to 1.0.
 */
static inline HL3Vector4 HL3Vector4FromLocation(HL3Vector aLocation) {
	return HL3Vector4FromHL3Vector(aLocation, 1.0f);
}

/**
 * Returns a HL3Vector4 homogeneous coordinate constructed from a 3D direction.
 *
 * The W component of the returned vector is set to 0.0.
 */
static inline HL3Vector4 HL3Vector4FromDirection(HL3Vector aDirection) {
	return HL3Vector4FromHL3Vector(aDirection, 0.0f);
}

/**
 * Returns a HL3Vector structure constructed from a HL3Vector4,
 * by simply ignoring the w component of the 4D vector.
 */
static inline HL3Vector HL3VectorFromTruncatedHL3Vector4(HL3Vector4 v) { return *(HL3Vector*)&v; }

/** Returns whether the two vectors are equal by comparing their respective components. */
static inline BOOL HL3Vector4sAreEqual(HL3Vector4 v1, HL3Vector4 v2) {
	return (v1.x == v2.x &&
			v1.y == v2.y &&
			v1.z == v2.z &&
			v1.w == v2.w);
}

/** Returns whether the specified vector is equal to the zero vector, specified by kHL3Vector4Zero. */
static inline BOOL HL3Vector4IsZero(HL3Vector4 v) {
	return HL3Vector4sAreEqual(v, kHL3Vector4Zero);
}

/** Returns whether the specified vector is equal to the null vector, specified by kHL3Vector4Null. */
static inline BOOL HL3Vector4IsNull(HL3Vector4 v) {
	return HL3Vector4sAreEqual(v, kHL3Vector4Null);
}

/**
 * Returns whether the vector represents a direction, rather than a location.
 *
 * It is directional if the w component is zero.
 */
static inline BOOL HL3Vector4IsDirectional(HL3Vector4 v) { return (v.w == 0.0); }

/**
 * Returns whether the vector represents a location, rather than a direction.
 *
 * It is locational if the w component is not zero.
 */
static inline BOOL HL3Vector4IsLocational(HL3Vector4 v) { return !HL3Vector4IsDirectional(v); }

/**
 * If the specified homogeneous vector represents a location (w is not zero), returns a
 * homoginized copy of the vector, by dividing each component by the w-component (including
 * the w-component itself, leaving it with a value of one). If the specified vector is a
 * direction (w is zero), or is already homogenized (w is one) the vector is returned unchanged.
 */
static inline HL3Vector4 HL3Vector4Homogenize(HL3Vector4 v) {
	if (v.w == 0.0f || v.w == 1.0f) return v;
	GLfloat oow = 1.0f / v.w;
	return HL3Vector4Make(v.x * oow,
						  v.y * oow,
						  v.z * oow,
						  1.0f);
}

/**
 * Returns a HL3Vector structure constructed from a HL3Vector4. The HL3Vector4 is first
 * homogenized (via HL3Vector4Homogenize), before copying the resulting x, y & z
 * coordinates into the HL3Vector.
 */
static inline HL3Vector HL3VectorFromHomogenizedHL3Vector4(HL3Vector4 v) {
	return HL3VectorFromTruncatedHL3Vector4(HL3Vector4Homogenize(v));
}

/** Returns the result of scaling the original vector by the corresponding scale factor uniformly along all axes. */
static inline HL3Vector4 HL3Vector4ScaleUniform(HL3Vector4 v, GLfloat scale) {
	return HL3Vector4Make(v.x * scale,
						  v.y * scale,
						  v.z * scale,
						  v.w * scale);
}

/**
 * Returns the result of scaling the original vector by the corresponding scale
 * factor uniformly along the X, Y & Z axes. The W component is left unchanged.
 *
 * Use this method for scaling 4D homgeneous coordinates.
 */
static inline HL3Vector4 HL3Vector4HomogeneousScaleUniform(HL3Vector4 v, GLfloat scale) {
	return HL3Vector4Make(v.x * scale,
						  v.y * scale,
						  v.z * scale,
						  v.w);
}

/** Returns the dot-product of the two given vectors (v1 . v2). */
static inline GLfloat HL3Vector4Dot(HL3Vector4 v1, HL3Vector4 v2) {
	return	((v1.x * v2.x) +
			 (v1.y * v2.y) +
			 (v1.z * v2.z) +
			 (v1.w * v2.w));
}

/**
 * Returns the square of the scalar length of the specified vector from the origin, including
 * the w-component. This is calculated as (x*x + y*y + z*z + w*w) and will always be positive.
 *
 * This function is useful for comparing vector sizes without having to run an expensive
 * square-root calculation.
 */
static inline GLfloat HL3Vector4LengthSquared(HL3Vector4 v) { return HL3Vector4Dot(v, v); }

/**
 * Returns the scalar length of the specified vector from the origin, including the w-component
 * This is calculated as sqrt(x*x + y*y + z*z + w*w) and will always be positive.
 */
static inline GLfloat HL3Vector4Length(HL3Vector4 v) {
	// Avoid expensive sqrt calc if vector is unit length or zero
	GLfloat lenSq = HL3Vector4LengthSquared(v);
	return (lenSq == 1.0f || lenSq == 0.0f) ? lenSq : sqrtf(lenSq);
}

/** Returns a normalized copy of the specified vector so that its length is 1.0. The w-component is also normalized. */
static inline HL3Vector4 HL3Vector4Normalize(HL3Vector4 v) {
	GLfloat lenSq = HL3Vector4LengthSquared(v);
	if (lenSq == 0.0f || lenSq == 1.0f) return v;
	return HL3Vector4ScaleUniform(v, (1.0f / sqrtf(lenSq)));
}

/** Returns a vector that is the negative of the specified vector in all dimensions, including W. */
static inline HL3Vector4 HL3Vector4Negate(HL3Vector4 v) {
	return HL3Vector4Make(-v.x, -v.y, -v.z, -v.w);
}

/**
 * Returns a vector that is the negative of the specified homogeneous
 * vector in the X, Y & Z axes. The W component is left unchanged.
 */
static inline HL3Vector4 HL3Vector4HomogeneousNegate(HL3Vector4 v) {
	return HL3Vector4Make(-v.x, -v.y, -v.z, v.w);
}

/**
 * Returns the result of adding the two specified vectors, by adding the
 * corresponding components of both vectors.
 *
 * If one vector is a location (W=1) and the other is a direction (W=0),
 * this can be thought of as a translation of the location in that direction.
 */
static inline HL3Vector4 HL3Vector4Add(HL3Vector4 v, HL3Vector4 translation) {
	return HL3Vector4Make(v.x + translation.x,
						  v.y + translation.y,
						  v.z + translation.z,
						  v.w + translation.w);
}

/**
 * Returns the difference between two vectors, by subtracting the subtrahend from the
 * minuend, which is accomplished by subtracting each of the corresponding components.
 *
 * If both vectors are locations (W=1), the result will be a direction (W=0).
 */
static inline HL3Vector4 HL3Vector4Difference(HL3Vector4 minuend, HL3Vector4 subtrahend) {
	return HL3Vector4Make(minuend.x - subtrahend.x,
						  minuend.y - subtrahend.y,
						  minuend.z - subtrahend.z,
						  minuend.w - subtrahend.w);
}














