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
	import flash.display.Graphics;
	
	public class DraggablePressureBody extends PressureBody
    {
        // Variables for dragging point masses in this body.
		
		private var dragForce:Vector2 = Vector2.Zero.clone();
        private var dragPoint:int = -1;

        /*VertexDeclaration mDecl;
        VertexPositionColor[] mVerts = null;*/
        var mIndices:Array = null;
        var mIndexList:Vector.<int>;
        var mColor:int = 0xFFFFFF;
        var mDistressColor:int = 0xFF0000;

        public function DraggablePressureBody(w:World, s:ClosedShape, massPerPoint:Number, gasPressure:Number, shapeSpringK:Number, shapeSpringDamp:Number,
											  edgeSpringK:Number, edgeSpringDamp:Number, pos:Vector2, angleInRadians:Number, scale:Vector2) : void 
        {
			super(w, s, massPerPoint, gasPressure, shapeSpringK, shapeSpringDamp, edgeSpringK, edgeSpringDamp, pos, angleInRadians, scale, false);
			
            mIndexList = new Vector.<int>();
        }

        // add an indexed triangle to this primitive.
         public function addTriangle(A:int, B:int, C:int) : void
        {
            mIndexList.push(A);
            mIndexList.push(B);
            mIndexList.push(C);
        }
		
		public function finalizeTriangles(c:uint, d:uint) : void
        {
            /*mVerts = new VertexPositionColor[mPointMasses.Count];

            mIndices = new int[mIndexList.Count];
            for (int i = 0; i < mIndexList.Count; i++)
                mIndices[i] = mIndexList[i];

            mColor = c;
            mDistressColor = d;*/
        }

        public function setDragForce(force:Vector2, pm:int) : void
        {
            dragForce = force;
            dragPoint = pm;
        }

        // add gravity, and drag force.
        public override function accumulateExternalForces() : void
        {
            super.accumulateExternalForces();

            // gravity.
            for (var i:int = 0; i < mPointMasses.length; i++)
            {
                mPointMasses[i].Force.Y += -9.8 * mPointMasses[i].Mass;
            }

            // dragging force.
            if (dragPoint != -1)
                mPointMasses[dragPoint].Force.plusEquals(dragForce);

            dragPoint = -1;
        }


        public function drawMe(g:Graphics) : void
        {
            /*if (mDecl == null)
            {
                mDecl = new VertexDeclaration(device, VertexPositionColor.VertexElements);
            }

            // update vert buffer.
            for (int i = 0; i < mPointMasses.Count; i++)
            {
                mVerts[i].Position = JelloPhysics.VectorTools.vec3FromVec2(mPointMasses[i].Position);

                float dist = (mPointMasses[i].Position - mGlobalShape[i]).Length() * 2.0f;
                if (dist > 1f) { dist = 1f; }
                
                mVerts[i].Color = new Color(Vector3.Lerp(mColor.ToVector3(), mDistressColor.ToVector3(),dist));
            }

            device.VertexDeclaration = mDecl;

            // draw me!
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                device.DrawUserIndexedPrimitives<VertexPositionColor>(PrimitiveType.TriangleList, mVerts, 0, mVerts.Length, mIndices, 0, mIndices.Length / 3);
                pass.End();
            }
            effect.End();*/
        }
    }
}