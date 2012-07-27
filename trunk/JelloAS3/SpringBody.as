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
	public class SpringBody extends Body
    {
        // PRIVATE VARIABLES
        protected var mSprings:Vector.<InternalSpring>;
		
        // shape-matching spring constants.
        public var mShapeMatchingOn:Boolean = true;
        public var mEdgeSpringK:Number;
        public var mEdgeSpringDamp:Number;
        public var mShapeSpringK:Number;
        public var mShapeSpringDamp:Number;
        
        //// debug visualization variables
        // VertexDeclaration mVertexDecl = null;
		
        // CONSTRUCTORS
        /// <summary>
        /// Create a Springbody with shape matching set to OFF.
        /// </summary>
        /// <param name="w">World to add this body to.</param>
        /// <param name="shape">ClosedShape shape for this body</param>
        /// <param name="massPerPoint">mass per PointMass.</param>
        /// <param name="edgeSpringK">spring constant for edges.</param>
        /// <param name="edgeSpringDamp">spring damping for edges</param>
        /// <param name="pos">global position of the body</param>
        /// <param name="angleinRadians">global angle of the body</param>
        /// <param name="scale">scale</param>
        /// <param name="kinematic">kinematic control boolean</param>
        /*public function SpringBody(w:World, shape:ClosedShape, massPerPoint:Number, edgeSpringK:Number, edgeSpringDamp:Number, pos:Vector2, angleinRadians:Number, scale:Vector2, kinematic:Boolean) : void
//             : base(w, shape, massPerPoint, pos, angleinRadians, scale, kinematic)
        {
			super(w, shape, massPerPoint, pos, angleinRadians, scale, kinematic);
			
            mShapeMatchingOn = false;
            mSprings = new List<InternalSpring>();
			
            base.setPositionAngle(pos, angleinRadians, scale);
			
            mEdgeSpringK = edgeSpringK;
            mEdgeSpringDamp = edgeSpringDamp;
            mShapeSpringK = 0.0f;
            mShapeSpringDamp = 0.0f;
			
            // build default springs.
            _buildDefaultSprings();
        }*/
		
        // <summary>
        /// Create a SpringBody with shape matching turned ON.
        /// </summary>
        /// <param name="w"></param>
        /// <param name="shape">ClosedShape shape for this body</param>
        /// <param name="massPerPoint">mass per PointMass.</param>
        /// <param name="shapeSpringK">shape-matching spring constant</param>
        /// <param name="shapeSpringDamp">shape-matching spring damping</param>
        /// <param name="edgeSpringK">spring constant for edges.</param>
        /// <param name="edgeSpringDamp">spring damping for edges</param>
        /// <param name="pos">global position</param>
        /// <param name="angleinRadians">global angle</param>
        /// <param name="scale">scale</param>
        /// <param name="kinematic">kinematic control boolean</param>
        public function SpringBody(w:World, shape:ClosedShape, massPerPoint:Number, shapeSpringK:Number, shapeSpringDamp:Number, edgeSpringK:Number, edgeSpringDamp:Number, pos:Vector2, angleinRadians:Number, scale:Vector2, kinematic:Boolean)
        {
			super(w, shape, Utils.fillArray(massPerPoint, shape.mLocalVertices.length), pos, angleinRadians, scale, kinematic);
			
            mSprings = new Vector.<InternalSpring>();
			
            super.setPositionAngle(pos, angleinRadians, scale);
            
            mShapeMatchingOn = true;
            mShapeSpringK = shapeSpringK;
            mShapeSpringDamp = shapeSpringDamp;
            mEdgeSpringK = edgeSpringK;
            mEdgeSpringDamp = edgeSpringDamp;
			
            // build default springs.
            _buildDefaultSprings();
        }
		
        // SPRINGS
        /// <summary>
        /// Add an internal spring to this body.
        /// </summary>
        /// <param name="pointA">point mass on 1st end of the spring</param>
        /// <param name="pointB">point mass on 2nd end of the spring</param>
        /// <param name="springK">spring constant</param>
        /// <param name="damping">spring damping</param>
        public function addInternalSpring(pointA:int, pointB:int, springK:Number, damping:Number) : void
        {
            // var dist:Number = mPointMasses[pointB].Position.minus(mPointMasses[pointA].Position).magnitude();
			
			var dx:Number = mPointMasses[pointB].PositionX - mPointMasses[pointA].PositionX;
			var dy:Number = mPointMasses[pointB].PositionY - mPointMasses[pointA].PositionY;
			
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			
            var s:InternalSpring = new InternalSpring(pointA, pointB, dist, springK, damping);
			
            mSprings.push(s);
        }
		
        /// <summary>
        /// Clear all springs from the body.
        /// </summary>
        /// <param name="k"></param>
        /// <param name="damp"></param>
        public function clearAllSprings() : void
        {
            mSprings.length = 0;
			
            _buildDefaultSprings();
        }
		
        private function _buildDefaultSprings() : void
        {
            for (var i:int = 0; i < mPointMasses.length; i++)
            {
                if (i < (mPointMasses.length - 1))
                    addInternalSpring(i, i + 1, mEdgeSpringK, mEdgeSpringDamp);
                else
                    addInternalSpring(i, 0, mEdgeSpringK, mEdgeSpringDamp);
            }
        }
		
        // SHAPE MATCHING
        /// <summary>
        /// Set shape-matching on/off.
        /// </summary>
        /// <param name="onoff">boolean</param>
        public function setShapeMatching(onoff:Boolean) : void { mShapeMatchingOn = onoff; }
		
        /// <summary>
        /// Set shape-matching spring constants.
        /// </summary>
        /// <param name="springK">spring constant</param>
        /// <param name="damping">spring damping</param>
        public function setShapeMatchingConstants(springK:Number, damping:Number) : void { mShapeSpringK = springK; mShapeSpringDamp = damping; }
		
        // ADJUSTING EDGE VALUES
        /// <summary>
        /// Change the spring constants for the springs around the shape itself (edge springs)
        /// </summary>
        /// <param name="edgeSpringK">spring constant</param>
        /// <param name="edgeSpringDamp">spring damping</param>
        public function setEdgeSpringConstants(edgeSpringK:Number, edgeSpringDamp:Number) : void
        {
            // we know that the first n springs in the list are the edge springs.
            for (var i:int = 0; i < mPointMasses.length; i++)
            {
                mSprings[i].springK = edgeSpringK;
                mSprings[i].damping = edgeSpringDamp;
            }
        }
		
        // ADJUSTING SPRING VALUES
        public function setSpringConstants(springID:int, springK:Number, springDamp:Number) : void
        {
            // index is for all internal springs, AFTER the default internal springs.
            var index:int = mPointMasses.length + springID;
			
            mSprings[index].springK = springK;
            mSprings[index].damping = springDamp;
        }
		
        public function getSpringK(springID:int) : Number
        {
            var index:int = mPointMasses.length + springID;
			
            return mSprings[index].springK;
        }
		
        public function getSpringDamping(springID:int) : Number
        {
            var index:int = mPointMasses.length + springID;
			
            return mSprings[index].damping;
        }
		
        // ACCUMULATING FORCES
        public override function accumulateInternalForces() : void
        {
            super.accumulateInternalForces();
			
            // internal spring forces.
            var force:Vector2 = new Vector2();
			
            for (var i:int = 0; i < mSprings.length; i++)
            {
                var s:InternalSpring = mSprings[i];
				
				var p1:PointMass = mPointMasses[s.pointMassA];
				var p2:PointMass = mPointMasses[s.pointMassB];
				
                VectorTools.calculateSpringForceNum(p1.PositionX, p1.PositionY,
													p1.VelocityX, p1.VelocityY,
													p2.PositionX, p2.PositionY,
													p2.VelocityX, p2.VelocityY,
													s.springD, s.springK, s.damping, force);
					
                p1.ForceX += force.X;
                p1.ForceY += force.Y;
				
                p2.ForceX -= force.X;
                p2.ForceY -= force.Y;
            }
			
            // shape matching forces.
            if (mShapeMatchingOn)
            {
                mBaseShape.transformVertices(mDerivedPos, mDerivedAngle, mScale, mGlobalShape);
				
                for (i = 0; i < mPointMasses.length; i++)
                {
					var p:PointMass = mPointMasses[i];
					
                    if (mShapeSpringK > 0)
                    {
                        if (!mKinematic)
                        {
                            VectorTools.calculateSpringForceNum(p.PositionX, p.PositionY, 
																p.VelocityX, p.VelocityY,
																mGlobalShape[i].X, mGlobalShape[i].Y,
																p.VelocityX, p.VelocityY,
																0.0, mShapeSpringK, mShapeSpringDamp, force);
                        }
                        else
                        {
                            // var kinVel:Vector2 = Vector2.Zero.clone();
							
                            VectorTools.calculateSpringForceNum(p.PositionX, p.PositionY,
																p.VelocityX, p.VelocityY,
																mGlobalShape[i].X, mGlobalShape[i].Y,
																0, 0,
																0.0, mShapeSpringK, mShapeSpringDamp, force);
                        }
						
                        p.ForceX += force.X;
                        p.ForceY += force.Y;
                    }
                }
            }
        }
		
		// DEBUG VISUALIZATION
        public override function debugDrawMe(g:Graphics) : void
        {
            /*if (mVertexDecl == null)
            {
                mVertexDecl = new VertexDeclaration(device, VertexPositionColor.VertexElements);
            }
            
            // now draw the goal positions.
            VertexPositionColor[] shape = new VertexPositionColor[mPointMasses.Count * 2];
            VertexPositionColor[] springs = new VertexPositionColor[mSprings.Count * 2];*/
			
			var s:Vector2 = RenderingSettings.Scale;
			var p:Vector2 = RenderingSettings.Offset;
			
			g.lineStyle(0, 0, 0);
			
            for (var i:int = 0; i < mPointMasses.length; i++)
            {
				//g.beginFill(0x7CFC00);
				
				var x:Number = mPointMasses[i].PositionX// - RenderingSettings.PointSize / 2;
				var y:Number = mPointMasses[i].PositionY// - RenderingSettings.PointSize / 2;
				var w:Number = RenderingSettings.PointSize * 2;
				var h:Number = RenderingSettings.PointSize * 2;
				
				//g.drawRect(x * s.X + p.X - RenderingSettings.PointSize, y * s.Y + p.Y - RenderingSettings.PointSize, w, h);
				
				//g.endFill();
				
				g.beginFill(0x808080);
				
				x = mGlobalShape[i].X;
				y = mGlobalShape[i].Y;
				w = RenderingSettings.PointSize * 2;
				h = RenderingSettings.PointSize * 2;
				
				g.drawRect(x * s.X + p.X - RenderingSettings.PointSize, y * s.Y + p.Y - RenderingSettings.PointSize, w, h);
				
				g.endFill();
				
				g.lineStyle(1, 0x808080);
				
				g.moveTo(x * s.X + p.X, y * s.Y + p.Y);
				
				g.lineTo(mPointMasses[i].PositionX * s.X + p.X, mPointMasses[i].PositionY * s.Y + p.Y);
            }
			
            for (i = 0; i < mSprings.length; i++)
            {
				g.lineStyle(0, 0x7CFC00);
				
				g.moveTo(mPointMasses[mSprings[i].pointMassA].PositionX * s.X + p.X, mPointMasses[mSprings[i].pointMassA].PositionY * s.Y + p.Y);
				g.lineTo(mPointMasses[mSprings[i].pointMassB].PositionX * s.X + p.X, mPointMasses[mSprings[i].pointMassB].PositionY * s.Y + p.Y);
            }
			
            /*device.VertexDeclaration = mVertexDecl;
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                device.DrawUserPrimitives<VertexPositionColor>(PrimitiveType.LineList, shape, 0, mPointMasses.Count);
                device.DrawUserPrimitives<VertexPositionColor>(PrimitiveType.LineList, springs, 0, mSprings.Count);
                pass.End();
            }
            effect.End();*/
			
			super.debugDrawMe(g);
        }
    }
}