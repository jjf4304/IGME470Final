import processing.serial.*;

Serial port;

Player player;

ArrayList<Asteroid> asteroids;
ArrayList<Bullet> bullets;
int time = 0;
float deltaTime;

boolean negativeModsOn;
String negativeMessage;
int numNegativeModsOn;
int blockerXPos;
int blockerYPos;
int blockerWidth;

float shootTimer;
int timeBtwShots;

float asteroidSpawnTimer;
int timeBtwSpawn;

int positionX;
int lastPosition;
int shoot;

int[] modifiers;

void setup(){
  
  size(800, 800);
  
   String portName = Serial.list()[0];
   port = new Serial(this, portName, 9600);
 
   port.clear();
   port.bufferUntil('\n');
   
   asteroids = new ArrayList<Asteroid>();
   bullets = new ArrayList<Bullet>();
   
   negativeModsOn = false;
   
   modifiers = new int[2];
   modifiers[0] = 0;
   modifiers[1] = 0;
   
   positionX = 400;
   shoot = 0;
   
   player = new Player(400, 700);
   time = millis();
   
   //Set up all other variables
   timeBtwShots = 2;
   shootTimer = 0.0f;
   
   timeBtwSpawn = 1;
   asteroidSpawnTimer = 0.0f;
   
   blockerXPos = 0;
   blockerYPos = 0;
   blockerWidth = 0;
   
   numNegativeModsOn = 0;
}

void draw(){
  //Get Delta Time;
  deltaTime = (float(millis() - time))/1000.0;
  time = millis();
  
  //Add to timers
  incrementTimers(deltaTime);

  //Draw background;
  background(200);

  //Get arduino input
  String input = port.readString();
  
  //If input isn't null, trim and set the movement and shoot inputs
  if(input != null){
    input = trim(input);
    int inputs[] = int(split(input, ','));
    if(inputs.length > 1){
      shoot = inputs[0];
      //Help get rid of the problem of random input shifting;
      if(abs(inputs[1] - positionX) <= 100){
        positionX = inputs[1];
      }
    }
  }
  
  //If shoot is 1 and enough time between shots has passed, spawn a new bullet
  if(shoot == 1 && shootTimer >= timeBtwShots){
    shootTimer = 0.0f;
    shoot = 0;
    Bullet b = new Bullet(player.getXPos(), player.getYPos()- player.getWidth()/2);
    bullets.add(b);
  }
  
  //if enough time has passed since last spawn, spawn a new asteroid
  if(asteroidSpawnTimer >= timeBtwSpawn){
    
   asteroidSpawnTimer = 0.0f;
   
   int xPos = int(random(30, 770));
   int asteroidWidth = int(random(40, 100));
   //brown rgb
   int red = 165;
   int green = 42;
   int blue = 42;
   
   Asteroid a = new Asteroid(xPos, 0, asteroidWidth, red, green, blue);
   asteroids.add(a);
  }
  
  //Check if reversed movement is on
  if(modifiers[0] == 1){
     positionX = reverseNumber(positionX, 25, 775); 
  }
  
  UpdateAllEntities();
  removeEntitiesFromLists();
  
  //Check if blocking rect is on
  if(modifiers[1] == 1){
      drawBlocker();
  }

}


//Call update on all entities
void UpdateAllEntities(){
    //Update player
    player.Update(positionX);
    
    //update bullets
    for(int i = 0; i < bullets.size(); i++){
     bullets.get(i).Update(deltaTime, asteroids); 
    }
    
    //update asteroids
    for(int i = 0; i < asteroids.size(); i++){
     if(asteroids.get(i).Update(deltaTime, player) == 1){
      setNegativeModifiers(); 
     } 
    }
}

//reverse a number given the max and min it can be. Used as a negative modifier
//to reverse the direction the controller moves the player.
int reverseNumber(int position, int max, int min){
   return (max+min) - position; 
}

//increment timers for actions
void incrementTimers(float dTime){
   shootTimer+=dTime; 
   asteroidSpawnTimer+=dTime;
}

//Remove dead entities from the array lists
void removeEntitiesFromLists(){
    //apparently need to reverse array lists to remove from, which makes sense I suppose
  //From processing's documentation: https://processing.org/reference/ArrayList.html
  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid asteroid = asteroids.get(i);
    if (asteroid.dead()) {
      asteroids.remove(i);
    }
  }
  
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    if (bullet.dead()) {
      bullets.remove(i);
    }
  }
}

void setNegativeModifiers(){
  negativeModsOn = true;
  numNegativeModsOn++;
  
  //Quick fix until more modifiers are in place.
  if(modifiers[1] != 1){
  modifiers[1] = 1;
  blockerXPos = int(random(25, 775));
  blockerYPos = int(random(25, 600));
  blockerWidth = int(random(500, 800));
  }
  
  //Right now reverse doesn't work so no reason to have more than one set. Fix this later
  /*
  if(numNegativeModsOn > modifiers.length){
    numNegativeModsOn = modifiers.length;
  }
  else{
    int modToTurnOn = int(random(0, modifiers.length));
    boolean assigned = false;
    //Assign a new modifier. If that mod is already on, find the next one that isnt
    for(int i =0; i < modifiers.length; i++){
      if(modifiers[modToTurnOn]== 0){
         modifiers[modToTurnOn] = 1; 
         //If Blocker drawing is now on, assign random width and pos.
         if(modToTurnOn == 1){
            blockerXPos = int(random(25, 775));
            blockerYPos = int(random(25, 600));
            blockerWidth = int(random(300, 500));
         }
         assigned = true;
      }
      else{
        modToTurnOn++;
        if(modToTurnOn >= modifiers.length)
          modToTurnOn = 0;
      }
      if(assigned)
        break;
    }
  }
  */
}

void drawBlocker(){
  fill(255,0,0);
  rect(blockerXPos, blockerYPos, blockerWidth/2, blockerWidth/2);
  noFill();
}
