﻿/*
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
	public class ClosedShape
    {
        // PRIVATE VARIABLES
        ////////////////////////////////////////////////////////////////
        // Vertices that make up this collision geometry.  shape connects vertices in order, closing the last vertex to the first.
        public var mLocalVertices:Vector.<Vector2>;
		
        // CONSTRUCTORS
        ////////////////////////////////////////////////////////////////
        // default constructor.
        /*public function ClosedShape()
        {
            mLocalVertices = new Vector
        }*/
		
        // construct from an existing list of vertices.
        public function ClosedShape(verts:Vector.<Vector2> = null) : void
        {
            mLocalVertices = new Vector.<Vector2>();
            finish(true);
        }
		
        // SETUP - ADDING VERTS
        ////////////////////////////////////////////////////////////////
        // start adding vertices to this collision.  will erase any existing verts.
        public function begin() : void
        {
            mLocalVertices.length = 0;
        }
		
        ////////////////////////////////////////////////////////////////
        // add a vertex to this collision.
        public function addVertex(vert:Vector2) : Number
        {
            mLocalVertices.push(vert.clone());
			
            return mLocalVertices.length;
        }
		
		public function addVertexPos(x:Number, y:Number) : Number
		{
			return addVertex(new Vector2(x, y));
		}
		
        ////////////////////////////////////////////////////////////////
        // finish adding vertices to this collision, and convert them into local space (be default).
        public function finish(recenter:Boolean = true) : void
        {
            if (recenter)
            {
                // find the average location of all of the vertices, this is our geometrical center.
                var center:Vector2 = Vector2.Zero.clone();
				
                for (var i:int = 0; i < mLocalVertices.length; i++)
				{
                    center.plusEquals(mLocalVertices[i]);
				}
				
                center.divEquals(mLocalVertices.length);
				
                // now subtract this from each element, to get proper "local" coordinates.
                for (i = 0; i < mLocalVertices.length; i++)
                    mLocalVertices[i].minusEquals(center);
            }
        }
		
        /*public function finish() : void
        {
            finish(true);
        }*/
		
        // PUBLIC PROPERTIES
        ////////////////////////////////////////////////////////////////
        // access to the vertice list.
		public function get Vertices() : Vector.<Vector2> {
			return mLocalVertices;
		}
		
		// HELPER FUNCTIONS
        /// <summary>
        /// Get a new list of vertices, transformed by the given position, angle, and scale.
        /// transformation is applied in the following order:  scale -> rotation -> position.
        /// </summary>
        /// <param name="worldPos">position</param>
        /// <param name="angleInRadians">rotation (in radians)</param>
        /// <param name="localScale">scale</param>
        /// <returns>new list of transformed points.</returns>
        /*public function transformVertices(worldPos:Vector2, angleInRadians:Number, localScale:Vector2) : Vector.<Vector2>
        {
            var ret:Vector.<Vector2> = new Vector.<Vector2>();
			
			for (var i:int = 0; i < mLocalVertices.length; i++)
				ret.push(mLocalVertices[i].clone());
			
            var v:Vector2 = new Vector2();
			
            for (i = 0; i < ret.length; i++)
            {
                // rotate the point, and then translate.
                v.X = ret[i].X * localScale.X;
                v.Y = ret[i].Y * localScale.Y;
				
                VectorTools.rotateVector(v, angleInRadians, v);
				
                v.X += worldPos.X;
                v.Y += worldPos.Y;
                ret[i] = v;
            }
			
            return ret;
        }*/
		
		// Transforms all vertices by the given angle and scale
		public function transformOwn(angleInRadians:Number, localScale:Vector2) : void
		{
			for (var i:int = 0; i < mLocalVertices.length; i++)
            {
				mLocalVertices[i].multEqualsVec(localScale);
				
				mLocalVertices[i] = VectorTools.rotateVector(mLocalVertices[i], angleInRadians);
			}
		}
		
        /// <summary>
        /// Get a new list of vertices, transformed by the given position, angle, and scale.
        /// transformation is applied in the following order:  scale -> rotation -> position.
        /// </summary>
        /// <param name="worldPos">position</param>
        /// <param name="angleInRadians">rotation (in radians)</param>
        /// <param name="localScale">scale</param>
        /// <param name="outList">new list of transformed points.</param>
        public function transformVertices(worldPos:Vector2, angleInRadians:Number, localScale:Vector2, outList:Vector.<Vector2>) : void
        {
			outList.length = mLocalVertices.length;
			
            for (var i:int = 0; i < mLocalVertices.length; i++)
            {
                // rotate the point, and then translate.
                var v:Vector2 = new Vector2();
				
				v.X = mLocalVertices[i].X;
                v.Y = mLocalVertices[i].Y;
				
				if(localScale != null) {
	                v.X *= localScale.X;
                	v.Y *= localScale.Y;
				}
				
                v = VectorTools.rotateVector(v, angleInRadians);
				
				if(worldPos != null) {
                	v.X += worldPos.X;
                	v.Y += worldPos.Y;
				}
				
                //outList[i] = JelloPhysics.VectorTools.rotateVector(mLocalVertices[i] * localScale, angleInRadians);
				
				outList[i] = new Vector2(v.X, v.Y);
            }
        }
    }
}