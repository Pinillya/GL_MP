package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GreatestLoveTeaParty extends MovieClip
 {
//Variables
		private var _teaParty:LTeaParty;
		private var _credits:LCredits;
		
		//Medals
		public var achievements:LAchievements;
		public var poisonMeadal:LPoisonMeadal;
		public var bubbleMedal:LBubbleMedal;
		public var hammerMedal:LHammerMedal;
		public var timeMedal:LTimeMedal;
		public var explorerMedal:LExplorerMedal;
		public var fistMedal:LFistMedal;
		
		public var medal:Sprite; //The sprites will help us move the items.
		
		//Signs
		private var _sign1:LSign;
		private var _sign2:LSign;
		private var _sign3:LSign;
		private var _sign4:LSign;
		private var _sign5:LSign;
		private var _sign6:LSign;
		private var _sign7:LSign;
		
		private var _sign:Sprite;
		
		public function GreatestLoveTeaParty() 
		{
//Items
			_teaParty = new LTeaParty;
			addChild(_teaParty);
			_teaParty.x = 0;
			_teaParty.y = 0;
			
			_credits = new LCredits;
			addChild (_credits);
			_credits.x = 841;
			_credits.y = 52;
			
			//Medals
			medal = new Sprite;
			addChild (medal);
			
			poisonMeadal = new LPoisonMeadal;
			medal.addChild (poisonMeadal);
			poisonMeadal.x = 830;
			poisonMeadal.y = 543;
			poisonMeadal.gotoAndStop(1);  
			
			bubbleMedal = new LBubbleMedal;
			medal.addChild (bubbleMedal);
			bubbleMedal.x = 1025;
			bubbleMedal.y = 543;
			bubbleMedal.gotoAndStop(1);
			
			hammerMedal = new LHammerMedal;
			medal.addChild (hammerMedal);
			hammerMedal.x = 1209;
			hammerMedal.y = 543;
			hammerMedal.gotoAndStop(1);
			
			timeMedal = new LTimeMedal;
			medal.addChild (timeMedal);
			timeMedal.x = 1410;
			timeMedal.y = 543;
			timeMedal.gotoAndStop(1);
			
			explorerMedal = new LExplorerMedal;
			medal.addChild (explorerMedal);
			explorerMedal.x = 1600;
			explorerMedal.y = 543;
			explorerMedal.gotoAndStop(1);
			
			fistMedal = new LFistMedal;
			medal.addChild (fistMedal);
			fistMedal.x = 1807;
			fistMedal.y = 543;
			fistMedal.gotoAndStop(1);
			
			//Signs
			_sign = new Sprite;
			addChild (_sign);
			
			_sign1 = new LSign;
			_sign.addChild(_sign1);
			_sign1.x = 859;
			_sign1.y = 533;
			_sign1.gotoAndStop(2);
			
			_sign2 = new LSign;
			_sign.addChild(_sign2);
			_sign2.x = 1060;
			_sign2.y = 533;
			_sign2.gotoAndStop(2);
			
			_sign3 = new LSign;
			_sign.addChild(_sign3);
			_sign3.x = 1243;
			_sign3.y = 533;
			_sign3.gotoAndStop(2);
			
			_sign4 = new LSign;
			_sign.addChild(_sign4);
			_sign4.x = 1447;
			_sign4.y = 533;
			_sign4.gotoAndStop(2);
			
			_sign5 = new LSign;
			_sign.addChild(_sign5);
			_sign5.x = 1647;
			_sign5.y = 533;
			_sign5.gotoAndStop(2);
			
			_sign6 = new LSign;
			_sign.addChild(_sign6);
			_sign6.x = 1835;
			_sign6.y = 533;
			_sign6.gotoAndStop(2);
		}
		
		public function onFrameLoop()
		{
			//Moves the medals, signs and credits
			medal.x -= 3;
			_sign.x -= 3;
			_credits.x -= 2;
			
			//Achivement summ upp - if the medal has gone to frame 2, the sign will tell you that you passed.
			if (poisonMeadal.currentFrame == 2)
				_sign1.gotoAndStop(1);
				
			if (bubbleMedal.currentFrame == 2)
				_sign2.gotoAndStop(1);
				
			if (hammerMedal.currentFrame == 2)
				_sign3.gotoAndStop(1);
				
			if (timeMedal.currentFrame == 2)
				_sign4.gotoAndStop(1);
				
			if (explorerMedal.currentFrame == 2)
				_sign5.gotoAndStop(1);
				
			if (fistMedal.currentFrame == 2)
				_sign6.gotoAndStop(1);
		}
 }
}
