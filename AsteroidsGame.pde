import java.util.*;

//your variable declarations here
private final int NUM_STARS = 80;
ArrayList<Star> stars = new ArrayList<Star>();

ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
private final int NUM_ASTEROIDS = 7;

private final CollisionHandler collisions = new CollisionHandler();

Spaceship main;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();

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

  //Draw + move bullets
  for (int i = 0; i < bullets.size(); i++){
    bullets.get(i).move();
    bullets.get(i).show();

    //Remove bullet if it is off-screen
    if(bullets.get(i).getX() > width || bullets.get(i).getX()<0
      || bullets.get(i).getY() > height || bullets.get(i).getY()<0)
      bullets.remove(i);
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

  for(int i = 0; i < asteroids.size(); i++){
    //Check each bullet for collisions
    for(Bullet b : bullets){
      //Break apart asteroid if hit by bullet
      if(collisions.shapesCollide(asteroids.get(i), b)){
        Asteroid a2 = asteroids.get(i).breakApart();

        if (asteroids.get(i).getSize() != 0){
          asteroids.add(a2);
        }
      }
    }
    //If the spaceship collides with asteroid
    if (collisions.shapesCollide(asteroids.get(i), main)) {
      //TODO do something - health depletion or game over or something
      collide = true;
      break;
    }

    //If the asteroid is size 0, remove it
    if(asteroids.get(i).getSize() == 0){
      asteroids.remove(i);
      i--;
    }
  }

  //Do something here when collisions between Spaceship and Asteroids happen
  debugCollide = collide;
}

void keyPressed(){
  if (key == 'q' || key == 'Q') debug = !debug;
  if (key == ' '){
    System.out.println("space");
    bullets.add(new Bullet(main.getX(), main.getY(), main.getPointDirection()));
  }
  if (key == 'b' || key == 'B'){
    //Hyperspace
    main.setX( (int) (Math.random()*647-6) );
    main.setY( (int) (Math.random()*485-4) );
    main.setDirectionX(0);
    main.setDirectionY(0);
  }
}
