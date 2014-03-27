package  
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class GreatestLoveUnderground  extends MovieClip
 {
//Variables
		//Timers
		var timerAttack:Timer = new Timer(6000); // Here we have the 6 sec boss timer. Every 6 sec the boss will go to hit the character.
		var timerDone:Timer = new Timer(29000); // As we want the fight to end in time ( 38sec) the shadow will come in and help the player if they are to slow. 
		
		//Background
		private var _undergBackg:LUndergBackg;
		private var _frontUnderg:LFrontUnderg;
		private var _forgroundEnd:LForgroundEnd;
		
		//Items
		private var _playerHP:LPlayerHP;
		private var _bossHP:LBossHP;
		private var _box:LBox;
		
		//Characters/hammer/shadow
		public var characterAxe:LCharacterAxe;
		private var _hammer:LHammer;
		private var _shadowHelp:LShadowHelp;
		
		//Help to controll walking - we will only have left and right walking, the character will not be able to jump with a weapon. 
		private var speed:Number = 0;
		private var maxSpeed:Number = 10;
		 
		//Helps controll the characters scale
		 private var scale:Number = 1;
		 
		//Booleans. Attacking will help us see if the boss should be damaged or not.
		//SceneStarted will run the removing of the forground one time aswell as putting the character into "idel"
		//CharacterDead will tell if the character fainted.
		//Blocking tells if the character is blocking an attack. 
		//Walk will help the character walk
		private var attacking:Boolean = false;
		private var sceneStarted:Boolean = true;
		private var walk:Boolean = false;
		private var walkL:Boolean = true;
		private var blocking:Boolean = false;
		private var keyLift:Boolean = true; //keyLift as in when you are not pressing down any keys on your keaboard.
		private var characterDead:Boolean = false;
		
		//We will add life to the character and the boss
		private var bossLife:int = 100; //100 
		private var characterLife:Number = 54; //devided in 3 for the HP bar. the boss needs 3 hits without the character blocking to kill him. Alternatively he needs 5 blocked attacks.
	
		//Achivements.
		public var bossAchi:Boolean = false;
		public var achiBling:LAchiBling;
	 
		public function GreatestLoveUnderground() 
		{
//items
			//Background. 
			_undergBackg = new LUndergBackg;
			addChild(_undergBackg);
			_undergBackg.x = 0;
			_undergBackg.y = 284;
			
			//Character
			characterAxe = new LCharacterAxe;
			addChild (characterAxe);
			characterAxe.x = 180;
			characterAxe.y = 470;
			characterAxe.gotoAndStop ("falling");
			characterAxe.scaleX = -scale;
			
			//Achivement - tells if the character has compleated an achivement.
			achiBling = new LAchiBling;
			addChild (achiBling);
			achiBling.visible = false;
			
			//The boss 
			_hammer = new LHammer;
			addChild (_hammer);
			_hammer.x = 570;
			_hammer.y = 761;
			_hammer.gotoAndPlay (1);
			
			//Roof in front for when the character is falling down and a forground for when he enters the mice hole.
			_frontUnderg = new LFrontUnderg;
			addChild (_frontUnderg);
			_frontUnderg.x = -103,10;
			_frontUnderg.y = -84,85;
			
			_forgroundEnd = new LForgroundEnd;
			addChild(_forgroundEnd);
			_forgroundEnd.x = 1914;
			_forgroundEnd.y = -137;
			_forgroundEnd.visible = false;

//event listners
			addEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
			
			//This will be the timer that makes the boss attack the player. The timer is every 6 sec. 
			timerAttack.addEventListener(TimerEvent.TIMER, bossAttack);
			timerDone.addEventListener(TimerEvent.TIMER, timeOut);
		}
//StageHandler
		//For more info, please see Greatest love forest
		private function stageAddHandler(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
			
			removeEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}

//OnFrameLoop
		public function onFrameLoop()
		{
			//We will put most functions in here as during a fight its always important for everything to be updated. 
			gettingSmaller ();
			fallingStart();
			characterMoving ();
			hammerFight();
			fightHP();
			shadowHelpingStill();
			
			//If the character has killed the boss, or if the character "died" and the shadow had to help him win the fight. 
			if (bossLife < 0 || bossLife == 0 && _undergBackg.x > -1200)
			fightDone();
		}
		
//Start - we will make the character fall into the screen and then the HP bars show up. 
		public function fallingStart()
		{
			//items moving into place
			if (_undergBackg.y > 0)
			{
				_undergBackg.y -= 12;
				_hammer.y -= 12;
				_frontUnderg.y -=12;
			}
			
			//When the character hit the ground he will go into idel pose. We will then remove the front that made the baloon look like it was comming out of the shaft with the
			//character. We will also use this oppertunety to make the HP bars only one time. Finally we will start the timer that will result in the hammer attacking the player.
			if (_undergBackg.y < 0 && sceneStarted == true)
			{
				characterAxe.gotoAndStop ("idel");
				
				if (_frontUnderg !=null)
				{
					timerAttack.start(); //We start the timer for the attacks as soon as the character lands.
					timerDone.start(); //We start the timer for the end of the fight.
					
					removeChild (_frontUnderg);
					_frontUnderg = null;
					
					//Makes this part of the function only hallen one time.
					sceneStarted = false;
					
					//Items being added
					_playerHP = new LPlayerHP;
					addChild (_playerHP);
					_playerHP.x = 12;
					_playerHP.y = -29;
					_playerHP.gotoAndStop(1);
					
					_bossHP = new LBossHP;
					addChild (_bossHP);
					_bossHP.x = 791;
					_bossHP.y = -29;
					_bossHP.gotoAndStop(1);
					_bossHP.scaleX = -1;
					
					_box = new LBox;
					addChild (_box);
					_box.x = 356;
					_box.y = 8;
					
				}
			}
		}

//HP 
//HP
		public function fightHP()
		{
			
//Player HP -> 
			//we use this section to make the image change on the HP bar. As the monster hits for an undecided number everytime 
			//we chose to do it this way as we cant simply ask the frame to turn = HP. Not as long as we are using a number instead of an int. 
			if (characterLife < 51 && characterLife > 50)
				_playerHP.gotoAndStop(2);
				
			if (characterLife < 50 && characterLife > 48)
				_playerHP.gotoAndStop(3);
				
			if (characterLife < 48 && characterLife > 45)
				_playerHP.gotoAndStop(4);
				
			if (characterLife < 45 && characterLife > 42)
				_playerHP.gotoAndStop(5);
				
			if (characterLife < 42 && characterLife > 39)
				_playerHP.gotoAndStop(6);
				
			if (characterLife < 39 && characterLife > 36)
				_playerHP.gotoAndStop(7);
				
			if (characterLife < 36 && characterLife > 33)
				_playerHP.gotoAndStop(8);
				
			if (characterLife < 33 && characterLife > 30)
				_playerHP.gotoAndStop(9);
				
			if (characterLife < 30 && characterLife > 27)
				_playerHP.gotoAndStop(10);
				
			if (characterLife < 27 && characterLife > 24)
				_playerHP.gotoAndStop(11);
				
			if (characterLife < 24 && characterLife > 21)
				_playerHP.gotoAndStop(12);
				
			if (characterLife < 21 && characterLife > 18)
				_playerHP.gotoAndStop(13);
			
			if (characterLife < 18 && characterLife > 15)
				_playerHP.gotoAndStop(14);
				
			if (characterLife < 15 && characterLife > 12)
				_playerHP.gotoAndStop(15);
				
			if (characterLife < 12 && characterLife > 9)
				_playerHP.gotoAndStop(16);
				
			if (characterLife < 9 && characterLife > 6)
				_playerHP.gotoAndStop(17);
				
			if (characterLife < 6 && characterLife > 3)
				_playerHP.gotoAndStop(18);
				
			if (characterLife < 3 && characterLife > 0)
				_playerHP.gotoAndStop(18);
				
			if (characterLife < 0 && characterLife > -10)
				_playerHP.gotoAndStop(19);
				
//BossHP
			
			if (bossLife < 100 && bossLife > 95)
				_bossHP.gotoAndStop(2);
				
			if (bossLife < 95 && bossLife > 90)
				_bossHP.gotoAndStop(3);
				
			if (bossLife < 90 && bossLife > 85)
				_bossHP.gotoAndStop(4);
				
			if (bossLife < 85 && bossLife > 80)
				_bossHP.gotoAndStop(5);
				
			if (bossLife < 80 && bossLife > 75)
				_bossHP.gotoAndStop(6);
				
			if (bossLife < 75 && bossLife > 70)
				_bossHP.gotoAndStop(7);
				
			if (bossLife < 70 && bossLife > 65)
				_bossHP.gotoAndStop(8);
				
			if (bossLife < 65 && bossLife > 60)
				_bossHP.gotoAndStop(9);
				
			if (bossLife < 60 && bossLife > 55)
				_bossHP.gotoAndStop(10);
				
			if (bossLife < 55 && bossLife > 50)
				_bossHP.gotoAndStop(11);
				
			if (bossLife < 50 && bossLife > 45)
				_bossHP.gotoAndStop(12);
				
			if (bossLife < 45 && bossLife > 40)
				_bossHP.gotoAndStop(13);
				
			if (bossLife < 40 && bossLife > 35)
				_bossHP.gotoAndStop(14);
				
			if (bossLife < 35 && bossLife > 30)
				_bossHP.gotoAndStop(15);
				
			if (bossLife < 30 && bossLife > 20)
				_bossHP.gotoAndStop(16);
				
			if (bossLife < 20 && bossLife > 10)
				_bossHP.gotoAndStop(17);
	
			if (bossLife < 10 && bossLife > 0)
				_bossHP.gotoAndStop(18);
				
			if (bossLife < 0 && bossLife > -10)
				_bossHP.gotoAndStop(19);

		}
		
//Fight
		public function hammerFight()
		{
			//We will  be working in frames on the boss as its simpler to make the boss animations play out. In this one the boss goes back to idel after attacking.
			if (_hammer.currentFrame == 87)
				_hammer.gotoAndPlay (1);
			
			//Here the character gets hit without blocking.
			if (_hammer.hitTestObject (characterAxe) && blocking == false && _hammer.currentFrame > 66 )
			{
				characterLife -=1;
				trace (characterLife);
			}
			
			//Here the character gets hit while he is blocking - he will lose half as much HP
			if (_hammer.hitTestObject (characterAxe) && blocking == true && _hammer.currentFrame > 66)
			{
				characterLife -= 0.5;
				trace (characterLife);
			}
			
			//If the character hits the boss, the boss will lose 1 life.
			if (_hammer.hitTestObject (characterAxe) && attacking == true)
			{
				keyLift = false;
				attacking = false;
				bossLife -=1;
				trace (bossLife + "Boss");
			}
			
			//This will make sure the boss dies if he has to little HP. We will stop the timer so he wont automaticly do another hit.
			if (bossLife < 0 && _hammer.currentFrame < 25 )
			{
				trace ("dead");
				_hammer.gotoAndPlay (25);
				timerAttack.stop();
				
			}
			
			//If the character dies and the boss isnt dead he will need some help. He will "die" and the shadow will come and help him. 
			if (characterLife < 0 && bossLife > 0)
			{
				trace ("Character dead");
				timerAttack.stop();
				characterDead = true;
				shadowHelp();
			}
			
			if (characterLife  > 5 && bossLife < 1)
			{
				bossAchi = true;
			}
		}
		
		//This times event will lead to the boss attacking every 6 sec.
		public function bossAttack (event:TimerEvent):void
		{
					_hammer.gotoAndPlay (66);
		}


		//Timer running out for the fight
		public function timeOut (event:TimerEvent):void
		{
			if (bossLife > 0)
			{
				trace ("Timeout");
				shadowHelp();
				timerAttack.stop();
				characterLife = 52;
				characterDead = true;
			}
		}

//ShadowHelp
		//Making the shadow.
		public function shadowHelp()
		{
			if (_shadowHelp == null)
			{
				_shadowHelp = new LShadowHelp;
				addChild (_shadowHelp);
				_shadowHelp.x = 885;
				_shadowHelp.y = 490;
				_shadowHelp.scaleX = _shadowHelp.scaleY = 0.5;
			}
		}
		
		//Helping the shadow move in, kick and kill the hammer then walk out and let our character wake up again. 
		public function shadowHelpingStill()
		{
			if (_shadowHelp != null)
			{
				//Shadow walks inn if he is not next to the hammer.
				if (_shadowHelp.hitTestObject(_hammer) != true)
					_shadowHelp.x -= 3;
				
				//The shadow gets to the hammer and kicks him, the hammer dies.
				if (_shadowHelp.hitTestObject (_hammer) && _hammer.currentFrame < 25 && _shadowHelp.currentFrame < 13)
				{
					_shadowHelp.gotoAndPlay (13) //42
				}
				
				if (_shadowHelp.hitTestObject (_hammer) && _hammer.currentFrame < 25 && _shadowHelp.currentFrame > 31)
				{
					_hammer.gotoAndPlay (25);
					bossLife = 0;
				}
				
				//The shadow walks out again.
				if (bossLife == 0 || bossLife < 0)
				{
					_shadowHelp.x += 3;
					
					if (_shadowHelp.currentFrame < 55)
						_shadowHelp.gotoAndPlay (55);
				}
				
				//The character stays "dead"
				if (_shadowHelp.x < 900 )
				{
					characterAxe.gotoAndStop ("dead");
					trace ("Character changing to dying");
				}
				
				//The shadow is all the way out and the character can wake up. The shadow is removed and the character gets his HP back. 
				if (_shadowHelp.x > 800 && bossLife == 0)
				{
					trace ("Character Not dead");
					characterAxe.gotoAndStop ("idel");
					
					removeChild(_shadowHelp);
					_shadowHelp = null;
					characterLife = 2;
					characterDead = false;
				}
				
			}
		}

//Done Fighting
		//When the fight is over we want the screen to move the character, but not if the character is out of the screens limits. We will also turn the HPbars invisible.
		public function fightDone()
		{
			//We dont want the HP bars to show when the fight is over, as we are not going to use this scene that long and all children will be removed and nulled out when the 
			//new scene startes we will only turn the three items invisible until the scene is over.
			_playerHP.visible = false;
			_bossHP.visible = false;
			_box.visible = false;
			_forgroundEnd.visible = true;
			
			if ( _undergBackg.x > -1279)
			{
				_undergBackg.x -= 3;
				_hammer.x -= 3;
				_forgroundEnd.x -=3;
			
			
				if (characterAxe.x < 800 && characterAxe.x > 0 )
					characterAxe.x -=3;
				
			}
		}

		public function gettingSmaller ()
		{
			if (_undergBackg.x < -100 && _undergBackg.x > -1100)
			{
				scale =  characterAxe.scaleX = characterAxe.scaleY *= 0.997;
				walkL = false;
			}

			if (_undergBackg.x < -1100)
			{
				walkL = true;			
			}
		}
		
//Moving
		//We make a the character move left and right, but if he moves left and hits the end of the screen he will stop. Same will happen if he walks right and hits the screen
		// We have two versions of this so that the character wont get stuck in the screen, this is due to there being only one boolean to say if the character is walking or not. 
		public function characterMoving ()
		{
			if (walk == true && characterAxe.x < 800 && speed > 0 )
			{
				characterAxe.x += speed;
				characterAxe.gotoAndStop ("walk");
			}
			
			if (walk == true && speed < 0 && characterAxe.x >0 )
			{
				characterAxe.x += speed;
				characterAxe.gotoAndStop ("walk");
			}
			
			//If the character is doing nothing he will go into an idel pose. 
			if (walk == false && attacking == false && blocking == false && sceneStarted == false && keyLift == true && characterDead == false)
			{
				characterAxe.gotoAndStop ("idel");
			}
				
		}
		
//Key pressed
		public function onKeyPressed(e:KeyboardEvent) : void
		{
			if (characterDead == false) //The character will no longer be able to move when dead. 
			{
			var key:uint = e.keyCode;
			switch (key)
				{
				case Keyboard.Q:
				if (attacking == false) // We dont want the character to be able to block and swing at the same time. We also want him to let go of the button before he changes pose. 
				{
					blocking = true;
					attacking = false;
					characterAxe.gotoAndStop ("block");
				}
				break;
				
				case Keyboard.W:
				if (attacking == false && keyLift == true && blocking == false)
				{
					attacking = true;
					characterAxe.gotoAndStop ("attack");
				}
				break;
				
					
				case Keyboard.A:
				if (walkL == true)
				{
					walk = true;
					speed = -maxSpeed;
					characterAxe.scaleX = -scale;
				}
				
				break;
				case Keyboard.D:
				walk = true;
				speed = maxSpeed;
				characterAxe.scaleX = scale;
				
				break;
				}
			}
			
		}
		
		public function onKeyReleased(e:KeyboardEvent) : void
		{
			var key:uint = e.keyCode;
			switch (key)
				{
				case Keyboard.Q:
				blocking = false;
				break;
					
				case Keyboard.W:
				attacking = false;
				keyLift = true;
				break;
				
				case Keyboard.A:
				walk = false;
				break;
				case Keyboard.D:
				walk = false;
				break;
				}
		}
 }
}
