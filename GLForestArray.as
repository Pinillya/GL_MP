package  
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class GLForestArray extends MovieClip
 {

//Variables
		//Items and shadow
		public var flowerBed:LFlowerBed;
	 	private var _shadowF:LShadowF;
		
		//Making the array
		public var flower:LFlowerArray;
		public var flowerArray:Array;
	 
		//Timer that will make the array spawn flowers. 
		public var arrayTimer:Timer;
	 	
		public function GLForestArray() 
		{
//Items
			//shadow - the one pulling out flowers and throwing them up in the air so they land on our player.
			_shadowF = new LShadowF;
			addChild (_shadowF);
			_shadowF.x = 1200;
			_shadowF.y = 200;
			_shadowF.scaleX = _shadowF.scaleY = 0.6;
			
			//FlowerBed will be used as the platfor for the shadow. 
			flowerBed = new LFlowerBed;
			addChild(flowerBed);
			flowerBed.x = 820;
			flowerBed.y = 100;
			flowerBed.visible = true;

//Array and Timer
			//Making the array
			flowerArray = new Array();
			
			arrayTimer = new Timer(1500);
			arrayTimer.addEventListener(TimerEvent.TIMER, makeFlowers);
			arrayTimer.start();
			
		}
		
//OnFrameLoop
		public function onFrameLoop()
		{
			//Moving the items (Not the array) across the screen.
			_shadowF.x -= 3;
			flowerBed.x -= 4;
			
			//Checking if one of the flowers has come so low it should be deleted.
			flowerEnd();
			
			//Moving the flowers with the scene aswell as making them "fall" 
			for (var j:int = 0; j < flowerArray.length; j++)
			{
				flowerArray[j].y += 4;
				flowerArray[j].x -= 5;
			}
		}
		
//MakeArray
		//The timer makes one and one flower spawn. We have also added a random factor into it so that the spawning will be irregular. 
		public function makeFlowers (event:TimerEvent):void
		{
			if ( Math.random() < 0.9 ) //Random spawn timer as they will only spawn 9 out of 10 times. 
			{
				var randomX:Number = 400 + Math.random() * 800; //Random spawn location. 
				flower = new LFlowerArray();
				flower.x = randomX;
				flower.y = -15;
				
				flowerArray.push( flower );
				addChild( flower );
			}
		}
		
//Removing flowers
		//We remove the flowers and splice the array. this way the array wont get to long. We will remove them whenever they get to low on the screen. 
		public function flowerEnd()
		{
			for (var j:int = 0; j < flowerArray.length; j++)
			{
				if (flowerArray[j].y > 439)
				{
					this.removeChild(flowerArray[j]);
					flowerArray[j] = null;
					flowerArray.splice(j, 1);
				}
			}
		}

 }
}
