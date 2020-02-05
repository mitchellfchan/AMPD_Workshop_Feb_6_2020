import processing.core.*;
import java.util.Comparator;
import java.util.Arrays;

public class DataPoint {

  PVector loc;
  PImage pic;
  boolean hoverDisplay = true;


  public DataPoint() {
  }

  public DataPoint(float _x, float _y) {

    loc = new PVector(_x, _y);
  }

  public void setX(float _x) {
    loc.set(_x, loc.y);
  }

  public void setY(float _y) {
    loc.set(loc.x, _y);
  }

  public float getX() {
    return loc.x;
  }

  public float getY() {
    return loc.y;
  }

  /* DEPRECATE THIS
   public void render(PGraphics pg, float _xAxMin, float _xAxMax, float _yAxMin, float _yAxMax, int border) {
   float xValMapped = map(loc.x, _xAxMin, _xAxMax, 0 + border, pg.width-border);
   float yValMapped = map(loc.y, _yAxMin, _yAxMax, pg.height-border, 0)+border;
   pushStyle();
   pg.strokeWeight(2);
   pg.fill(255, 177, 199);
   pg.ellipse(xValMapped, yValMapped, 20, 20);
   popStyle();
   }
   */

  public void render(PGraphics pg) {
    pushStyle();
    pg.strokeWeight(2);
    pg.fill(255, 77, 99);
    pg.ellipse(loc.x, loc.y, 20, 20);

    popStyle();
  }

  public void renderScaled(PGraphics pg, float _xAxMin, float _xAxMax, float _yAxMin, float _yAxMax, float border) {
    pushStyle();
    
    pg.strokeWeight(2);
    pg.fill(255, 77, 99);
    float xValMapped = map(getX(), _xAxMin, _xAxMax, 0 + border, pg.width-border);
    float yValMapped = map(getY(), _yAxMin, _yAxMax, pg.height-border, 0)+border;
    
    if (hoverDisplay) {
      if (dist(mouseX, mouseY, xValMapped, yValMapped) < 20) {
        pg.fill(55,255,99);
        pg.text(getY(), xValMapped+10, yValMapped-25);
        println("mouse is close");
      } else {
        println(yValMapped + " " + mouseY);
      }
    pg.ellipse(xValMapped, yValMapped, 20, 20);
    
      popStyle();
    }
  }



  //this should be static
  //public static final Comparator<DataPoint> xComparator = new Comparator<DataPoint>() {
  //  @Override
  //    public final int compare(DataPoint d1, DataPoint d2) {
  //    return (d1.getX() < d2.getX() ? -1 :
  //      (d2.getX() == d1.getX() ? 0 : 1));
  //  }
  //};

  //this should be static
  //public static final Comparator<DataPoint> yComparator = new Comparator<DataPoint>() {
  //  @Override
  //    public final int compare(DataPoint d1, DataPoint d2) {
  //    return (d1.getY() < d2.getY() ? -1 :
  //      (d2.getY() == d1.getY() ? 0 : 1));
  //  }
  //};
}
