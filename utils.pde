// Collision detection
// copied and adapted from http://www.jeffreythompson.org/collision-detection/point-rect.php

// POINT/RECTANGLE 
boolean isPointInRectangle(float px, float py, float rx, float ry, float rw, float rh) {
    return px >= rx && px <= rx + rw && py >= ry && py <= ry + rh;
    
}



// trace functions: 
//    traceWithTime( String traceMessage )
//    traceIfChanged( String id , String logLine )

import java.util.Map;
import java.util.HashMap;

private static float start = System.nanoTime();


/**
 * Traces a string preceded with the current time.
 * @param traceMessage  Message to be traced.
 */
public static void traceWithTime( String traceMessage )
{
    float now = timeSinceStartInSeconds();
    
    println( now + " > " + traceMessage );
}

/**
 * Returns the number of seconds since the start of the execution.
 */
public static int timeSinceStartInSeconds()
{
    return (int) ( ( System.nanoTime() - start ) / 1e9 );
}

private static Map<String,String> logid2line = new HashMap<String,String>();

/**
 * Only logs data associated with an id, if and only if the *data* has changed.
 */
public static void traceIfChanged( String id , String logLine )
{
    if ( !logid2line.containsKey(id) || !logid2line.get(id).equals( logLine ) ) {
        println( id + " = " + logLine );
        logid2line.put( id, logLine );
    }
}


private static Map<String,Long> function2time = new HashMap<String,Long>();

public static void traceFunctionTime( String id ) {
    long now = System.nanoTime();
    if ( !function2time.containsKey(id) ) {
        
        println( ">>> " + id +"()" );
        function2time.put( id, now );
    } else {
        float duration = int( ( now - function2time.get(id) ) / 1e6 );
        duration /= 1e3;  // number in seconds, 3 digits
        println( "<<< " + id +"() took " + duration + " sec");
        function2time.remove( id );
    }
}


public static int pixelDensity;
public static float x_scale;
public static float y_scale;

int setDisplayScale( int width, int height ) {
    pixelDensity = displayWidth != width * displayDensity() ? 2 : displayDensity();
    //pixelDensity( pixelDensity );
    x_scale =  float( displayWidth ) / width  / pixelDensity;
    y_scale = float( displayHeight ) / height / pixelDensity;
    
    print( "scale=  " + x_scale + " , " + y_scale );
    println( "\tpixelDensity = " + pixelDensity );
    println( "\tdisplayDensity = " + displayDensity() );
    
    return pixelDensity;
}

void setScaling() {
    scale( x_scale, y_scale );
}


//int mouseX;
//int mouseY;
//int pmouseX;
//int pmouseY;

//void setMouseToScale() {
//    mouseX = int( super.mouseX  / x_scale );
//    mouseY = int( super.mouseY  / y_scale );
//   pmouseX = int( super.pmouseX / x_scale );
//   pmouseY = int( super.pmouseY / y_scale );
//}
