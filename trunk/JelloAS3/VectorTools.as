/*
Copyright (c) 2007 Walaber

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/


package JelloAS3 
{
	/**
	 * ...
	 * @author Luiz
	 */
	public class VectorTools
    {
        /// <summary>
        ///  rotate a vector by a given angle (in radians).
        /// </summary>
        /// <param name="vec">vector</param>
        /// <param name="angleRadians">angle in radians</param>
        /// <returns>rotated vector</returns>
        public static function rotateVector(vec:Vector2, angleRadians:Number) : Vector2
        {
            var ret:Vector2 = new Vector2();
			
            var c:Number = Math.cos(angleRadians);
            var s:Number = Math.sin(angleRadians);
			
            ret.X = (c * vec.X) - (s * vec.Y);
            ret.Y = (c * vec.Y) + (s * vec.X);
			
            return ret;
        }
		
        /// <summary>
        /// rotate a vector by a given angle (reference type version)
        /// </summary>
        /// <param name="vecIn">vector to rotate</param>
        /// <param name="angleRadians">angle in radians</param>
        /// <param name="vecOut">rotated vector</param>
        /*public static void rotateVector(ref Vector2 vecIn, float angleRadians, ref Vector2 vecOut)
        {
            float c = (float)Math.Cos(angleRadians);
            float s = (float)Math.Sin(angleRadians);
            vecOut.X = (c * vecIn.X) - (s * vecIn.Y);
            vecOut.Y = (c * vecIn.Y) + (s * vecIn.X);
        }
		
        /// <summary>
        /// rotate a given vector by a given angle (reference type version)
        /// </summary>
        /// <param name="vecIn">vector to rotate</param>
        /// <param name="angleRadians">angle in radians</param>
        /// <param name="vecOut">rotated vector</param>
        public static function rotateVector(vecInOut:Vector2, angleRadians:Number) : void
        {
            float originalX = vecInOut.X;
            float originalY = vecInOut.Y;
            float c = (float)Math.Cos(angleRadians);
            float s = (float)Math.Sin(angleRadians);
            vecInOut.X = (c * originalX) - (s * originalY);
            vecInOut.Y = (c * originalY) + (s * originalX);
        }*/
		
        /// <summary>
        ///  reflect a vector about a normal.  Normal must be a unit vector.
        /// </summary>
        /// <param name="V">vector</param>
        /// <param name="N">normal</param>
        /// <returns>reflected vector</returns>
        public static function reflectVector(V:Vector2, N:Vector2) : Vector2
        {
            var ret:Vector2 = V.minus(N.mult(2 * Vector2.Dot(V, N)));
            return ret;
        }
		
        /// <summary>
        /// reflect a vector about a normal.  Normal must be a unit vector.  (reference type version)
        /// </summary>
        /// <param name="V">vector in</param>
        /// <param name="N">normal</param>
        /// <param name="?">reflected vector out</param>
        /*public static function reflectVector(V:Vector2, N:Vector2, vOut:Vector2) : void
        {
            var dot:Number;
			
            Vector2.Dot(V, N, dot);
            vOut = V - (N * (2 * dot));
        }*/
		
        /// <summary>
        /// get a vector perpendicular to this vector.
        /// </summary>
        /// <param name="vec">vector</param>
        /// <returns>perpendicular vector</returns>
        public static function getPerpendicular1(vec:Vector2) : Vector2
        {
            return new Vector2(-vec.Y, vec.X);
        }
		
        /// <summary>
        /// get a vector perpendicular to this vector (reference type version)
        /// </summary>
        /// <param name="vIn">vector int</param>
        /// <param name="vOut">perpendicular vector out</param>
        public static function getPerpendicular(vIn:Vector2, vOut:Vector2) : void
        {
            vOut.X = -vIn.Y;
            vOut.Y = vIn.X;
        }
		
        /// <summary>
        /// make this vector perpendicular to itself
        /// </summary>
        /// <param name="vIn">vector in / out</param>
        public static function makePerpendicular(v:Vector2) : void
        {
            v.perpendicular();
        }
		
        /// <summary>
        /// is rotating from A to B Counter-clockwise?
        /// </summary>
        /// <param name="A">vector A</param>
        /// <param name="B">vector B</param>
        /// <returns>true = CCW or opposite (180 degrees), false = CW</returns>
        /*public static bool isCCW(Vector2 A, Vector2 B)
        {
            Vector2 perp = JelloPhysics.VectorTools.getPerpendicular(A);
            
			float dot;
			
            Vector2.Dot(B, perp, out dot);
            return (dot >= 0.0f);
        }*/
		
        /// <summary>
        /// is rotating from A to B Counter-Clockwise?
        /// </summary>
        /// <param name="A">vector A</param>
        /// <param name="B">vector B</param>
        /// <returns>true = CCW or opposite (180 degrees), false = CW</returns>
        public static function isCCW(A:Vector2, B:Vector2) : Boolean
        {
            var perp:Vector2 = new Vector2();
            VectorTools.getPerpendicular(A, perp);
            var dot:Number;
            
			dot = B.dot(perp);
			
            // Vector2.dot(B, perp, dot);
            return (dot >= 0.0);
        }
		
        /// <summary>
        /// turn a Vector2 into a Vector3 (sets Z component to zero) (reference type version)
        /// </summary>
        /// <param name="vec">input Vector2</param>
        /// <returns>result Vector3</returns>
        /*public static function vec3FromVec2(vec:Vector2) : Vector3
        {
            return new Vector3(vec.X, vec.Y, 0);
        }*/
		
        /// <summary>
        /// turn a Vector2 into a Vector3, specifying the Z component to use.
        /// </summary>
        /// <param name="vec">input Vector2</param>
        /// <param name="Z">Z component</param>
        /// <returns>result Vector3</returns>
        public static function vec3FromVec2(vec:Vector2, Z:Number = 0) : Vector3
        {
            return new Vector3(vec.X, vec.Y, Z);
        }
		
        /// <summary>
        /// see if 2 line segments intersect. (line AB collides with line CD)
        /// </summary>
        /// <param name="ptA">first point on line AB</param>
        /// <param name="ptB">second point on line AB</param>
        /// <param name="ptC">first point on line CD</param>
        /// <param name="ptD">second point on line CD</param>
        /// <param name="hitPt">resulting point of intersection</param>
        /// <param name="Ua">distance along AB to intersection [0,1]</param>
        /// <param name="Ub">distance along CD to intersection [0,1]</param>
        /// <returns>true / false</returns>
        /*public static bool lineIntersect(Vector2 ptA, Vector2 ptB, Vector2 ptC, Vector2 ptD, out Vector2 hitPt, out float Ua, out float Ub)
        {
            hitPt = Vector2.Zero;
            Ua = 0f;
            Ub = 0f;
			
            float denom = ((ptD.Y - ptC.Y) * (ptB.X - ptA.X)) - ((ptD.X - ptC.X) * (ptB.Y - ptA.Y));
			
            // if denom == 0, lines are parallel - being a bit generous on this one..
            if (Math.Abs(denom) < 0.000001f)
                return false;
				
            float UaTop = ((ptD.X - ptC.X) * (ptA.Y - ptC.Y)) - ((ptD.Y - ptC.Y) * (ptA.X - ptC.X));
            float UbTop = ((ptB.X - ptA.X) * (ptA.Y - ptC.Y)) - ((ptB.Y - ptA.Y) * (ptA.X - ptC.X));
			
            Ua = UaTop / denom;
            Ub = UbTop / denom;
			
            if ((Ua >= 0f) && (Ua <= 1f) && (Ub >= 0f) && (Ub <= 1f))
            {
                // these lines intersect!
                hitPt = ptA + ((ptB - ptA) * Ua);
                return true;
            }
			
            return false;
        }*/
		
        /// <summary>
        /// see if 2 line segments intersect. (line AB collides with line CD) (reference type version)
        /// </summary>
        /// <param name="ptA">first point on line AB</param>
        /// <param name="ptB">second point on line AB</param>
        /// <param name="ptC">first point on line CD</param>
        /// <param name="ptD">second point on line CD</param>
        /// <param name="hitPt">resulting point of intersection</param>
        /// <param name="Ua">distance along AB to intersection [0,1]</param>
        /// <param name="Ub">distance along CD to intersection [0,1]</param>
        /// <returns>true / false</returns>
		// TODO: Fix out those out parameters
        public static function lineIntersect(ptA:Vector2, ptB:Vector2, ptC:Vector2, ptD:Vector2, hitPt:Vector2, Ua:Array, Ub:Array) : Boolean
        {
            hitPt = Vector2.Zero;
            Ua[0] = 0.0;
            Ub[0] = 0.0;
			
            var denom:Number = ((ptD.Y - ptC.Y) * (ptB.X - ptA.X)) - ((ptD.X - ptC.X) * (ptB.Y - ptA.Y));
			
            // if denom == 0, lines are parallel - being a bit generous on this one..
            if ((denom < 0 ? - denom : denom) < 0.000001)
                return false;
			
            var UaTop:Number = ((ptD.X - ptC.X) * (ptA.Y - ptC.Y)) - ((ptD.Y - ptC.Y) * (ptA.X - ptC.X));
            var UbTop:Number = ((ptB.X - ptA.X) * (ptA.Y - ptC.Y)) - ((ptB.Y - ptA.Y) * (ptA.X - ptC.X));
			
            Ua[0] = UaTop / denom;
            Ub[0] = UbTop / denom;
			
            if ((Ua[0] >= 0) && (Ua[0] <= 1) && (Ub[0] >= 0) && (Ub[0] <= 1))
            {
                // these lines intersect!
                hitPt = ptA.plus(ptB.minus(ptA).mult(Ua[0]));
				
                return true;
            }
			
            return false;
        }
		
        /// <summary>
        /// see if 2 line segments intersect. (line AB collides with line CD) - simplified version
        /// </summary>
        /// <param name="ptA">first point on line AB</param>
        /// <param name="ptB">second point on line AB</param>
        /// <param name="ptC">first point on line CD</param>
        /// <param name="ptD">second point on line CD</param>
        /// <param name="hitPt">resulting point of intersection</param>
        /// <returns>true / false</returns>
        /*public static bool lineIntersect(Vector2 ptA, Vector2 ptB, Vector2 ptC, Vector2 ptD, out Vector2 hitPt)
        {
            float Ua;
            float Ub;
            return lineIntersect(ptA, ptB, ptC, ptD, out hitPt, out Ua, out Ub);
        }
		
        /// <summary>
        /// see if 2 line segments intersect. (line AB collides with line CD) - simplified version (reference type version)
        /// </summary>
        /// <param name="ptA">first point on line AB</param>
        /// <param name="ptB">second point on line AB</param>
        /// <param name="ptC">first point on line CD</param>
        /// <param name="ptD">second point on line CD</param>
        /// <param name="hitPt">resulting point of intersection</param>
        /// <returns>true / false</returns>
        public static bool lineIntersect(ref Vector2 ptA, ref Vector2 ptB, ref Vector2 ptC, ref Vector2 ptD, out Vector2 hitPt)
        {
            float Ua;
            float Ub;
            return lineIntersect(ref ptA, ref ptB, ref ptC, ref ptD, out hitPt, out Ua, out Ub);
        }*/
		
        /// <summary>
        /// calculate a spring force, given position, velocity, spring constant, and damping factor.
        /// </summary>
        /// <param name="posA">position of point A on spring</param>
        /// <param name="velA">velocity of point A on spring</param>
        /// <param name="posB">position of point B on spring</param>
        /// <param name="velB">velocity of point B on spring</param>
        /// <param name="springD">rest distance of the springs</param>
        /// <param name="springK">spring constant</param>
        /// <param name="damping">coefficient for damping</param>
        /// <returns>spring force Vector</returns>
        /*public static function calculateSpringForce(Vector2 posA, Vector2 velA, Vector2 posB, Vector2 velB, springD:Number, springK:Number, damping:Number) : Vector2
        {
            var BtoA:Vector2 = (posA - posB);
            float dist = BtoA.Length();
            if (dist > 0.0001f)
                BtoA /= dist;
            else
                BtoA = Vector2.Zero;
            
            dist = springD - dist;
			
            Vector2 relVel = velA - velB;
            float totalRelVel = Vector2.Dot(relVel, BtoA);
			
            return BtoA * ((dist * springK) - (totalRelVel * damping));  
        }*/
		
        /// calculate a spring force, given position, velocity, spring constant, and damping factor. (reference type version)
        /// @param posA position of point A on spring
        /// @param velA velocity of point A on spring
        /// @param posB position of point B on spring
        /// @param velB velocity of point B on spring
        /// @param springD rest distance of the springs
        /// @param springK spring constant
        /// @param damping coefficient for damping
        /// @param forceOut rsulting force Vector2
        public static function calculateSpringForce(posA:Vector2, velA:Vector2, posB:Vector2, velB:Vector2, springD:Number, springK:Number, damping:Number, forceOut:Vector2) : void
        {
            var BtoAX:Number = (posA.X - posB.X);
            var BtoAY:Number = (posA.Y - posB.Y);
			
            var dist:Number = Math.sqrt((BtoAX * BtoAX) + (BtoAY * BtoAY));
			
            if (dist > 0.0001)
            {
                BtoAX /= dist;
                BtoAY /= dist;
            }
            else
            {
                forceOut.X = 0;
                forceOut.Y = 0;
				
                return;
            }
			
            dist = springD - dist;
			
            var relVelX:Number = velA.X - velB.X;
            var relVelY:Number = velA.Y - velB.Y;
			
            var totalRelVel:Number = (relVelX * BtoAX) + (relVelY * BtoAY);
			
            forceOut.X = BtoAX * ((dist * springK) - (totalRelVel * damping));
            forceOut.Y = BtoAY * ((dist * springK) - (totalRelVel * damping));
        }
		
		public static function calculateSpringForceRet(posA:Vector2, velA:Vector2, posB:Vector2, velB:Vector2, springD:Number, springK:Number, damping:Number) : Vector2
        {
            var BtoAX:Number = (posA.X - posB.X);
            var BtoAY:Number = (posA.Y - posB.Y);
			
            var dist:Number = Math.sqrt((BtoAX * BtoAX) + (BtoAY * BtoAY));
			
            if (dist > 0.0001)
            {
                BtoAX /= dist;
                BtoAY /= dist;
            }
            else
            {
                return Vector2.Zero.clone();
            }
			
            dist = springD - dist;
			
            var relVelX:Number = velA.X - velB.X;
            var relVelY:Number = velA.Y - velB.Y;
			
            var totalRelVel:Number = (relVelX * BtoAX) + (relVelY * BtoAY);
			
			return new Vector2(BtoAX * ((dist * springK) - (totalRelVel * damping)), BtoAY * ((dist * springK) - (totalRelVel * damping)));
        }
    }
}