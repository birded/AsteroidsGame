/* 
 * left/right arrow keys to rotate ship
 * w/s to accelerate / decelerate
 * down to brake
 * r to hyperspace
 * space to shoot bullets
 * you have two lives
*/


SpaceShip ship = new SpaceShip();
Star[] stars;
boolean rightPressed, leftPressed, upPressed, downPressed, rPressed, spacePressed, shipHit, gameOver, restart, gameStart = false;
color playButtonFill = color(0,0,0);
int score = 0;
int lives = 2;
int startingAsteroids = 10;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

public void setup() 
{
  size(600,600);
  stars = new Star[250];

  for(int i = 0 ; i < stars.length ; i++){
    stars[i] = new Star();
  }

  for(int i = 0 ; i < startingAsteroids ; i++){
  asteroids.add(new Asteroid());
  asteroids.get(i).accelerate(Math.random() *2);
  }


}

public void draw() 
{
  background(0);



  for(int i = 0 ; i < stars.length ; i++){
    stars[i].show();
  }

  if(gameOver == false){
   ship.move();
  }

  for(int i = 0; i < bullets.size() ; i++){

    if(gameOver == false){
    bullets.get(i).move();
  }

    bullets.get(i).show();
  }

  ship.show();


  double newAstChance = Math.random();

  for(int i = 0 ; i < asteroids.size() ; i++){

    if(gameOver == false){
      asteroids.get(i).move();
    }

    asteroids.get(i).show();

    for(int n = 0; n < bullets.size() ; n++){
        if( dist(asteroids.get(i).getX() , asteroids.get(i).getY() , bullets.get(n).getX() , bullets.get(n).getY() ) < 20){
          if( asteroids.get(i).getDirectionX() < -0.9 || asteroids.get(i).getDirectionX() > 0.9 || asteroids.get(i).getDirectionY() < -0.4 || asteroids.get(i).getDirectionY() > 0.4){
            //if speed of asteroid is greater than 0.9 / -0.9 in any direction give 15 pt
            score += 15;
          }else if( asteroids.get(i).getDirectionX() < -0.4 || asteroids.get(i).getDirectionX() > 0.4 || asteroids.get(i).getDirectionY() < -0.4 || asteroids.get(i).getDirectionY() > 0.4){
            //if speed of asteroid is greater than 0.4 / -0.4 in any direction give 10 pt
            score += 10;
          }else if( asteroids.get(i).getDirectionX() < -0.2 || asteroids.get(i).getDirectionX() > 0.2 || asteroids.get(i).getDirectionY() < -0.4 || asteroids.get(i).getDirectionY() > 0.4){
            score += 5;
          }else{
            score += 3;
          }


          asteroids.remove(i);
          bullets.remove(n);
          addAsteroid();
          if(newAstChance < 0.5 && asteroids.size() < 150){
            //50% chance to add another asteroid, asteroids capped at 150
            addAsteroid();
          }
        }
    } 


    //remove asteroid if ship hits
    if( dist(asteroids.get(i).getX() , asteroids.get(i).getY() , ship.getX() , ship.getY() ) < 23 ){ //dist between the asteroid and ship
      asteroids.remove(i);
      addAsteroid();
      lives--;
    }
    


  }

  fill(255);
  textAlign(LEFT);
  textSize(12);
  text("Score: " + score, 10, 15);
  text("Lives: " + lives, 10, 30);

  if(lives <= 0){ gameOver = true;}
  if(lives > 0){ gameOver = false;}

  if(gameOver == false){ //only able to control ship if game is not over
    if(rightPressed){ ship.rotate(5); }
    if(leftPressed){ ship.rotate(-5); }
    if(upPressed){ ship.accelerate(0.1); }
    if(downPressed){ ship.accelerate(-0.1); }
    if(spacePressed && frameCount%10 == 0){ bullets.add(new Bullet(ship));} //limits # of bullets created
  }


  //game over screen

  if(gameOver == true){
    fill(0,0,0,150);
    rectMode(CENTER);
    rect(width/2, height/2, 600, 600);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(48);
    text("GAME OVER \n Score: " + score, width/2, height/2);

    fill(0,0,0,150);
    rect(width/2, 450, 200, 80);
    fill(0,255,0);
    text("restart", width/2, 440);
  }

  //beginning screen
  if(gameStart == false){
    fill(0,0,0);
    rectMode(CENTER);
    rect(width/2, height/2, 600, 600);

    fill(playButtonFill);
    ellipse(width/2, height/2, 180, 180);
    triangle(width/2 - 25, height/2 - 50, width/2 - 25, height/2 + 50, width/2 + 50, height/2);
  }


  if(restart == true || gameStart == false){
    ship.setDirectionX(0);
    ship.setDirectionY(0);

    for(int i = 0; i < asteroids.size() ; i++){
      asteroids.remove(i);
    }

    for(int i = 0 ; i < bullets.size(); i++){
      bullets.remove(i);
    }

  }

}

