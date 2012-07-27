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

	// Vector2 class
	public class Vector2
	{
		public static const Zero:Vector2 = new Vector2(0,0);
		public static const One:Vector2 = new Vector2(1,1);

		public var X:Number;
		public var Y:Number;

		public function Vector2(px:Number=0,py:Number=0)
		{
			X = px;
			Y = py;
		}

		public function setTo(px:Number,py:Number):void
		{
			X = px;
			Y = py;
		}

		public function setToVec(v:Vector2):void
		{
			X = v.X;
			Y = v.Y;
		}

		public function copy(v:Vector2):void
		{
			X = v.X;
			Y = v.Y;
		}

		public function clone():Vector2
		{
			return new Vector2(X, Y);
		}

		public function dot(v:Vector2):Number
		{
			return X * v.X + Y * v.Y;
		}

		public static function Dot(v1:Vector2, v2:Vector2):Number
		{
			return v1.dot(v2);
		}

		public function cross(v:Vector2):Number
		{
			return X * v.Y - Y * v.X;
		}

		public function plus(v:Vector2):Vector2
		{
			return new Vector2(X + v.X, Y + v.Y);
		}

		public function plusEquals(v:Vector2):Vector2
		{
			X += v.X;
			Y += v.Y;

			return this;
		}

		public function minus(v:Vector2):Vector2
		{
			return new Vector2(X - v.X, Y - v.Y);
		}

		public function minusEquals(v:Vector2):Vector2
		{
			X -= v.X;
			Y -= v.Y;

			return this;
		}

		public function mult(s:Number):Vector2
		{
			return new Vector2(X * s, Y * s);
		}

		public function multVec(v:Vector2):Vector2
		{
			return new Vector2(X * v.X, Y * v.Y);
		}

		public function perpendicular():Vector2
		{
			var t:Number = X;

			X = -Y;
			Y = t;

			return this;
		}

		public function div(s:Number):Vector2
		{
			var revS:Number = 1 / s;
			
			return new Vector2(X * revS, Y * revS);
		}

		public function multEquals(s:Number):Vector2
		{
			X *= s;
			Y *= s;

			return this;
		}
		
		public function multEqualsVec(v:Vector2):Vector2
		{
			X *= v.X;
			Y *= v.Y;

			return this;
		}

		public function times(v:Vector2):Vector2
		{
			return new Vector2(X * v.X, Y * v.Y);
		}

		public function divEquals(s:Number):Vector2
		{
			if (s == 0)
			{
				s = 0.0001;
			}
			
			var revS:Number = 1 / s;
			
			X *= revS;
			Y *= revS;

			return this;
		}

		public function magnitude():Number
		{
			return Math.sqrt(X * X + Y * Y);
		}

		public function length():Number
		{
			return (X * X) + (Y * Y);
		}

		public function distance(v:Vector2):Number
		{
			var delta:Vector2 = this.minus(v);

			return delta.magnitude();
		}

		public static function Distance(value1:Vector2, value2:Vector2):Number
		{
			var num2:Number = value1.X - value2.X;
			var num:Number = value1.Y - value2.Y;

			return Math.sqrt((num2 * num2) + (num * num));
		}

		public static function DistanceSquared(value1:Vector2, value2:Vector2):Number
		{
			var num2:Number = value1.X - value2.X;
			var num:Number = value1.Y - value2.Y;

			return (num2 * num2) + (num * num);
		}

		public static function Normalize(value:Vector2, result:Vector2):void
		{
			var num2:Number = (value.X * value.X) + (value.Y * value.Y);
			var num:Number = 1 / Math.sqrt(num2);

			result.X = value.X * num;
			result.Y = value.Y * num;
		}

		public function getDifference(v:Vector2):Vector2
		{
			return new Vector2(v.X - X, v.Y - Y);
		}
		
		public function normalize():Vector2
		{
			var m:Number = magnitude();

			if (m == 0)
			{
				m = 0.0001;
			}

			return div(m);
		}

		public function normalizeThis():Vector2
		{
			var m:Number = magnitude();

			if (m == 0)
			{
				m = 0.0001;
			}

			divEquals(m);
			
			/*var num2:Number = (X * X) + (Y * Y);
			var num:Number = 1 / Math.sqrt(num2);
			
			X *= num;
			Y *= num;*/

			return this;
		}

		public function negate():Vector2
		{
			X =  -  X;
			Y =  -  Y;

			return this;
		}

		public function toString():String
		{
			return ('{X:' + X + " Y:" + Y + '}');
		}
	}
}