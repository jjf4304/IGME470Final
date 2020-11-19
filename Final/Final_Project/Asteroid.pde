
class Asteroid extends Entity{
  
  float speed;
  float speedMod;
  
  int windowHeight;
  //static int gameWindowWidth;
  
  Asteroid(int _xpos, int _ypos, int _width, int _r, int _g, int _b){
      super(_xpos, _ypos, _width, _r, _g, _b);
      
      speed = 100;
      speedMod = 1;
  }
  
  int Update(float deltaTime, Player player){
     yPos += (speed * speedMod) * deltaTime; 
     fill(r,g,b);
     ellipse(xPos, yPos, entityWidth/2, entityWidth/2);
     noFill();
     
     if(yPos >= height + entityWidth/2){
         collide();
     }
     
     if(checkCollision(player)){
         collide();
         return 1;
     }
     
     //Change this later? For Collisions
     return -1;
  }
  
}
