import controlP5.*;

import java.io.*;

Table table;
DataViz dv1;
ControlPanel cp;
public float testSliderVal = 4;

void setup(){
  size(1600,1200);
  table = loadTable("demo1.csv", "header");
  cp = new ControlPanel(this);
  
  dv1 = new DataViz(table, 1000, 1000);
  dv1.mapChart("Year", "2019 Reference Case (BR4)");  
  dv1.setAxisLimits(2015, 2035, 500,900);
  dv1.scalePoints();
  
  //dv1.renderChart(2015, 2035, 500,900);
  dv1.renderChart();
  dv1.labelAxes();
  dv1.extras();
  dv1.renderCurve();
  image(dv1.pgViz, 0,0);
  dv1.sortTestY();
  dv1.createAnimation();
}

void draw(){
  if(mousePressed){
  dv1.renderBouncing();
  dv1.renderCurve();
  
 
  }
  
  else {
    dv1.renderChart();
    dv1.labelAxes();
  dv1.extras();
  dv1.renderCurve();
  }
  
  image(dv1.pgViz, 0,0);
  
  
  //println(dv1.animatedPoints.get(2).getY() + " " + dv1.animatedPoints.get(2).v + " " + dv1.ySize);
}



float gettestSliderVal(){
  return testSliderVal;
}
