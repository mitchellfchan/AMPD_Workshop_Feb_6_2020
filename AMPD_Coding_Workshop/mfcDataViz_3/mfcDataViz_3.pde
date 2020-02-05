import controlP5.*;

import java.io.*;

Table table;
DataViz dv1;
ControlPanel cp;
public float testSliderVal = 4;
Rain[] rainDrops = new Rain[200];

void setup() {
  size(1000, 1000);
  table = loadTable("AcidRain.csv", "header");
  cp = new ControlPanel(this);

  dv1 = new DataViz(table, 1000, 1000);
  dv1.mapChart("Year", "Sulphur oxides (percentage change from 1990 level)");  
  dv1.setAxisLimits(1990, 2017, -100, 0);
  dv1.scalePoints();

  //dv1.renderChart(2015, 2035, 500,900);
  dv1.renderChart();
  dv1.labelAxes();
  dv1.extras();
  dv1.renderCurve();
  image(dv1.pgViz, 0, 0);
  dv1.sortTestY();
  dv1.createAnimation();
  for (int i = 0; i < rainDrops.length; i++) {
    rainDrops[i] =  new Rain();
  }
}

void draw() {
  if (mousePressed) {
   
    renderRain();
    //dv1.renderCurve();
  } else {
    dv1.renderChart();
    dv1.labelAxes();
    dv1.extras();
    dv1.renderCurve();
  }
  
 
  image(dv1.pgViz, 0, 0);


  //println(dv1.animatedPoints.get(2).getY() + " " + dv1.animatedPoints.get(2).v + " " + dv1.ySize);
}

void renderRain() {
  dv1.pgViz.beginDraw();
  dv1.pgViz.background(255);
  dv1.pgViz.endDraw();
  //for (DataPointAnimated d : dv1.animatedPoints) {
  //  d.rainCalculate(rainDrops);
  //}

  for (Rain r : rainDrops) {
    r.fall();
    r.calculateHilight(dv1.animatedPoints);
    r.display(dv1.pgViz);
    r.hilight = false;
  }
}

float gettestSliderVal() {
  return testSliderVal;
}
