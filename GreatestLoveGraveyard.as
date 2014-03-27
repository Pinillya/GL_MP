package  
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class GreatestLoveGraveyard extends MovieClip
	{
//Variables
		//End cut scene when it starts and when it changes.
		private var dragDownHalfWay:Boolean = false;
		private var dragDown:Boolean = false;
		
		var timerDragDown:Timer = new Timer(28000, 1); //28+000sec
		var timerHalfWayDragDown:Timer = new Timer(35000, 1);
		
		//Achivements
		public var explored:Boolean = false;
		public var achiBling:LAchiBling;
		
		//Ground
		private var ground:Sprite;
		private var _ground:LGYGround;
		
		//Light
		private var _lanternShadow:LLanternShadow;
		
		//Pickup items
		private var _axe:LGyAxe;
		private var _gyFlower:LGyFlower;
		
		//Character related
		public var characterG:LCharacterG;
		private var _characterFalling:LCharacterFalling;
		
		//Movement
		//Speed
		private var speed:Number = 0;
		private var maxSpeed:Number = 7;
		
		//Directions
		private var directions:Number = 0;   
		private var turnCharacter:Number = 0;
		private var turnSpeed:Number = 7;

		public function GreatestLoveGraveyard() 
		{
//Items
			//Ground
			ground = new Sprite;
			addChild (ground);
			
			_ground = new LGYGround;
			ground.addChild(_ground);
			_ground.x = 174;
			_ground.y = -833;
			_ground.scaleX = _ground.scaleY = 2;
			
			//Items
			_axe = new LGyAxe;
			ground.addChild(_axe);
			_axe.x = 1330;
			_axe.y = -470;
			
			//Character
			characterG = new LCharacterG;
			addChild(characterG);
			characterG.x = 400; //121
			characterG.y = 300; // 554
			characterG.scaleX = characterG.scaleY = 0.27;
			characterG.gotoAndStop("idel");
			
			//Achivement bling
			achiBling = new LAchiBling;
			addChild(achiBling);
			achiBling.visible = false;
			
			//Items
			_gyFlower = new LGyFlower;
			ground.addChild(_gyFlower);
			_gyFlower.x = 2700;
			_gyFlower.y = -100;
			_gyFlower.visible = true;
			
			_lanternShadow = new LLanternShadow;
			addChild(_lanternShadow);
			
			//Timers
			timerDragDown.start();
			timerDragDown.addEventListener(TimerEvent.TIMER, dragDownCharacter);
			timerHalfWayDragDown.addEventListener(TimerEvent.TIMER, characterinHole);
			timerHalfWayDragDown.start();

			//Stage Handler
			addEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}

//Stage handler
		//For more info, see the "greatest love forest" doc. 
		private function stageAddHandler(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
			
			removeEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}
		
//OnFrameLoop
		public function onFrameLoop()
		{
			//CutScene
			if (dragDownHalfWay == true) // Helps the cut scene go smoothly
				halfWay();
				
			
			if (dragDown == true) // Starts the cutscene
				characterG.gotoAndStop("zombies");
			
			
			//Picking up items
			if (_axe != null)
			{
				if (_axe.hitTestPoint (characterG.x, characterG.y - 100, true))
					axePickup();
			}
			
			if (_gyFlower != null)
			{
				if (_gyFlower.hitTestPoint (characterG.x, characterG.y, true))
					flowerPickup();
			}
			
			//Trigers the achivement
			if (_gyFlower  == null && _axe == null)
				explored = true;
			
			//Functions we want to have running constantly. 
			moving();
			groundMoving();
		}
		
//Cutscene
		public function dragDownCharacter(event:TimerEvent):void
		{
			dragDown = true;
			speed = 0;
			trace ("timer");
		}
		
		public function characterinHole(event:TimerEvent):void
		{
			dragDownHalfWay = true;
			speed = 0;
			trace ("timer");
		}

		private function halfWay ()
		{
			if (_characterFalling == null)
			{
				_characterFalling = new LCharacterFalling;
				addChild (_characterFalling);
				_characterFalling.x = 0;
				_characterFalling.y = 0;
			}
		}
		
//Picking up items
		private function axePickup()
		{
			characterG.gotoAndStop("walkAxe");
			ground.removeChild(_axe);
			_axe = null;
			trace ("hitting the axe");
		}
	
		private function flowerPickup()
		{
			ground.removeChild(_gyFlower);
			_gyFlower = null;
			trace ("hitting the _gyFlower");
		}
		
//Ground moving
		private function groundMoving()
		{
			//Here we make sure that character cant walk outside of the graveyeard
			if (ground.y > 977)
				ground.y = 976;
			
			if (ground.y < 0)
				ground.y = 1;
				
			if (ground.x > 51)
				ground.x = 50;
			
			if (ground.x < -2314)
				ground.x = -2313;
				
//Restrictions
			//Making the character unable to walk on the graves
			//First section of graves on the loswer part of the image.
			if (ground.x < -728 && ground.y < 198)
				ground.y = 197;
		
			//Second section of graves on the lower part of the screen.
			if (ground.x < -1541 && ground.y < 334)
				ground.y = 333;
				
			//Making the transition go smother when the character walks along the graves.
			if (ground.x < -1447 && ground.y < 216)
				ground.y = 215;
				
			//First section of graves on the top part of the screen
			if (ground.x > -739 && ground.y > 567)
				ground.y = 566;
			
			//Second section of graves on the top part of the secreen, including the tree.
			if (ground.x > -2061 && ground.y > 701)
				ground.y = 700;
		}

//Character moving
		private function moving ()
		{
			if (turnCharacter < 40 && turnCharacter > -40 && dragDown == false)
				directions += turnCharacter;
				
				ground.y += Math.cos(directions*Math.PI/180) * speed; 
				ground.x -= Math.sin(directions*Math.PI/180) * speed;
				
				characterG.rotation = directions;
		}

//KeyPress
		//We dont want the character to walk while there is a cut scene, thats why we have added if tests. 
		public function onKeyPressed(e:KeyboardEvent):void
		{
			if (dragDown == false)
			{
				var key:uint = e.keyCode;
				switch (key)
				{
					case Keyboard.W:
					speed = maxSpeed;
					
					if (_axe != null)
					characterG.gotoAndStop("walk");
					if (_axe == null)
					characterG.gotoAndStop("walkAxe");
					break;
					
					case Keyboard.S:
					speed = -maxSpeed;
					
					if (_axe != null)
					characterG.gotoAndStop("walk");
					if (_axe == null)
					characterG.gotoAndStop("walkAxe");
					
					break;
					case Keyboard.A:
					turnCharacter += -turnSpeed;
					break;
					case Keyboard.D:
					turnCharacter += +turnSpeed;
					break;
				}
			}
		}
		
		public function onKeyReleased(e:KeyboardEvent):void
		{

			if (dragDown == false)
			{
				var key:uint = e.keyCode;
				switch (key)
				{
					case Keyboard.W:
					speed = 0;
					
					if (_axe != null)
					characterG.gotoAndStop("idel");
					if (_axe == null)
					characterG.gotoAndStop("idelAxe");
					break;
					
					case Keyboard.S:
					speed = 0;
					
					if (_axe != null)
					characterG.gotoAndStop("idel");
					if (_axe == null)
					characterG.gotoAndStop("idelAxe");
					break;
					
					case Keyboard.A:
					turnCharacter = 0;
					break;
					case Keyboard.D:
					turnCharacter = 0;
					break;
				}
			}
		}

 }
}
