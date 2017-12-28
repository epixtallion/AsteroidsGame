import java.util.*;

//your variable declarations here
private final int NUM_STARS = 80;
ArrayList<Star> stars = new ArrayList<Star>();

ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
private int numAsteroids = 6;

private final CollisionHandler collisions = new CollisionHandler();

Spaceship main;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
private int bulletCountdown = 0;

private int hyperspaceCountdown = 1200;

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
  for (int i = 0; i<numAsteroids; i++){
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

  //Bullet countdown
  if(bulletCountdown > 0) bulletCountdown--;

  //Hyperspace countdown
  if(hyperspaceCountdown < 1200) hyperspaceCountdown++;

  //Draw lives + ammo indicator
  drawIndicators();

  //Debug
  if (debug){
    fill(255);
    textSize(20);
    String pointDirDebug = "Point direction: "+ main.getPointDirection();
    text(pointDirDebug, 10, 20);
    text("Keys pressed: " + key, 10, 40);
    text("Is key pressed? " + keyPressed, 10, 60);
    text("Colliding? " + debugCollide, 10, 80);
    text("Number of bullets: " + main.getBullets(), 10, 100);

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
    for(int b = 0; b < bullets.size(); b++){
      //Break apart asteroid if hit by bullet
      if(collisions.shapesCollide(asteroids.get(i), bullets.get(b))){
        //Remove bullet
        bullets.remove(b);

        //Break apart asteroid
        Asteroid a2 = asteroids.get(i).breakApart();

        //If the asteroid that just broke apart has a size bigger than 0, duplicate
        if (asteroids.get(i).getSize() > 0){
          asteroids.add(a2);
        }
      }
    }

    //If the asteroid is size 0, remove it
    if(asteroids.get(i).getSize() <= 0){
      asteroids.remove(i);
      i--;
      continue;
    }
    //If the spaceship collides with asteroid
    if (!(main.isInvulnerable())&&main.isVisible() && collisions.shapesCollide(asteroids.get(i), main)) {
      collide = true;
      main.die();
      break;
    }
  }

  //Do something here when collisions between Spaceship and Asteroids happen
  debugCollide = collide;
}

void keyPressed(){
  if (key == 'q' || key == 'Q') debug = !debug;
  if (key == ' ' && main.isVisible() && bulletCountdown == 0){
    if(main.getBullets() > 0){
      bullets.add(new Bullet(main.getX(), main.getY(), main.getPointDirection()));
      bulletCountdown = 10;
      main.fireBullet();
    } else {
      bulletCountdown = 150;
    }
  }
  if (key == 'b' || key == 'B'){
    //Hyperspace
    if(hyperspaceCountdown == 1200){
      main.setX( (int) (Math.random()*647-6) );
      main.setY( (int) (Math.random()*485-4) );
      main.setDirectionX(0);
      main.setDirectionY(0);
      hyperspaceCountdown = 0;
    }
  }
  if ((main.getLives() < 0 || asteroids.size() == 0) && key == 'r' || key == 'R')
    resetGame();
}
void drawIndicators(){
  //Draw health
  for(int i = 0; i < main.getLives(); i++){
    pushMatrix();
    translate(width-10-25-50*i, 35);
    fill(249, 44, 103);
    if(main.isInvulnerable()) fill(222, 255, 153);
    noStroke();

    beginShape();
    //Draw heart
    vertex(0,-15);
    vertex(15,-20);
    vertex(15,-5);
    vertex(0,15);
    vertex(-15,-5);
    vertex(-15,-20);
    endShape(CLOSE);

    popMatrix();
  }

  //Draw ammo indicator
  fill(230);
  stroke(1);
  rect(width-20, 60, -5*main.getMaxBullets(), 15);
  noStroke();
  fill(111, 219, 161);
  rect(width-21, 61, -5*main.getBullets(), 13);

  //Draw hyperspace indicator
  fill(230);
  stroke(1);
  rect(width-20, 80, -100, 15);
  noStroke();
  if(hyperspaceCountdown == 1200) fill(111, 161, 219);
  else fill(55, 80, 90);
  rect(width-21, 81, hyperspaceCountdown/-12, 13);

  //Draw invulnerability text
  textAlign(RIGHT);
  textSize(20);
  fill(222, 255, 153);
  if(main.isInvulnerable()) text("INVULNERABLE!", width-10, height-20);
  textAlign(LEFT);

  //Draw game over text
  if(main.getLives()<0){
    textAlign(CENTER);
    textSize(72);
    fill(255);
    text("GAME OVER", width/2, height/2);
    textSize(30);
    text("Press R to restart.", width/2, height/2+40);
  }
  if(asteroids.size() == 0){
    textAlign(CENTER);
    textSize(72);
    fill(255);
    text("LEVEL CLEARED!", width/2, height/2);
    textSize(30);
    text("Press R to go to next level.", width/2, height/2+40);
  }
}
void resetGame(){
  //Reset ArrayLists
  stars = new ArrayList<Star>();
  asteroids = new ArrayList<Asteroid>();

  if(main.getLives() < 0){
    //Initialize main spaceship
    int[] mainX = {10, -10, -5, -10};
    int[] mainY = {0, -10, -0, 10};
    main = new Spaceship(mainX, mainY);
    numAsteroids = 6;
  } else {
    numAsteroids++;
    main.addMaxBullets(5);
    main.setLives(main.getLives() + 1);
    main.setInvulnerability();
    main.setX(width/2);
    main.setY(height/2);
    main.setDirectionX(0);
    main.setDirectionY(0);
  }

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
  for (int i = 0; i<numAsteroids; i++){
    asteroids.add(new Asteroid(3));
  }
}
