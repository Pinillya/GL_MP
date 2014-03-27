package  
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.media.Sound;
	
	
	public class GreatestLoveMain extends MovieClip 
 {     
 
 //Variables
		//This will help the song start
		private var musik:Sound;
			
		//timers 
		var timerCemetery:Timer = new Timer(113000, 1); //113+000sec
		var timerUnderground:Timer = new Timer(43000, 1); //43+000sec
		var timerTeaParty:Timer = new Timer(50000, 1); //50+000sec 2.37 157 - 3.26 207 -- 8 sec til neste scene
		var timerFinish:Timer = new Timer (26000, 1); //26sec until the song is done.
		 
		//Other Classes
		public var glStart:GreatestLoveStart;
		public var glForest:GreatestLoveForest;
		public var  glAchi:GreatestLoveAchievement;
		public var  glGraveyard:GreatestLoveGraveyard;
		public var  glUnderground:GreatestLoveUnderground;
		public var 	glTeaParty:GreatestLoveTeaParty;
		 
		 
		//Booleans thats going to check what function is active, that way we will have less running on onFrameLoop and hinder the game from running slowly. 
		private var introActive:Boolean = true;
		private var forestActive:Boolean = false;
		private var cemeteryActive:Boolean = false;
		private var undergroundActive:Boolean = false;
		private var teaPartyActive:Boolean = false;
		 
		//Here we check if the next scene has been drawn or not. This way we will only draw it one time.
		private var forestDrawn:Boolean = false;
		private var cemeteryDrawn:Boolean = false;
		private var undergroundDrawn:Boolean = false;
		private var tableDrawn:Boolean = false;
		 
		//screens that will be used through out the game.  (the final screen "achivements" has its own class and is therefor not here.)
		public var instructions:LInstructions;
		public var frame:LFrame;
		
		//Sprite that assists in making the achivements and the instructions stay infront of the screen.
		public var aAndI:Sprite;
		
		
		public function GreatestLoveMain() 
		{
//Adding items and eventListners

			//Starts the first screen. We dont want all the items in here as we want to be able to remove them and add them when they are needed.
			//Only the items and actions that we want to have as long as the game is active, is in this section.
			drawIntro();
			
			//We will add achivm and Instructions to a sprite, this way we can change their index number together. 
			aAndI = new Sprite;
			addChild(aAndI);
			
			instructions = new LInstructions;
			aAndI.addChild(instructions);
			instructions.x = 0;
			instructions.y = 0;
			instructions.visible = false;
			
			glAchi = new GreatestLoveAchievement; 
			aAndI.addChild(glAchi);
			glAchi.visible = false;
			glAchi.addDisplay = true; // This will enshure that our glAchi only adds itself one time.
			
			frame = new LFrame;
			addChild (frame);
			frame.x = 0;
			frame.y = 0;
			
			musik = new LMusik; // From the band Ctrl-Alt-Delete with the song A vampire Cyllable. All rights provided for this flash game.
			
			
			addEventListener(Event.ENTER_FRAME, onFrameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
		}
		
//Drawing the scenes.

		//Intro
		//We start the game by drawing the intro. The intro will never be deleted, only hidden. This helps when we reset the game and start all over. 
		public function drawIntro()
		{
			if (introActive == true)
			
			{
				glStart = new GreatestLoveStart;
				addChild (glStart);
			}
		}
		
		//Forest
		//We draw the forest, start the music, then we set the index of the two items that needs to always be infront of the screen. 
		//Finally we start the timer that will lead us to the Grave Yard. 
		public function drawForest()
		{
			glForest = new GreatestLoveForest;
			addChild(glForest);
			
			musik.play();
			
			setChildIndex(aAndI, 3)
			setChildIndex (frame, 3)
			
			
			//We want the scenes to end when the song fits best, this is why we are adding timers. Timers will make the scene end in time with the music, even if the game lags.  
			timerCemetery.addEventListener(TimerEvent.TIMER, drawCemetery);
			timerCemetery.start();
		}
		
		//Cemetery
		//Fist we will remove the forest to stop the game from lagging. 
		//We will also add a variable so that we can turn on the onFrameLoop of the 
		//graveyeard and turn the one helping the onFrameLoop in "forest" - off. 
		public function drawCemetery(event:TimerEvent):void
		{			
			glGraveyard = new GreatestLoveGraveyard;
			addChild(glGraveyard);

			forestActive = false;
			cemeteryActive = true;
			glForest.forestOver(); // This will help us stop the keyPresses from the forest. 
			
			setChildIndex(aAndI, 4)
			setChildIndex (frame, 4)

			removeChild(glForest);
			glForest = null;
			
			//We want the scenes to end when the song fits best, this is why we are adding timers. 
			timerUnderground.addEventListener(TimerEvent.TIMER, drawUnderground);
			timerUnderground.start();
		}
		
		//Underground
		//We will add the underground, make sure onframe loop runs only for the right scene and remove any scene that has come before. 
		//Finally we activate a timer that will get us to the next scene.
		public function drawUnderground(event:TimerEvent):void
		{
			
			glUnderground = new GreatestLoveUnderground;
			addChild(glUnderground);
			
			undergroundActive = true;
			cemeteryActive = false;
			
			setChildIndex(aAndI, 4)
			setChildIndex (frame, 4)

			removeChild(glGraveyard);
			glGraveyard = null;
			
			//We want the scenes to end when the song fits best, this is why we are adding timers. 
			timerTeaParty.addEventListener(TimerEvent.TIMER, drawTeaParty);
			timerTeaParty.start();
		}
		
		//TeaParty
		//We will add the tea party, make sure onframe loop runs only for the right scene and remove any scene that has come before. 
		//Finally we activate a timer that will get us to the next scene.
		public function drawTeaParty(event:TimerEvent):void
		{			
			glTeaParty = new GreatestLoveTeaParty;
			addChild (glTeaParty);
			
			teaPartyActive = true;
			undergroundActive = false;
			
			
			setChildIndex(aAndI, 4)
			setChildIndex (frame, 4)

			removeChild(glUnderground);
			glUnderground = null;
			
			timerFinish.addEventListener(TimerEvent.TIMER, drawFinish);
			timerFinish.start();
		}
		
		//Finish
		//We will here only remove the tea party child then turn the right onFrameLoop on. As we want the game to loop and the start screen is only invisible
		//We will turn the start screen visible. 
		public function drawFinish(event:TimerEvent):void
		{			
			removeChild (glTeaParty);
			glTeaParty = null;
			
			teaPartyActive = false;
			introActive = true;
			
			glStart.visible = true;
			glStart.removeIntro = false;
		}
		
//FrameLoop

		//Here we add onFrameLoop. We will use alot of booleans here to ease what this function needs to go through so that only onFrameLoop is active at the scene it is needed.
		public function onFrameLoop (e:Event):void
		{		
			
			//As we want the onFrameLoop funktion within Achievement to always be running, so that we can update the achivements asap, we will add it here without any if checks. 
			glAchi.onFrameLoop();
			
			//Intro
			//Intro onFrameLoop - will only be active if the intro is.
			//We check if the intro is active, if th eplayer wants the game to start he will turn it off and the forest scene will begin.
			if (introActive == true && glStart != null) 
			{
				if (glStart.removeIntro == true) 
				{
					glStart.visible = false;  		
					
					forestActive = true;
					forestDrawn = false;
					introActive = false;
				}
			}
			
			//Forest
			//Forest onFrameLoop - Will only be active if the forest is. 
			//First we check if the forest needs to be drawn (made). This wil only happen one time. Then to avoid errors we check if the forest exists"
			//if it does we want the on frame loop of the forest to run.
			//We then check if any of the forest achivements has been compleated. This has to happen here in this doc as we are comunicationg between two classes. 
			if (forestActive == true) 
			{				
				if (forestDrawn == false)
				{
					drawForest();
					forestDrawn = true;
				}
				
				if (glForest != null)
				{
					glForest.onFrameLoop();
					
					//Achivements.
					//This section is for updating all achivements. We will use the main doc to comunicate between the two classes.

					//Achi glimer to tell the player he has compleated an achivement. We want to make sure it turns of again.  
					if (glForest.achiBling.currentFrame == 14) 
						glForest.achiBling.visible = false;
					
					
					//First we check if the achivement is done, and then if it has already been compleated. Then we change the icon on the achivement page.
					// We then run the achi bling to tell the player that he has indeed finished an achivement.
					
					//Bubble achiv - popping 30 bubbles.
					if (glForest.bubbleCount == 30 && glAchi.bubbleMedal.currentFrame != 2)
					{
						glAchi.bubbleMedal.gotoAndStop(2); //Here we update the madal so it is shining. 
						glForest.achiBling.x = glForest.characterF.x;
						glForest.achiBling.y = glForest.characterF.y;
						glForest.achiBling.visible = true;
						glForest.achiBling.gotoAndPlay (1);
					}
					
					//9 to 5 - never let the character fall behind and hit the screen side on the left. 
					if (glForest.nineToFive == true && glForest.sceneOver == true)
					{
						glAchi.timeMedal.gotoAndStop(2); //Here we update the madal so it is shining. 
						glForest.achiBling.x = glForest.characterF.x;
						glForest.achiBling.y = glForest.characterF.y;
						glForest.achiBling.visible = true;
						glForest.achiBling.gotoAndPlay (1);
						glForest.nineToFive = false;
					}
					
					//Bubble dodger - never hitting a poisones bubble. 
					if (glForest.bubbleDeathCount == false && glForest.sceneOver == true)
					{
						glAchi.poisonMeadal.gotoAndStop(2); //Here we update the madal so it is shining. 
						glForest.achiBling.x = glForest.characterF.x;
						glForest.achiBling.y = glForest.characterF.y;
						glForest.achiBling.visible = true;
						glForest.achiBling.gotoAndPlay (1);
						glForest.bubbleDeathCount = true;
					}
				}
				
			}
			
			//Cemetery
			//Cemetery onFrameLoop - Will only be active if the forest timer has activated it. 
			//First we check if the cemetery needs to be drawn (made). This wil only happen one time. Then to avoid errors we check if the cemetery exists"
			//if it does we want the on frame loop of the cemetery to run.
			//We then check if the cemetery achivement has been compleated. This has to happen here in this doc as we are comunicationg between two classes. 
			if (cemeteryActive == true && glGraveyard != null) 
			{
				glGraveyard.onFrameLoop();
				
				if (glGraveyard != null)
				{
					
					//Achi glimer to tell the player he has compleated an achivement. We want to make sure it turns of again. 
					if (glGraveyard.achiBling.currentFrame == 14) 
						glGraveyard.achiBling.visible = false;
					
					//First we check if the achivement is done, and then if it has already been compleated. Then we change the icon on the achivement page.
					// We then run the achi bling to tell the player that he has indeed finished an achivement.
					
					//Explorer
					if (glGraveyard.explored == true && glAchi.explorerMedal.currentFrame == 1)
					{
						glAchi.explorerMedal.gotoAndStop(2); //Here we update the madal so it is shining. 
						glGraveyard.achiBling.x = glGraveyard.characterG.x ;
						glGraveyard.achiBling.y = glGraveyard.characterG.y +100;
						glGraveyard.achiBling.visible = true;
						glGraveyard.achiBling.gotoAndPlay (1);
					}
				}
			}
			
			//Underground
			//Underground onFrameLoop - Will only be active if the forest is.  
			//First we check if the Underground needs to be drawn (made). This wil only happen one time. Then to avoid errors we check if the Underground exists"
			//if it does we want the on frame loop of the cemetery to run.
			//We then check if the Underground achivement has been compleated. This has to happen here in this doc as we are comunicationg between two classes.
			if (undergroundActive == true) 
			{
				glUnderground.onFrameLoop();
				
				if (glUnderground != null)
				{
					//Achi glimer to tell the player he has compleated an achivement. We want to make sure it turns of again
					if (glUnderground.achiBling.currentFrame == 14) 
						glUnderground.achiBling.visible = false;
				
					//First we check if the achivement is done, and then if it has already been compleated. Then we change the icon on the achivement page.
					// We then run the achi bling to tell the player that he has indeed finished an achivement. 
					
					//Killing the boss
					if (glUnderground.bossAchi == true && glAchi.hammerMedal.currentFrame != 2)
					{
						glAchi.hammerMedal.gotoAndStop(2); 
						glUnderground.achiBling.x = glUnderground.characterAxe.x;
						glUnderground.achiBling.y = glUnderground.characterAxe.y;
						glUnderground.achiBling.visible = true;
						glUnderground.achiBling.gotoAndPlay (1);
					}
				}

			}
			
			//TeaParty 
			//The tea party on frame loop will help run the achivements across the screen. This will help the player see what he has finished. 
			//This will only happen if the tea Party exists. 
			//We will check if the medals are at frame 2. They will only be at frame 2 if the achivement has been compleated. Then if it has been compleated we will turn make
			//The medal shine in the last scene aswell. We will tenn use this to tell that class if the achivement is done or not witch will finally lead to a sign saying passed of fail. 
			if (teaPartyActive == true) 
			{
				glTeaParty.onFrameLoop();
				
				if (glTeaParty != null)
				{
					//Achivement summ upp.
					if (glAchi.poisonMeadal.currentFrame == 2)
						glTeaParty.poisonMeadal.gotoAndStop(2);
						
					if (glAchi.bubbleMedal.currentFrame == 2)
						glTeaParty.bubbleMedal.gotoAndStop(2);
						
					if (glAchi.hammerMedal.currentFrame == 2)
						glTeaParty.hammerMedal.gotoAndStop(2);
						
					if (glAchi.timeMedal.currentFrame == 2)
						glTeaParty.timeMedal.gotoAndStop(2);
						
					if (glAchi.explorerMedal.currentFrame == 2)
						glTeaParty.explorerMedal.gotoAndStop(2);
						
					if (glAchi.fistMedal.currentFrame == 2)
						glTeaParty.fistMedal.gotoAndStop(2);
				}
			}
		}
		
//KeyPress
		//This section will help us find out if the player wants to look at the instructuions or look at their achivements. It will also help the player start the game. 
		public function onKeyPressed(e:KeyboardEvent) : void
		{	
			var key:uint = e.keyCode;
			switch (key)
				{
				case Keyboard.SPACE:
				if (glStart.visible == true)
					glStart.removeIntro = true;
				break;
					
				case Keyboard.F:
				instructions.visible = true;
				break;
				case Keyboard.E:
				glAchi.visible = true;
				break;
				}
		}
		
		public function onKeyReleased(e:KeyboardEvent) : void
		{
			var key:uint = e.keyCode;
			switch (key)
				{
				case Keyboard.E:
				glAchi.visible = false;
				break;
				case Keyboard.F:
				instructions.visible = false;
				break;
				}
		}
 }
}