public void addAsteroid(){

  double asteroidChance = Math.random();
      if(asteroidChance < 0.25){
        //add an asteroid above the screen
        asteroids.add(new Asteroid( (int)Math.random()*600, -19 ));
      }
      else if(asteroidChance < 0.5){

        //add an asteroid to the right of the screen
        asteroids.add(new Asteroid( width+19, (int)Math.random() * 600));
      }
      else if(asteroidChance < 0.75){
        //add an asteroid to the bottom of the screen
        asteroids.add(new Asteroid( (int)(Math.random()*600), height+19 ));
      }
      else{
        //add an asteroid to the left of the screen
        asteroids.add(new Asteroid( -19, (int)Math.random() * 600 ));
      }

        asteroids.get(asteroids.size()-1).accelerate(Math.random() *2); //set an acceleration for the new asteroid

}

public void mousePressed(){
  if(gameOver == true && mouseX > 200 && mouseX < 400 && mouseY > 410 && mouseY < 490){
    //restart button
    restart = true;
  }

  if(gameStart == false && dist(mouseX,mouseY,width/2,height/2) < 90){
    playButtonFill = color(0,255,0,200); //fills the play button green
  }
}

public void mouseReleased(){

if(gameOver == true && restart == true && mouseX > 200 && mouseX < 400 && mouseY > 410 && mouseY < 490){
    restart = false;
    gameOver = false;
    lives = 2;
    score = 0;

    ship.setX(300);
    ship.setY(300);
    ship.setDirectionX(0);
    ship.setDirectionY(0);

    for(int i = 0 ; i < startingAsteroids ; i++){
    asteroids.add(new Asteroid());
    asteroids.get(i).accelerate(Math.random() *2);
  }

  }


  if(gameStart == false){
    playButtonFill = color(0,0,0);

    if(dist(mouseX,mouseY,width/2,height/2) < 90){
    gameStart = true;
    restart = false;
    gameOver = false;
    lives = 2;
    score = 0;

    ship.setX(300);
    ship.setY(300);

    for(int i = 0 ; i < startingAsteroids ; i++){
    asteroids.add(new Asteroid());
    asteroids.get(i).accelerate(Math.random() *2);
    }
  }

  }

}

public void keyPressed(){
  if(keyCode == 39){rightPressed = true;} //right

  if(keyCode == 37){leftPressed = true;} //left

  if(keyCode == 32){spacePressed = true;} //spacebar

  if(keyCode == 40){downPressed = true;} //down

  if(keyCode == 38){upPressed = true;} //up

  if(key == 'r'){ //hyperspace
    if(gameOver == false){
    ship.setX( (int)(Math.random() * width));
    ship.setY( (int)(Math.random() * height));
    ship.setDirectionX(0);
    ship.setDirectionY(0);
    }
  }

  if(key == 's'){ //down arrow key, brake ship 40
    ship.setDirectionY(0); 
    ship.setDirectionX(0);
  }
}

public void keyReleased(){
  if(keyCode == 39){rightPressed = false;} //right

  if(keyCode == 37){leftPressed = false;} //left

  if(keyCode == 32){spacePressed = false;} //space

  if(keyCode == 40){downPressed = false;} //down

  if(keyCode == 38){upPressed = false;} //up

}

public class SpaceShip extends Floater
{   
    public SpaceShip(){
      corners = 11;
      int[] xS = {-8, 16, -8, -4, -8, -8, -4, -4, -8, -8, -4};
      int[] yS = {12,  0,-12, -5, -5, -1, -1,  1,  1,  5,  5};
      xCorners = xS;
      yCorners = yS;

      myColor = color(0,255,0);
      myCenterX = 300;
      myCenterY = 300;
      myDirectionX = 0;
      myDirectionY = 0;
      myPointDirection = 0;
    }

    public void setX(int x){myCenterX = x;}
    public int getX(){return (int)myCenterX;}
    public void setY(int y){myCenterY = y;}
    public int getY(){return (int)myCenterY;}
    public void setDirectionX(double x){myDirectionX = x;}
    public double getDirectionX(){return myDirectionX;}
    public void setDirectionY(double y){myDirectionY = y;}
    public double getDirectionY(){return myDirectionY;}
    public void setPointDirection(int degrees){myPointDirection = degrees;}
    public double getPointDirection(){return myPointDirection;}
    public void setColor(int c){ myColor = c;}

  public void show ()  //Draws the floater at the current position  
  {             
    fill(0,0,0);   
    stroke(myColor);    
    strokeWeight(1.5);
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   

}

public class Star
{
  private int x, y, size, opacity, rotation;
  public Star(){
    x = (int)(Math.random() * width);
    y = (int)(Math.random() * height);
    size = (int)(Math.random() * 3 + 1); 
    opacity = (int)(Math.random() * 300);
    rotation = (int)(Math.random()*360);
  }

  public void show(){
    noStroke();
    fill(255, 255, 255, opacity);
    rectMode(CENTER);
    pushMatrix();
    translate(x,y);
    rotate(rotation);
    rect(0,0,size,size);
    popMatrix();
    //ellipse(x, y, size, size);
  }

}

public class Asteroid extends Floater
{
  private int rotSpeed; 

