package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class GreatestLoveForest extends MovieClip 
 {	 
 //variables
 		//Timer that makes the shadow hit the light to turn it off. 
 		var timerDark:Timer = new Timer(112000, 1); //112 sec + 000 1 sec less then when the whole thing is done. 
 
		//Array variables - we will add them here so that we can better use them later again when we want to interact with the bubbles.
		public var bubbleArray:Array;
		public var maxBubbles:Number = 10;
 
		//Achi tracker
		public var bubbleCount:int;
		public var bubbleDeathCount:Boolean = false;
		public var achiBling:LAchiBling;// makes the bling happen when the achivement has been compleated. 
		public var nineToFive:Boolean = true;
		public var sceneOver:Boolean = false;
		
		//bubbles and a sprite
		private var _bubble1:LBubble;
		private var _bubble2:LBubble;
		private var _bubble3:LBubble;
		private var _bubbleP:LBubblePoison;
		private var bubble:Sprite;
		
		//shadow turning of the light
		private var _shadowHammer:LShadowHammer;
	 
		//This wall will hinder the characters movement into objects. The boolean will tell us if the character hits the objects. 
		private var _wall1:LWall1;
		private var _wall2:LWall2;
		private var wall:Sprite;
		 
		private var hitWall:Boolean = false;
		private var hitWallL:Boolean = false;
		private var hitWallR:Boolean = false;

		//variables that will make the game run smoother
		private var a:int = 2;
		private var b:int = 2;
		 
		private var itemAdded:int = 0;
		private var dead:Boolean = false;
		 
		private var speedForest:Number = -5;
		 
		//Importet Classes
		private var glBackg:GreatestLoveBackgrounds;
		private var glArray:GLForestArray;
	
		//Here we add the characterF
		public var characterF:LCharacterF;
	
		//Walking
		public var walkL:Boolean = false;
		public var walkR:Boolean = false;
		public var speed:Number = 0;
		 
		//Jumping
		public var jumping:Boolean = false;
		public var onGround:Boolean = true;
		 
		//Physics 
		public var gravity:Number = 3;
		public var friktion:Number = 0.9;
		public var jumpSpeed:Number = 0;
		public var maxJumpSpeed:Number = -40;
		 
		public var maxSpeed:Number = 15;
	 
		public function GreatestLoveForest() 
		{
//Items
			// Adding items that will be there all the way through the scene. We will add Walls here although its counterparts are in "g.l.Backgrounds" This is to better change 
			// the variables a and b without having to add to much code in this class. We will use a and b as indicators to help us add items or activate functions. 

			//The walls used to block the character from moving into unwanted places.
			wall = new Sprite;
			addChild(wall);
			wall.visible = false;
 
			_wall1 = new LWall1;
			wall.addChild (_wall1);
			_wall1.x = 0;
			_wall1.y = 0;
			_wall1.gotoAndStop(a);
			
			_wall2 = new LWall2;
			wall.addChild (_wall2);
			_wall2.x = 800;
			_wall2.y = 0;
			_wall2.gotoAndStop(b);
			
		
			//Background
			glBackg = new GreatestLoveBackgrounds;
			addChild (glBackg);

			//character
			characterF = new LCharacterF;
			addChild (characterF);
			characterF.x = 100;
			characterF.y = 570;
			characterF.gotoAndStop(1);
			characterF.scaleX = characterF.scaleY = 0.7;
			
			//Bling that will help the player know when he has finished an achivement.
			achiBling = new LAchiBling;
			addChild (achiBling);
			achiBling.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
			
			//We start making the array here. 
			bubbleArray = new Array();
			
			//Timer to start the event where the shadow turns of the lights. 
			timerDark.addEventListener(TimerEvent.TIMER, shadowHammering);
			timerDark.start();
		}
		
		
//onFrameLoop
		public function onFrameLoop ()
		{	
			//Here we tell the game if the scene is comming to an end and if the player should have an achivement.
			if (b == 10) 
				sceneOver = true;
				
			//This line here is to stop the character moving out of the screen. 
			if (characterF.x > 30 && characterF.x < 800 && a < 11 && b < 12)
				characterF.x += speedForest;
			 
			//Checks if the character has died and if he has it turns the gravity back to 3. If the character on the other hans -is- dead, 
			//we want an animation to play while the character is floating down. 
			if (dead == false)
				gravity = 3;
				
			if (dead == true)
				characterF.gotoAndStop("flying");
				
			//Functions that I want running constantly
			itemsOnStage();
			stageEvents();
			
			//Movement & world
			movement ();
			jumpFunction();
			wallMovement();
			characterOnGround();
			hittingWalls();
			fallingInAcide();
			bubbleJump();
			
			//funktions in a different class. The class is "GreatestLoveBackgrounds"
			glBackg.onFrameLoop();
			
			//funktions in a different class. The class is "GreatestLoveArray"
			if (glArray != null)
				glArray.onFrameLoop();

		}
		
//Stage Handler
		//Stage handler is used to activate the keyboard events. This is cause the "stage" here is not a global event. It will only be added if 
		//we call on it -after- adding the class GLForest to the stage. 
		private function stageAddHandler(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
			
			removeEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}
		
//Die or Scnene over
		//Here we will add two functions that will end the scene or make the character die and respawn. 
		//When the character dies he will float down again so that the player can find a safe place to aim. 
		public function playerDead()
		{
			if (dead == true)
			{
				characterF.y =  175;
				gravity = 0.01;
				jumping = true;
				jumpSpeed = 0;
			}
		}
		
		public function forestOver()
		{
			trace ("ForestOver");
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
		}

//Stage
		//Everything placed on stage is in this section. 
		//In this one we will be adding items that will show up on stage as the song goes on. We will also remove them. 
		private function itemsOnStage()
		{
			//Array - Adding the array
			if (a == 9) //7
			{
				if (itemAdded != 5 && glArray == null)
				{
					glArray = new GLForestArray;
					addChild (glArray);
					itemAdded = 5;
					
				}
			}
			
			//Array - removing the array
			if (glArray !=null) //8
			{
				if (glArray.flowerBed.x < -1000)
				{
					removeChild (glArray);
					glArray = null;
				}
			}
			
			//Bubbles
			//We are adding 4 bubbles used as the item the character is supposed to pick up. We will add 3 nice bubbles then move them around instead of 
			//an array as there are only 3 nice bubbles and an array would be unsessesery.
			if (itemAdded !=3 && a == 2)
			{
				//Nice bubble
				bubble = new Sprite;
				addChild (bubble);
				
				_bubble1 = new LBubble;
				bubble.addChild(_bubble1);
				_bubble1.x = 900;
				_bubble1.y = 300;
				_bubble1.play();
				
				_bubble2 = new LBubble;
				bubble.addChild(_bubble2);
				_bubble2.x = 1000;
				_bubble2.y = 200;
				_bubble2.play();
				
				_bubble3 = new LBubble;
				bubble.addChild(_bubble3);
				_bubble3.x = 1500;
				_bubble3.y = 500;
				_bubble3.play();
			
				//Evil bubble!
				_bubbleP = new LBubblePoison;
				bubble.addChild(_bubbleP);
				_bubbleP.x = 1350;
				_bubbleP.y = 500;
				_bubbleP.play();
				
				itemAdded = 3;
			}
			
			//Shadow turns of light - when the scene is about to end we want the shadow to come and turn the light off. This will happen as the song sings it. 
			if (b == 10 && _shadowHammer == null)
			{
				_shadowHammer = new LShadowHammer;
				addChild(_shadowHammer);
				_shadowHammer.x = 1416;
				_shadowHammer.y = 521;
				_shadowHammer.gotoAndStop("idel");
			}
		}

//EventsStage
		//Things happening on the stage in reaction to the character comming in range or stepping on something. 
		public function stageEvents()
		{
			
			//Array - checks if the character hits any of the flowers in the array. 
			if (glArray !=null)
			{
				setChildIndex(glArray, 2)
				for each (var flower:LFlowerArray in glArray.flowerArray)
				{
					if (characterF.hitTestObject (flower))
						{
							glArray.flowerEnd();
							trace(glArray.flower);
							flower.y = 700;
							
							if (dead == false)
							{
								dead = true;
								playerDead();
							}
						}
				}
			}
			
			//FlowerLift - this lift is in the doc class GreatestLoveBackgrounds - makes the flower go up and makes the world move down a bit. 
			// This will do so the character doesnt jump out of sight. 
			if (b == 5 || a == 6 || b == 6) //We only want to test for this while the flower is on stage. 
			{
				if (characterF.hitTestObject(glBackg.lift))
					{
					glBackg.lift.y -= 2;
					characterF.y -= 2;
					
					}
			
			
				if (characterF.hitTestObject (glBackg.lift) && glBackg.y < 100)
				{
					glBackg.y += 2;
					_wall1.y += 2;
					_wall2.y +=2;
				}
			}
			
			if ( b == 6 && glBackg.y < 100)
			{
				glBackg.y += 0.5;
				_wall1.y += 0.5;
				_wall2.y +=0.5;
			}

			//Bubble
			//Bubble Movement
			// This part is meant to make the bubbles move and respawn as the game pogresses. the bubbles will spawn in a sett lacation, then move across the screen
			// when they hit -100 they will respawn in a ranom location aimed to be within range of the character most of the time. 
			if (_bubble1.x < -100)
			{
				_bubble1.x = 800 + Math.random() * 800;
				_bubble1.y = 570 + Math.random() * -450;
				_bubble1.visible = true;
				_bubble1.gotoAndPlay(1);
			}

			if (_bubble2.x < -100)
			{
				_bubble2.x = 800 + Math.random() * 800;
				_bubble2.y = 570 + Math.random() * -450;
				_bubble2.visible = true;
				_bubble2.gotoAndPlay(1);
			}

			if (_bubble3.x < -100)
			{
				_bubble3.x = 800 + Math.random() * 800;
				_bubble3.y = 570 + Math.random() * -450;
				_bubble3.visible = true;
				_bubble3.gotoAndPlay(1);
			}
			
			if (_bubbleP.x < -100)
			{
				_bubbleP.x = 800 + Math.random() * 800;
				_bubbleP.y = 570 + Math.random() * -450;
				_bubbleP.visible = true;
				_bubbleP.gotoAndPlay(1);
			}
			
			//Here we move the bubbles. 
			_bubble1.x += speedForest;
			_bubble2.x += speedForest;
			_bubble3.x += speedForest;
			_bubbleP.x += speedForest;
			
			//Bubble Hit
			//If the character hits the bubbles we want them to popp and change a score that will result in the character getting an achivement. 
			//We will go and play the frame 81 ++, if the bubble has finished playing the frames the bubble will become invisible and the character will no longer be able to popp them.
			//This will resett when the bubble respawns again. 
			
			//Bubble 1
			if (characterF.hitTestObject(_bubble1) && _bubble1.visible == true && _bubble1.currentFrame < 102)
			{
				_bubble1.gotoAndPlay(103);
				
			}
				
			if (_bubble1.currentFrame == 110 && _bubble1.visible == true)
			{
				_bubble1.visible = false;;
				bubbleCount +=1;
				trace (bubbleCount);
			}
			

			//Bubble 2
			if (characterF.hitTestObject(_bubble2) && _bubble2.visible == true && _bubble2.currentFrame < 102)
			{
				_bubble2.gotoAndPlay(103);
			}
				
			if (_bubble2.currentFrame == 110 && _bubble2.visible == true)
			{
				_bubble2.visible = false;
				bubbleCount +=1;
				trace (bubbleCount);
			}
			
			
			//Bubble 3
			if (characterF.hitTestObject(_bubble3) && _bubble3.visible == true && _bubble3.currentFrame < 102)
			{
				_bubble3.gotoAndPlay(103);
				
			}
			if (_bubble3.currentFrame == 110 && _bubble3.visible == true)
			{
				_bubble3.visible = false;
				bubbleCount +=1;
				trace (bubbleCount);
			}
			
			//Evil bubble
			if (characterF.hitTestObject(_bubbleP) && _bubbleP.visible == true && _bubbleP.currentFrame < 91)
			{
				_bubbleP.gotoAndPlay(92);
				
			}
			if (_bubbleP.currentFrame == 102 && _bubbleP.visible == true)
			{
				dead = true;
				playerDead();
				_bubbleP.visible = false;
				bubbleDeathCount = true;
			}
			
			//Shadow turns of light - movement of the shadowHammer
			if (_shadowHammer != null && a != 11)
			{
				_shadowHammer.x += speedForest;
			}
		}

//ShadowTimer
		//Here the timed event makes the shadow hit the light so it turns dark.
		public function shadowHammering(event:TimerEvent):void
		{
			_shadowHammer.gotoAndStop("hitting");
		}

		
//Background
		
		//Acide - dead
		//To make out character die when he hits the acide we will add a funktion where the character hitTestObjects a small stripp that will constantly be on the screen.
		public function fallingInAcide()
		{
			if (characterF.hitTestObject(glBackg.acideFront))
			{
				playerDead();
				dead = true;
			}
		}
		
		//BubbleJumping
		//At the end of the scene we want the character to jump over bubbles, we will add the bubbles by using an array. We will then remove them when the character jumps on them. 
		public function bubbleJump()
		{
			if (glBackg.ground.visible == false && b == 8)
			{
				//This will let the item show even though its located on the "ground" sprite
				glBackg.ground.visible = true;
				
				for (var i:Number = 0; i< maxBubbles; i++)
				{
					var bubbleStone:LBubbleStones = new LBubbleStones();
					glBackg.ground.addChild(bubbleStone);
					bubbleStone.y = 331 + Math.random() * 100; // As we dont want the position of the bubbles to all be the same we will add some random factores in. 
					bubbleStone.x = 845 + (70 * i + (Math.random() * 60));
					
					bubbleArray.push(bubbleStone);
				}
			}
			
			if (glBackg.ground.visible == true && b == 8)
			{
			//Under this for we will check the bubbles to see if they have been hit or if we want to move them.
				for (var j:int = 0; j < bubbleArray.length; ++j)
				{
					bubbleArray[j].x -= 5;
					trace ("j" + j);
					
					if (characterF.hitTestObject(bubbleArray[j]) &&  bubbleArray[j].currentFrame < 84)
						{
						trace ("this" + j);
						bubbleArray[j].gotoAndPlay(85);
						}					
				}
			}
		}
		
		//Walls
		//WallHitting
		//We will add walls to our game, this will help the character stay within given limits. 
		public function hittingWalls()
		{
			//First we will check if the character hits our walls. If we use a normal hit test point on this, the character will only tell the game when its Z point is in contact with the map.
			//To prevent this we have measured up the character and devided the X in two(60 = 30), while (as our Z point is at the characters feet) the Y had only been added in one direction. 
			// We have split Walking Right and Walking left into two different test, this is to more accurately make a Boolean to fir the situation. 
			
			if (b == 3 || a == 6 || a == 7 || a == 8 || a == 9 || b == 6 || b == 7 || b == 8 || b == 10 ) // here we check if its even a point running the hitTestPoint check. HitTestPoint takes alot for the game to check. 
			{
				
				if (walkR == true && wall.hitTestPoint((characterF.x + 23),(characterF.y - 40),true)) // Tests if the character is walking Right when hitting the wall. 
					hitWallR = true;
	
				if (walkL == true && wall.hitTestPoint((characterF.x - 23),(characterF.y - 40),true)) // Testing if the character is walking Left when hitting the wall.
					hitWallL = true;
				
				//We dont need to check if the character hits the roof at this point, but as we might in the future we will keep the codes even if they arnt active atm.
				/*if (jumping == true && wall.hitTestPoint((characterF.x),(characterF.y - 130),true))//Here we check if the character is jumping. This will stop the character from jumping through the hit test point ground as well as make for good obstacles.  
					{
					hitWall = true;
					}*/
			}

			//I have added the jumping event first for a reason. The result is that this will override the other events if not stopped from doing so. 
			//We have in this situation added (hitWallL == false && hitWallR == false) that helps flash determine if we are currently in the process of walking into another wall.
			//This is however not enough. We would stop the event from letting you pass through walls to your left and right, but we would not stop it from being used again thus letting you walk through walls. 
			//This is why we have added walkL and walkR = false. This means that when your character hits the wall he will stop dead in his track. 
			/*if (jumping == true && hitWall == true)
			{
				hitWall = false;
				characterF.y += 40;  // On all the events we have added a bounce back. This is so that our character won't get stuck inside one of the walls. As for the roof.. it actually looks better. 
				jumpSpeed = 0;
				characterOnGround();
			}*/
				
			if (walkL == true && hitWallL == true)
			{
				walkL = false;
				hitWallL = false;
				characterF.x += 20; //alternatively, if you have a ball, you could reverse the speed and have it bounce even more.  
			}

			if (walkR == true && hitWallR == true)
			{
				walkR = false;
				hitWallR = false;
				characterF.x -= 20;
			}
		}
		
		//Wall moving
		public function wallMovement()
		{
		
			// Here we add the thing that will make the character unable to pass through walls and such. 
			if (a < 11 && b < 11)
			{
				_wall1.x += speedForest;
				_wall2.x += speedForest;
				
				if (_wall1.x == -800)
				{
					a += 1;
					_wall1.x = 800;
					_wall1.gotoAndStop(a);
				}
				if (_wall2.x == -800)
				{
					b += 1;
					_wall2.x = 800;
					_wall2.gotoAndStop(b);
				}
			}
		}
		
//Moving
// The whole next section is all about Movement done by the characterF.
		//Jumping
		//Here we check if the character is jumping. We have added a check to see if the character is hitting a wall.
		public function jumpFunction()
		{
			if (jumping == true) 
			{
				characterF.y +=jumpSpeed;
				stayingOnGround();
				
				//We will add this so that the character no longer will go through the floors 
				if (jumpSpeed < 20)
				{
					jumpSpeed += gravity;
				}
			}
			if (jumping == true  && glBackg.ground.hitTestPoint(characterF.x,characterF.y,true) )
			{
				if (jumpSpeed > 5)
				{
					characterF.gotoAndStop("idel");
					jumping = false;
					stayingOnGround();
					jumpSpeed = 0;
				}
			}
		}
		
		//Falling of the ground
		private function characterOnGround():void
		{
				if (glBackg.ground.hitTestPoint(characterF.x,characterF.y,true) == false )
				{
					characterF.y +=  jumpSpeed;
					stayingOnGround();
						
					if (jumpSpeed < 20)
					{
						jumpSpeed += gravity;
					}
				}
		}
		
		//Staying on the ground
		//Here we have a function that makes sure the character stays on the ground at all times. When the character walks down hill we want him to stay on the ground and easily desend
		//This runs as it says "while" the character is doing X. This means that it runs even more often then onFrameLoop, and therefor we dont need to use a high vaslu to keep it smooth. 
		private function stayingOnGround():void
		{
			
			while (glBackg.ground.hitTestPoint(characterF.x,characterF.y,true))
			{
				characterF.y-= 0.1;
				dead = false;
			}
			
			characterF.y +=  3;
		}


		//Character controll - This sections makes the character move left and right
		public function movement()
		{ 
			
			if (walkL == true && characterF.x > 0)
			{
				characterF.x += speed;
				stayingOnGround()
				characterF.scaleX = -0.7;
				
				if (jumping == false)
					characterF.gotoAndStop("run");
			}
				
			if (walkR == true && characterF.x < 800)
			{
				characterF.x += speed;
				stayingOnGround()
				characterF.scaleX = 0.7;
				
				if (jumping == false)
					characterF.gotoAndStop("run");
			}
			
			if (characterF.x < 31)
				nineToFive = false;
			
			//Friktion			
			//Potentyally later I will add friction so the game will be harder
/*			if (walkR == false && walkL == false && speed != 0 && characterF.x < 800 && hitWall == false)
			{
				characterF.x += speed;
				speed *= friktion;
				stayingOnGround()
			}
			
			if (walkR == false && walkL == false && speed < 2 )
			{
				speed = 0;
				stayingOnGround()
			}*/

		}
		
		//Key presses
		
		public function onKeyPressed(e:KeyboardEvent) : void
		{
			var key:uint = e.keyCode;
			switch (key)
				{
				case Keyboard.SPACE:
				case Keyboard.W:
				if (jumping == false) // we only want the player to be able to jump if he isnt already jumping. 
				{
					jumpSpeed = maxJumpSpeed;
					jumping = true;
					characterF.gotoAndStop("jump");
				}
				
				break;
				case Keyboard.A:
				trace ("Stil Workingada");
				walkL = true;
				speed = -maxSpeed;				
				break;
				case Keyboard.D:
				walkR = true;
				speed = maxSpeed;
				break;
				}
			
		}
		
		public function onKeyReleased(e:KeyboardEvent) : void
		{
				var key:uint = e.keyCode;
				switch (key)
				{
				case Keyboard.A:
				characterF.gotoAndStop("idel");
				walkL = false;
				break;
				case Keyboard.D:
				characterF.gotoAndStop("idel");
				walkR = false;
				break;
				}
		}

 }
}
