//Add rotations, both with respect to the spine-aligned cross-section plane, and the manually defined ones
//Important:: Check if the crosssection is closed, and make the following arrangements:
//-Make a relevant boolean to check throughout the operations
//-reduce length of the crossection array by one
//-arrange faces accordingly:the last should close with the first. Without this, shape will have problems
//Secondly Important:: check if the spine is closed. Similar arrangements concerning both size of points and faces must be made
//Thirdly: what about inverse direction? Do the normals change? CCW still aplies?
//The lids do not work
//Fix the face directions to point outwards
package org.exist.xquery.modules.mpeg7.x3d.geometries;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringWriter;
import org.apache.log4j.Logger;

/**
 *
 * @author Markos
 */
public class ExtrusionDescription {
    private static final Logger logger = Logger.getLogger("app.annotation");
    public static void main(String[] args) {
        String command[] = new String[1];
        command[0] = "Extrusion.txt";
        try {
            ExtrusionDescription(command);
        } catch (IOException e) {
            logger.error(e);
        }

    }

    public static String ExtrusionDescription(String[] args) throws FileNotFoundException, IOException {
//************ Data Input from hard disk *****************
        BufferedReader ExtrusionFile;

        ExtrusionFile = new BufferedReader(new FileReader(args[0]));

        String StrCrossSection = null;
        String StrSpine = null;
        String StrScale = null;
        String StrOrientation = null;

        Boolean CrossSectionCloses = false;
        Boolean SpineCloses = false;

        try {
            String line = ExtrusionFile.readLine();

            while (line != null) {
                if (line.equalsIgnoreCase("CrossSection")) {
                    line = ExtrusionFile.readLine();
                    StrCrossSection = line;
                }
                if (line.equalsIgnoreCase("Spine")) {
                    line = ExtrusionFile.readLine();
                    StrSpine = line;
                }
                if (line.equalsIgnoreCase("Scale")) {
                    line = ExtrusionFile.readLine();
                    StrScale = line;
                }
                if (line.equalsIgnoreCase("Orientation")) {
                    line = ExtrusionFile.readLine();
                    StrOrientation = line;
                }
                line = ExtrusionFile.readLine();
            }
        } finally {
            ExtrusionFile.close();
        }

        String[] TmpCrossSection = null;
        String[] TmpSpine = null;
        String[] TmpScale = null;
        String[] TmpOrientation = null;

        double[][] CrossSection = null;
        double[][] Spine = null;
        double[][] Scale = null;
        double[][] Orientation = null;

        String delim = "\\s+";

        TmpCrossSection = StrCrossSection.split(delim);
        TmpSpine = StrSpine.split(delim);
        if (StrScale != null) {
            TmpScale = StrScale.split(delim);
        }
        if (StrOrientation != null) {
            TmpOrientation = StrOrientation.split(delim);
        }

        CrossSection = new double[TmpCrossSection.length / 2][2];
        for (int i = 0; i < TmpCrossSection.length / 2; i++) {
            CrossSection[i][0] = Float.valueOf(TmpCrossSection[i * 2]);
            CrossSection[i][1] = Float.valueOf(TmpCrossSection[i * 2 + 1]);
        }

        Spine = new double[TmpSpine.length / 3][3];
        for (int i = 0; i < TmpSpine.length / 3; i++) {
            Spine[i][0] = Float.valueOf(TmpSpine[i * 3]);
            Spine[i][1] = Float.valueOf(TmpSpine[i * 3 + 1]);
            Spine[i][2] = Float.valueOf(TmpSpine[i * 3 + 2]);
        }

        if (StrScale != null) {
            Scale = new double[TmpScale.length / 2][2];
            for (int i = 0; i < TmpScale.length / 2; i++) {
                Scale[i][0] = Float.valueOf(TmpScale[i * 2]);
                Scale[i][1] = Float.valueOf(TmpScale[i * 2 + 1]);
            }
        } else {
            Scale = new double[TmpSpine.length / 3][3];
            for (int i = 0; i < TmpSpine.length / 3; i++) {
                Scale[i][0] = 1;
                Scale[i][1] = 1;
            }
        }

        if (StrOrientation != null) {
            Orientation = new double[TmpOrientation.length / 4][4];
            for (int i = 0; i < TmpOrientation.length / 4; i++) {
                Orientation[i][0] = Float.valueOf(TmpOrientation[i * 4]);
                Orientation[i][1] = Float.valueOf(TmpOrientation[i * 4 + 1]);
                Orientation[i][2] = Float.valueOf(TmpOrientation[i * 4 + 2]);
                Orientation[i][3] = Float.valueOf(TmpOrientation[i * 4 + 3]);
            }
        } else {
            Orientation = new double[TmpSpine.length / 3][4];
            for (int i = 0; i < TmpSpine.length / 3; i++) {
                Orientation[i][0] = 0;
                Orientation[i][1] = 1;
                Orientation[i][2] = 0;
                Orientation[i][3] = 0;
            }
        }

        //Due to Schema specs, sometimes a single '1 1' value is passed in spine/or there could be an authoring error
        //Optimally, instead of replacing all values, the last given one should be replicated for the rest of the length
        if (Scale.length < Spine.length) {
            double auxScale[][] = new double[Spine.length][2];
            for (int i = Scale.length; i < Spine.length; i++) {
                auxScale[i][0] = 1;
                auxScale[i][1] = 1;
            }
            Scale = auxScale;
        }
        //Similarly for orientation
        if (Orientation.length < Spine.length) {
            double auxOrient[][] = new double[Spine.length][4];
            for (int i = Orientation.length; i < Spine.length; i++) {
                auxOrient[i][0] = 0;
                auxOrient[i][1] = 1;
                auxOrient[i][2] = 0;
                auxOrient[i][3] = 0;
            }
            Orientation = auxOrient;
        }

        // End of file input
        double Yaxis[] = new double[3];
        double Zaxis[] = new double[3];
        double prevZaxis[] = new double[3];
        double intermediateZaxis[] = new double[3];
        double reverseZaxis[] = new double[3];
        double prevVector[] = new double[3];
        double nextVector[] = new double[3];
        double norm;

        double NewPoint[] = new double[3];

        double PriorYangle[] = new double[Spine.length];
        double Yangle[] = new double[Spine.length];
        double Zangle[] = new double[Spine.length];

        System.out.println(Spine.length);
        System.out.println(CrossSection.length);

        //  System.out.println(CrossSection[CrossSection.length - 1][0] + " " + CrossSection[CrossSection.length - 1][1] + " ");
        //  System.out.println(CrossSection[0][0] + " " + CrossSection[0][1] + " ");
        if ((CrossSection[CrossSection.length - 1][0] == CrossSection[0][0]) && (CrossSection[CrossSection.length - 1][1] == CrossSection[0][1])) {
            CrossSectionCloses = true;
            System.out.println("Cross Section Closes");
        }

        if ((Spine[Spine.length - 1][0] == Spine[0][0]) && (Spine[Spine.length - 1][1] == Spine[0][1]) && (Spine[Spine.length - 1][2] == Spine[0][2])) {
            SpineCloses = true;
            System.out.println("Spine Closes");
        }

        for (int i = 0; i < Spine.length; i++) {
            //first point

            if (i == 0) {
                if (!SpineCloses) {

                    Yaxis[0] = Spine[1][0] - Spine[0][0];
                    Yaxis[1] = Spine[1][1] - Spine[0][1];
                    Yaxis[2] = Spine[1][2] - Spine[0][2];

                    norm = Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[1], 2) + Math.pow(Yaxis[2], 2));
                    if (norm != 0) {
                        Yaxis[0] = Yaxis[0] / norm;
                        Yaxis[1] = Yaxis[1] / norm;
                        Yaxis[2] = Yaxis[2] / norm;
                    }

                    Yangle[i] = -Math.atan2(Yaxis[2], Yaxis[0]);
                    Zangle[i] = Math.atan2(Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[2], 2)), Yaxis[1]);
                    PriorYangle[i] = 0;

