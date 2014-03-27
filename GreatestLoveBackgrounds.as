package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GreatestLoveBackgrounds extends MovieClip
 {
//Variables
	 	//a and b will help the objects "ground" and "backg" know what frame they are supposed to show at any given time. 
		//This will also help activate some of the events during the game. 
		private var a:int = 2;
		private var b:int = 2;
		
		//Background.
		private var _backg1:LBackg1;
		private var _backg2:LBackg2;
		 
		//Items
		public var lift:LLift;
		 
		//Ground floor, this will help the character move on our objects. 
		private var _ground1:LGround1;
		private var _ground2:LGround2;
		public var ground:Sprite;
		 
		//Acide
		//If the character falls he falls into some acide. We will both have the visual acide and the acide that the character dies if he hits. 
		private var _acide1:LAcide;
		private var _acide2:LAcide;
		public var acideFront:LAcideFront; //dies
		public var acide:Sprite;
		
		//Number used to controll how fast the stage moves. 
		private var speedForest:Number = -5;

		public function GreatestLoveBackgrounds() 
		{
//Items
			
			//Acide
			acide = new Sprite;
			addChild(acide);
		
			_acide1 = new LAcide;
			addChild(_acide1);
			_acide1.x = 406;
			_acide1.y = 600;
			_acide1.visible = false;
			setChildIndex (_acide1,1);
			
			_acide2 = new LAcide;
			addChild(_acide2);
			_acide2.x = 1215;
			_acide2.y = 600;
			_acide2.visible = false;
			setChildIndex (_acide2,2);
			
			//We will use this small stationary strip to check if the character falls inn. 
			acideFront = new LAcideFront;
			addChild (acideFront);
			acideFront.x = 0;
			acideFront.y = 587;
			
			//Ground
			//Here we will add a sprite that we will use to colect the two ground objects this will make it easier to check against 
			//aswell as open for the option of adding items into the sprite like the lift. 
			ground = new Sprite;
			addChild(ground);
			ground.visible = false;


			//The ground he will walk on and we will use to hit thest point.
			_ground1 = new LGround1;
			ground.addChild (_ground1);
			_ground1.x = 0;
			_ground1.y = 0;
			_ground1.gotoAndStop(a);
			
			_ground2 = new LGround2;
			ground.addChild (_ground2);
			_ground2.x = 800;
			_ground2.y = 0;
			_ground2.gotoAndStop(b);
			
			//Background
			_backg1 = new LBackg1;
			addChild (_backg1);
			_backg1.x = 0;
			_backg1.y = 0;
			_backg1.gotoAndStop(a);
			
			_backg2 = new LBackg2;
			addChild (_backg2);
			_backg2.x = 800;
			_backg2.y = 0;
			_backg2.gotoAndStop(b);
		
		}
//OnFrameLoop
		public function onFrameLoop ()
		{
			//The only important function of this class is to contain the world, and to make it move. 
			stageMoving();
			
		}

//Moving the world.
		//This part  controlls the movement of the forest the ground and the Acide. The main background. Please notice how A and B changes value as the background image changes. 
		//They will change as they leaves the screen, being at x 800, then reenters so that they can pass by again this time with a new image sept for the acide witch only has one image. 
		public function stageMoving()
		{
			
			//Background
			if (a < 11 && b < 12)
			{
				_backg1.x += speedForest;
				_backg2.x += speedForest;
				
				if (_backg1.x == -800)
				{
					a += 1;
					_backg1.x = 800;
					_backg1.gotoAndStop(a);
				}
				
				if (_backg2.x == -800)
				{
					b += 1;
					_backg2.x = 800;
					_backg2.gotoAndStop(b);
				}
			
			}
			
			//Ground
			if (a < 11 && b < 11) 
			{
				_ground1.x += speedForest;
				_ground2.x += speedForest;
				
				if (_ground1.x == -800)
				{
					trace ("Ground changing" + a);
					_ground1.x = 800;
					_ground1.gotoAndStop(a);
				}
				
				if (_ground2.x == -800)
				{
					trace ("Ground changing2" + b);
					_ground2.x = 800;
					_ground2.gotoAndStop(b);
				}
			}
			
			//Adding the other functions here as there is no need for them to start unless the ground and background has been made. 
			stageFlowerLift();
			stageAddingAcide();
		}

//FlowerLift
		//The flowerlift will help the character move up on the higher levels. We will also at the same time lower the screen so that the character isnt jumping out of wiev. 
		public function stageFlowerLift()
		{ 
			//Adding
			if (b == 5 && lift == null) 
			{
				trace ("running the lift");
				lift = new LLift;
				ground.addChild(lift);
				lift.x = 1581,55;
				lift.y = 963,60;
				lift.visible = true;
			}
			
			//Removing
			if (b == 7)
			{
				if(lift != null)
				{
					ground.removeChild(lift);
					lift = null;
				}
			}
			
			//Visible/Invisible
			//Speed and turning the ground visible so that the flower lift will actuallt show up.
			if (lift != null)
			{
				ground.visible = true;
				lift.x += speedForest;
			}
				
			//Turning the ground invisible again
			if (b == 7)
			{
				ground.visible = false;
			}
			
		}
		
//Acide 
		//We will give the acide its own function as it will be added later then the background and ground.
		public function stageAddingAcide()
		{			
			//Movement
			//Here we will add the acide. We will not use the a and b value here as we only have two frames with them.
			if (b > 3 && a < 11 && b < 11)
			{
				_acide1.visible = true;
	 			_acide2.visible = true;
				
				_acide1.x += -3;
				_acide2.x += -3;
				
				if (_acide1.x < -395)
				{
					_acide1.x = 1206;
				}
				if (_acide2.x < -395)
				{
					_acide2.x = 1206;
				}
			}
		}
			
 }
}