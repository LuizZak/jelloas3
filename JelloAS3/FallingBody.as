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


package JelloAS3 {
	
	public class FallingBody extends SpringBody {

		public function FallingBody(w:World, s:ClosedShape, massPerPoint:Number, edgeSpringK:Number, edgeSpringDamp:Number, pos:Vector2, angle:Number, scale:Vector2)
        {
			// base(w, s, massPerPoint, edgeSpringK, edgeSpringDamp, pos, angle, scale, false);
			// w:World, shape:ClosedShape, pointMasses:Array, position:Vector2, angleInRadians:Number, scale:Vector2, kinematic:Boolean
			
			super(w, s, massPerPoint, 0, 0, edgeSpringK, edgeSpringDamp, pos, angle, scale, false);
			
			this.mShapeMatchingOn = false;
			
			this.mShapeSpringDamp = this.mShapeSpringK = 0;
        }
		
		public override function accumulateExternalForces() : void
        {
            super.accumulateExternalForces();
			
			// trace(mPointMasses[i].Velocity);
			
            // gravity!
            for (var i:int = 0; i < mPointMasses.length; i++)
                mPointMasses[i].Force.plusEquals(new Vector2(0, -1.8 * mPointMasses[i].Mass));
        }
	}
}