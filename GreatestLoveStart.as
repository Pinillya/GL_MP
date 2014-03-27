package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class GreatestLoveStart extends MovieClip
 {
//Variables
	 public var intro:LIntro;
	 public var firstPlay:LFirstPlay;
	 public var achievement:LAchievement;
	 
	 public var removeIntro:Boolean = false;

		public function GreatestLoveStart() 
		{
//Items
			intro = new LIntro;
			addChild (intro);
			intro.x = -50;
			intro.y = 20;
			intro.scaleX = intro.scaleY = 1.5;
			
			firstPlay = new LFirstPlay;
			addChild (firstPlay);
			firstPlay.x = 227;
			firstPlay.y = 256;
			
		}

 }
}

