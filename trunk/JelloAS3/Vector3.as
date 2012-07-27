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
	public class Vector3
	{
		public var X:Number;
		public var Y:Number;
		public var Z:Number;
		
		public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0) 
		{
			X = x;
			Y = y;
			Z = z;
		}
		
		public static function Cross(vector1:Vector3, vector2:Vector3, result:Vector3) : void
		{
			var num3:Number = (vector1.Y * vector2.Z) - (vector1.Z * vector2.Y);
			var num2:Number = (vector1.Z * vector2.X) - (vector1.X * vector2.Z);
			var num:Number = (vector1.X * vector2.Y) - (vector1.Y * vector2.X);
			
			result.X = num3;
			result.Y = num2;
			result.Z = num;
		}
		
		public static function Cross2(vector1:Vector3, vector2:Vector3) : Vector3
		{
			var vector:Vector3 = new Vector3();
			
			vector.X = (vector1.Y * vector2.Z) - (vector1.Z * vector2.Y);
			vector.Y = (vector1.Z * vector2.X) - (vector1.X * vector2.Z);
			vector.Z = (vector1.X * vector2.Y) - (vector1.Y * vector2.X);
			
			return vector;
		}
		
		public static function Cross2Z(vector1:Vector3, vector2:Vector3) : Number
		{
			var z:Number = (vector1.X * vector2.Y) - (vector1.Y * vector2.X);
			return z;
		}
		
		public function fromVector2(v:Vector2, z:Number = 0) : void
		{
			X = v.X;
			Y = v.Y;
			Z = z;
		}
	}
}