package 
{
	import flash.display.Sprite;
	import flash.events.*;
	
	import JelloAS3.*;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Luiz
	 */
	public class Main extends Sprite 
	{
		public var mWorld:World = new World();
		
		public var RenderCanvas:Sprite;
		
		public var showDebug:Boolean = true;
		
		public var frames:Number = 0;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseup);
			
			RenderCanvas = new Sprite();
			addChild(RenderCanvas);
			
			var groundShape:ClosedShape = new ClosedShape();
            groundShape.begin();
            groundShape.addVertex(new Vector2(-20, -2));
            groundShape.addVertex(new Vector2(-20, 2));
            groundShape.addVertex(new Vector2(20, 2));
            groundShape.addVertex(new Vector2(20, -2));
            groundShape.finish();
			
			var groundBody:Body = new Body(mWorld, groundShape, Utils.fillArray(Number.POSITIVE_INFINITY, groundShape.Vertices.length), new Vector2(0, -5), 0, Vector2.One, false);
			
			mWorld.addBody(groundBody);
			
			var shape:ClosedShape = new ClosedShape();
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
			
			// draggablespringbody is an inherited version of SpringBody that includes polygons for visualization, and the
            // ability to drag the body around the screen with the cursor.
            for (var x:int = -8; x <= 8; x += 4)
            {
                var body:DraggableSpringBody = new DraggableSpringBody(mWorld, shape, 1, 150.0, 5.0, 300.0, 15.0, new Vector2(x, 0), 0.0, Vector2.One.clone());
				
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
                body.finalizeTriangles(0x00FF7F, 0x000080);

                // mSpringBodies.(body);
            }
			
			
			/*var ball:ClosedShape = new ClosedShape();
            ball.begin();
            for (var i:int = 0; i < 360; i += 20)
            {
                ball.addVertex(new Vector2(Math.cos(-i * (Math.PI / 180)), Math.sin(-i * (Math.PI / 180))));
            }
            ball.finish();
			
			
            for (var x:int = -10; x <= 10; x+=5)
            {
                var pb:DraggablePressureBody = new DraggablePressureBody(mWorld, ball, 1.0, 40.0, 10.0, 1.0, 300.0, 20.0, new Vector2(x, 7), 0, Vector2.One.clone());
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
				pb.finalizeTriangles(0x000000, 0x000000);
				
                // mPressureBodies.Add(pb);
            }*/
			
			setInterval(fpsCheck, 1000);
		}
		
		function fpsCheck() {
			fpsText.text = "" + frames;
			frames = 0;
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
		
		public function loop(e:Event) : void
		{
			frames ++;
			
			var s:Vector2 = RenderingSettings.Scale;
			var p:Vector2 = RenderingSettings.Offset;
			
			var cursorPos = new Vector2((mouseX - p.X) / s.X, (mouseY - p.Y) / s.Y);
			
			for (var i:int = 0; i < 3; i++)
            {
                mWorld.update(1.0 / 200);
				
				if (dragBody != null)
                    {
                        var pm:PointMass = dragBody.getPointMass(dragPoint);
						
                        if (dragBody is DraggableSpringBody)
                            DraggableSpringBody(dragBody).setDragForce(VectorTools.calculateSpringForceRet(pm.Position, pm.Velocity, cursorPos, Vector2.Zero, 0.0, 100.0, 10.0), dragPoint);
                        else if (dragBody is DraggablePressureBody)
                            DraggablePressureBody(dragBody).setDragForce(VectorTools.calculateSpringForceRet(pm.Position, pm.Velocity, cursorPos, Vector2.Zero, 0.0, 100.0, 10.0), dragPoint);
                    }
				else
				{
					dragBody = null;
					dragPoint = -1;
				}
				
                // dragging!
                /*if (ks.IsKeyDown(Keys.S) || Mouse.GetState().LeftButton == ButtonState.Pressed)
                {
                    if (dragBody != null)
                    {
                        PointMass pm = dragBody.getPointMass(dragPoint);
						
                        if (dragBody)
                            ((DraggableSpringBody)dragBody).setDragForce(JelloPhysics.VectorTools.calculateSpringForce(pm.Position, pm.Velocity, mCursorPos, Vector2.Zero, 0.0, 100.0, 10.0), dragPoint);
                        else if (dragBody.GetType().Name == "DraggablePressureBody")
                            ((DraggablePressureBody)dragBody).setDragForce(JelloPhysics.VectorTools.calculateSpringForce(pm.Position, pm.Velocity, mCursorPos, Vector2.Zero, 0.0, 100.0, 10.0), dragPoint);
                    }
                }
                else
                {
                    dragBody = null;
                    dragPoint = -1;
                }*/
            }
			
			RenderCanvas.graphics.clear();
			
			if (!showDebug)
            {
                /*for (i = 0; i < mSpringBodies.Count; i++)
                    mSpringBodies[i].drawMe(graphics.GraphicsDevice, lineEffect);

                for (i = 0; i < mPressureBodies.Count; i++)
                    mPressureBodies[i].drawMe(graphics.GraphicsDevice, lineEffect);

                for (i = 0; i < mStaticBodies.Count; i++)
                    mStaticBodies[i].debugDrawMe(graphics.GraphicsDevice, lineEffect);*/
            }
            else
            {
                // draw all the bodies in debug mode, to confirm physics.
                mWorld.debugDrawMe(RenderCanvas.graphics);
                mWorld.debugDrawAllBodies(RenderCanvas.graphics, true);
            }
		}
		
		public var dragBody:Body;
		public var mouseDown:Boolean = false;
		public var dragPoint:int = 0;
	}
}