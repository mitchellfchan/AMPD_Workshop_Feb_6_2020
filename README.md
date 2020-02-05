<h1>THINKING THROUGH A NEW DATA VIZUALIZATION CLASS IN PROCESSING</h1>


<h3> The Context:  
One of the primary ways that artists can engage the climate crisis is to aid in the representation and communication climate phenomena. In the battle for any massive change to our socioeconomic structures, our greatest weapon is the ability to communicate with clarity and excitement.  

With this in mind, we establish this goal: Create a toolset that will allow us to create unique and captivating visualizations that could be used by scientists, journalists, and activist groups. </h3>

<h2> The Goal:       
Create a class that can read a .csv file, and turn it into a number of DataPoint objects (of a class we'll define ourselves) that could later be animated.
</h2>


<hr>

<h2>STEP 1. Baby Steps: Using the Processing's Table Class</h2>

***Key concepts:***

[The Table Object](https://processing.org/reference/Table.html)

Processing already includes a class for importing .csv files. 


<h2>STEP 2. Thinking through our data visualizer class, and getting the data out of the chart</h2>

What do we want our class, which we'll call **DataViz**, to do?
For now, we'll focus on taking 2D data from our chart, and turning it into objects. Our TODO list will look something like thi:

1. Receive a table object
2. Read only certain values (the columns we specify as holding the data we want to plot)
3. Be able to handle entries in the table that contain irregular dataTypes(e.g. a cell in the table has no entry, or reads "N/A" or "-")
4. Turn each valid entry into a unique DataPoint object (which we'll have to define)


We'll handle each of these goals  one at a time.

<h3>
1. Receive a table object
</h3>

This means that our constructor should, at the very least, require a **Table** object as an argument. We'll add more arguments as we decide what other information we'll need to achieve the aforementioned goals.

<h3>
2. Read only certain values
</h3>

This will happen in a new method of our class we'll create called **mapChart**. 

If we've read the documentation on Processing's **Table** object, then we know that we can easily iterate through a table to look at each individual row like this:

```java
for (TableRow row : thisTable.rows()) {
}
```

...and we can get the data from a specific column in that row if we just provide the name of the column header, like this:

```java
value = row.getFloat("nameOfColumn");
```

<h3>
3. Be able to handle entries in the table that contain irregular data types
</h3>


***Key Concepts:***

[Data Primitives vs. Reference Types](https://javarevisited.blogspot.com/2015/09/difference-between-primitive-and-reference-variable-java.html)

[Exception Handlers](https://www.w3schools.com/java/java_try_catch.asp)

This is where things get tricky. In the .csv file I'm using, entries where there is no data available are marked "-". We DON'T want our sketch to screech to a halt every time one of these ticks comes up. To plan for this, we're going to store our data in a Float (note the capital F!!) **reference object** rather than a float data primitive. This allows us to assign a **null** value to those entries.

And if any other errors come up with our data, we'll create an exception handler that once again assigns a null value to that entry.

<h3>
4. Turn each valid entry into a unique DataPoint object
</h3>

Easy as pie:

```java
if (!Float.isNaN(xVal) && !Float.isNaN(yVal)) {
        dataPoints.add(new DataPoint(xVal, yVal));
        }
```
<h2>
STEP 3. Thinking through our DataPoint class, and drawing the data
</h2>

***Key Concepts:***

[The PGraphics Object](https://processing.org/reference/PGraphics.html) 

We got ahead of ourselves a bit in the last step. We're adding new DataPoints, but we haven't defined that class yet. So let's go ahead and do that.

As we think about the DataPoint constructor, all we know for sure is that it probably needs 2 datapoints to be created: a value along the x-axis and a value along the y-axis. 

While we're at it, let's make our next TODO list. What _else_ do we want our DataViz class and new DataPoint class to do?

5. Display the datapoints on a chart
6. Draw a spline curve through the datapoints

We've also decided that it would be beneficial for each DataViz object to draw in its own PGraphics canvas. This is useful because it would allow us to have multiple vizualizations at once without them interfering with each other. With this in mind, we'll go back and add arguments to the DataViz constructor, so that we can decide how big the PGraphics canvas should be.

Now, back to our TODO list:

<h3>
5. Display the data
</h3>

***Key Concepts:***

[Encapsulation with Getters and Setters](https://www.w3schools.com/java/java_encapsulation.asp)

[map](https://processing.org/reference/map_.html)

This should be easy. We'll create a function in the DataViz class that iterates through all our DataPoint objects and call a render method for that object.

A basic render method in the class DataPoint can be as simple as:

```java

public void render(PGraphics pg) {
    pushStyle();
    pg.strokeWeight(2);
    pg.fill(255, 77, 99);
    pg.ellipse(loc.x, loc.y, 20, 20);

    popStyle();
  }
```

But wait! There's one problem. I can't just use the raw values of a datapoint for mapping. If, for example, I had a chart showing a value of 62,001, it would try to draw the datapoint 62,001 pixels over. So we need to map those values across the size of the PGraphics canvas. 

We also want to know what range of data we're looking at. For example, I probably don't want to chart the years 0 to 2030... I should specify that I only want to chart the years 2015 to 2030. For that, request the minimum and maximum values of each axis as arguments to this new method which I'm calling **renderScaled**

```java

public void renderScaled(PGraphics pg, float _xAxMin, float _xAxMax, float _yAxMin, float _yAxMax, float border) {
    pg.pushStyle();  
    pg.strokeWeight(2);
    pg.fill(255, 77, 99);
    float xValMapped = map(getX(), _xAxMin, _xAxMax, 0 + border, pg.width-border);
    float yValMapped = map(getY(), _yAxMin, _yAxMax, pg.height-border, 0)+border;
    
    pg.ellipse(xValMapped, yValMapped, 20, 20);
    
    pg.popStyle();
    }
```

One more thing to note! You see that when we get the x value to manipulate the data, we're not just directly calling the for the loc.x property. We've created a number of getter and setter functions -- getX(), getY(), set(X), etcetera -- to do that. This is called encapsulation. Basically, the core data that we've pulled out of the CSV is really important! I don't want it change it by accident. Getters and Setters give me a way to access the data in the object I want, without risk of assigning it a value. It will also allow me to define those properties as **private** . A small detail, but it's good form!

<h3>
6. Drawing a spline curve through the datapoints
</h3>

***Key Concepts:***

[ArrayList Methods](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html)

[The java.util.Comparator Object](https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html)

[Overriding A SuperClass Method](https://docs.oracle.com/javase/tutorial/java/IandI/override.html)

This is another thing that looks like it should be easy, and it _is_... if our ArrayList of DataPoints is indexed in order.

We'd use Processing's method's for drawing curves and place curve vertexes at each datapoint.

```java
   pgViz.beginShape()
    for (DataPoint d : arrayListOfDataPoints) {
      pgViz.curveVertex(d.getX(), d.getY());
    }
```

But consider what would happen if our data was entered out of order! Our curve points would be entered out of order, and the result would be a scribbly line that went back and forth across our canvas. So before drawing our line, we need to consider how we can sort through all our datapoints to make sure they're all in order.

Surely there must be a simple way to sort through an ArrayList? 

Yes, there is! The ArrayList object has a method called sort(), and it does what you might imagine. The problem is, sort() is set up to sort an ArrayList of ints or strings or some other data primitive. We've got an ArrayList of our own custom-made DataPoint objects. So we'll have to reprogram how the .sort() function works.

If we were to look inside the The sort() function itself, we'd see that it uses an object called a comparator. We need to change how that comparator works.

```java
static final Comparator<DataPoint> xComparator = new Comparator<DataPoint>() {
  @Override
    final int compare(DataPoint d1, DataPoint d2) {
    return (d1.getX() < d2.getX() ? -1 :
      (d2.getX() == d1.getX() ? 0 : 1));
  }
};
```

>Sidebar: There's another interesting part of this code: a conditional operator that's less common, but still good to know. The question mark - colon construction is a way of setting up an if-else statement. I think it's set up pretty ugly here (I don't like the nested construction) but included it because it's a good thing to get familiar with. 

>To explain:

```java
val1 < val2 ? do.this() : do.somethingElse();
```

>could also be written as
```java
if (val1 < val2){
    do.this();
} else {
    do.somethingElse();
}
```

Now the comparator is set up to look at 2 DataPoints, get specific properties from them, and return a decision about which is bigger.  1, -1, or 0 are the possible values returned by the Comparator's compare() function, and these results are interpreted by the sort() function as it figures out where to index each member of the arraylist. There's a lot going on here, and we're actually looking at methods in a couple different layers of superclass! We're far outside of the Processing Reference Docs and into the Java Reference Docs!

When we were using the sort() method, you might have noticed that we were calling it from the **Collections** class, which is actually a superclass of ArrayList. ArrayList _inherits_ a bunch of methods from that parent class.


<h2> STEP 4. Extending the DataPoint class</h2>


This was an excellent segue into creating our own subclass of DataPoint. 

We've made a chart! Now let's make our datapoints dance by creating a subclass of datapoints that have fun and wacky methods.

You can open the final example file to see a simple DataPoint subclass, which I called DataPointAnimated.


