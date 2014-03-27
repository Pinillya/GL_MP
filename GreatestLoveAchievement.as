package  
{
	import flash.display.MovieClip;
	
	public class GreatestLoveAchievement extends MovieClip
 {
//Variables
		 //Items
		 public var achievements:LAchievements;
		 public var poisonMeadal:LPoisonMeadal;
		 public var bubbleMedal:LBubbleMedal;
		 public var hammerMedal:LHammerMedal;
		 public var timeMedal:LTimeMedal;
		 public var explorerMedal:LExplorerMedal;
		 public var fistMedal:LFistMedal;
		 
		 //Sparks
		 private var _spark:LSpark;
		 	 
		 //Booleans see if items have been added before or not
		 public var addDisplay:Boolean;
	 
	 
		public function GreatestLoveAchievement() 
		{
			
//All the medals
				achievements = new LAchievements;
				addChild(achievements);

				poisonMeadal = new LPoisonMeadal;
				addChild (poisonMeadal);
				poisonMeadal.x = 233;
				poisonMeadal.y = 142;
				poisonMeadal.gotoAndStop(1); //This is how the final result will look like when an achiv is done. 
				
				bubbleMedal = new LBubbleMedal;
				addChild (bubbleMedal);
				bubbleMedal.x = 233;
				bubbleMedal.y = 205;
				bubbleMedal.gotoAndStop(1);
				
				hammerMedal = new LHammerMedal;
				addChild (hammerMedal);
				hammerMedal.x = 233;
				hammerMedal.y = 276;
				hammerMedal.gotoAndStop(1);
				
				timeMedal = new LTimeMedal;
				addChild (timeMedal);
				timeMedal.x = 233;
				timeMedal.y = 349;
				timeMedal.gotoAndStop(1);
				
				explorerMedal = new LExplorerMedal;
				addChild (explorerMedal);
				explorerMedal.x = 233;
				explorerMedal.y = 412;
				explorerMedal.gotoAndStop(1);
				
				fistMedal = new LFistMedal;
				addChild (fistMedal);
				fistMedal.x = 233;
				fistMedal.y = 472;
				fistMedal.gotoAndStop(1); 
			
		}
		
//On Frame Loop
		//The final medal will be given if the player manages to do all the achivements. 
		public function onFrameLoop ()
		{
			if (poisonMeadal.currentFrame == 2  && bubbleMedal.currentFrame == 2 && hammerMedal.currentFrame == 2 && timeMedal.currentFrame == 2 && explorerMedal.currentFrame == 2  && fistMedal.currentFrame != 2) 				
				fistMedal.gotoAndStop(2);
		}
 }
}
