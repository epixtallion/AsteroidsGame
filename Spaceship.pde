class Spaceship extends SpaceFloater implements Collidable
{
  public Spaceship(int[] x, int[] y){
		super(x, y);
    myColor = color(
			(int) (Math.random()*203+53),
			(int) (Math.random()*202+53),
			(int) (Math.random()*202+53)
    );
	}
	public void move(){
		super.move();
		myDirectionX = myDirectionX / 1.005;
		myDirectionY = myDirectionY / 1.005;
	}
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
