class Spaceship extends SpaceFloater implements Collidable
{
  private boolean visible;
  private int deathCountdown;
  private int lives;
  private int invulnCountdown;
  public Spaceship(int[] x, int[] y){
		super(x, y);
    myColor = color(
			(int) (Math.random()*203+53),
			(int) (Math.random()*202+53),
			(int) (Math.random()*202+53)
    );
    visible = true;
    deathCountdown = 0;
    lives = 3;
    invulnCountdown = 300;
	}
	public void move(){
		super.move();
		myDirectionX = myDirectionX / 1.005;
		myDirectionY = myDirectionY / 1.005;
	}
  public void show(){
    if(visible) {
      super.show();
      if(invulnCountdown > 0){
        invulnCountdown--;
        int opacity = (invulnCountdown/50%2 == 0) ? 255 : 80;
        myColor = color(red(myColor), green(myColor), blue(myColor),
          opacity);
      }
    }
    else {
      if(deathCountdown > 0) deathCountdown--;
      if(deathCountdown == 0) {
        myCenterX = width/2;
        myCenterY = height/2;
        myDirectionX = 0;
        myDirectionY = 0;
        lives--;
        if(lives>-1){
          visible = true;
          invulnCountdown = 300;
        }
      }
    }
  }
  public boolean isInvulnerable(){return invulnCountdown > 0;}
  public boolean isVisible(){return visible;}
  public void die(){
    visible = false;
    if(lives > 0){
      deathCountdown = 180;
    } else lives--;
  }
  public int getLives(){return lives;}
}
class Bullet extends SpaceFloater implements Collidable
{
  private int[] coordsX = {-3, 3, -3};
  private int[] coordsY = {3, 0, -3};

  public Bullet(int x, int y, double angle){
    super(false);
    this.xCorners = coordsX;
    this.yCorners = coordsY;
    this.myColor = color(255);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = cos(radians((float)angle))*5;
    myDirectionY = sin(radians((float)angle))*5;
  }
  public void move(){
    myCenterX+=myDirectionX;
    myCenterY+=myDirectionY;
  }
}
