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
	public class PointMass
    {
        // PRIVATE VARIABLES
        ////////////////////////////////////////////////////////////////
        /// <summary>
        /// Mass of thie PointMass.
        /// </summary>
        public var Mass:Number;

        /// <summary>
        /// Global position of the PointMass.
        /// </summary>
        // public var Position:Vector2;
		
		public var PositionX:Number;
		public var PositionY:Number;

        /// <summary>
        /// Global velocity of the PointMass.
        /// </summary>
        // public var Velocity:Vector2;
		
		public var VelocityX:Number = 0;
		public var VelocityY:Number = 0;

        /// <summary>
        /// Force accumulation variable.  reset to Zero after each call to integrate().
        /// </summary>
        // public var Force:Vector2;
		
		public var ForceX:Number = 0;
		public var ForceY:Number = 0;

        // CONSTRUCTORS
        ////////////////////////////////////////////////////////////////
        // CONSTRUCTORS
        /*public PointMass()
        {
            Mass = 0;
            Position = Velocity = Force = Vector2.Zero;
        }*/

        public function PointMass(mass:Number = 0.0, pos:Vector2 = null)
        {
            Mass = mass;
            
			// Position = (pos == null ? Vector2.Zero.clone() : pos.clone());
			
			PositionX = pos.X;
			PositionY = pos.Y;
            
			// Velocity = Vector2.Zero.clone();
			
			// Force = Vector2.Zero.clone();
        }

        // INTEGRATION
        ////////////////////////////////////////////////////////////////
        /// <summary>
        /// integrate Force >> Velocity >> Position, and reset force to zero.
        /// this is usually called by the World.update() method, the user should not need to call it directly.
        /// </summary>
        /// <param name="elapsed">time elapsed in seconds</param>
        public function integrateForce(elapsed:Number) : void
        {
            if (Mass != Number.POSITIVE_INFINITY)
            {
                var elapMass:Number = elapsed / Mass;
				
                VelocityX += (ForceX * elapMass);
                VelocityY += (ForceY * elapMass);

                PositionX += (VelocityX * elapsed);
                PositionY += (VelocityY * elapsed);
            }

            ForceX = 
            ForceY = 0.0;
        }
		
		public function VecPos() : Vector2
		{
			return new Vector2(PositionX, PositionY);
		}
    }
}