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
	import JelloAS3.*;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Luiz
	 */
	public class World
    {
        // PUBLIC VARIABLES
        /// <summary>
        /// Collision Filter type. return TRUE to allow collision, FALSE to ignore collision.
        /// </summary>
        /// <param name="bodyA">The colliding body</param>
        /// <param name="bodyApm">Point mass that has collided</param>
        /// <param name="bodyB">Body that bodyA collided with</param>
        /// <param name="bodyBpm1">PointMass 1 on the edge that was collided with</param>
        /// <param name="bodyBpm2">PointMass 2 on the edge that was collided with</param>
        /// <param name="hitPt">Location of collision in global space</param>
        /// <param name="normalVel">Velocity along normal of collision.</param>
        /// <returns>TRUE = accept collision, FALSE = ignore collision</returns>
		
        // public function collisionFilter( Body bodyA, int bodyApm, Body bodyB, int bodyBpm1, int bodyBpm2, Vector2 hitPt, float normalVel )
		
		public var collisionFilter:Function;

        /// <summary>
        /// number of materials created.
        /// </summary>
        public function get MaterialCount() : int
        {
            return mMaterialCount;
        }

        // PRIVATE VARIABLES
        private var mBodies:Vector.<Body>;
        private var mWorldLimits:AABB;
        private var mWorldSize:Vector2;
        private var mWorldGridStep:Vector2;

        private var mPenetrationThreshold:Number;
        private var mPenetrationCount:int;

        // material chart.
        private var mMaterialPairs:Array;
        private var mDefaultMatPair:MaterialPair;
        private var mMaterialCount:int;

        private var mCollisionList:Vector.<BodyCollisionInfo>;
		
        //// debug visualization variables
        // var mVertexDecl:VertexDeclaration = null;

        // CONSTRUCTOR
        /// <summary>
        /// Creates the World object, and sets world limits to default (-20,-20) to (20,20).
        /// </summary>
        public function World() : void
        {
            mBodies = new Vector.<Body>();
            mCollisionList = new Vector.<BodyCollisionInfo>();
			
            // initialize materials.
            mMaterialCount = 1;
            mMaterialPairs = new Array();
			mMaterialPairs.length = 1;
			mMaterialPairs[0] = new Array();
			mMaterialPairs[0].length = 1;
			
			mDefaultMatPair = new MaterialPair();
            mDefaultMatPair.Friction = 0.3;
            mDefaultMatPair.Elasticity = 0.2;
            mDefaultMatPair.Collide = true;
            mDefaultMatPair.CollisionFilter = this.defaultCollisionFilter;
            
            mMaterialPairs[0][0] = mDefaultMatPair.clone();

            var min:Vector2 = new Vector2(-20.0, -20.0);
            var max:Vector2 = new Vector2(20.0, 20.0);
			
            setWorldLimits(min, max);

            mPenetrationThreshold = 0.3;
        }

        // WORLD SIZE
        public function setWorldLimits(min:Vector2, max:Vector2) : void
        {
            mWorldLimits = new AABB(min, max);
			
			mWorldSize = new Vector2();
            mWorldSize.setToVec(max.minus(min));
			
			mWorldGridStep = new Vector2();
            mWorldGridStep.setToVec(mWorldSize.div(32));
        }
        

        // MATERIALS
        /// <summary>
        /// Add a new material to the world.  all previous material data is kept intact.
        /// </summary>
        /// <returns>int ID of the newly created material</returns>
        public function addMaterial() : int
        {
            var old:Array = mMaterialPairs.slice();
            mMaterialCount++;
			
            mMaterialPairs = new Array();
			mMaterialPairs.length = mMaterialCount;
			
            // replace old data.
            for (var i:int = 0; i < mMaterialCount; i++)
            {
				mMaterialPairs[i] = new Array();
				mMaterialPairs.length = mMaterialCount;
				
                for (var j:int = 0; j < mMaterialCount; j++)
                {
                    if ((i < (mMaterialCount-1)) && (j < (mMaterialCount-1)))
                        mMaterialPairs[i][j] = old[i][j];
                    else
                        mMaterialPairs[i][j] = mDefaultMatPair.clone();
                }
            }
			
            return mMaterialCount - 1;
        }

        /// <summary>
        /// Enable or Disable collision between 2 materials.
        /// </summary>
        /// <param name="a">material ID A</param>
        /// <param name="b">material ID B</param>
        /// <param name="collide">true = collide, false = ignore collision</param>
        public function setMaterialPairCollide(a:int, b:int, collide:Boolean) : void
        {
            if ((a >= 0) && (a < mMaterialCount) && (b >= 0) && (b < mMaterialCount))
            {
                mMaterialPairs[a][b].Collide = collide;
                mMaterialPairs[b][a].Collide = collide;
            }
        }

        /// <summary>
        /// Set the collision response variables for a pair of materials.
        /// </summary>
        /// <param name="a">material ID A</param>
        /// <param name="b">material ID B</param>
        /// <param name="friction">friction.  [0,1] 0 = no friction, 1 = 100% friction</param>
        /// <param name="elasticity">"bounce" [0,1] 0 = no bounce (plastic), 1 = 100% bounce (super ball)</param>
        public function setMaterialPairData(a:int, b:int, friction:Number, elasticity:Number) : void
        {
            if ((a >= 0) && (a < mMaterialCount) && (b >= 0) && (b < mMaterialCount))
            {
                mMaterialPairs[a][b].Friction = friction;
                mMaterialPairs[a][b].Elasticity = elasticity;
				
                mMaterialPairs[b][a].Friction = friction;
                mMaterialPairs[b][a].Elasticity = elasticity;
            }
        }

        /// <summary>
        /// Sets a user function to call when 2 bodies of the given materials collide.
        /// </summary>
        /// <param name="a">Material A</param>
        /// <param name="b">Material B</param>
        /// <param name="filter">User fuction (delegate)</param>
        public function setMaterialPairFilterCallback(a:int, b:int, filter:Function) : void
        {
            if ((a >= 0) && (a < mMaterialCount) && (b >= 0) && (b < mMaterialCount))
            {
                mMaterialPairs[a][b].CollisionFilter = filter;
				
                mMaterialPairs[b][a].CollisionFilter = filter;
            }
        }
        

        // ADDING / REMOVING BODIES
        /// <summary>
        /// Add a Body to the world.  Bodies do this automatically, you should NOT need to call this.
        /// </summary>
        /// <param name="b">the body to add to the world</param>
        public function addBody(b:Body) : void
        {
            if (mBodies.indexOf(b) == -1)
            {
                mBodies.push(b);
            }
        }

        /// <summary>
        /// Remove a body from the world.  call this outside of an update to remove the body.
        /// </summary>
        /// <param name="b">the body to remove</param>
        public function removeBody(b:Body) : void
        {
            if (mBodies.indexOf(b) != -1)
            {
                mBodies.splice(mBodies.indexOf(b), 1);
            }
        }

        /// <summary>
        /// Get a body at a specific index.
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        public function getBody(index:int) : Body
        {
            if ((index >= 0) && (index < mBodies.length))
                return mBodies[index];

            return null;
        }
        

        // BODY HELPERS
        /// <summary>
        /// Find the closest PointMass in the world to a given point.
        /// </summary>
        /// <param name="pt">global point</param>
        /// <param name="bodyID">index of the body that contains the PointMass</param>
        /// <param name="pmID">index of the PointMass</param>
        public function getClosestPointMass(pt:Vector2, bodyID:Array, pmID:Array) : void
        {
            bodyID[0] = -1;
            pmID[0] = -1;
			
            var closestD:Number = 1000.0;
            for (var i:int = 0; i < mBodies.length; i++)
            {
                var dist:Array = [0];
				
                var pm:int = mBodies[i].getClosestPointMass(pt, dist);
                if (dist[0] < closestD)
                {
                    closestD = dist[0];
                    bodyID[0] = i;
                    pmID[0] = pm;
                }
            }
        }

        /// <summary>
        /// Given a global point, get a body (if any) that contains this point.
        /// Useful for picking objects with a cursor, etc.
        /// </summary>
        /// <param name="pt">global point</param>
        /// <returns>Body (or null)</returns>
        public function getBodyContaining(pt:Vector2) : Body
        {
            for (var i:int = 0; i < mBodies.length; i++)
            {
                if (mBodies[i].containsVec(pt))
                    return mBodies[i];
            }
			
            return null;
        }
        
		
        // UPDATE
        /// <summary>
        /// Update the world by a specific timestep.
        /// </summary>
        /// <param name="elapsed">elapsed time in seconds</param>
        public function update(elapsed:Number) : void
        {
            mPenetrationCount = 0;
			
			var body_count:int = mBodies.length;
			var body1:Body;
			
            // first, accumulate all forces acting on PointMasses.
            /*for (var i:int = 0; i < mBodies.length; i++)
            {
				body1 = mBodies[i];
				
                body1.derivePositionAndAngle(elapsed);
                body1.accumulateExternalForces();
                body1.accumulateInternalForces();
            }*/
			
            // now integrate.
            // for (i = 0; i < mBodies.length; i++)
                // mBodies[i].integrate(elapsed);
			
            // update all bounding boxes, and then bitmasks.
            for (var i:int = 0; i < body_count; i++)
            {
				// Everything's in one single loop, now:
				
				body1 = mBodies[i];
				
				body1.derivePositionAndAngle(elapsed);
                body1.accumulateExternalForces();
                body1.accumulateInternalForces();
				
				body1.integrate(elapsed);
				
				body1.updateAABB(elapsed, false);
				updateBodyBitmask(body1);
            }
			
            // now check for collision.
            // inter-body collision!
            for (i = 0; i < body_count; i++)
            {
				body1 = mBodies[i];
				
                for (var j:int = i + 1; j < body_count; j++)
                {
					var body2:Body = mBodies[j];
					
					// another early-out - both bodies are static.
                    if ((body1.IsStatic) && (body2.IsStatic))
                        continue;
					
					// grid-based early out.
                    if (((body1.mBitMaskX.mask & body2.mBitMaskX.mask) == 0) && 
                        ((body1.mBitMaskY.mask & body2.mBitMaskY.mask) == 0))
                        continue;
					
                    // early out - these bodies materials are set NOT to collide
                    if (!mMaterialPairs[body1.Material][body2.Material].Collide)
                        continue;
					
                    // broad-phase collision via AABB.
                    // early out
					if(!body1.mAABB.intersects(body2.mAABB))
                        continue;
					
                    // okay, the AABB's of these 2 are intersecting.  now check for collision of A against B.
                    bodyCollide(body1, body2, mCollisionList);
					
                    // and the opposite case, B colliding with A
                    bodyCollide(body2, body1, mCollisionList);
                }
            }
			
            // now handle all collisions found during the update at once.
            _handleCollisions();

            // now dampen velocities.
            for (i = 0; i < body_count; i++)
                mBodies[i].dampenVelocity();
        }

        private function updateBodyBitmask(body:Body) : void
        {
            var box:AABB = body.mAABB;
			
			var rev_DividerX:Number = 1.0 / mWorldGridStep.X;
			var rev_DividerY:Number = 1.0 / mWorldGridStep.Y;
			
            var minX:int = ((box.Min.X - mWorldLimits.Min.X) * rev_DividerX) << 0;
            var maxX:int = ((box.Max.X - mWorldLimits.Min.X) * rev_DividerX) << 0;
			
            if (minX < 0) { minX = 0; } else if (minX > 32) { minX = 32; }
            if (maxX < 0) { maxX = 0; } else if (maxX > 32) { maxX = 32; }
			
            var minY:int = ((box.Min.Y - mWorldLimits.Min.Y) * rev_DividerY) << 0;
            var maxY:int = ((box.Max.Y - mWorldLimits.Min.Y) * rev_DividerY) << 0;
			
            if (minY < 0) { minY = 0; } else if (minY > 32) { minY = 32; }
            if (maxY < 0) { maxY = 0; } else if (maxY > 32) { maxY = 32; }
			
            body.mBitMaskX.clear();
			
            for (var i:int = minX; i <= maxX; i++)
                body.mBitMaskX.setOn(i);
				
            body.mBitMaskY.clear();
			
            for (i = minY; i <= maxY; i++)
                body.mBitMaskY.setOn(i);
				
            //Console.WriteLine("Body bitmask: minX{0} maxX{1} minY{2} maxY{3}", minX, maxX, minY, minY, maxY);
        }
        
		private var fromPrev:Vector2 = new Vector2();
		private var toNext:Vector2 = new Vector2();
		private var ptNorm:Vector2 = new Vector2();
		private var hitPt:Vector2 = new Vector2();
		private var norm:Vector2 = new Vector2();
		
        // COLLISION CHECKS / RESPONSE
        private function bodyCollide(bA:Body, bB:Body, infoList:Vector.<BodyCollisionInfo>) : void
        {
            var bApCount:int = bA.mPointMasses.length;
            var bBpCount:int = bB.mPointMasses.length;
			
            var boxB:AABB = bB.getAABB();
			
            // check all PointMasses on bodyA for collision against bodyB.  if there is a collision, return detailed info.
            var infoAway:BodyCollisionInfo = new BodyCollisionInfo();
            var infoSame:BodyCollisionInfo = new BodyCollisionInfo();
			
            for (var i:int = 0; i < bApCount; i++)
            {
                // var pt:Vector2 = bA.getPointMass(i).Position.clone();
				
				var ptX:Number = bA.mPointMasses[i].PositionX;
				var ptY:Number = bA.mPointMasses[i].PositionY;
				
                // early out - if this point is outside the bounding box for bodyB, skip it!
                if (!boxB.contains(ptX, ptY))
                    continue;
					
                // early out - if this point is not inside bodyB, skip it!
                if (!bB.contains(ptX, ptY))
                    continue;
					
                var prevPt:int = (i > 0) ? i - 1 : bApCount - 1;
                var nextPt:int = (i < bApCount - 1) ? i + 1 : 0;
				
                // var prev:Vector2 = bA.getPointMass(prevPt).Position.clone();
				var prevX:Number = bA.mPointMasses[prevPt].PositionX;
				var prevY:Number = bA.mPointMasses[prevPt].PositionY;
				
                // var next:Vector2 = bA.getPointMass(nextPt).Position.clone();
				var nextX:Number = bA.mPointMasses[nextPt].PositionX;
				var nextY:Number = bA.mPointMasses[nextPt].PositionY;
				
                // now get the normal for this point. (NOT A UNIT VECTOR)
				
                fromPrev.X = ptX - prevX;
                fromPrev.Y = ptY - prevY;
				
                toNext.X = nextX - ptX;
                toNext.Y = nextY - ptY;
				
                ptNorm.X = fromPrev.X + toNext.X;
                ptNorm.Y = fromPrev.Y + toNext.Y;
				
                // VectorTools.makePerpendicular(ptNorm);
				ptNorm = ptNorm.perpendicular();
				
				// var fromPrev:Vector2 = new Vector2();
                /*var fromPrevX:Number = ptX - prevX;
                var fromPrevY:Number = ptY - prevY;
				
                // var toNext:Vector2 = new Vector2();
                var toNextX:Number = nextX - ptX;
                var toNextY:Number = nextY - ptY;
				
                // var ptNorm:Vector2 = new Vector2();
                var ptNormX:Number = -(fromPrevY + toNextY);
                var ptNormY:Number = fromPrevX + toNextX;*/
				
                // VectorTools.makePerpendicular(ptNorm);
				// ptNorm.perpendicular();
                
                // this point is inside the other body.  now check if the edges on either side intersect with and edges on bodyB.          
                var closestAway:Number = Number.POSITIVE_INFINITY;
                var closestSame:Number = Number.POSITIVE_INFINITY;
				
                infoAway.Clear();
                infoAway.bodyA = bA;
                infoAway.bodyApm = i;
                infoAway.bodyB = bB;
				
                infoSame.Clear();
                infoSame.bodyA = bA;
                infoSame.bodyApm = i;
                infoSame.bodyB = bB;
				
                var found:Boolean = false;
				
                var b1:int = 0;
                var b2:int = 1;
				
                for (var j:int = 0; j < bBpCount; j++)
                {
                    var edgeD:Number;
					
                    b1 = j;
					
					b2 = (j + 1) % (bBpCount);
						
                    // var pt1:Vector2 = bB.getPointMass(b1).Position.clone();
					var pt1X:Number = bB.mPointMasses[b1].PositionX;
					var pt1Y:Number = bB.mPointMasses[b1].PositionY;
					
                    // var pt2:Vector2 = bB.getPointMass(b2).Position.clone();
					var pt2X:Number = bB.mPointMasses[b2].PositionX;
					var pt2Y:Number = bB.mPointMasses[b2].PositionY;
					
                    // quick test of distance to each point on the edge, if both are greater than current mins, we can skip!
					var dx1:Number = (pt1X - ptX);
					var dy1:Number = (pt1Y - ptY);
					var dx2:Number = (pt2X - ptX);
					var dy2:Number = (pt2Y - ptY);
                    var distToA:Number = (dx1 * dx1) + (dy1 * dy1);
                    var distToB:Number = (dx2 * dx2) + (dy2 * dy2);
					
                   	if ((distToA > closestAway) && (distToA > closestSame) && (distToB > closestAway) && (distToB > closestSame))
					{
                    	continue;
					}
					
					var e:Array = [0];
					
                    // test against this edge.
                    var dist:Number = bB.getClosestPointOnEdgeSquared(ptX, ptY, j, hitPt, norm, e);
					edgeD = e[0];
					
                    // only perform the check if the normal for this edge is facing AWAY from the point normal.
                    var dot:Number;
                    //Vector2.Dot(ptNorm, edgeNorm, out dot);
                    dot = Vector2.Dot(ptNorm, norm);
					
					//trace(hitPt, Math.sqrt(dist));
					
                    if (dot <= 0.0)
                    {
                        if (dist < closestAway)
                        {
                            closestAway = dist;
							
                            infoAway.bodyBpmA = b1;
                            infoAway.bodyBpmB = b2;
                            infoAway.edgeD = edgeD;
							infoAway.hitPt.setToVec(hitPt);
							infoAway.normal.setToVec(norm);
                            infoAway.penetration = dist;
							
                            found = true;
                        }
                    }
                    else
                    {
                        if (dist < closestSame)
                        {
                            closestSame = dist;
							
                            infoSame.bodyBpmA = b1;
                            infoSame.bodyBpmB = b2;
                            infoSame.edgeD = edgeD;
							infoSame.hitPt.setToVec(hitPt);
							infoSame.normal.setToVec(norm);
                            infoSame.penetration = dist;
                        }
                    }
                }
				
                // we've checked all edges on BodyB.  add the collision info to the stack.
                if ((found) && (closestAway > mPenetrationThreshold) && (closestSame < closestAway))
                {
                    infoSame.penetration = Math.sqrt(infoSame.penetration);
                    infoList.push(infoSame.clone());
                }
                else
                {
                    infoAway.penetration = Math.sqrt(infoAway.penetration);
                    infoList.push(infoAway.clone());
                }
            }
        }
		
		private var tangent:Vector2 = new Vector2();
		private var numV:Vector2 = new Vector2();
		private function _handleCollisions() : void
        {
			// Let's cache this guy for speed
			var infinity:Number = Number.POSITIVE_INFINITY;
			
            // handle all collisions!
            var collisions_count:int = mCollisionList.length;
            for (var i:int = 0; i < collisions_count; i++)
            {
                //BodyCollisionInfo info = mCollisionList[i];
				var info:BodyCollisionInfo = mCollisionList[i];
				
                var A:PointMass = info.bodyA.getPointMass(info.bodyApm);
                var B1:PointMass = info.bodyB.getPointMass(info.bodyBpmA);
                var B2:PointMass = info.bodyB.getPointMass(info.bodyBpmB);

                // velocity changes as a result of collision.
                // var bVel:Vector2 = new Vector2();
				
                var bVelX:Number = (B1.VelocityX + B2.VelocityX) * 0.5;
                var bVelY:Number = (B1.VelocityY + B2.VelocityY) * 0.5;

                var relVel:Vector2 = new Vector2(A.VelocityX - bVelX, A.VelocityY - bVelY);
                /*relVel.X = A.VelocityX - bVelX;
                relVel.Y = A.VelocityY - bVelY;*/
				
                var relDot:Number = Vector2.Dot(relVel, info.normal);

                // collision filter!
                // if (!mMaterialPairs[info.bodyA.Material, info.bodyB.Material].CollisionFilter(info.bodyA, info.bodyApm, info.bodyB, info.bodyBpmA, info.bodyBpmB, info.hitPt, relDot))
                   //  continue;
				   
				if (!mMaterialPairs[info.bodyA.Material][info.bodyB.Material].CollisionFilter(info.bodyA, info.bodyApm, info.bodyB, info.bodyBpmA, info.bodyBpmB, info.hitPt, relDot))
                     continue;
				
                if (info.penetration > mPenetrationThreshold)
                {
                    //Console.WriteLine("penetration above Penetration Threshold!!  penetration={0}  threshold={1} difference={2}",
                    //    info.penetration, mPenetrationThreshold, info.penetration-mPenetrationThreshold);
					
                    mPenetrationCount++;
					
                    continue;
                }

                var b1inf:Number = 1.0 - info.edgeD;
                var b2inf:Number = info.edgeD;

                var b2MassSum:Number = ((infinity == (B1.Mass)) || (infinity == (B2.Mass))) ? infinity : (B1.Mass + B2.Mass);

                var massSum:Number = A.Mass + b2MassSum;
                
                var Amove:Number;
                var Bmove:Number;
				
                if (infinity == A.Mass)
                {
                    Amove = 0.0;
                    Bmove = (info.penetration) + 0.001;
                }
                else if (infinity == b2MassSum)
                {
                    Amove = (info.penetration) + 0.001;
                    Bmove = 0.0;
                }
                else
                {
                    /*Amove = (info.penetration * (b2MassSum / massSum));
                    Bmove = (info.penetration * (A.Mass / massSum));*/
					var rev_massSum:Number = 1.0 / massSum;
                    Amove = (info.penetration * (b2MassSum * rev_massSum));
                    Bmove = (info.penetration * (A.Mass * rev_massSum));
                }

                var B1move:Number = Bmove * b1inf;
                var B2move:Number = Bmove * b2inf;

                var AinvMass:Number = (infinity == A.Mass) ? 0 : 1.0 / A.Mass;
                var BinvMass:Number = (infinity == b2MassSum) ? 0 : 1.0 / b2MassSum;

                var jDenom:Number = AinvMass + BinvMass;
                var elas:Number = 1 + mMaterialPairs[info.bodyA.Material][info.bodyB.Material].Elasticity;
				//var numV:Vector2 = new Vector2(relVel.X * elas, relVel.Y * elas);
				numV.setTo(relVel.X * elas, relVel.Y * elas);
				
				var rev_jDenom = 1 / jDenom;
                var j:Number = -Vector2.Dot(numV, info.normal) * rev_jDenom;
				var infoNormal:Vector2 = info.normal;

                if (infinity != A.Mass && b2MassSum == infinity)
                {
                    A.PositionX += infoNormal.X * Amove;
                    A.PositionY += infoNormal.Y * Amove;
                }

                if (infinity != B1.Mass)
                {
                   	B1.PositionX -= infoNormal.X * B1move;
                    B1.PositionY -= infoNormal.Y * B1move;
                }

                if (infinity != B2.Mass)
                {
                    B2.PositionX -= infoNormal.X * B2move;
                    B2.PositionY -= infoNormal.Y * B2move;
                }
                
				VectorTools.getPerpendicular(info.normal, tangent);
				
                var friction:Number = mMaterialPairs[info.bodyA.Material][info.bodyB.Material].Friction;
                var f:Number = (Vector2.Dot(relVel, tangent) * friction) * rev_jDenom;
				
				var jMult:Number = 0;
				var fMult:Number = 0;
				
                // adjust velocity if relative velocity is moving toward each other.
                if (relDot <= 0.0001)
                {
                    if (infinity != A.Mass)
                    {
						var rev_AMass:Number = 1 / A.Mass;
						jMult = j * rev_AMass;
						fMult = f * rev_AMass;
						
						A.VelocityX += (info.normal.X * jMult) - (tangent.X * fMult);
                        A.VelocityY += (info.normal.Y * jMult) - (tangent.Y * fMult);
                    }

                    if (infinity != b2MassSum)
                    {
						jMult = j / b2MassSum;
						fMult = f / b2MassSum;
						
                        B1.VelocityX -= (info.normal.X * jMult * b1inf) - (tangent.X * fMult * b1inf);
                        B1.VelocityY -= (info.normal.Y * jMult * b1inf) - (tangent.Y * fMult * b1inf);
						
                        B2.VelocityX -= (info.normal.X * jMult * b2inf) - (tangent.X * fMult * b2inf);
                        B2.VelocityY -= (info.normal.Y * jMult * b2inf) - (tangent.Y * fMult * b2inf);
                    }
                }
            }
			
			mCollisionList.length = 0;
        }
		
        // DEBUG VISUALIZATION
        /// <summary>
        /// draw the world extents on-screen.
        /// </summary>
        /// <param name="device">Graphics Device</param>
        /// <param name="effect">An Effect to draw the lines with (should implement vertex color diffuse)</param>
        public function debugDrawMe(g:Graphics) : void
        {
            /*if (mVertexDecl == null)
            {
                mVertexDecl = new VertexDeclaration(device, VertexPositionColor.VertexElements);
            }
			
            // draw the world limits.
            VertexPositionColor[] limits = new VertexPositionColor[5];
			
            limits[0].Position = new Vector3(mWorldLimits.Min.X, mWorldLimits.Max.Y, 0);
            limits[0].Color = Color.SlateGray;
			
            limits[1].Position = new Vector3(mWorldLimits.Max.X, mWorldLimits.Max.Y, 0);
            limits[1].Color = Color.SlateGray;
			
            limits[2].Position = new Vector3(mWorldLimits.Max.X, mWorldLimits.Min.Y, 0);
            limits[2].Color = Color.SlateGray;
			
            limits[3].Position = new Vector3(mWorldLimits.Min.X, mWorldLimits.Min.Y, 0);
            limits[3].Color = Color.SlateGray;
			
            limits[4].Position = new Vector3(mWorldLimits.Min.X, mWorldLimits.Max.Y, 0);
            limits[4].Color = Color.SlateGray;
			
            device.VertexDeclaration = mVertexDecl;
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                device.DrawUserPrimitives<VertexPositionColor>(PrimitiveType.LineStrip, limits, 0, 4);
                pass.End();
            }
            effect.End();*/
        }
		
        /// <summary>
        /// draw the velocities of all PointMasses in the simulation on-screen in an orange/yellow color.
        /// </summary>
        /// <param name="device">GraphicsDevice</param>
        /// <param name="effect">An Effect to draw the lines with</param>
        public function debugDrawPointVelocities(g:Graphics) : void
        {
            /*if (mVertexDecl == null)
            {
                mVertexDecl = new VertexDeclaration(device, VertexPositionColor.VertexElements);
            }
			
            for (var i:int = 0; i < mBodies.length; i++)
            {
                VertexPositionColor[] vels = new VertexPositionColor[mBodies[i].PointMas.length * 2];
				
                for (var pm:int = 0; pm < mBodies[i].PointMas.length; pm++)
                {
                    vels[(pm * 2) + 0].Position = VectorTools.vec3FromVec2(mBodies[i].getPointMass(pm).Position);
                    vels[(pm * 2) + 0].Color = Color.Yellow;
                    vels[(pm * 2) + 1].Position = VectorTools.vec3FromVec2(mBodies[i].getPointMass(pm).Position + (mBodies[i].getPointMass(pm).Velocity * 0.25));
                    vels[(pm * 2) + 1].Color = Color.Orange;
                }
				
                effect.Begin();
                foreach (EffectPass pass in effect.CurrentTechnique.Passes)
                {
                    pass.Begin();
                    device.DrawUserPrimitives<VertexPositionColor>(PrimitiveType.LineList, vels, 0, mBodies[i].PointMas.length);
                    pass.End();
                }
                effect.End();
            }*/
        }
		
        private function defaultCollisionFilter(A:Body, Apm:int, B:Body, Bpm1:int, Bpm2:int, hitPt:Vector2, normSpeed:Number) : Boolean
        {
            return true;
        }
		
        /// <summary>
        /// Draw all of the bodies in the world in debug mode, for quick visualization of the entire scene.
        /// </summary>
        /// <param name="device">GraphicsDevice</param>
        /// <param name="effect">An Effect to draw the lines with</param>
        /// <param name="drawAABBs"></param>
        public function debugDrawAllBodies(g:Graphics, drawAABBs:Boolean) : void
        {
            for (var i:int = 0; i < mBodies.length; i++)
            {
                if (drawAABBs)
                    mBodies[i].debugDrawAABB(g);
				
                mBodies[i].debugDrawMe(g);
            }
        }
		
        // PUBLIC PROPERTIES
        /// <summary>
        /// This threshold allows objects to be crushed completely flat without snapping through to the other side of objects.
        /// It should be set to a value that is slightly over half the average depth of an object for best results.  Defaults to 0.5.
        /// </summary>
        public function get PenetrationThreshold() : Number
        {
			return mPenetrationThreshold;
        }
		
		public function set PenetrationThreshold(value:Number) : void
		{
			mPenetrationThreshold = value;
		}
		
        /// <summary>
        /// How many collisions exceeded the Penetration Threshold last update.  if this is a high number, you can assume that
        /// the simulation has "broken" (one or more objects have penetrated inside each other).
        /// </summary>
        public function get PenetrationCount() : int
        {
            return mPenetrationCount;
        }
    }
}