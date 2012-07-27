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
	
	public class DraggableSpringBody extends SpringBody
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

        public function DraggableSpringBody(w:World, s:ClosedShape, massPerPoint:Number, shapeSpringK:Number, shapeSpringDamp:Number, edgeSpringK:Number, edgeSpringDamp:Number, pos:Vector2, angleInRadians:Number, scale:Vector2) : void
        {
			super(w, s, massPerPoint, shapeSpringK, shapeSpringDamp, edgeSpringK, edgeSpringDamp, pos, angleInRadians, scale, false)
			
            mIndexList = new Vector.<int>();
        }

        // add an indexed triangle to this primitive.
        public function addTriangle(A:int, B:int, C:int) : void
        {
            mIndexList.push(A);
            mIndexList.push(B);
            mIndexList.push(C);
        }

        // finalize triangles
        public function finalizeTriangles(c:uint, d:uint) : void
        {
            /*mVerts = new VertexPositionColor[mPointMasses.Count];

            mIndices = new int[mIndexList.Count];
            for (int i = 0; i < mIndexList.Count; i++)
                mIndices[i] = mIndexList[i];*/

            mColor = c;
            mDistressColor = d;
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
                mPointMasses[i].ForceY += -9.8 * mPointMasses[i].Mass;
            }

            // dragging force.
            if (dragPoint != -1)
			{
                mPointMasses[dragPoint].ForceX += dragForce.X;
				mPointMasses[dragPoint].ForceY += dragForce.Y;
			}

            dragPoint = -1;
        }
		
		public function drawMe(g:Graphics) : void
		{
			var s:Vector2 = RenderingSettings.Scale;
			var p:Vector2 = RenderingSettings.Offset;
			
			var v:Vector.<Number> = new Vector.<Number>();
			
			g.beginFill(mColor)
			
			for (var i:int = 0; i < mPointMasses.length; i++)
            {
				var posX:Number = mPointMasses[i].PositionX * s.X + p.X;
				var posY:Number = mPointMasses[i].PositionY * s.Y + p.Y;
				
				// v.push(posX, posY);
				if(i == 0)
					g.moveTo(posX, posY);
				
				g.lineTo(posX, posY);
            }
			
			g.endFill();
		}

        public override function debugDrawMe(g:Graphics) : void
        {
			super.debugDrawMe(g);
        }
    }
}