  Asteroid(){
    if(Math.random() < 0.5){ //variation 1
      corners = 10;
      int[] xS = {5, 9, 15, 19, 8, 3, -8, -15, -18, -9};
      int[] yS = {15, 9, 8, -1, -17, -20, -19, -16, 4, 18};
      xCorners = xS;
      yCorners = yS;  
    }else{ //variation 2
      corners = 18;
      int[] xS = {6, 14, 16, 11, 8, -2, -5, -3, -5, -7, -15, -17, -18, -17, -11, -9, -5, -4};
      int[] yS = {15, 8, 0, -2, -17, -18, -15, -11, -9, -12, -11, -3, 6, 13, 14, 15, 17, 16};
      xCorners = xS;
      yCorners = yS;  
    }

      myColor = color(0,255,0);
      myCenterX = (int)(Math.random()* 600);
      myCenterY = (int)(Math.random()* 600);
      myDirectionX = 0;
      myDirectionY = 0;
      myPointDirection = Math.random()*360;

      rotSpeed = (int)(Math.random() * 5 - 2);
  }

  Asteroid(int x, int y){
    if(Math.random() < 0.5){ //variation 1
      corners = 10;
      int[] xS = {5, 9, 15, 19, 8, 3, -8, -15, -18, -9};
      int[] yS = {15, 9, 8, -1, -17, -20, -19, -16, 4, 18};
      xCorners = xS;
      yCorners = yS;  
    }else{ //variation 2
      corners = 18;
      int[] xS = {6, 14, 16, 11, 8, -2, -5, -3, -5, -7, -15, -17, -18, -17, -11, -9, -5, -4};
      int[] yS = {15, 8, 0, -2, -17, -18, -15, -11, -9, -12, -11, -3, 6, 13, 14, 15, 17, 16};
      xCorners = xS;
      yCorners = yS;  
    }

      myColor = color(0,255,0);
      myCenterX = x;
      myCenterY = y;
      myDirectionX = 0;
      myDirectionY = 0;
      myPointDirection = Math.random()*360;

      rotSpeed = (int)(Math.random() * 5 - 2);
  }

  public void setX(int x){myCenterX = x;}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){myCenterY = y;}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){myDirectionX = x;}
  public double getDirectionX(){return myDirectionX;}
  public void setDirectionY(double y){myDirectionY = y;}
  public double getDirectionY(){return myDirectionY;}
  public void setPointDirection(int degrees){myPointDirection = degrees;}
  public double getPointDirection(){return myPointDirection;}
  public int getRotSpeed(){return rotSpeed;}
  
  public void show () 
  {          
    fill(0,0,0);
    strokeWeight(0.7); 
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  

    fill(255);

    //double dirX = (double)Math.round(myDirectionX * 100d) / 100d;
    //double dirY = (double)Math.round(myDirectionY * 100d) / 100d;
    //text((float)myDirectionX + ", " + (float)myDirectionY, (float)myCenterX, (float)myCenterY);
    //text( dirX + ", " + dirY, (float)myCenterX, (float)myCenterY);
  }   

  public void move(){  
    rotate(rotSpeed);

    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;

    if(myCenterX >width+20) //accounting for width of asteroid
    {     
      myCenterX = -20;    
    }    
    else if (myCenterX< -20)
    {     
      myCenterX = width+20;    
    }    
    if(myCenterY >height+20)
    {    
      myCenterY = -20;    
    }   
    else if (myCenterY < -20)
    {     
      myCenterY = height+20;    
    }   
  }


}

public class Bullet extends Floater{

  Bullet(SpaceShip theShip){
    myCenterX = theShip.getX();
    myCenterY = theShip.getY();
    myPointDirection = theShip.getPointDirection();
    double dRadians =myPointDirection*(Math.PI/180);
    myDirectionX = 5 * Math.cos(dRadians) + theShip.getDirectionX();
    myDirectionY = 5 * Math.sin(dRadians) + theShip.getDirectionY();
    myColor = color(0,255,0);
  }

  public void show(){
    fill(0,0,0);
    stroke(myColor);
    strokeWeight(1);
    ellipse((float)myCenterX,(float)myCenterY, 5, 5);
  }

public void move ()   
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     
  }   
    public void setX(int x){myCenterX = x;}
    public int getX(){return (int)myCenterX;}
    public void setY(int y){myCenterY = y;}
    public int getY(){return (int)myCenterY;}
    public void setDirectionX(double x){myDirectionX = x;}
    public double getDirectionX(){return myDirectionX;}
    public void setDirectionY(double y){myDirectionY = y;}
    public double getDirectionY(){return myDirectionY;}
    public void setPointDirection(int degrees){myPointDirection = degrees;}
    public double getPointDirection(){return myPointDirection;}
}
//////////////////////////////////////////////////////////////////////////////////////////////

abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  abstract public void setX(int x);  
  abstract public int getX();   
  abstract public void setY(int y);   
  abstract public int getY();   
  abstract public void setDirectionX(double x);   
  abstract public double getDirectionX();   
  abstract public void setDirectionY(double y);   
  abstract public double getDirectionY();   
  abstract public void setPointDirection(int degrees);   
  abstract public double getPointDirection(); 

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));       
  }   
  public void rotate (int nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >height)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
} 

