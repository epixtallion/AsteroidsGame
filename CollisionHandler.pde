class CollisionHandler{
  public boolean shapesCollide(Collidable f1, Collidable f2){
    //TODO do something that will get the real vertices with centerX and Y, as well as rotation accounted for
    double[] x1 = f1.getXVertices();
    double[] y1 = f1.getYVertices();
    double[] x2 = f2.getXVertices();
    double[] y2 = f2.getYVertices();

    //TODO figure out how to project axes
    for(int i = 1; i < x1.length); i++{
      double m = (y1[i] - y1[i-1])/(x1[i] - x1[i-1]);

    }
    return false;
  }
  private double[] getProjection(double m, double[] x, double[] y){
    double topY, bottomY;
    for(int i = 0; i < x.length; i++){
      double point = m*y[i]
      if()
    }
  }
}

interface Collidable{
  public int[] getXVertices();
  public int[] getYVertices();
}
