/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.exist.xquery.modules.mpeg7;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;


/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class test {

    public static void main(String[] args) {

        String[] coordIndexArray = null;
        String coordIndex = "0 1 2 3 0 -1 4 5 6 7 4 -1 0 4 -1 1 5 -1 2 6 -1 3 7 -1";
        String points = "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
        List totalPointParts = null;

        Scanner sc = new Scanner(coordIndex).useDelimiter(" ");
        int maxCoordIndex=0;
        while(sc.hasNextInt()){
            int thisVal = sc.nextInt();
            if (thisVal > maxCoordIndex){
                maxCoordIndex = thisVal;
            }
        }        
        System.out.println("maxCoordIndex: " + maxCoordIndex);
        totalPointParts = new ArrayList();
        totalPointParts = getPointParts(points, maxCoordIndex);

        if (coordIndex.contains("-1")) {
            coordIndex = coordIndex.substring(0, coordIndex.lastIndexOf("-1"));
            coordIndexArray = coordIndex.split(" -1 ");
        } else {
            coordIndexArray = new String[1];
            coordIndexArray[0] = coordIndex;
        }


          System.out.println("coordIndexArray");
          System.out.println("coordIndexArray.length: " + coordIndexArray.length);
        for (int i = 0; i < coordIndexArray.length; i++) {
          
            System.out.println(i + ": " + coordIndexArray[i]);
        }
        System.out.println("totalPointsParts");
        for (int j = 0; j < totalPointParts.size(); j++) {
            
            System.out.println(j + ": " + totalPointParts.get(j));
        }

    }

    private static List getPointParts(String points, int indexSize) {
        List pointParts = new ArrayList();
        String test[] = points.split(" ");
        System.out.println(test.length);
        Scanner scannedPoints = new Scanner(points).useDelimiter(" ");        
        int totalPointIndex = 3 * (indexSize + 1);
        System.out.println("totalPointIndex: 3 * (" + indexSize +" + 1) = " + totalPointIndex);
        int index = 0;
        float[] floats = new float[totalPointIndex];

        while ((scannedPoints.hasNextFloat()) && (index < floats.length)) {
            float fl = scannedPoints.nextFloat();
            floats[index] = fl;
            index++;
        }
        for (int i = 0; i < floats.length; i += 3) {
            String nextPart = Float.toString(floats[i]) + " " + Float.toString(floats[i + 1]) + " " + Float.toString(floats[i + 2]);
            pointParts.add(nextPart);
        }
        return pointParts;
    }
}
