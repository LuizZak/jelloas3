package {
	import flash.events.*;
	import flash.ui.Keyboard;
	
	public class Input2 {
		public static var press_left = false;
		public static var press_right = false;
		public static var press_up = false;
		public static var press_down = false;
		public static var press_space = false;
		
		
		///// KEYS BEING PRESSED:
		// Public array:
		public var Keys:Array = new Array(150);
		// Static array:
		public static var keysDown:Array = new Array(150);
		
		///// INTERVALS:
		// Public array:
		public var KeysInterval:Array = new Array(150);
		// Static array:
		public static var keysDownInterval:Array = new Array(150);
		
		// The keyboard input history
		public static var keyIO:String = "";
		// The maximum size for the keyboard input history
		public static var keyIOSize:uint = 9;
		
		public static var calls:Array = new Array();
		
		public static var debug:Boolean = false;
		
		public var Movieclip:*;
		
		public function Input2(movieclip) {
			movieclip.stage.addEventListener(FocusEvent.FOCUS_OUT, focus, false, 0);
			movieclip.stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down, false, 0);
			movieclip.stage.addEventListener(KeyboardEvent.KEY_UP, key_up, false, 1);
			movieclip.stage.addEventListener('enterFrame', loop, false, 0, true);
			
			Movieclip = movieclip;
			
			focus(null);
		}
		
		public function removeHandlers() : void {
			Movieclip.stage.removeEventListener(FocusEvent.FOCUS_OUT, focus);
			Movieclip.stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Movieclip.stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			Movieclip.stage.removeEventListener('enterFrame', loop);
		}
		
		public function returnHandlers() : void {
			Movieclip.stage.addEventListener(FocusEvent.FOCUS_OUT, focus, false, 0);
			Movieclip.stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down, false, 0);
			Movieclip.stage.addEventListener(KeyboardEvent.KEY_UP, key_up, false, 0);
			Movieclip.stage.addEventListener('enterFrame', loop);
		}
		
		public function focus(e:FocusEvent){
			for(var i:int = 0;i<Keys.length;i++){
				Keys[i] = false;
				Input2.keysDown[i] = false;
				
				KeysInterval[i] = 0;
				keysDownInterval[i] = 0;
			}
			
			press_left = false;
			press_right = false;
			press_up = false;
			press_down = false;
			press_space = false;
		}
		
		public function is_left() {
			return press_left;
		}
		
		public function is_right() {
			return press_right;
		}
		
		public function is_up() {
			return press_up;
		}
		
		public function is_down() {
			return press_down;
		}
		
		public function is_space() {
			return press_space;
		}
		
		public function isDown(key:int){
			return Keys[key] > 0;
		}
		
		private function loop(e:Event) : void {
			for(var i:int = 0; i < Keys.length; i++){
				if(Keys[i]){
					KeysInterval[i] ++;
					keysDownInterval[i] ++;
				} else {
					KeysInterval[i] = 0;
					keysDownInterval[i] = 0;
				}
			}
		}
		
		private function key_down(event:KeyboardEvent) : void {
			if(event.keyCode != Keyboard.ENTER) {
				if(keyIO.length < keyIOSize)
					keyIO += String.fromCharCode(event.charCode);
				else {
					keyIO += String.fromCharCode(event.charCode);
					keyIO = keyIO.slice(1);
				}
			}
			
			if(Keys[event.keyCode] == false){
				for(var i:int = 0; i < calls.length; i++){
					calls[i](event);
				}
			}
			
			Keys[event.keyCode] = true;
			
			Input2.keysDown[event.keyCode] = true;
			
			if (Input2.debug) {
				trace(event.keyCode);
			}
			
			if (event.keyCode == 32) {
				press_space = true;
			}
			if (event.keyCode == 37 || event.keyCode == 65) {
				press_left = true;
			}
			if (event.keyCode == 38 || event.keyCode == 87) {
				press_up = true;
			}
			if (event.keyCode == 39 || event.keyCode == 68) {
				press_right = true;
			}
			if (event.keyCode == 40 || event.keyCode == 83) {
				press_down = true;
			}
		}
		
		private function key_up(event:KeyboardEvent) {
			
			Keys[event.keyCode] = false;
			
			Input2.keysDown[event.keyCode] = false;
			
			if (Input2.debug) {
				trace(event.keyCode);
			}
			
			if (event.keyCode == 32) {
				press_space = false;
			}
			if (event.keyCode == 37 || event.keyCode == 65) {
				press_left = false;
			}
			if (event.keyCode == 38 || event.keyCode == 87) {
				press_up = false;
			}
			if (event.keyCode == 39 || event.keyCode == 68) {
				press_right = false;
			}
			if (event.keyCode == 40 || event.keyCode == 83) {
				press_down = false;
			}
		}
		
		public static function addCallback(callback:Function) : void {
			calls.push(callback);
		}
		
		public static function removeCallback(callback:Function) : void {
			var cInt:uint = calls.indexOf(callback);
			
			if(cInt == -1) return;
			
			calls[cInt] = null;
			calls.splice(cInt, 1);
		}
	}
}