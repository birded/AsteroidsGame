/** left/right arrow keys to rotate ship
w/s to accelerate / decelerate
spacebar to brake
**/

SpaceShip ship = new SpaceShip();
Star[] stars;
boolean rightPressed = false;
boolean leftPressed = false;
boolean wPressed = false;
boolean sPressed = false;

public void setup() 
{
  size(500,500);
  stars = new Star[150];

  for(int i = 0 ; i < 150 ; i++){
    stars[i] = new Star();
  }

}

public void draw() 
{
  background(0);

  for(int i = 0 ; i < 150 ; i++){
    stars[i].show();
  }

  ship.show();
  ship.move();

  if(rightPressed){ ship.rotate(5); }
  if(leftPressed){ ship.rotate(-5); }
  if(wPressed){ ship.accelerate(0.1); }
  if(sPressed){ ship.accelerate(-0.1); }
}

class SpaceShip extends Floater  
{   
    SpaceShip(){
      corners = 11;
      int[] xS = {-8, 16, -8, -4, -8, -8, -4, -4, -8, -8, -4};
      int[] yS = {12,  0,-12, -5, -5, -1, -1,  1,  1,  5,  5};
      xCorners = xS;
      yCorners = yS;

      myColor = color(0,150,255);
      myCenterX = 250;
      myCenterY = 250;
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
}

public void keyPressed(){
  if(keyCode == 39){rightPressed = true;} //right

  if(keyCode == 37){leftPressed = true;} //left

  if(key == 'w'){wPressed = true;}

  if(key == 's'){sPressed = true;}

  if(keyCode == 32){ //spacebar
    ship.setDirectionY(0); 
    ship.setDirectionX(0);
  }
}

public void keyReleased(){
  if(keyCode == 39){rightPressed = false;} //right

  if(keyCode == 37){leftPressed = false;} //left

  if(key == 'w'){wPressed = false;}

  if(key == 's'){sPressed = false;}

}

class Star
{
  private int x, y, size, opacity;
  Star(){
    x = (int)(Math.random() * width);
    y = (int)(Math.random() * height);
    size = (int)(Math.random() * 4 + 1); 
    opacity = (int)(Math.random() * 300);
  }

  public void show(){
    noStroke();
    fill(255, 255, 255, opacity);
    ellipse(x, y, size, size);
  }

}


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

