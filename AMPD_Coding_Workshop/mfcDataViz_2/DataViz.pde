import processing.data.*;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Collections;

static final Comparator<DataPoint> xComparator = new Comparator<DataPoint>() {
  @Override
    final int compare(DataPoint d1, DataPoint d2) {
    return (d1.getX() < d2.getX() ? -1 :
      (d2.getX() == d1.getX() ? 0 : 1));
  }
};

static final Comparator<DataPoint> yComparator = new Comparator<DataPoint>() {
  @Override
    final int compare(DataPoint d1, DataPoint d2) {
    return (d1.getY() < d2.getY() ? -1 :
      (d2.getY() == d1.getY() ? 0 : 1));
  }
};

public class DataViz {

  PGraphics pgViz;
  int border = 100;
  color vizBg = color(255, 252, 222);
  float xAxMin, xAxMax, yAxMin, yAxMax;
  int xSize;
  int ySize;
  ArrayList<DataPoint> dataPoints = new ArrayList<DataPoint>();
  ArrayList<DataPointAnimated> animatedPoints = new ArrayList<DataPointAnimated>();
  ArrayList<DataPoint> scaledPoints = new ArrayList<DataPoint>();


  public DataViz(Table table, PApplet parent) {
    pgViz = createGraphics(parent.width, parent.height);
  }

  public DataViz(Table table, int _vizWidth, int _vizHeight) {
    xSize = _vizWidth;
    ySize = _vizHeight;
    pgViz = createGraphics(xSize, ySize);
    println("Data Visualization Initialized");
  }
  
  public void setAxisLimits(float _xAxMin, float _xAxMax, float _yAxMin, float _yAxMax){
    xAxMin = _xAxMin;
    xAxMax = _xAxMax;
    yAxMin = _yAxMin;
    yAxMax = _yAxMax;
  }

  public void mapChart(String _xAxis, String _yAxis) {
    String xAxis = _xAxis;
    String yAxis = _yAxis;

    for (TableRow row : table.rows()) {
      println("trying to read row " + xAxis);

      Float xVal, yVal;
      try {
        xVal = row.getFloat(xAxis);
        if (Float.isNaN(xVal)) println("Not a number");
      } 
      catch (Exception e) {
        xVal = null;
      }

      try {
        yVal = row.getFloat(yAxis);
        if (Float.isNaN(yVal)) println("Value in row " + xVal + " is not a number(NaN)");
      } 
      catch (Exception e) {
        println("caught a null data point");
        yVal = null;
      }

      if (!Float.isNaN(xVal) && !Float.isNaN(yVal)) {
        dataPoints.add(new DataPoint(xVal, yVal));
        println("Created Data Point with coordinates " + xVal + ", " + yVal);
      }
    }
  }

/* DEPRECATE THIS
  void renderChart(float _xAxMin, float _xAxMax, float _yAxMin, float _yAxMax) {
    xAxMin = _xAxMin;
    xAxMax = _xAxMax;
    yAxMin = _yAxMin;
    yAxMax = _yAxMax;

    pgViz.beginDraw();
    pgViz.background(vizBg);
    for (DataPoint d : dataPoints) {
      d.render(pgViz, _xAxMin, _xAxMax, _yAxMin, _yAxMax, border);
      println("rendered a point on the chart");
    }
    pgViz.endDraw();
  }
*/

  void scalePoints(){
    
    scaledPoints = scaleToChart(dataPoints, pgViz, xAxMin, xAxMax, yAxMin, yAxMax);
    
  }
  
  void createAnimation(){
    for(DataPoint d : scaledPoints){
      animatedPoints.add(new DataPointAnimated(d.getX(), d.getY()));
    }
    
  }
  
