/* 
 * left/right arrow keys to rotate ship
 * w/s to accelerate / decelerate
 * down to brake
 * r to hyperspace
*/

SpaceShip ship = new SpaceShip();
Star[] stars;
boolean rightPressed, leftPressed, wPressed, sPressed, rPressed, spacePressed = false;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

public void setup() 
{
  size(600,600);
  stars = new Star[250];

  for(int i = 0 ; i < stars.length ; i++){
    stars[i] = new Star();
  }

  for(int i = 0 ; i < 15 ; i++){
  asteroids.add(new Asteroid());
  asteroids.get(i).accelerate(Math.random());
  }


}

public void draw() 
{
  background(0);

  for(int i = 0 ; i < stars.length ; i++){
    stars[i].show();
  }

  ship.move();

  for(int i = 0; i < bullets.size() ; i++){
    bullets.get(i).move();
    bullets.get(i).show();
  }

  ship.show();
  for(int i = 0 ; i < asteroids.size() ; i++){
    asteroids.get(i).move();
    asteroids.get(i).show();

    /** for(int n = 0; n < bullets.size() ; n++){
      for(int j = 0; j < asteroids.size() ; j++){
      if( dist(asteroids.get(j).getX() , asteroids.get(j).getY() , bullets.get(n).getX() , bullets.get(n).getY() ) < 20){
        asteroids.remove(j);
        bullets.remove(n);
        System.out.println("!");    
        addAsteroid();

      }
      }
    } **/

    if( dist(asteroids.get(i).getX() , asteroids.get(i).getY() , ship.getX() , ship.getY() ) < 20 ){ //dist between the asteroid and ship
      asteroids.remove(i);
      addAsteroid();

    }

  }


  if(rightPressed){ ship.rotate(5); }
  if(leftPressed){ ship.rotate(-5); }
  if(wPressed){ ship.accelerate(0.1); }
  if(sPressed){ ship.accelerate(-0.1); }
  if(spacePressed && frameCount%10 == 0 ){ bullets.add(new Bullet(ship));} //limits # of bullets created
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

        asteroids.get(asteroids.size()-1).accelerate(Math.random()); //set an acceleration for the new asteroid

}

public void keyPressed(){
  if(keyCode == 39){rightPressed = true;} //right

  if(keyCode == 37){leftPressed = true;} //left

  if(keyCode == 32){spacePressed = true;} //spacebar

  if(key == 'w'){wPressed = true;}

  if(key == 's'){sPressed = true;}

  if(key == 'r'){ //hyperspace
    ship.setX( (int)(Math.random() * width));
    ship.setY( (int)(Math.random() * height));
    ship.setDirectionX(0);
    ship.setDirectionY(0);
  }

  if(keyCode == 40){ //down arrow key, brake ship
    ship.setDirectionY(0); 
    ship.setDirectionX(0);
  }
}

public void keyReleased(){
  if(keyCode == 39){rightPressed = false;} //right

  if(keyCode == 37){leftPressed = false;} //left

  if(keyCode == 32){spacePressed = false;} //space

  if(key == 'w'){wPressed = false;}

  if(key == 's'){sPressed = false;}

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

