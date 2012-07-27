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
	public class AABB
    {
		// PRIVATE VARIABLES
        public var PointValidity:Array = [0, 1];
		
        /// <summary>
        /// Minimum point of this bounding box.
        /// </summary>
        public var Min:Vector2 = new Vector2();
		
        /// <summary>
        /// Maximum point of this bounding box.
        /// </summary>
        public var Max:Vector2 = new Vector2();
		
        /// <summary>
        /// Property that indicated whether or not this bounding box is valid.
        /// </summary>
        public var Validity:int = 0;
		
        // CONSTRUCTORS
        /// <summary>
        /// Basic constructor.  creates a bounding box that is invalid (describes no space)
        /// </summary>
        /*public function AABB()
        {
            Min = Max = Vector2.Zero;
            Validity = PointValidity[0];
        }*/
		
        /// <summary>
        /// create a boundingbox with the given min and max points.
        /// </summary>
        /// <param name="minPt">min point</param>
        /// <param name="maxPt">max point</param>
        public function AABB(minPt:Vector2 = null, maxPt:Vector2 = null)
        {
			if(minPt == null)
				Min.setTo(0, 0);
			else
				Min.setToVec(minPt);
			if(maxPt == null)
				Max.setTo(0, 0);
			else
				Max.setToVec(maxPt);
			
            Validity = (minPt == null || maxPt == null ? PointValidity[0] : PointValidity[1]);
        }
		
        // CLEAR
        /// <summary>
        /// Resets a bounding box to invalid.
        /// </summary>
        public function clear() : void
        {
            Max.X = Max.Y = 0;
			Min.X = Min.Y = 0;
			
            Validity = PointValidity[0];
        }
		
        // EXPANSION
        public function expandToInclude(pt:Vector2) : void
        {
            if (Validity == PointValidity[1])
            {
                if (pt.X < Min.X) { Min.X = pt.X; }
                else if (pt.X > Max.X) { Max.X = pt.X;}
				
                if (pt.Y < Min.Y) { Min.Y = pt.Y; }
                else if (pt.Y > Max.Y) { Max.Y = pt.Y;}
            }
            else
            {
                Min.setToVec(pt);
				Max.setToVec(pt);
				
                Validity = PointValidity[1];
            }
        }
		
		 public function expandToIncludePos(ptX:Number, ptY:Number) : void
        {
            if (Validity == PointValidity[1])
            {
                if (ptX < Min.X) { Min.X = ptX; }
                else if (ptX > Max.X) { Max.X = ptX;}
				
                if (ptY < Min.Y) { Min.Y = ptY; }
                else if (ptY > Max.Y) { Max.Y = ptY;}
            }
            else
            {
                Min.setTo(ptX, ptY);
				Max.setTo(ptX, ptY);
				
                Validity = PointValidity[1];
            }
        }
		
        // COLLISION / OVERLAP
        public function contains(ptX:Number, ptY:Number) : Boolean
        {
            if (Validity == PointValidity[0]) { return false; }
		
            return ((ptX >= Min.X) && (ptX <= Max.X) && (ptY >= Min.Y) && (ptY <= Max.Y));
        }
		
		public function containsVec(pt:Vector2) : Boolean
        {
            if (Validity == PointValidity[0]) { return false; }
		
            return ((pt.X >= Min.X) && (pt.X <= Max.X) && (pt.Y >= Min.Y) && (pt.Y <= Max.Y));
        }
		
        public function intersects(box:AABB) : Boolean
        {
            // X overlap check.
			if((Min.X <= box.Max.X) && (Max.X >= box.Min.X))
			{
				// Y overlap check
            	if((Min.Y <= box.Max.Y) && (Max.Y >= box.Min.Y))
				{
					return true;
				}
			}
		
            //return (overlapX && overlapY);
			return false;
        }
		
		public function toString() : String
		{
			return "[AABB: " + Min + " : " + Max + "]";
		}
    }
}