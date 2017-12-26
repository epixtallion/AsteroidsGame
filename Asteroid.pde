class Asteroid extends SpaceFloater implements Collidable {

  //Variables for size and rotation speed
  private int mySize, myRotationSpeed;

  //Constructor with size
  public Asteroid(int size){
    super(false);
    this.myCenterX = Math.random()*647-6;
    this.myCenterY = Math.random()*485-4;
    this.myColor = color(150);
    this.mySize = size;

    //default point array
    int[] coordsX = {0,2,2,0,-2};
    int[] coordsY = {2,1,-1,-2,0};
    this.corners = coordsX.length;
    this.xCorners = new int[coordsX.length];
    this.yCorners = new int[coordsX.length];
    for (int i = 0; i<coordsX.length; i++){
      this.xCorners[i] = coordsX[i]*8;
      this.yCorners[i] = coordsY[i]*8;
    }
    myDirectionX = Math.random()*3-1.5;
    myDirectionY = Math.random()*3-1.5;
    myPointDirection = Math.random()*364-3;
    myRotationSpeed = (int)(Math.random()*5-2);
  }
  public Asteroid breakApart(){
    this.mySize = mySize - 1;
    myRotationSpeed*=1.2;
    Asteroid a = new Asteroid(mySize);
    a.setX((int)(myCenterX+mySize*8));
    a.setY((int)(myCenterY+mySize*8));
    return a;
  }

  public int getSize(){return mySize*8;}

  //Override move()
  public void move(){
    super.move();
    myPointDirection+=myRotationSpeed;

    //debug
    int i = 1;
    double distance = Math.sqrt(Math.pow(xCorners[i], 2)+Math.pow(yCorners[i], 2));
    double angle = atan2(xCorners[i], yCorners[i]);

  }

  //Override show
  public void show(){
    //Convert radians
    float dRadians = radians((float) myPointDirection);

    pushMatrix();
  	translate((float) myCenterX, (float) myCenterY);
  	rotate(dRadians);

    if(IS_SPRITE_FLOATER){
      //code for sprite rendering
    } else {
      fill(myColor);
      beginShape();
      for (int nI = 0; nI < xCorners.length; nI++)
      {
        vertex(xCorners[nI]*mySize, yCorners[nI]*mySize);
      }
      endShape(CLOSE);
    }

  	popMatrix();
  }
}
