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
  private int[] coordsX = {-1, 1, -1};
  private int[] coordsY = {1, 0, -1};

  public Bullet(int x, int y, double angle){
    super(coordsX, coordsY);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = cos(radians(angle))*5;
    myDirectionY = sin(radians(angle))*5;
  }
}
