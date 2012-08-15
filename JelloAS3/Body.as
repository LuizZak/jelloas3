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
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Luiz
	 */
	public class Body
    {
        // PRIVATE VARIABLES
        protected var mBaseShape:ClosedShape;
        public var mGlobalShape:Vector.<Vector2>;
        public var mPointMasses:Vector.<PointMass>;
        protected var mScale:Vector2;
        protected var mDerivedPos:Vector2;
        protected var mDerivedVel:Vector2;
        protected var mDerivedAngle:Number;
        protected var mDerivedOmega:Number;
        protected var mLastAngle:Number;
        public var mAABB:AABB;
        protected var mMaterial:int;
        protected var mIsStatic:Boolean;
        protected var mKinematic:Boolean;
        protected var mObjectTag:*;
		
		public var mIsPined:Boolean = false;
		
        protected var mVelDamping:Number = 0.999;
		
        //// debug visualization variables
        // VertexDeclaration mVertexDecl = null;
        
		
        // INTERNAL VARIABLES
        internal var mBitMaskX:Bitmask = new Bitmask();
        internal var mBitMaskY:Bitmask = new Bitmask();
        
		
        // CONSTRUCTORS
		
		/// <summary>
        /// create a body, and set its shape and position immediately - with individual masses for each PointMass.
        /// </summary>
        /// <param name="w">world to add this body to (done automatically)</param>
        /// <param name="shape">closed shape for this body</param>
        /// <param name="pointMasses">list of masses for each PointMass</param>
        /// <param name="position">global position of the body</param>
        /// <param name="angleInRadians">global angle of the body</param>
        /// <param name="scale">local scale of the body</param>
        /// <param name="kinematic">whether this body is kinematically controlled.</param>
        public function Body(w:World, shape:ClosedShape, pointMasses:Array, position:Vector2, angleInRadians:Number, scale:Vector2, kinematic:Boolean) : void
        {
            mAABB = new AABB();
            mDerivedPos = position;
            mDerivedAngle = angleInRadians;
            mLastAngle = mDerivedAngle;
            mScale = scale;
            mMaterial = 0;
            mIsStatic = false;
            mKinematic = kinematic;
			
            mPointMasses = new Vector.<PointMass>();
            setShape(shape);
			
            for (var i:int = 0; i < mPointMasses.length; i++)
			{
                mPointMasses[i].Mass = pointMasses[i];
			}
				
            updateAABB(0, true);
			
			if(w != null)
			{
            	w.addBody(this);
			}
        }
		
        /// <summary>
        /// default constructor.
        /// </summary>
        /// <param name="w">world to add this body to (done automatically)</param>
        /*public function Body(w:World)
        {
            mAABB = new AABB();
            mBaseShape = null;
            mGlobalShape = null;
            mPointMasses = new List<PointMass>();
            mScale = Vector2.One;
            mIsStatic = false;
            mKinematic = false;
			
            mMaterial = 0;
			
            w.addBody(this);
        }
		
        /// <summary>
        /// create a body, and set its shape and position immediately
        /// </summary>
        /// <param name="w">world to add this body to (done automatically)</param>
        /// <param name="shape">closed shape for this body</param>
        /// <param name="massPerPoint">mass for each PointMass to be created</param>
        /// <param name="position">global position of the body</param>
        /// <param name="angleInRadians">global angle of the body</param>
        /// <param name="scale">local scale of the body</param>
        /// <param name="kinematic">whether this body is kinematically controlled</param>
        public Body(World w, ClosedShape shape, float massPerPoint, Vector2 position, float angleInRadians, Vector2 scale, bool kinematic)
        {
            mAABB = new AABB();
            mDerivedPos = position;
            mDerivedAngle = angleInRadians;
            mLastAngle = mDerivedAngle;
            mScale = scale;
            mMaterial = 0;
            mIsStatic = float.IsPositiveInfinity(massPerPoint);
            mKinematic = kinematic;
			
            mPointMasses = new List<PointMass>();
            setShape(shape);
            for (var i:int = 0; i < mPointMasses.length; i++)
                mPointMasses[i].Mass = massPerPoint;
				
            updateAABB(0f, true);
			
            w.addBody(this);
        }*/
        
		
        // SETTING SHAPE
        /// <summary>
        /// set the shape of this body to a new ClosedShape object.  This function 
        /// will remove any existing PointMass objects, and replace them with new ones IF
        /// the new shape has a different vertex count than the previous one.  In this case
        /// the mass for each newly added point mass will be set zero.  Otherwise the shape is just
        /// updated, not affecting the existing PointMasses.
        /// </summary>
        /// <param name="shape">new closed shape</param>
        public function setShape(shape:ClosedShape) : void
        {
            mBaseShape = shape;
			
            if (mBaseShape.Vertices.length != mPointMasses.length)
            {
                mPointMasses.length = 0;
				
                mGlobalShape = new Vector.<Vector2>();
				mGlobalShape.length = mBaseShape.Vertices.length;
                
                mBaseShape.transformVertices(mDerivedPos, mDerivedAngle, mScale, mGlobalShape);
				
				var count:int = mBaseShape.Vertices.length;
                for (var i:int = 0; i < count; i++)
				{
                    mPointMasses.push(new PointMass(0.0, mGlobalShape[i]));    
				}
            }
        }
        
		
        // SETTING MASS
        /// <summary>
        /// set the mass for each PointMass in this body.
        /// </summary>
        /// <param name="mass">new mass</param>
        public function setMassAll(mass:Number) : void
        {
			var count:int = mPointMasses.length;
            for (var i:int = 0; i < count; i++)
			{
                mPointMasses[i].Mass = mass;
			}
			
            if (Number.POSITIVE_INFINITY == mass) { mIsStatic = true; }
        }
		
        /// <summary>
        /// set the mass for each PointMass individually.
        /// </summary>
        /// <param name="index">index of the PointMass</param>
        /// <param name="mass">new mass</param>
        public function setMassIndividual(index:int, mass:Number) : void
        {
            if ((index >= 0) && (index < mPointMasses.length))
                mPointMasses[index].Mass = mass;
        }
		
        /// <summary>
        /// set the mass for all point masses from a list.
        /// </summary>
        /// <param name="masses">list of masses (count MUSE equal PointMasses.length)</param>
        public function setMassFromList(masses:Array) : void
        {
            if (masses.length == mPointMasses.length)
            {
                var count:int = mPointMasses.length;
            	for (var i:int = 0; i < count; i++)
				{
                    mPointMasses[i].Mass = masses[i];
				}
            }
        }
		
		
        // MATERIAL
        /// <summary>
        /// Material for this body.  Used for physical interaction and collision notification.
        /// </summary>
        public function get Material() : int 
        {
            return mMaterial;
        }
		
		public function set Material(value:int) : void
		{
			mMaterial = value;
		}
		
		
        // SETTING POSITION AND ANGLE MANUALLY
        /// <summary>
        /// Set the position and angle of the body manually.
        /// </summary>
        /// <param name="pos">global position</param>
        /// <param name="angleInRadians">global angle</param>
        public function setPositionAngle(pos:Vector2, angleInRadians:Number, scale:Vector2) : void
        {
			if(mGlobalShape == null)
			{
				mGlobalShape = new Vector.<Vector2>();
			}
			
            mBaseShape.transformVertices(pos == null ? mDerivedPos : pos, angleInRadians, scale == null ? new Vector2(1, 1) : scale, mGlobalShape);
			
			var p:PointMass;
			var v:Vector2;
			
			var count:int = mPointMasses.length;
            for (var i:int = 0; i < count; i++)
			{
				p = mPointMasses[i];
				v = mGlobalShape[i];
				
                p.PositionX = v.X;
				p.PositionY = v.Y;
			}
			
			if(pos != null)
            mDerivedPos = pos;
            mDerivedAngle = angleInRadians;
        }
		
        /// <summary>
        /// For moving a body kinematically.  sets the position in global space.  via shape-matching, the
        /// body will eventually move to this location.
        /// </summary>
        /// <param name="pos">position in global space.</param>
        public function setKinematicPosition(pos:Vector2) : void
        {
            mDerivedPos = pos;
        }
		
        /// <summary>
        /// For moving a body kinematically.  sets the angle in global space.  via shape-matching, the
        /// body will eventually rotate to this angle.
        /// </summary>
        /// <param name="angleInRadians"></param>
        public function setKinematicAngle(angleInRadians:Number) : void
        {
            mDerivedAngle = angleInRadians;
        }
		
        /// <summary>
        /// For changing a body kinematically.  via shape matching, the body will eventually
        /// change to the given scale.
        /// </summary>
        /// <param name="scale"></param>
        public function setKinematicScale(scale:Vector2) : void
        {
            mScale = scale;
        }
		
		
		// DERIVING POSITION AND VELOCITY
		
        /// Derive the global position and angle of this body, based on the average of all the points.
        /// This updates the DerivedPosision, DerivedAngle, and DerivedVelocity properties.
        /// This is called by the World object each Update(), so usually a user does not need to call this.  Instead
        /// you can juse access the DerivedPosition, DerivedAngle, DerivedVelocity, and DerivedOmega properties.
		/*public function derivePositionAndAngle(elaspsed:Number) : void
        {
            // no need it this is a static body, or kinematically controlled.
            if (mIsStatic || mKinematic)
                return;
				
            // find the geometric center.
            //var center:Vector2 = new Vector2();
			var centerX:Number = 0, centerY:Number = 0;
			
            //var vel:Vector2 = new Vector2();
			var velX:Number = 0, velY:Number = 0;
			
			var p:PointMass;
			
			var l:int = mPointMasses.length;
			
            for (var i:int = 0; i < l; i++)
            {
				p = mPointMasses[i];
				
                centerX += p.PositionX;
                centerY += p.PositionY;
				
                velX += p.VelocityX;
                velY += p.VelocityY;
            }
			
            centerX /= l;
            centerY /= l;
			
            velX /= l;
            velY /= l;
			
            mDerivedPos.setTo(centerX, centerY);
            mDerivedVel = new Vector2(velX, velY);
			
            // find the average angle of all of the masses.
            var angle:Number = 0;
            
			var originalSign:int = 1;
            var originalAngle:Number = 0;
			
            for (i = 0; i < l; i++)
            {
				p = mPointMasses[i];
				
                var baseNorm:Vector2 = new Vector2();
                baseNorm.X = mBaseShape.Vertices[i].X;
                baseNorm.Y = mBaseShape.Vertices[i].Y;
				
                Vector2.Normalize(baseNorm, baseNorm);
				
                var curNorm:Vector2 = new Vector2();
				
                curNorm.X = p.PositionX - mDerivedPos.X;
                curNorm.Y = p.PositionY - mDerivedPos.Y;
				
                // Vector2.Normalize(curNorm, curNorm);
				curNorm.normalizeThis();
				
                var dot:Number = Vector2.Dot(baseNorm, curNorm);
				
                if (dot > 1.0) { dot = 1.0; }
                if (dot < -1.0) { dot = -1.0; }
				
                var thisAngle:Number = Math.acos(dot);
				
                if (!VectorTools.isCCW(baseNorm, curNorm)) { thisAngle = -thisAngle; }
				
                if (i == 0)
                {
                    originalSign = (thisAngle >= 0.0) ? 1 : -1;
                    originalAngle = thisAngle;
                }
                else
                {
                    var diff:Number = (thisAngle - originalAngle);
                    var thisSign:int = (thisAngle >= 0.0) ? 1 : -1;
					
                    if (((diff < 0 ? -diff : diff) > Math.PI) && (thisSign != originalSign))
                    {
                        thisAngle = (thisSign == -1) ? (Math.PI + (Math.PI + thisAngle)) : ((Math.PI - thisAngle) - Math.PI);
                    }
                }
				
                angle += thisAngle;
            }
			
            angle /= l;
			
			trace(angle);
            mDerivedAngle = angle;
			
            // now calculate the derived Omega, based on change in angle over time.
            var angleChange:Number = (mDerivedAngle - mLastAngle);
			
            if ((angleChange < 0 ? -angleChange : angleChange) >= Math.PI)
            {
                if (angleChange < 0)
                    angleChange = angleChange + (Math.PI * 2);
                else
                    angleChange = angleChange - (Math.PI * 2);
            }
			
            mDerivedOmega = angleChange / elaspsed;
			
            mLastAngle = mDerivedAngle;
        }*/
        public function derivePositionAndAngle(elaspsed:Number) : void
        {
            // no need it this is a static body, or kinematically controlled.
            if (mIsStatic || mKinematic)
				return;
			
			// Temp variables
			var p:PointMass;
			
			// Precalculations
			var l:int = mPointMasses.length;
			var reverse_length:Number = 1.0 / l;
			
			if(!mIsPined)
			{
				// find the geometric center.
				//var center:Vector2 = new Vector2();
				var centerX:Number = 0, centerY:Number = 0;
				
				//var vel:Vector2 = new Vector2();
				var velX:Number = 0, velY:Number = 0;
				
				for (var i:int = 0; i < l; i++)
				{
					p = mPointMasses[i];
					
					centerX += p.PositionX;
					centerY += p.PositionY;
					
					velX += p.VelocityX;
					velY += p.VelocityY;
				}
				
				centerX *= reverse_length;
				centerY *= reverse_length;
				
				velX *= reverse_length;
				velY *= reverse_length;
				
				mDerivedPos.setTo(centerX, centerY);
            	mDerivedVel = new Vector2(velX, velY);
			}
			
            // find the average angle of all of the masses.
            var angle:Number = 0;
            
			var originalSign:int = 1;
            var originalAngle:Number = 0;
			
            for (i = 0; i < l; i++)
            {
				p = mPointMasses[i];
				
                var baseNorm:Vector2 = new Vector2(); var baseShapeVertice:Vector2 = mBaseShape.Vertices[i];
                baseNorm.X = baseShapeVertice.X;
                baseNorm.Y = baseShapeVertice.Y;
				
                //Vector2.Normalize(baseNorm, baseNorm);
				baseNorm.normalizeThis();
				
                var curNorm:Vector2 = new Vector2();
				
                curNorm.X = p.PositionX - mDerivedPos.X;
                curNorm.Y = p.PositionY - mDerivedPos.Y;
				
                // Vector2.Normalize(curNorm, curNorm);
				curNorm.normalizeThis();
				
                var dot:Number = Vector2.Dot(baseNorm, curNorm);
				
                if (dot > 1.0) { dot = 1.0; }
                if (dot < -1.0) { dot = -1.0; }
				
                var thisAngle:Number = Math.acos(dot);
				
                if (!VectorTools.isCCW(baseNorm, curNorm)) { thisAngle = -thisAngle; }
				
                if (i == 0)
                {
                    originalSign = (thisAngle >= 0.0) ? 1 : -1;
                    originalAngle = thisAngle;
                }
                else
                {
                    var diff:Number = (thisAngle - originalAngle);
                    var thisSign:int = (thisAngle >= 0.0) ? 1 : -1;
					
                    if (((diff < 0 ? -diff : diff) > Math.PI) && (thisSign != originalSign))
                    {
                        thisAngle = (thisSign == -1) ? (Math.PI + (Math.PI + thisAngle)) : ((Math.PI - thisAngle) - Math.PI);
                    }
                }
				
                angle += thisAngle;
            }
			
            angle /= l;
			
            mDerivedAngle = angle;
			
            // now calculate the derived Omega, based on change in angle over time.
            var angleChange:Number = (mDerivedAngle - mLastAngle);
			
            if ((angleChange < 0 ? -angleChange : angleChange) >= Math.PI)
            {
                if (angleChange < 0)
                    angleChange = angleChange + (Math.PI * 2);
                else
                    angleChange = angleChange - (Math.PI * 2);
            }
			
            mDerivedOmega = angleChange / elaspsed;
			
            mLastAngle = mDerivedAngle;
        }
		
        /// <summary>
        /// Derived position of the body in global space, based on location of all PointMasses.
        /// </summary>
        public function get DerivedPosition() : Vector2
        {
            return mDerivedPos;
        }
		
        /// <summary>
        /// Derived global angle of the body in global space, based on location of all PointMasses.
        /// </summary>
        public function get DerivedAngle() : Number
        {
            return mDerivedAngle;
        }
		
        /// <summary>
        /// Derived global velocity of the body in global space, based on velocity of all PointMasses.
        /// </summary>
        public function get DerivedVelocity() : Vector2
        {
            return mDerivedVel;
        }
		
        /// <summary>
        /// Derived rotational velocity of the body in global space, based on changes in DerivedAngle.
        /// </summary>
        public function DerivedOmega() : Number
        {
            return mDerivedOmega;
        }
		
        // ACCUMULATING FORCES - TO BE INHERITED!
        /// <summary>
        /// this function should add all internal forces to the Force member variable of each PointMass in the body.
        /// these should be forces that try to maintain the shape of the body.
        /// </summary>
        public function accumulateInternalForces() : void { }
		
        /// <summary>
        /// this function should add all external forces to the Force member variable of each PointMass in the body.
        /// these are external forces acting on the PointMasses, such as gravity, etc.
        /// </summary>
        public function accumulateExternalForces() : void { } 
		
        // INTEGRATION
        internal function integrate(elapsed:Number) : void
        {
            if (mIsStatic) { return; }
			
            var points_count:int = mPointMasses.length;
            for (var i:int = 0; i < points_count; i++)
			{
                mPointMasses[i].integrateForce(elapsed);
			}
        }
		
        internal function dampenVelocity() : void
        {
            if (mIsStatic) { return; }
			
            var points_count:int = mPointMasses.length;
            for (var i:int = 0; i < points_count; i++)
            {
				var p:PointMass = mPointMasses[i];
				
               	p.VelocityX *= mVelDamping;
                p.VelocityY *= mVelDamping;
            }
        }
		
        // HELPER FUNCTIONS
        /// <summary>
        /// update the AABB for this body, including padding for velocity given a timestep.
        /// This function is called by the World object on Update(), so the user should not need this in most cases.
        /// </summary>
        /// <param name="elapsed">elapsed time in seconds</param>
        public function updateAABB(elapsed:Number, forceUpdate:Boolean) : void
        {
            if ((!IsStatic) || (forceUpdate))
            {
                mAABB.clear();
				
                var points_count:int = mPointMasses.length;
                for (var i:int = 0; i < points_count; i++)
                {
					var p:PointMass = mPointMasses[i];
					
                    mAABB.expandToIncludePos(p.PositionX, p.PositionY);
					
					// expanding for velocity only makes sense for dynamic objects.
                    if (!IsStatic)
                    {
                        mAABB.expandToIncludePos(p.PositionX + (p.VelocityX * elapsed), p.PositionY + (p.VelocityY * elapsed));
                    }
                }
            }
        }
		
        /// <summary>
        /// get the Axis-aligned bounding box for this body.  used for broad-phase collision checks.
        /// </summary>
        /// <returns>AABB for this body</returns>
        public function getAABB() : AABB
        {
            return mAABB;
        }
		
        /// <summary>
        /// collision detection.  detect if a global point is inside this body.
        /// </summary>
        /// <param name="pt">point in global space</param>
        /// <returns>true = point is inside body, false = it is not.</returns>
        public function contains(ptX:Number, ptY:Number) : Boolean
        {
            // basic idea: draw a line from the point to a point known to be outside the body.  count the number of
            // lines in the polygon it intersects.  if that number is odd, we are inside.  if it's even, we are outside.
            // in this implementation we will always use a line that moves off in the positive X direction from the point
            // to simplify things.
            // var endPt:Vector2 = new Vector2();
            var endPtX:Number = mAABB.Max.X + 0.1;
            var endPtY:Number = ptY;
			
            // line we are testing against goes from pt -> endPt.
            var inside:Boolean = false;
            
			// var edgeSt:Vector2 = mPointMasses[0].Position.clone();
			
			var edgeStX:Number = mPointMasses[0].PositionX;
			var edgeStY:Number = mPointMasses[0].PositionY;
			
            var edgeEndX:Number = 0;
			var edgeEndY:Number = 0;
			
            var c:int = mPointMasses.length;
			
            for (var i:int = 0; i < c; i++)
            {
                // the current edge is defined as the line from edgeSt -> edgeEnd.
                if (i < (c - 1))
				{
                    edgeEndX = mPointMasses[i + 1].PositionX;
					edgeEndY = mPointMasses[i + 1].PositionY;
				}
				else
				{
                    edgeEndX = mPointMasses[0].PositionX;
					edgeEndY = mPointMasses[0].PositionY;
				}
				
                // perform check now...
                if (((edgeStY <= ptY) && (edgeEndY > ptY)) || ((edgeStY > ptY) && (edgeEndY <= ptY)))
                {
                    // this line crosses the test line at some point... does it do so within our test range?
                    var slope:Number = (edgeEndX - edgeStX) / (edgeEndY - edgeStY);
                    var hitX:Number = edgeStX + ((ptY - edgeStY) * slope);
					
                    if ((hitX >= ptX) && (hitX <= endPtX))
                        inside = !inside;
                }
                edgeStX = edgeEndX;
				edgeStY = edgeEndY;
            }
			
            return inside;
        }
		
		public function containsVec(pt:Vector2) : Boolean
        {
            // basic idea: draw a line from the point to a point known to be outside the body.  count the number of
            // lines in the polygon it intersects.  if that number is odd, we are inside.  if it's even, we are outside.
            // in this implementation we will always use a line that moves off in the positive X direction from the point
            // to simplify things.
            // var endPt:Vector2 = new Vector2();
            var endPtX:Number = mAABB.Max.X + 0.1;
            var endPtY:Number = pt.Y;
			
            // line we are testing against goes from pt -> endPt.
            var inside:Boolean = false;
            
			// var edgeSt:Vector2 = mPointMasses[0].Position.clone();
			
			var edgeStX:Number = mPointMasses[0].PositionX;
			var edgeStY:Number = mPointMasses[0].PositionY;
			
            var edgeEndX:Number = 0;
			var edgeEndY:Number = 0;
			
            var c:int = mPointMasses.length;
			
            for (var i:int = 0; i < c; i++)
            {
                // the current edge is defined as the line from edgeSt -> edgeEnd.
                if (i < (c - 1))
				{
                    edgeEndX = mPointMasses[i + 1].PositionX;
					edgeEndY = mPointMasses[i + 1].PositionY;
				}
				else
				{
                    edgeEndX = mPointMasses[0].PositionX;
					edgeEndY = mPointMasses[0].PositionY;
				}
				
                // perform check now...
                if (((edgeStY <= pt.Y) && (edgeEndY > pt.Y)) || ((edgeStY > pt.Y) && (edgeEndY <= pt.Y)))
                {
                    // this line crosses the test line at some point... does it do so within our test range?
                    var slope:Number = (edgeEndX - edgeStX) / (edgeEndY - edgeStY);
                    var hitX:Number = edgeStX + ((pt.Y - edgeStY) * slope);
					
                    if ((hitX >= pt.X) && (hitX <= endPtX))
                        inside = !inside;
                }
                edgeStX = edgeEndX;
				edgeStY = edgeEndY;
            }
			
            return inside;
        }
		
        /// <summary>
        /// collision detection - given a global point, find the point on this body that is closest to the global point,
        /// and if it is an edge, information about the edge it resides on.
        /// </summary>
        /// <param name="pt">global point</param>
        /// <param name="hitPt">returned point on the body in global space</param>
        /// <param name="normal">returned normal on the body in global space</param>
        /// <param name="pointA">returned ptA on the edge</param>
        /// <param name="pointB">returned ptB on the edge</param>
        /// <param name="edgeD">scalar distance between ptA and ptB [0,1]</param>
        /// <returns>distance</returns>
        public function getClosestPoint(pt:Vector2, hitPt:Vector2, normal:Vector2, pointA:Array, pointB:Array, edgeD:Array) : Number
        {
            // hitPt = Vector2.Zero.clone();
            pointA[0] = -1;
            pointB[0] = -1;
            edgeD[0] = 0;
            // normal = Vector2.Zero.clone();
			
            var closestD:Number = 1000.0;
			
            var points_count:int = mPointMasses.length;
            for (var i:int = 0; i < points_count; i++)
            {
                var tempHit:Vector2;
                var tempNorm:Vector2;
                var tempEdgeD:Array;
				
                var dist:Number = getClosestPointOnEdge(pt, i, tempHit, tempNorm, tempEdgeD);
				
                if (dist < closestD)
                {
                    closestD = dist;
                    pointA[0] = i;
					
                    if (i < (points_count - 1))
                        pointB[0] = i + 1;
                    else
                        pointB[0] = 0;
					
                    edgeD[0] = tempEdgeD[0];
                    normal.setToVec(tempNorm);
                    hitPt.setToVec(tempHit);
                }
            }
			
            // return.
            return closestD;
        }
		
        /// <summary>
        /// find the distance from a global point in space, to the closest point on a given edge of the body.
        /// </summary>
        /// <param name="pt">global point</param>
        /// <param name="edgeNum">edge to check against.  0 = edge from pt[0] to pt[1], etc.</param>
        /// <param name="hitPt">returned point on edge in global space</param>
        /// <param name="normal">returned normal on edge in global space</param>
        /// <param name="edgeD">returned distance along edge from ptA to ptB [0,1]</param>
        /// <returns>distance</returns>
		private var toP3:Vector3 = new Vector3();
		private var E3:Vector3 = new Vector3();
		private var toP:Vector2 = new Vector2();
		private var E:Vector2 = new Vector2();
		private var n:Vector2 = new Vector2();
        public function getClosestPointOnEdge(pt:Vector2, edgeNum:int, hitPt:Vector2, normal:Vector2, edgeD:Array) : Number
        {
            /*hitPt = new Vector2();
            hitPt.X = 0;
            hitPt.Y = 0;
			
            normal = new Vector2();
            normal.X = 0;
            normal.Y = 0;*/
			
            edgeD[0] = 0.0;
            var dist:Number = 0.0;
			
            // var ptA:Vector2 = mPointMasses[edgeNum].Position.clone();
			
			var ptAX:Number = mPointMasses[edgeNum].PositionX;
			var ptAY:Number = mPointMasses[edgeNum].PositionY;
			
            var ptBX:Number = 0;
			var ptBY:Number = 0;
			
            if (edgeNum < (mPointMasses.length - 1))
			{
                ptBX = mPointMasses[edgeNum + 1].PositionX;
				ptBY = mPointMasses[edgeNum + 1].PositionY;
			}
            else
			{
                ptBX = mPointMasses[0].PositionX;
				ptBY = mPointMasses[0].PositionY;
			}
            
            toP.X = pt.X - ptAX;
            toP.Y = pt.Y - ptAY;
			
            E.X = ptBX - ptAX;
            E.Y = ptBY - ptAY;
			
            // get the length of the edge, and use that to normalize the vector.
            var edgeLength:Number = Math.sqrt((E.X * E.X) + (E.Y * E.Y));
			
            if (edgeLength > 0.00001)
            {
                E.X /= edgeLength;
                E.Y /= edgeLength;
            }
			
            // normal
            n.setTo(0, 0);
            VectorTools.getPerpendicular(E, n);
			
            // calculate the distance!
            var x:Number;
            x = Vector2.Dot(toP, E);
			
            if (x <= 0.0)
            {
                // x is outside the line segment, distance is from pt to ptA.
                //dist = (pt - ptA).Length();
                dist = Vector2.Distance(pt, new Vector2(ptAX, ptAY));
				
                hitPt.setTo(ptAX, ptAY);
                edgeD[0] = 0.0;
                normal.setToVec(n);
			}
            else if (x >= edgeLength)
            {
                // x is outside of the line segment, distance is from pt to ptB.
                //dist = (pt - ptB).Length();
                dist = Vector2.Distance(pt, new Vector2(ptBX, ptBY));
				
                hitPt.setTo(ptBX, ptBY);
                edgeD[0] = 1.0;
                normal.X = n.X;
				normal.Y = n.Y;
            }
            else
            {
                // point lies somewhere on the line segment.
                toP3.X = toP.X;
                toP3.Y = toP.Y;
                
                E3.X = E.X;
                E3.Y = E.Y;
				
                //dist = Math.Abs(Vector3.Cross(toP3, E3).Z);
                Vector3.Cross(toP3, E3, E3);
                
				//dist = (E3.Z < 0.0 ? -E3.Z : E3.Z);
				dist = E3.Z;
				
                hitPt.X = ptAX + (E.X * x);
                hitPt.Y = ptAY + (E.Y * x);
                edgeD[0] = x / edgeLength;
                
				normal.setToVec(n);
            }
			
            return dist;
        }
		
        /// <summary>
        /// find the squared distance from a global point in space, to the closest point on a given edge of the body.
        /// </summary>
        /// <param name="pt">global point</param>
        /// <param name="edgeNum">edge to check against.  0 = edge from pt[0] to pt[1], etc.</param>
        /// <param name="hitPt">returned point on edge in global space</param>
        /// <param name="normal">returned normal on edge in global space</param>
        /// <param name="edgeD">returned distance along edge from ptA to ptB [0,1]</param>
        /// <returns>distance</returns>
        public function getClosestPointOnEdgeSquared(ptX:Number, ptY:Number, edgeNum:int, hitPt:Vector2, normal:Vector2, edgeD:Array) : Number
        {
            edgeD[0] = 0;
            var dist:Number = 0;
			
			var p:PointMass = mPointMasses[edgeNum];
			
			var ptAX:Number = p.PositionX;
			var ptAY:Number = p.PositionY;
			
            var ptBX:Number = 0;
			var ptBY:Number = 0;
			
            if (edgeNum < (mPointMasses.length - 1))
			{
				p = mPointMasses[edgeNum + 1];
				
                ptBX = p.PositionX;
				ptBY = p.PositionY;
			}
            else
			{
				p = mPointMasses[0];
				
                ptBX = p.PositionX;
				ptBY = p.PositionY;
			}
			
            toP.X = ptX - ptAX;
            toP.Y = ptY - ptAY;
			
            E.X = ptBX - ptAX;
            E.Y = ptBY - ptAY;
			
            // get the length of the edge, and use that to normalize the vector.
            var edgeLength:Number = Math.sqrt((E.X * E.X) + (E.Y * E.Y));
			
            if (edgeLength > 0.0000001)
            {
                E.X /= edgeLength;
                E.Y /= edgeLength;
            }
			
            // normal
            //var n:Vector2 = new Vector2();
            // VectorTools.getPerpendicular(E, n);
			
			/*n.X = -E.Y;
			n.Y = E.X;*/
			
			var nX:Number = -E.Y;
			var nY:Number = E.X;
			
            // calculate the distance!
            var x:Number;
            x = Vector2.Dot(toP, E);
			
            if (x <= 0.0)
            {
				//trace(1);
                // x is outside the line segment, distance is from pt to ptA.
                //dist = (pt - ptA).Length();
                //dist = Vector2.DistanceSquared(new Vector2(ptX, ptY), new Vector2(ptAX, ptAY));
				dist = (ptX - ptAX) * (ptX - ptAX) + (ptY - ptAY) * (ptY - ptAY);
				
                //hitPt.setTo(ptAX, ptAY);
				hitPt.X = ptAX;
				hitPt.Y = ptAY;
				
                edgeD[0] = 0;
				
                //normal.setToVec(n);
				normal.X = nX;
				normal.Y = nY;
            }
            else if (x >= edgeLength)
            {
				//trace(2);
                // x is outside of the line segment, distance is from pt to ptB.
                //dist = (pt - ptB).Length();
                dist = Vector2.DistanceSquared(new Vector2(ptX, ptY), new Vector2(ptBX, ptBY));
				
                //hitPt.setTo(ptBX, ptBY);
				hitPt.X = ptBX;
				hitPt.Y = ptBY;
				
                edgeD[0] = 1;
                
				//normal.setToVec(n);
				normal.X = nX;
				normal.Y = nY;
            }
            else
            {
				//trace(3);
                // point lies somewhere on the line segment.
                toP3.X = toP.X;
                toP3.Y = toP.Y;
				
                E3.X = E.X;
                E3.Y = E.Y;
				
                //dist = Math.Abs(Vector3.Cross(toP3, E3).Z);
                Vector3.Cross(toP3, E3, E3);
				
                dist = E3.Z * E3.Z;
				
                hitPt.X = ptAX + (E.X * x);
                hitPt.Y = ptAY + (E.Y * x);
                edgeD[0] = x / edgeLength;
				
				normal.X = nX;
				normal.Y = nY;
            }
			
			//trace(dist);
			
            return dist;
        }
		
        /// <summary>
        /// Find the closest PointMass in this body, givena global point.
        /// </summary>
        /// <param name="pos">global point</param>
        /// <param name="dist">returned dist</param>
        /// <returns>index of the PointMass</returns>
        public function getClosestPointMass(pos:Vector2, dist:Array) : int
        {
            var closestSQD:Number = 100000.0;
            var closest:int = -1;

            var points_count:int = mPointMasses.length;
            for (var i:int = 0; i < points_count; i++)
            {
				var p:PointMass = mPointMasses[i];
				
                // var thisD:Number = (pos.minus(mPointMasses[i].Position)).length();
				var dx:Number = pos.X - p.PositionX;
				var dy:Number = pos.Y - p.PositionY;
				
				var thisD:Number = dx * dx + dy * dy;
				
                if (thisD < closestSQD)
                {
                    closestSQD = thisD;
                    closest = i;
                }
            }
			
            dist[0] = Math.sqrt(closestSQD);
			
            return closest;
        }
		
        /// <summary>
        /// Number of PointMasses in the body
        /// </summary>
        public function get PointMassCount() : int
        {
            return mPointMasses.length;
        }
		
        /// <summary>
        /// Get a specific PointMass from this body.
        /// </summary>
        /// <param name="index">index</param>
        /// <returns>PointMass</returns>
        public function getPointMass(index:int) : PointMass
        {
            return mPointMasses[index];
        }
		
        /// <summary>
        /// Helper function to add a global force acting on this body as a whole.
        /// </summary>
        /// <param name="pt">location of force, in global space</param>
        /// <param name="force">direction and intensity of force, in global space</param>
		private static var tempR:Vector2 = new Vector2();
		private static var tempV1:Vector3 = new Vector3();
		private static var tempV2:Vector3 = new Vector3();
        public function addGlobalForce(pt:Vector2, force:Vector2) : void
        {
			tempR = (mDerivedPos.minus(pt));
            
			tempV1.fromVector2(tempR);
			tempV2.fromVector2(force);
			var torqueF:Number = Vector3.Cross2Z(tempV1, tempV2);
			
            for (var i:int = 0; i < mPointMasses.length; i++)
            {
                // var toPt:Vector2 = (mPointMasses[i].Position.clone().minus(mDerivedPos));
				
				var m:PointMass = mPointMasses[i];
				
				var toPt:Vector2 = new Vector2(m.PositionX - mDerivedPos.X, m.PositionY - mDerivedPos.Y);
				
                var torque:Vector2 = VectorTools.rotateVector(toPt, -(Math.PI) * 0.5);
				
                m.ForceX += torque.X * torqueF;//.plusEquals(torque.mult(torqueF));
				m.ForceY += torque.Y * torqueF;
				
                // mPointMasses[i].Force(force);
				
				m.ForceX += force;
				m.ForceY += force;
            }
        }
        
        // DEBUG VISUALIZATION
        /// <summary>
        /// This function draws the points to the screen as lines, showing several things:
        /// WHITE - actual PointMasses, connected by lines
        /// GREY - baseshape, at the derived position and angle.
        /// </summary>
        /// <param name="device">graphics device</param>
        /// <param name="effect">effect to use (MUST implement VertexColors)</param>
        public function debugDrawMe(g:Graphics) : void
        {
			// Temp vars
			var gs_count = mGlobalShape.length;
			var pm_count = mPointMasses.length;
			
			var s:Vector2 = RenderingSettings.Scale;
			var p:Vector2 = RenderingSettings.Offset;
			
			mBaseShape.transformVertices(mDerivedPos, mDerivedAngle, mScale, mGlobalShape);
			
			for (i = 0; i < gs_count; i++)
			{
				mGlobalShape[i].X = mGlobalShape[i].X * s.X + p.X;
				mGlobalShape[i].Y = mGlobalShape[i].Y * s.Y + p.Y;
			}
			
			// Draw body original shape
			
			g.lineStyle(0, 0x808080);
			g.moveTo(mGlobalShape[0].X, mGlobalShape[0].Y);
			
            for (var i:int = 0; i < gs_count; i++)
            {
				g.lineTo(mGlobalShape[i].X, mGlobalShape[i].Y);
            }
			
			g.lineTo(mGlobalShape[0].X, mGlobalShape[0].Y);
			
			
			// Draw body outline
			
			g.lineStyle(0, 0xFFFFFF);
			g.moveTo(mPointMasses[0].PositionX * s.X + p.X, mPointMasses[0].PositionY * s.Y + p.Y);
			
			for (i = 0; i < pm_count; i++)
            {
				g.lineTo(mPointMasses[i].PositionX * s.X + p.X, mPointMasses[i].PositionY * s.Y + p.Y);
            }
			g.lineTo(mPointMasses[0].PositionX * s.X + p.X, mPointMasses[0].PositionY * s.Y + p.Y);
			
			for (i = 0; i < pm_count; i++)
            {
				g.lineStyle(0, 0, 0);
				
				g.beginFill(0xFFFFFF);
				
				g.drawRect(mPointMasses[i].PositionX * s.X + p.X - RenderingSettings.PointSize, mPointMasses[i].PositionY * s.Y + p.Y - RenderingSettings.PointSize,
						   RenderingSettings.PointSize * 2, RenderingSettings.PointSize * 2);
				
				g.endFill();
			}
			
			
			// UP and LEFT vectors.
			
			g.lineStyle(0, 0xFF4500);
			
			g.moveTo(mDerivedPos.X * s.X + p.X, mDerivedPos.Y * s.Y + p.Y);
			var v:Vector2 = mDerivedPos.plus(VectorTools.rotateVector(new Vector2(0, 1), mDerivedAngle));
			g.lineTo(v.X * s.X + p.X, v.Y * s.Y + p.Y);
			
			
			g.lineStyle(0, 0x9ACD32);
			
			g.moveTo(mDerivedPos.X * s.X + p.X, mDerivedPos.Y * s.Y + p.Y);
			v = 		    mDerivedPos.plus(VectorTools.rotateVector(new Vector2(1, 0), mDerivedAngle));
			g.lineTo(v.X * s.X + p.X, v.Y * s.Y + p.Y);
			
			// Center vector
			g.lineStyle(0, 0, 0);
			g.beginFill(0xCD5C5C, 1);
			
			g.drawRect(mDerivedPos.X * s.X + p.X - RenderingSettings.PointSize, mDerivedPos.Y * s.Y + p.Y - RenderingSettings.PointSize,
					   RenderingSettings.PointSize * 2,  RenderingSettings.PointSize * 2);
			
			g.endFill();
        }
		
        /// <summary>
        /// Draw the AABB for this body, for debug purposes.
        /// </summary>
        /// <param name="device">graphics device</param>
        /// <param name="effect">effect to use (MUST implement VertexColors)</param>
        public function debugDrawAABB(g:Graphics) : void
        {
            var box:AABB = getAABB();
			
			g.lineStyle(0, 0x708090);
			
			var s:Vector2 = RenderingSettings.Scale;
			var p:Vector2 = RenderingSettings.Offset;
			
			g.drawRect(box.Min.X * s.X + p.X, box.Min.Y * s.Y + p.Y, (box.Max.X - (box.Min.X)) * s.X, (box.Max.Y - box.Min.Y) * s.Y);
        }
		
        // PUBLIC PROPERTIES
        /// <summary>
        /// Gets / Sets whether this is a static body.  setting static greatly improves performance on static bodies.
        /// </summary>
        public function get IsStatic() : Boolean
        {
            return mIsStatic;
        }
		
		public function set IsStatic(value:Boolean) : void
		{
			mIsStatic = value;	
		}
		
        /// <summary>
        /// Sets whether this body is kinematically controlled.  kinematic control requires shape-matching forces to work properly.
        /// </summary>
        public function get IsKinematic() : Boolean
        {
            return mKinematic;
        }
		public function set IsKinematic(value:Boolean) : void
		{
			mKinematic = value;
		}
		
        public function get VelocityDamping() : Number
        {
            return mVelDamping;
        }
		public function set VelocityDamping(value:Number) : void
		{
			mVelDamping = value;
		}
		
		public function get ObjectTag() : *
		{
			return mObjectTag;
		}
		public function set ObjectTag(value:*) : void
        {
			mObjectTag = value;
        }
    }
}