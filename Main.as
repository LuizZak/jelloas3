package 
{
	import flash.display.*;
	import flash.events.*;
	
	import JelloAS3.*;
	import flash.utils.setInterval;
	
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Luiz
	 */
	public class Main extends MovieClip 
	{
		public var mWorld:World = new World();
		
		public var RenderCanvas:Sprite;
		
		public var mSpringBodies:Vector.<DraggableSpringBody> = new Vector.<DraggableSpringBody>();
		public var mPressureBodies:Vector.<DraggablePressureBody> = new Vector.<DraggablePressureBody>();
		public var mStaticBodies:Vector.<Body> = new Vector.<Body>();
		
		public var tId:int = 0;
		
		public function Main() : void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			var i:Input2 = new Input2(this);
		}
		
		private function init(e:Event = null) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.quality = "LOW";
			
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseup);
			
			RenderCanvas = new Sprite();
			addChildAt(RenderCanvas, 0);
			
			//this.addChild(new FlashPreloadProfiler());
			showDebug = false;
			
			loadTest(2);
			
			addChild(new Stats());
		}
		
		function loadTest(t:int) : void
		{
			tId = t;
			
			// Temp vars:
			var shape:ClosedShape;
			var pb:DraggablePressureBody;
			
			var groundShape:ClosedShape = new ClosedShape();
			groundShape.begin();
			groundShape.addVertex(new Vector2(-20, 1));
			groundShape.addVertex(new Vector2(20, 1));
			groundShape.addVertex(new Vector2(20, -1));
			groundShape.addVertex(new Vector2(-20, -1));
			groundShape.finish();
			
			// groundShape.transformOwn(0, new Vector2(3, 3));
			
			var groundBody:Body = new Body(mWorld, groundShape, Utils.fillArray(Number.POSITIVE_INFINITY, groundShape.Vertices.length), new Vector2(0, -19), 0, Vector2.One.clone(), false);
			
			mStaticBodies.push(groundBody);
			
			if(t == 0)
			{
				shape = new ClosedShape();
				
				shape.begin();
				shape.addVertexPos(0, 0);
				shape.addVertexPos(0, 1);
				shape.addVertexPos(0, 2);
				shape.addVertexPos(1, 2);
				shape.addVertexPos(2, 2);
				shape.addVertexPos(2, 1);
				shape.addVertexPos(2, 0);
				shape.addVertexPos(1, 0);
				shape.finish();
				
				for (x = -16; x <= -10; x += 3)
				{
					/*var body:DraggableSpringBody = new DraggableSpringBody(mWorld, shape, 1, 150.0, 5.0, 300.0, 15.0, new Vector2(0, x), 0.0, Vector2.One.clone());
					
					body.addInternalSpring(0, 2, 300, 10);
					body.addInternalSpring(1, 3, 300, 10);*/
					
					var body1:DraggablePressureBody = new DraggablePressureBody(mWorld, shape, 1, 40.0, 150.0, 5.0, 300.0, 15.0, new Vector2(0, x), 0.0, Vector2.One.clone());
				
					//body.addInternalSpring(0, 2, 300, 10);
					//body.addInternalSpring(1, 3, 300, 10);
					
					//body.addTriangle(0, 1, 3);
					//body.addTriangle(1, 3, 2);
					body1.addTriangle(7, 0, 1);
					body1.addTriangle(7, 1, 2);
					body1.addTriangle(7, 2, 3);
					body1.addTriangle(7, 3, 4);
					body1.addTriangle(7, 4, 5);
					body1.addTriangle(7, 5, 6);
					
					mPressureBodies.push(body1);
					
					body1.finalizeTriangles(0x00FF7F, 0x00FF7F);
					
					//mSpringBodies.Add(body);
					//mPressureBodies.Add(body);
				}
				
			}
			if(t == 1)
			{
				shape = new ClosedShape();
				shape.begin();
				shape.addVertex(new Vector2(-1.5, 2.0));
				shape.addVertex(new Vector2(-0.5, 2.0));
				shape.addVertex(new Vector2(0.5, 2.0));
				shape.addVertex(new Vector2(1.5, 2.0));
				shape.addVertex(new Vector2(1.5, 1.0));
				shape.addVertex(new Vector2(0.5, 1.0));
				shape.addVertex(new Vector2(0.5, -1.0));
				shape.addVertex(new Vector2(1.5, -1.0));
				shape.addVertex(new Vector2(1.5, -2.0));
				shape.addVertex(new Vector2(0.5, -2.0));
				shape.addVertex(new Vector2(-0.5, -2.0));
				shape.addVertex(new Vector2(-1.5, -2.0));
				shape.addVertex(new Vector2(-1.5, -1.0));
				shape.addVertex(new Vector2(-0.5, -1.0));
				shape.addVertex(new Vector2(-0.5, 1.0));
				shape.addVertex(new Vector2(-1.5, 1.0));
				shape.finish();
				
				shape.transformOwn(0, new Vector2(1.0, 1.0));
				
				// draggablespringbody is an inherited version of SpringBody that includes polygons for visualization, and the
				// ability to drag the body around the screen with the cursor.
				for (var x:int = -8; x <= 8; x += 4)
				{
					var body:DraggableSpringBody = new DraggableSpringBody(mWorld, shape, 1, 150.0, 5.0, 300.0, 20.0, new Vector2(x, 0), 0.0, Vector2.One.clone());
					
					body.addInternalSpring(0, 14, 300.0, 10.0);
					body.addInternalSpring(1, 14, 300.0, 10.0);
					body.addInternalSpring(1, 15, 300.0, 10.0);
					body.addInternalSpring(1, 5, 300.0, 10.0);
					body.addInternalSpring(2, 14, 300.0, 10.0);
					body.addInternalSpring(2, 5, 300.0, 10.0);
					body.addInternalSpring(1, 5, 300.0, 10.0);
					body.addInternalSpring(14, 5, 300.0, 10.0);
					body.addInternalSpring(2, 4, 300.0, 10.0);
					body.addInternalSpring(3, 5, 300.0, 10.0);
					body.addInternalSpring(14, 6, 300.0, 10.0);
					body.addInternalSpring(5, 13, 300.0, 10.0);
					body.addInternalSpring(13, 6, 300.0, 10.0);
					body.addInternalSpring(12, 10, 300.0, 10.0);
					body.addInternalSpring(13, 11, 300.0, 10.0);
					body.addInternalSpring(13, 10, 300.0, 10.0);
					body.addInternalSpring(13, 9, 300.0, 10.0);
					body.addInternalSpring(6, 10, 300.0, 10.0);
					body.addInternalSpring(6, 9, 300.0, 10.0);
					body.addInternalSpring(6, 8, 300.0, 10.0);
					body.addInternalSpring(7, 9, 300.0, 10.0);
	
					// polygons!
					body.addTriangle(0, 15, 1);
					body.addTriangle(1, 15, 14);
					body.addTriangle(1, 14, 5);
					body.addTriangle(1, 5, 2);
					body.addTriangle(2, 5, 4);
					body.addTriangle(2, 4, 3);
					body.addTriangle(14, 13, 6);
					body.addTriangle(14, 6, 5);
					body.addTriangle(12, 11, 10);
					body.addTriangle(12, 10, 13);
					body.addTriangle(13, 10, 9);
					body.addTriangle(13, 9, 6);
					body.addTriangle(6, 9, 8);
					body.addTriangle(6, 8, 7);
					
					
					body.finalizeTriangles(0x00FF7F, 0xFF0080);
	
					mSpringBodies.push(body);
				}
				
				var ball:ClosedShape = new ClosedShape();
				ball.begin();
				for (var i:int = 0; i < 360; i += 20)
				{
					ball.addVertexPos(Math.cos(-i * (Math.PI / 180)), Math.sin(-i * (Math.PI / 180)));
				}
				ball.finish();
				
				for (x = -10; x <= 10; x+=5)
				{
					pb = new DraggablePressureBody(mWorld, ball, 1.0, 40.0, 10.0, 1.0, 300.0, 20.0, new Vector2(x, -12), 0, Vector2.One.clone());
					
					pb.addTriangle(0, 10, 9);
					pb.addTriangle(0, 9, 1);
					pb.addTriangle(1, 9, 8);
					pb.addTriangle(1, 8, 2);
					pb.addTriangle(2, 8, 7);
					pb.addTriangle(2, 7, 3);
					pb.addTriangle(3, 7, 6);
					pb.addTriangle(3, 6, 4);
					pb.addTriangle(4, 6, 5);
					pb.addTriangle(17, 10, 0);
					pb.addTriangle(17, 11, 10);
					pb.addTriangle(16, 11, 17);
					pb.addTriangle(16, 12, 11);
					pb.addTriangle(15, 12, 16);
					pb.addTriangle(15, 13, 12);
					pb.addTriangle(14, 12, 15);
					pb.addTriangle(14, 13, 12);
					
					// pb.finalizeTriangles((x==-10) ? Color.Teal : Color.Maroon);
					pb.finalizeTriangles(0x008080, 0xFFFFFF);
					
					mPressureBodies.push(pb);
					
					if(x == -10)
						pb.GasPressure = 0;
				}
			}
			if(t == 2)
			{
				/*groundShape = new ClosedShape();
				
				groundShape.begin();
				groundShape.addVertexPos(-3, -15);
				groundShape.addVertexPos(-3,  15);
				groundShape.addVertexPos( 3,  15);
				groundShape.addVertexPos( 3, -15);
				groundShape.finish();
				
				var groundBody1 = new Body(mWorld, groundShape, Utils.fillArray(Number.POSITIVE_INFINITY, groundShape.Vertices.length), new Vector2(-19, -19), 0, Vector2.One, false);
				
				mStaticBodies.push(groundBody1);
				
				groundBody1 = new Body(mWorld, groundShape, Utils.fillArray(Number.POSITIVE_INFINITY, groundShape.Vertices.length), new Vector2( 19, -19), 0, Vector2.One, false);
				
				mStaticBodies.push(groundBody1);*/
				
				var def:Number = 20;
				
				ball = new ClosedShape();
				ball.begin();
				for (i = 0; i < 360; i += def)
				{
					ball.addVertexPos(Math.cos(-i * (Math.PI / 180)), Math.sin(-i * (Math.PI / 180)));
				}
				ball.transformOwn(0, new Vector2(0.3, 0.3));
				ball.finish();
				
				//var pb:DraggablePressureBody;
				pb = new DraggablePressureBody(mWorld, ball, 0.6, 30.0, 10.0, 1.0, 600.0, 20.0, new Vector2(x, -15), 0, Vector2.One.clone());
				
				pb.finalizeTriangles(0x008080, 0x000000);
				
				mPressureBodies.push(pb);
				
				createBox(5, -17, 2, 2, 0);
				createBox(5, -14, 2, 2, 0);
				createBox(5, -11, 2, 2, 0);
				createBox(5, -8, 2, 2, 0);
				createBox(0, -17, 2, 2, 1);
				
				createBox(-5, -10, 3, 3, 2);
			}
			else if(tId == 3)
			{
				mWorld.removeBody(groundBody);
				mStaticBodies.splice(mStaticBodies.indexOf(groundBody), 1);
				
				def = 20;
				
				ball = new ClosedShape();
				ball.begin();
				for (i = 0; i < 360; i += def)
				{
					ball.addVertexPos(Math.cos(-i * (Math.PI / 180)), Math.sin(-i * (Math.PI / 180)));
				}
				ball.transformOwn(0, new Vector2(0.3, 0.3));
				ball.finish();
				
				
				//var pb:DraggablePressureBody;
				pb = new DraggablePressureBody(mWorld, ball, 0.6, 90.0, 10.0, 1.0, 1000.0, 25.0, new Vector2(0, -3), 0, Vector2.One.clone());
				
				// Equalize the size by the pressure by extending the soft body a bit so it won't wobble right off:
				pb.setPositionAngle(null, 0, new Vector2(4.33, 4.33));
				
				pb.finalizeTriangles(0x996633, 0x996633);
				
				mPressureBodies.push(pb);
				
				
				mWorld.setMaterialPairData(0, 0, 0.0, 0.9);
				
				
				var bs:Number = 1.3;
				
				fix(createBox(0, -18, bs, bs, 0));
				
				fix(createBox(2, -15, bs, bs, 0));
				fix(createBox(-2, -15, bs, bs, 0));
				
				fix(createBox(4, -12, bs, bs, 0));
				fix(createBox(0, -12, bs, bs, 0));
				fix(createBox(-4, -12, bs, bs, 0));
				
				fix(createBox(6, -9, bs, bs, 0));
				fix(createBox(2, -9, bs, bs, 0));
				fix(createBox(-2, -9, bs, bs, 0));
				fix(createBox(-6, -9, bs, bs, 0));
				
				createBox(-9, -12, 2, 27, 3).setPositionAngle(null, Math.PI / 5, null);
				createBox(9, -12, 2, 27, 3).setPositionAngle(null, -Math.PI / 5, null);
			}
		}
		
		public function fix(b:Body) : void
		{
			b.mIsPined = true;
			
			b.VelocityDamping = 0.97;
			
			(b as SpringBody).setEdgeSpringConstants(100, 10);
		}
		
		public function createBox(x:Number, y:Number, w:Number, h:Number, t:int = 0) : Body
		{
			var shape = new ClosedShape();
			
			if(t == 0)
			{
				shape.begin();
				shape.addVertexPos(0, 0);
				shape.addVertexPos(0, h);
				shape.addVertexPos(w, h);
				shape.addVertexPos(w, 0);
				shape.finish();
				
				var body:DraggableSpringBody = new DraggableSpringBody(mWorld, shape, 1, 150.0, 5.0, 300.0, 15.0, new Vector2(x, y), 0.0, Vector2.One.clone());
				
				body.addInternalSpring(0, 2, 300, 10);
				body.addInternalSpring(1, 3, 300, 10);
				
				body.addTriangle(0, 1, 2);
				body.addTriangle(1, 2, 3);
				body.finalizeTriangles(0xDDDD00, 0xDDDD00);
				
				mSpringBodies.push(body);
				
				return body;
			}
			else if(t == 1)
			{
				shape.begin();
				shape.addVertexPos(0, 0);
				shape.addVertexPos(0, h/2);
				shape.addVertexPos(0, h);
				shape.addVertexPos(w/2, h);
				shape.addVertexPos(w, h);
				shape.addVertexPos(w, h/2);
				shape.addVertexPos(w, 0);
				shape.addVertexPos(w/2, 0);
				shape.finish();
				
				var body1:DraggablePressureBody = new DraggablePressureBody(mWorld, shape, 1, 40.0, 150.0, 5.0, 300.0, 15.0, new Vector2(x, y), 0.0, new Vector2(0.5, 0.5));
				
				body1.addTriangle(7, 0, 1);
				body1.addTriangle(7, 1, 2);
				body1.addTriangle(7, 2, 3);
				body1.addTriangle(7, 3, 4);
				body1.addTriangle(7, 4, 5);
				body1.addTriangle(7, 5, 6);
				
				mPressureBodies.push(body1);
				
				body1.finalizeTriangles(0x00FF7F, 0x00FF7F);
				
				return body1;
			}
			else if(t == 2)
			{
				shape.begin();
				shape.addVertexPos(0, 0);
				shape.addVertexPos(0, h/2);
				shape.addVertexPos(0, h);
				shape.addVertexPos(w/2, h);
				shape.addVertexPos(w, h);
				shape.addVertexPos(w, h/2);
				shape.addVertexPos(w, 0);
				shape.addVertexPos(w/2, 0);
				shape.finish();
				
				var body2:SpringBody = new SpringBody(mWorld, shape, 5, 900, 50, 30, 15, new Vector2(x, y), 0, Vector2.One.clone(), true);
				
				mStaticBodies.push(body2);
				
				return body2;
			}
			else if(t == 3)
			{
				shape.begin();
				shape.addVertexPos(0, 0);
				shape.addVertexPos(0, h);
				shape.addVertexPos(w, h);
				shape.addVertexPos(w, 0);
				shape.finish();
				
				var body3:Body = new Body(mWorld, shape, Utils.fillArray(Number.POSITIVE_INFINITY, shape.Vertices.length), new Vector2(x, y), 0, Vector2.One.clone(), false);
				
				mStaticBodies.push(body3);
				
				return body3;
			}
			
			return null;
		}
		
		public function mouseClick(e:Event) : void
		{
			// cursorPos = new Vector3(Mouse.GetState().X - Window.ClientBounds.Width / 2, -Mouse.GetState().Y + Window.ClientBounds.Height / 2, 0) * 0.038;
			
			var s:Vector2 = RenderingSettings.Scale;
			var p:Vector2 = RenderingSettings.Offset;
			
			// var cursorPos = new Vector2(mouseX - p.X, mouseY - p.Y);
			var cursorPos = new Vector2((mouseX - p.X) / s.X, (mouseY - p.Y) / s.Y);
			
			
	        if (dragBody == null)
			{
				var body:Array = [0];
				var dragp:Array = [0];
				
				mWorld.getClosestPointMass(cursorPos, body, dragp);
				
				dragPoint = dragp[0];
				dragBody = mWorld.getBody(body[0]);
			}
			
			mouseDown = true;
		}
		
		public function mouseup(e:Event) : void
		{
			mouseDown = false;
			
			dragBody = null;
		}
		
		public function numbOfPairs(numb:int, wholeNumb:int) : int
        {
            var i:int = 0;
			
            while (wholeNumb > numb)
            {
                wholeNumb -= numb;
                i++;
            }
            
            return i;
        }
		
		public var go:Boolean = true;
		
		public function loop(e:Event) : void
		{
			var s:Vector2 = RenderingSettings.Scale;
			var p:Vector2 = RenderingSettings.Offset;
			
			var cursorPos:Vector2 = new Vector2((mouseX - p.X) / s.X, (mouseY - p.Y) / s.Y);
			
			var pm:PointMass;
			
			if(Input2.keysDownInterval[32] == 1)
				go = !go;
			
			if(go)
				for (var i:int = 0; i < 5; i++)
				{
					mWorld.update(1.0 / 200.0);
					
					if (dragBody != null)
					{
						pm = dragBody.getPointMass(dragPoint);
						
						if (dragBody is DraggableSpringBody)
							DraggableSpringBody(dragBody).setDragForce(
							VectorTools.calculateSpringForceRetPos(pm.PositionX, pm.PositionY, pm.VelocityX, pm.VelocityY, cursorPos.X, cursorPos.Y, 0, 0, 0.0, 100.0, 10.0), dragPoint);
						
						else if (dragBody is DraggablePressureBody)
							DraggablePressureBody(dragBody).setDragForce(
							VectorTools.calculateSpringForceRetPos(pm.PositionX, pm.PositionY, pm.VelocityX, pm.VelocityY, cursorPos.X, cursorPos.Y, 0, 0, 0.0, 100.0, 10.0), dragPoint);
					}
				}
			
			RenderCanvas.graphics.clear();
			
			// Control the blob on test 2
			if(tId == 2)
			{
				var pb:PressureBody = mPressureBodies[0];
				
				if(Input2.press_up)
				{
					pb.setEdgeSpringConstants(1200, 25);
					pb.GasPressure = 70;
				}
				else
				{
					pb.setEdgeSpringConstants(400, 20);
					pb.GasPressure = 20;
				}
				
				if((Input2.press_left && pb.DerivedOmega() < 5) ||
				   (Input2.press_right && pb.DerivedOmega() > -5))
				{
					for(i = 0; i < pb.mPointMasses.length; i++)
					{
						pm = pb.mPointMasses[i];
						// var pmL:PointMass = mPointMasses[
						
						var dx:Number = pm.PositionX - pb.DerivedPosition.X;
						var dy:Number = pm.PositionY - pb.DerivedPosition.Y;
						
						var dis:Number = Math.sqrt(dx * dx + dy * dy);
						
						dx /= dis;
						dy /= dis;
						
						if(Input2.press_left)
						{
							dx = -dx;
							dy = -dy;
						}
						
						pm.ForceX +=  dy * 25;
						pm.ForceY += -dx * 25;
					}
				}
			}
			
			if (!showDebug)
            {
				for(i = 0; i < mSpringBodies.length; i++)
					mSpringBodies[i].drawMe(RenderCanvas.graphics);
				
				for(i = 0; i < mPressureBodies.length; i++)
					mPressureBodies[i].drawMe(RenderCanvas.graphics);
				
				for(i = 0; i < mStaticBodies.length; i++)
					mStaticBodies[i].debugDrawMe(RenderCanvas.graphics);
            }
            else
            {
                // draw all the bodies in debug mode, to confirm physics.
                mWorld.debugDrawMe(RenderCanvas.graphics);
                mWorld.debugDrawAllBodies(RenderCanvas.graphics, false);
            }
			
			if(dragBody != null)
			{
				s = RenderingSettings.Scale;
				p = RenderingSettings.Offset;
				
				pm = dragBody.mPointMasses[dragPoint];
				
				RenderCanvas.graphics.lineStyle(1, 0xD2B48C);
				
				RenderCanvas.graphics.moveTo(pm.PositionX * s.X + p.X, pm.PositionY * s.Y + p.Y);
				RenderCanvas.graphics.lineTo(mouseX, mouseY);
			}
			else
			{
				dragBody = null;
				dragPoint = -1;
			}
		}
		
		public var showDebug:Boolean = false;
		
		public var dragBody:Body;
		public var mouseDown:Boolean = false;
		public var dragPoint:int = 0;
	}
}