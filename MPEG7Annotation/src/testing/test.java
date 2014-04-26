/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testing;

import com.sun.org.apache.xml.internal.utils.SystemIDResolver;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Scanner;
import javax.xml.transform.TransformerException;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class test {

    public static void main(String[] args) throws IOException, TransformerException {

        String pt = "../HelloWorld.x3d";
        String bp = "/db/3dData/x3d/X3DForWebAuthors/Chapter13-Grouping";
        System.out.println(resolveExistUri(bp, pt));
        //System.out.println("test " + path.relativize(path.resolve(base)).toString());        

        String[] coordIndexArray = null;
        String coordIndex = "0 1 2 3 -1";

        String points = "-1 -1 1 1 -1 1 1 1 1 -1 1 1 1 1 -1 -1 1 -1 -1 -1 -1 1 -1 -1";
        List totalPointParts = null;
        coordIndex = coordIndex.replaceAll("\\r|\\n", " ").trim().replaceAll(" +", " ").replaceAll(",", "");
        System.out.println(coordIndex);
        points = points.replaceAll("\\r|\\n", " ").trim().replaceAll(" +", " ").replaceAll(",", "");
        System.out.println(points);
        Scanner sc = new Scanner(coordIndex).useDelimiter(" ");
        int maxCoordIndex = 0;
        while (sc.hasNextInt()) {
            int thisVal = sc.nextInt();
            if (thisVal > maxCoordIndex) {
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
        System.out.println("totalPointIndex: 3 * (" + indexSize + " + 1) = " + totalPointIndex);
        int index = 0;
        double[] floats = new double[totalPointIndex];

        while ((scannedPoints.hasNextDouble()) && (index < floats.length)) {
            double fl = scannedPoints.nextDouble();
            floats[index] = fl;
            index++;
        }
        for (int i = 0; i < floats.length; i += 3) {
            String nextPart = Double.toString(floats[i]) + " " + Double.toString(floats[i + 1]) + " " + Double.toString(floats[i + 2]);
            pointParts.add(nextPart);
        }
        return pointParts;
    }

    private static String resolveExistUri(String basePath, String filePath) {
        int countSteps = StringUtils.countMatches(filePath, "../");
        String basePathParts[] = basePath.split("/");
        List<String> basePathPartsList = new ArrayList<String>(Arrays.asList(basePathParts));
        basePathPartsList.removeAll(Arrays.asList("", null));
        String newBasePath = "";
        int remainingParts = basePathPartsList.size() - 1 - countSteps;
        for (int i = 0; i <= remainingParts; i++) {
            newBasePath = newBasePath.concat("/").concat(basePathPartsList.get(i));            
        }
        return newBasePath.concat(filePath.substring(filePath.lastIndexOf("../") + 2)); 
    }
}