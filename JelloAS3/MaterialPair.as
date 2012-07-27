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
	/// <summary>
	/// represents data about collision between 2 materials.
	/// </summary>
	public class MaterialPair
	{
		/// <summary>
		/// Whether these 2 materials should collide with each other or not.
		/// </summary>
		public var Collide : Boolean

		/// <summary>
		/// Amount of "bounce" when collision occurs. value range [0,1]. 0 == no bounce, 1 == 100% bounce
		/// </summary>
		public var Elasticity : Number

		/// <summary>
		/// Amount of friction.  Value range [0,1].  0 == no friction, 1 == 100% friction, will stop on contact.
		/// </summary>
		public var Friction : Number

		/// <summary>
		/// Collision filter function.
		/// </summary>
		public var CollisionFilter:Function;
		
		public function clone() : MaterialPair
		{
			var mp:MaterialPair = new MaterialPair();
			
			mp.Collide = Collide;
			mp.Elasticity = Elasticity;
			mp.Friction = Friction;
			mp.CollisionFilter = CollisionFilter;
			
			return mp;
		}
	}
}