                    // System.out.println("Angles (First): Y:" + Yangle[i] + " Z:" + Zangle[i] + " Prior:" + PriorYangle[i]);
                } else {

                    prevVector[0] = Spine[Yangle.length - 1][0] - Spine[i][0];
                    prevVector[1] = Spine[Yangle.length - 1][1] - Spine[i][1];
                    prevVector[2] = Spine[Yangle.length - 1][2] - Spine[i][2];
                    norm = Math.sqrt(Math.pow(prevVector[0], 2) + Math.pow(prevVector[1], 2) + Math.pow(prevVector[2], 2));
                    if (norm != 0) {
                        prevVector[0] = prevVector[0] / norm;
                        prevVector[1] = prevVector[1] / norm;
                        prevVector[2] = prevVector[2] / norm;
                    }

                    nextVector[0] = Spine[i + 1][0] - Spine[i][0];
                    nextVector[1] = Spine[i + 1][1] - Spine[i][1];
                    nextVector[2] = Spine[i + 1][2] - Spine[i][2];
                    norm = Math.sqrt(Math.pow(nextVector[0], 2) + Math.pow(nextVector[1], 2) + Math.pow(nextVector[2], 2));
                    if (norm != 0) {
                        nextVector[0] = nextVector[0] / norm;
                        nextVector[1] = nextVector[1] / norm;
                        nextVector[2] = nextVector[2] / norm;
                    }

                    Yaxis[0] = Spine[i + 1][0] - Spine[Yangle.length - 1][0];
                    Yaxis[1] = Spine[i + 1][1] - Spine[Yangle.length - 1][1];
                    Yaxis[2] = Spine[i + 1][2] - Spine[Yangle.length - 1][2];
                    norm = Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[1], 2) + Math.pow(Yaxis[2], 2));
                    if (norm != 0) {
                        Yaxis[0] = Yaxis[0] / norm;
                        Yaxis[1] = Yaxis[1] / norm;
                        Yaxis[2] = Yaxis[2] / norm;
                    }

                    // System.out.println("Previous: " + prevVector[0] + " " + prevVector[1] + " " + prevVector[2]);
                    // System.out.println("Next: " + nextVector[0] + " " + nextVector[1] + " " + nextVector[2]);
                    // System.out.println("Y: " + Yaxis[0] + " " + Yaxis[1] + " " + Yaxis[2]);
                    prevZaxis[0] = Zaxis[0];
                    prevZaxis[1] = Zaxis[1];
                    prevZaxis[2] = Zaxis[2];

                    Zaxis[0] = nextVector[1] * prevVector[2] - nextVector[2] * prevVector[1];
                    Zaxis[1] = nextVector[2] * prevVector[0] - nextVector[0] * prevVector[2];
                    Zaxis[2] = nextVector[0] * prevVector[1] - nextVector[1] * prevVector[0];

                    norm = Math.sqrt(Math.pow(Zaxis[0], 2) + Math.pow(Zaxis[1], 2) + Math.pow(Zaxis[2], 2));

                    if (norm == 0) {
                        PriorYangle[i] = PriorYangle[Yangle.length - 1];
                        Yangle[i] = Yangle[Yangle.length - 1];
                        //Zangle[i] = Zangle[i - 1];
                        Zangle[i] = Math.atan2(Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[2], 2)), Yaxis[1]);

                        Zaxis[0] = prevZaxis[0];
                        Zaxis[1] = prevZaxis[1];
                        Zaxis[2] = prevZaxis[2];

                        // System.out.println(Zaxis[0] + ":" + Zaxis[1] + ":" + Zaxis[2] + "|" + prevZaxis[0] + ":" + prevZaxis[1] + ":" + prevZaxis[2]);
                        //  System.out.println(i + " Looking to twist: " + String.valueOf(Zaxis[0] * prevZaxis[0] + Zaxis[1] * prevZaxis[1] + Zaxis[2] * prevZaxis[2]));
                        //   System.out.println("Zero norm");
                    } else {
                        Zaxis[0] = Zaxis[0] / norm;
                        Zaxis[1] = Zaxis[1] / norm;
                        Zaxis[2] = Zaxis[2] / norm;

                        //    System.out.println(Zaxis[0] + ":" + Zaxis[1] + ":" + Zaxis[2] + " | " + prevZaxis[0] + ":" + prevZaxis[1] + ":" + prevZaxis[2]);
                        //     System.out.println(i + " Looking to twist: " + String.valueOf(Zaxis[0] * prevZaxis[0] + Zaxis[1] * prevZaxis[1] + Zaxis[2] * prevZaxis[2]));
                        if ((i > 1) && (Zaxis[0] * prevZaxis[0] + Zaxis[1] * prevZaxis[1] + Zaxis[2] * prevZaxis[2] < 0)) {
                            // System.out.println("Twisted");
                            Zaxis[0] = -Zaxis[0];
                            Zaxis[1] = -Zaxis[1];
                            Zaxis[2] = -Zaxis[2];
                        }

                        //  System.out.println("Z: " + Zaxis[0] + " " + Zaxis[1] + " " + Zaxis[2]);
                        //    System.out.println("Inner Product:" + (Zaxis[0] * Yaxis[0] + Zaxis[1] * Yaxis[1] + Zaxis[2] * Yaxis[2]));
                        Yangle[i] = -Math.atan2(Yaxis[2], Yaxis[0]);
                        Zangle[i] = Math.atan2(Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[2], 2)), Yaxis[1]);

                        intermediateZaxis[0] = Math.cos(Yangle[i]) * Zaxis[0] - Math.sin(Yangle[i]) * Zaxis[2];
                        intermediateZaxis[1] = Zaxis[1];
                        intermediateZaxis[2] = Math.sin(Yangle[i]) * Zaxis[0] + Math.cos(Yangle[i]) * Zaxis[2];

                        reverseZaxis[0] = Math.cos(Zangle[i]) * intermediateZaxis[0] + Math.sin(Zangle[i]) * intermediateZaxis[1];
                        reverseZaxis[1] = -Math.sin(Zangle[i]) * intermediateZaxis[0] + Math.cos(Zangle[i]) * intermediateZaxis[1];
                        reverseZaxis[2] = intermediateZaxis[2];

                        //   System.out.println(intermediateZaxis[0] + ":" + intermediateZaxis[1] + ":" + intermediateZaxis[2] + "   -   " + reverseZaxis[0] + ":" + reverseZaxis[1] + ":" + reverseZaxis[2]);
                        //    System.out.println(PriorYangle[i]);
                    }

                    //   System.out.println("Angles (" + String.valueOf(i) + ") Y:" + Yangle[i] + " Z:" + Zangle[i] + " Prior:" + PriorYangle[i]);
                }

            } else if (i == Spine.length - 1) {
                if (!SpineCloses) {

                    //last point
                    Yaxis[0] = Spine[i][0] - Spine[i - 1][0];
                    Yaxis[1] = Spine[i][1] - Spine[i - 1][1];
                    Yaxis[2] = Spine[i][2] - Spine[i - 1][2];
                    norm = Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[1], 2) + Math.pow(Yaxis[2], 2));
                    if (norm != 0) {
                        Yaxis[0] = Yaxis[0] / norm;
                        Yaxis[1] = Yaxis[1] / norm;
                        Yaxis[2] = Yaxis[2] / norm;
                    }
                    PriorYangle[i] = PriorYangle[i - 1];

                    Yangle[i] = -Math.atan2(Yaxis[2], Yaxis[0]);
                    Zangle[i] = Math.atan2(Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[2], 2)), Yaxis[1]);

                    //      System.out.println("Angles (Final): Y:" + Yangle[i] + " Z:" + Zangle[i] + " Prior:" + PriorYangle[i]);
                }
            } else {

                prevVector[0] = Spine[i - 1][0] - Spine[i][0];
                prevVector[1] = Spine[i - 1][1] - Spine[i][1];
                prevVector[2] = Spine[i - 1][2] - Spine[i][2];
                norm = Math.sqrt(Math.pow(prevVector[0], 2) + Math.pow(prevVector[1], 2) + Math.pow(prevVector[2], 2));
                if (norm != 0) {
                    prevVector[0] = prevVector[0] / norm;
                    prevVector[1] = prevVector[1] / norm;
                    prevVector[2] = prevVector[2] / norm;
                }

                nextVector[0] = Spine[i + 1][0] - Spine[i][0];
                nextVector[1] = Spine[i + 1][1] - Spine[i][1];
                nextVector[2] = Spine[i + 1][2] - Spine[i][2];
                norm = Math.sqrt(Math.pow(nextVector[0], 2) + Math.pow(nextVector[1], 2) + Math.pow(nextVector[2], 2));
                if (norm != 0) {
                    nextVector[0] = nextVector[0] / norm;
                    nextVector[1] = nextVector[1] / norm;
                    nextVector[2] = nextVector[2] / norm;
                }

                Yaxis[0] = Spine[i + 1][0] - Spine[i - 1][0];
                Yaxis[1] = Spine[i + 1][1] - Spine[i - 1][1];
                Yaxis[2] = Spine[i + 1][2] - Spine[i - 1][2];
                norm = Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[1], 2) + Math.pow(Yaxis[2], 2));
                if (norm != 0) {
                    Yaxis[0] = Yaxis[0] / norm;
                    Yaxis[1] = Yaxis[1] / norm;
                    Yaxis[2] = Yaxis[2] / norm;
                }

                // System.out.println("Previous: " + prevVector[0] + " " + prevVector[1] + " " + prevVector[2]);
                // System.out.println("Next: " + nextVector[0] + " " + nextVector[1] + " " + nextVector[2]);
                //   System.out.println("Y: " + Yaxis[0] + " " + Yaxis[1] + " " + Yaxis[2]);
                prevZaxis[0] = Zaxis[0];
                prevZaxis[1] = Zaxis[1];
                prevZaxis[2] = Zaxis[2];

                Zaxis[0] = nextVector[1] * prevVector[2] - nextVector[2] * prevVector[1];
                Zaxis[1] = nextVector[2] * prevVector[0] - nextVector[0] * prevVector[2];
                Zaxis[2] = nextVector[0] * prevVector[1] - nextVector[1] * prevVector[0];

                norm = Math.sqrt(Math.pow(Zaxis[0], 2) + Math.pow(Zaxis[1], 2) + Math.pow(Zaxis[2], 2));

                if (norm == 0) {
                    PriorYangle[i] = PriorYangle[i - 1];
                    Yangle[i] = Yangle[i - 1];
                    //Zangle[i] = Zangle[i - 1];
                    Zangle[i] = Math.atan2(Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[2], 2)), Yaxis[1]);

                    Zaxis[0] = prevZaxis[0];
                    Zaxis[1] = prevZaxis[1];
                    Zaxis[2] = prevZaxis[2];

                    //     System.out.println(Zaxis[0] + ":" + Zaxis[1] + ":" + Zaxis[2] + "|" + prevZaxis[0] + ":" + prevZaxis[1] + ":" + prevZaxis[2]);
                    //      System.out.println(i + " Looking to twist: " + String.valueOf(Zaxis[0] * prevZaxis[0] + Zaxis[1] * prevZaxis[1] + Zaxis[2] * prevZaxis[2]));
                    //       System.out.println("Zero norm");
                } else {
                    Zaxis[0] = Zaxis[0] / norm;
                    Zaxis[1] = Zaxis[1] / norm;
                    Zaxis[2] = Zaxis[2] / norm;

                    //        System.out.println(Zaxis[0] + ":" + Zaxis[1] + ":" + Zaxis[2] + " | " + prevZaxis[0] + ":" + prevZaxis[1] + ":" + prevZaxis[2]);
                    //       System.out.println(i + " Looking to twist: " + String.valueOf(Zaxis[0] * prevZaxis[0] + Zaxis[1] * prevZaxis[1] + Zaxis[2] * prevZaxis[2]));
                    if ((i > 1) && (Zaxis[0] * prevZaxis[0] + Zaxis[1] * prevZaxis[1] + Zaxis[2] * prevZaxis[2] < 0)) {
                        //           System.out.println("Twisted");
                        Zaxis[0] = -Zaxis[0];
                        Zaxis[1] = -Zaxis[1];
                        Zaxis[2] = -Zaxis[2];
                    }

                    //      System.out.println("Z: " + Zaxis[0] + " " + Zaxis[1] + " " + Zaxis[2]);
                    //      System.out.println("Inner Product:" + (Zaxis[0] * Yaxis[0] + Zaxis[1] * Yaxis[1] + Zaxis[2] * Yaxis[2]));
                    Yangle[i] = -Math.atan2(Yaxis[2], Yaxis[0]);
                    Zangle[i] = Math.atan2(Math.sqrt(Math.pow(Yaxis[0], 2) + Math.pow(Yaxis[2], 2)), Yaxis[1]);

                    intermediateZaxis[0] = Math.cos(Yangle[i]) * Zaxis[0] - Math.sin(Yangle[i]) * Zaxis[2];
                    intermediateZaxis[1] = Zaxis[1];
                    intermediateZaxis[2] = Math.sin(Yangle[i]) * Zaxis[0] + Math.cos(Yangle[i]) * Zaxis[2];

                    reverseZaxis[0] = Math.cos(Zangle[i]) * intermediateZaxis[0] + Math.sin(Zangle[i]) * intermediateZaxis[1];
                    reverseZaxis[1] = -Math.sin(Zangle[i]) * intermediateZaxis[0] + Math.cos(Zangle[i]) * intermediateZaxis[1];
                    reverseZaxis[2] = intermediateZaxis[2];

                    //     System.out.println(intermediateZaxis[0] + ":" + intermediateZaxis[1] + ":" + intermediateZaxis[2] + "   -   " + reverseZaxis[0] + ":" + reverseZaxis[1] + ":" + reverseZaxis[2]);
                    //      System.out.println(PriorYangle[i]);
                }

                //   System.out.println("Angles (" + String.valueOf(i) + ") Y:" + Yangle[i] + " Z:" + Zangle[i] + " Prior:" + PriorYangle[i]);
            }

            //Zangle[0]=-2.8;
            //Yangle[0]=-1.57;
            // Zangle[1]=3.6;
            // Zangle[2]=-1.57;
            // Zangle[3]=0;
            // Zangle[4]=0;
        }
            // This should occur only if the curve is not closed

        //Yangle[0] = Yangle[1];
        if (!SpineCloses) {
            PriorYangle[0] = PriorYangle[1];
        }

        int NumberOfSpinePoints;
        int NumberOfLids;
        int SpineClosingSegment;
        if (SpineCloses) {
            NumberOfSpinePoints = Spine.length - 1;
            NumberOfLids = 0;
            SpineClosingSegment = 1;
        } else {
            NumberOfSpinePoints = Spine.length;
            NumberOfLids = 2;
            SpineClosingSegment = 0;
        }

        int NumberOfCSPoints;
        int CSClosingFaces;
        if (CrossSectionCloses) {
            NumberOfCSPoints = CrossSection.length - 1;
            CSClosingFaces = 1;
        } else {
            NumberOfCSPoints = CrossSection.length;
            CSClosingFaces = 0;
        }

        int IFSNumberOfFaces = (NumberOfCSPoints - 1 + CSClosingFaces) * 2 * (NumberOfSpinePoints - 1 + SpineClosingSegment) + NumberOfLids * (NumberOfCSPoints-1 + CSClosingFaces);
        int IFSNumberOfPoints = NumberOfCSPoints * NumberOfSpinePoints + NumberOfLids;
        System.out.println("Number of Spine Vertebrae: " + NumberOfSpinePoints);
        System.out.println("Number of CS Points: " + NumberOfCSPoints);
        System.out.println("Number of Points in FaceSet: " + IFSNumberOfPoints);
        System.out.println("Number of Faces in FaceSet: " + IFSNumberOfFaces);
        float Points[][] = new float[IFSNumberOfPoints][3]; //The +2 here and + 2 * CrossSection.length below assume both lids are closed and the spine doesn't loop unto itself
        int Indexes[][] = new int[IFSNumberOfFaces][3];

        for (int i = 0; i < NumberOfSpinePoints; i++) {
            for (int Point = 0; Point < NumberOfCSPoints; Point++) {
                NewPoint = CalculateRotatedPoint(PriorYangle[i], Yangle[i], Zangle[i], CrossSection[Point], Scale[i], Spine[i]);
                Points[i * NumberOfCSPoints + Point][0] = (float) NewPoint[0];
                Points[i * NumberOfCSPoints + Point][1] = (float) NewPoint[1];
                Points[i * NumberOfCSPoints + Point][2] = (float) NewPoint[2];
            }
        }

        for (int i = 0; i < NumberOfSpinePoints - 1; i++) {
            for (int j = 0; j < NumberOfCSPoints - 1; j++) {
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2][0] = i * (NumberOfCSPoints) + j;
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2][1] = i * (NumberOfCSPoints) + j + 1;
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2][2] = (i + 1) * (NumberOfCSPoints) + j;

                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2 + 1][0] = i * (NumberOfCSPoints) + j + 1;
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2 + 1][1] = (i + 1) * (NumberOfCSPoints) + j + 1;
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2 + 1][2] = (i + 1) * (NumberOfCSPoints) + j;
            }
            // replace j with NumberOfCSPoints-1

            if (CrossSectionCloses) {
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2][0] = i * (NumberOfCSPoints) + NumberOfCSPoints - 1;
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2][1] = (i - 1) * (NumberOfCSPoints) + NumberOfCSPoints - 1 + 1;
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2][2] = (i + 1) * (NumberOfCSPoints) + NumberOfCSPoints - 1;

                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2 + 1][0] = ((i - 1) * (NumberOfCSPoints) + NumberOfCSPoints - 1 + 1);
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2 + 1][1] = ((i) * (NumberOfCSPoints) + NumberOfCSPoints - 1 + 1);
                Indexes[i * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2 + 1][2] = (i + 1) * (NumberOfCSPoints) + NumberOfCSPoints - 1;
            }
        }

        if (SpineCloses) {
            for (int j = 0; j < NumberOfCSPoints - 1; j++) {
                System.out.println(((NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2));
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2][0] = (NumberOfSpinePoints - 1) * (NumberOfCSPoints) + j;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2][1] = (NumberOfSpinePoints - 1) * (NumberOfCSPoints) + j + 1;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2][2] = j;

                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2 + 1][0] = (NumberOfSpinePoints - 1) * (NumberOfCSPoints) + j + 1;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2 + 1][1] = j + 1;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + j * 2 + 1][2] = j;
            }
            // replace j with NumberOfCSPoints-1

            if (CrossSectionCloses) {
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2][0] = NumberOfSpinePoints * NumberOfCSPoints - 1;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2][1] = (NumberOfSpinePoints - 1) * NumberOfCSPoints;;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2][2] = NumberOfCSPoints - 1;

                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2 + 1][0] = (NumberOfSpinePoints - 1) * NumberOfCSPoints;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2 + 1][1] = 0;
                Indexes[(NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1 + CSClosingFaces) * (2) + (NumberOfCSPoints - 1) * 2 + 1][2] = NumberOfCSPoints - 1;
            }
        } else {
            //If both lids are closed and the spine doesn't loop. 
            //Add a point at the centre of both ends.
            float CentralPoint1[] = new float[3];
            float CentralPoint2[] = new float[3];

            for (int i = 0; i < NumberOfCSPoints; i++) {
                CentralPoint1[0] = CentralPoint1[0] + Points[i][0] / NumberOfCSPoints;
                CentralPoint1[1] = CentralPoint1[1] + Points[i][1] / NumberOfCSPoints;
                CentralPoint1[2] = CentralPoint1[2] + Points[i][2] / NumberOfCSPoints;

                CentralPoint2[0] = CentralPoint2[0] + Points[(NumberOfSpinePoints - 1) * NumberOfCSPoints + i][0] / NumberOfCSPoints;
                CentralPoint2[1] = CentralPoint2[1] + Points[(NumberOfSpinePoints - 1) * NumberOfCSPoints + i][1] / NumberOfCSPoints;
                CentralPoint2[2] = CentralPoint2[2] + Points[(NumberOfSpinePoints - 1) * NumberOfCSPoints + i][2] / NumberOfCSPoints;
            }
            Points[Points.length - 2][0] = CentralPoint1[0];
            Points[Points.length - 2][1] = CentralPoint1[1];
            Points[Points.length - 2][2] = CentralPoint1[2];
            Points[Points.length - 1][0] = CentralPoint2[0];
            Points[Points.length - 1][1] = CentralPoint2[1];
            Points[Points.length - 1][2] = CentralPoint2[2];

            int NumOfSideFaces = (NumberOfSpinePoints - 1) * (NumberOfCSPoints - 1) * 2;
            if (CrossSectionCloses) {
                NumOfSideFaces += (NumberOfSpinePoints - 1) * 2;
            }
            System.out.println(NumOfSideFaces);
            System.out.println(Indexes.length);
            System.out.println(NumberOfCSPoints);
            for (int i = 0; i < NumberOfCSPoints - 1; i++) {
                //System.out.println(Indexes[NumOfSideFaces + i][0] + " " + Indexes[NumOfSideFaces + i][1] + " " + Indexes[NumOfSideFaces + i][2]);
                Indexes[NumOfSideFaces + i ][0] = i + 1;
                Indexes[NumOfSideFaces + i ][1] = i;
                Indexes[NumOfSideFaces + i ][2] = Points.length - 2;
                Indexes[NumOfSideFaces + NumberOfCSPoints - 1 + i][0] = Points.length - 3 - i - 1;
                Indexes[NumOfSideFaces + NumberOfCSPoints - 1 + i][1] = Points.length - 3 - i;
                Indexes[NumOfSideFaces + NumberOfCSPoints - 1 + i][2] = Points.length - 1;
            }
            if (CrossSectionCloses){
                Indexes[Indexes.length-2][0]=0;
                Indexes[Indexes.length-2][1]=NumberOfCSPoints-1;
                Indexes[Indexes.length-2][2]=Points.length - 2;
                
                Indexes[Indexes.length-1][0]=Points.length - 3;
                Indexes[Indexes.length-1][1]=Points.length - NumberOfCSPoints-2;
                Indexes[Indexes.length-1][2]=Points.length - 1;
            }
        }
        float MaxXYZ[] = new float[3];
        float MinXYZ[] = new float[3];

        for (int j = 0; j < 3; j++) {
            MaxXYZ[j] = -Float.MAX_VALUE;
            MinXYZ[j] = Float.MAX_VALUE;
            for (int i = 0; i < Points.length; i++) {
                if (MaxXYZ[j] < Points[i][j]) {
                    MaxXYZ[j] = Points[i][j];
                }
                if (MinXYZ[j] > Points[i][j]) {
                    MinXYZ[j] = Points[i][j];
                }
            }
        }
        /*
         for (int i = 0; i < Spine.length; i++) {
         for (int j = 0; j < CrossSection.length; j++) {
         }
         }

         for (int i = 0; i < Spine.length - 1; i++) {
         for (int j = 0; j < CrossSection.length - 1; j++) {
         }
         }
         */
        float BBoxSize[] = new float[3];
        BBoxSize[0] = MaxXYZ[0] - MinXYZ[0];
        BBoxSize[1] = MaxXYZ[1] - MinXYZ[1];
        BBoxSize[2] = MaxXYZ[2] - MinXYZ[2];

        float BBoxCenter[] = new float[3];
        BBoxCenter[0] = (MaxXYZ[0] + MinXYZ[0]) / 2;
        BBoxCenter[1] = (MaxXYZ[1] + MinXYZ[1]) / 2;
        BBoxCenter[2] = (MaxXYZ[2] + MinXYZ[2]) / 2;

        StringWriter PointWriter = new StringWriter();
        StringWriter IndexWriter = new StringWriter();

        for (float[] Point : Points) {
            PointWriter.write(Point[0] + " " + Point[1] + " " + Point[2] + " ");
        }
        for (int[] Indexe : Indexes) {
            IndexWriter.write(Indexe[0] + " " + Indexe[1] + " " + Indexe[2] + " -1 ");
        }
        System.out.println();
        System.out.println("<X3D> \n <Scene> \n "
                //                + "<Transform translation=\"0 2 10\" center=\"0 0 -10\" rotation=\"0 1 0 1.57\">\n"
                //               + "<Viewpoint position=\"0 0 0\"/>\n </Transform> \n"
                + "<Shape> \n <IndexedFaceSet solid=\"true\" coordIndex=\"" + IndexWriter.toString() + "\" > \n <Coordinate point=\"" + PointWriter.toString() + "\"/> \n </IndexedFaceSet> \n <Appearance><Material/></Appearance> \n </Shape> \n </Scene> \n </X3D>");

        String ShapeIndex = ShapeIndexExtraction.PerformActualComputation(Points, Indexes);
        String FinalOutput = String.valueOf(BBoxSize[0]) + " " + String.valueOf(BBoxSize[1]) + " " + String.valueOf(BBoxSize[2]) + " " + String.valueOf(BBoxCenter[0]) + " " + String.valueOf(BBoxCenter[1]) + " " + String.valueOf(BBoxCenter[2]) + "&" + ShapeIndex;

        System.out.println(ShapeIndex);

        String[] argsb = new String[2];
        argsb[0] = "Faces.txt";
        argsb[1] = "Points.txt";
        //String ShapeIndexb = ShapeIndexExtraction.shapeIndexEctraction(argsb);
        System.out.print(Indexes.length);
        //System.out.println(ShapeIndexb);
        return FinalOutput;
    }

    static double[] CalculateRotatedPoint(double PriorYangle, double Yangle, double Zangle, double[] CrossSection, double[] Scale, double[] Spine) {
        double NewPoint[] = new double[3];

        double ScaledCrossSection[] = new double[2];
        double PartiallyRotatedPoints[] = new double[3];
        double OrientedForNewZ[] = new double[2];

        //First scale points
        ScaledCrossSection[0] = CrossSection[0] * Scale[0];
        ScaledCrossSection[1] = CrossSection[1] * Scale[1];

        //First rotate around Y to make sure the Z plane will be oriented with the vector cross-product
        OrientedForNewZ[0] = ScaledCrossSection[0] * Math.cos(PriorYangle) + ScaledCrossSection[1] * Math.sin(PriorYangle);
        OrientedForNewZ[1] = -ScaledCrossSection[0] * Math.sin(PriorYangle) + ScaledCrossSection[1] * Math.cos(PriorYangle); //ScaledCrossSection[1];

        //Rotate around Z
        PartiallyRotatedPoints[0] = OrientedForNewZ[0] * Math.cos(Zangle);
        PartiallyRotatedPoints[1] = -OrientedForNewZ[0] * Math.sin(Zangle);
        PartiallyRotatedPoints[2] = OrientedForNewZ[1];

        //Rotate around Y
        NewPoint[0] = (float) (PartiallyRotatedPoints[0] * Math.cos(Yangle) + PartiallyRotatedPoints[2] * Math.sin(Yangle));
        NewPoint[1] = (float) (PartiallyRotatedPoints[1]);
        NewPoint[2] = (float) (-PartiallyRotatedPoints[0] * Math.sin(Yangle) + PartiallyRotatedPoints[2] * Math.cos(Yangle));

        //Finally translate
        NewPoint[0] += Spine[0];
        NewPoint[1] += Spine[1];
        NewPoint[2] += Spine[2];

        return NewPoint;
    }
}