  void renderBouncing(){
    pgViz.beginDraw();
    pgViz.background(vizBg);
    
    for (DataPointAnimated d : animatedPoints) {
      d.bounce(ySize,0);
      d.render(pgViz);
      //println("rendered an animated point on the chart");
    }
    pgViz.endDraw();
    
  }
  void renderChart(){
    pgViz.beginDraw();
    pgViz.background(vizBg);
    
    for (DataPoint d : dataPoints) {
      d.renderScaled(pgViz, xAxMin, xAxMax, yAxMin, yAxMax, border);
      //println("rendered a point on the chart");
    }
    pgViz.endDraw();
  }
  
 
    

  void labelAxes() {
    pgViz.beginDraw();
    pgViz.pushStyle();
    for (DataPoint d : dataPoints) {
      float xValMapped = map(d.loc.x, xAxMin, xAxMax, 0+border, pgViz.width-border);
      float yValMapped = map(d.loc.y, yAxMin, yAxMax, pgViz.height-border, 0+border);
      pgViz.pushMatrix();
      pgViz.translate(xValMapped, pgViz.height-50);
      pgViz.rotate(radians(60));
      pgViz.text((int)d.loc.x, 0, 0);
      pgViz.popMatrix();
    }
    pgViz.popStyle();
    pgViz.endDraw();
  }

  //void sortTest() {
  //  DataSorter ds = new DataSorter(dataPoints);
  //  System.out.println("-----sorted by x column, descending-------");
  //  ArrayList<DataPoint> sortedDataPoints = ds.getSortedByX();
  //  for (DataPoint d : sortedDataPoints) {
  //    System.out.println(d.loc.x + ", " + d.loc.y);
  //  }
  //}

  ArrayList scaleToChart(ArrayList<DataPoint> dp, PGraphics pg, float _xAxMin, float _xAxMax, float _yAxMin, float _yAxMax) {
    xAxMin = _xAxMin;
    xAxMax = _xAxMax;
    yAxMin = _yAxMin;
    yAxMax = _yAxMax;
    ArrayList<DataPoint> scaled = new ArrayList<DataPoint>();
    for (DataPoint d : dp) {
      float xValMapped = map(d.getX(), _xAxMin, _xAxMax, 0 + border, pg.width-border);
      float yValMapped = map(d.getY(), _yAxMin, _yAxMax, pg.height-border, 0)+border;
      scaled.add(new DataPoint(xValMapped, yValMapped));
    }
    return(scaled);
  }

 



  void extras() {
    pgViz.beginDraw();
    pgViz.pushStyle();
    pgViz.noFill();
    pgViz.strokeWeight(1);
    pgViz.stroke(0);
    pgViz.rect(border, border, pgViz.width-border*2, pgViz.height-border*2);
    pgViz.popStyle();
    pgViz.endDraw();
  }

  void setSize(int x, int y) {
    xSize = x;
    ySize = y;
  }

  void renderCurve() {
    
    
    ArrayList<DataPoint> scaled = scaleToChart(dataPoints, pgViz, xAxMin, xAxMax, yAxMin, yAxMax);
    Collections.sort(scaled, xComparator);
    pgViz.beginDraw();
    pgViz.pushStyle();
    pgViz.strokeWeight(2);
    pgViz.stroke(0);
    pgViz.noFill();

    pgViz.beginShape();
    pgViz.curveVertex(scaled.get(0).getX(), scaled.get(0).getY());
    for (DataPoint d : scaled) {
      pgViz.curveVertex(d.getX(), d.getY());
      //println("drew curve control point at " + d.getX() + ", " + d.getY());
    }
    int lastIndex = scaled.size() - 1;
    pgViz.curveVertex(scaled.get(lastIndex).getX(), scaled.get(lastIndex).getY());
    pgViz.endShape();
    pgViz.popStyle();
    pgViz.endDraw();
  }
  
  // -------------------------------------------------------------------------
  // below here is for testing only. can be deprecated
  // -------------------------------------------------------------------------
  
   void sortTestY() {
    ArrayList<DataPoint> sorted = (ArrayList<DataPoint>)(dataPoints.clone());

    Collections.sort(sorted, yComparator);
    for (DataPoint d : sorted) {
      println(d.loc.x + ", " + d.loc.y);
    }
  }
  
}
