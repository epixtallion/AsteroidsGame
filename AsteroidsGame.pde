import java.util.*;

//your variable declarations here
private final int NUM_STARS = 80;
ArrayList<Star> stars = new ArrayList<Star>();

ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
private final int NUM_ASTEROIDS = 1;

private final CollisionHandler collisions = new CollisionHandler();

Spaceship main;

boolean debug = false;
private final int TURN_SPEED = 4;
private final float SPEED = 0.1;


public void setup()
{
  size(640, 480);
  background(15);

  //Initialize stars
  for (int i = 0; i < NUM_STARS; i++) {
  	int[] col = {
  				(int) (Math.random()*203+53),
  				(int) (Math.random()*202+53),
  				(int) (Math.random()*202+53)
  			};
  	stars.add(new Star(
  			(int) (Math.random()*647-6),
  			(int) (Math.random()*485-4),
  			col
  		));
  }

  //Initialize asteroids
  for (int i = 0; i<NUM_ASTEROIDS; i++){
    asteroids.add(new Asteroid(3));
  }

  //Initialize main spaceship
  int[] mainX = {10, -10, -5, -10};
  int[] mainY = {0, -10, -0, 10};
  main = new Spaceship(mainX, mainY);
}
public void draw()
{
  //Run keyCheck
  keyCheck();

  //Check collisions
  collisionCheck();

	//Clear
  noStroke();
	fill(15);
	rect(0, 0, 640, 480);

  //Show stars
  for (Star s : stars) {
  	s.show();
  }

  //Draw + move spaceship
  main.move();
  main.show();

  //Draw + move asteroids
  for (Asteroid a : asteroids){
    a.move();
    a.show();
  }

  //Debug
  if (debug){
    fill(255);
    textSize(20);
    String pointDirDebug = "Point direction: "+ main.getPointDirection();
    text(pointDirDebug, 10, 20);
    text("Keys pressed: " + key, 10, 40);
    text("Is key pressed? " + keyPressed, 10, 60);
    text("Colliding? " + debugCollide, 10, 80);

    //System.out.println("Asteroid coordsX: "+Arrays.toString(asteroids.get(0).getXVertices()));
  }
}

void keyCheck(){
  if(keyPressed == true){
    if (key == 'w' || key == 'W') {
      main.accelerate(SPEED);
    }
    if (key == 'a' || key == 'A'){
      main.turn(-1*TURN_SPEED);
    }
    //TODO fix backwards acceleration
    /*if (key == 's' || key == 'S'){
      main.backAccelerate(.03);
    }*/
    if (key == 'd' || key == 'D'){
      main.turn(TURN_SPEED);
    }
  }
}

boolean debugCollide = false;
void collisionCheck(){
  boolean collide = false;
  for(Asteroid a : asteroids){
    //Get distance between asteroid and spaceship

    /*double distance =
      Math.sqrt(Math.pow(a.getX()-main.getX(), 2)+Math.pow(a.getY()-main.getY(), 2));
    if (distance < a.getSize()*Math.sqrt(5) + sqrt(200)){*/
      if (collisions.shapesCollide(a, main)) {
        System.out.println("Collision! "+Math.random());
        collide = true;
        break;
      }
      collisions.shapesCollide(a, main);
    //}
  }
  debugCollide = collide;
}

void keyPressed(){
  if (key == 'q' || key == 'Q') debug = !debug;
  if (key == 'b' || key == 'B'){
    //Hyperspace
    main.setX( (int) (Math.random()*647-6) );
    main.setY( (int) (Math.random()*485-4) );
    main.setDirectionX(0);
    main.setDirectionY(0);
  }
}
