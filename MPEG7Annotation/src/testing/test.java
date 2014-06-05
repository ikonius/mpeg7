/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testing;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import javax.imageio.ImageIO;
import javax.xml.transform.TransformerException;
import org.apache.commons.lang3.StringUtils;
import org.apache.lucene.analysis.core.WhitespaceAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.FSDirectory;
import org.exist.xquery.modules.mpeg7.net.semanticmetadata.lire.DocumentBuilder;
import org.exist.xquery.modules.mpeg7.net.semanticmetadata.lire.DocumentBuilderFactory;
import org.exist.xquery.modules.mpeg7.net.semanticmetadata.lire.utils.FileUtils;
import org.exist.xquery.modules.mpeg7.net.semanticmetadata.lire.utils.LuceneUtils;
import org.exist.xquery.modules.mpeg7.x3d.colors.ScalableColorImpl;
import org.exist.xquery.modules.mpeg7.x3d.textures.EdgeHistogramImplementation;
import org.exist.xquery.modules.mpeg7.x3d.filters.ExtrusionToIFSFilter;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class test {

    public static void main(String[] args) throws IOException, TransformerException {
        String temp="0 1 2 -1 3 4 1 -1 5 3 6 -1 0 7 8 -1 9 10 11 -1 12 13 14 -1 8 15 16 -1 17 18 19 -1 20 21 22 -1 23 24 25 -1 26 27 28 -1 5 4 3 -1 29 3 30 -1 31 32 33 -1 15 34 16 -1 12 35 36 -1 37 23 38 -1 17 39 18 -1 33 40 41 -1 17 42 39 -1 43 9 25 -1 14 37 38 -1 24 43 25 -1 44 45 39 -1 44 39 46 -1 20 47 21 -1 48 49 47 -1 30 0 50 -1 46 31 10 -1 10 31 11 -1 51 52 25 -1 15 53 34 -1 54 13 36 -1 52 35 55 -1 23 25 55 -1 23 55 38 -1 25 52 55 -1 42 56 57 -1 21 47 42 -1 9 51 25 -1 58 11 33 -1 21 17 19 -1 18 39 45 -1 48 47 20 -1 42 47 49 -1 22 21 19 -1 17 21 42 -1 42 57 31 -1 48 29 49 -1 6 3 59 -1 49 60 56 -1 55 35 38 -1 38 35 12 -1 43 61 9 -1 39 42 46 -1 61 10 9 -1 49 29 60 -1 30 3 0 -1 62 63 50 -1 63 30 50 -1 30 63 64 -1 65 66 60 -1 30 64 60 -1 66 65 57 -1 66 56 60 -1 66 57 56 -1 57 64 62 -1 42 49 56 -1 31 33 11 -1 32 40 33 -1 67 36 26 -1 35 26 36 -1 35 68 26 -1 69 70 71 -1 54 36 67 -1 40 50 72 -1 3 1 0 -1 73 7 74 -1 0 2 7 -1 51 9 75 -1 58 76 11 -1 52 77 78 -1 58 33 79 -1 75 9 11 -1 78 58 79 -1 80 81 28 -1 26 8 16 -1 73 15 8 -1 7 73 8 -1 82 44 61 -1 44 46 61 -1 42 31 46 -1 62 50 40 -1 40 83 41 -1 72 0 8 -1 50 0 72 -1 68 8 26 -1 83 8 68 -1 77 84 78 -1 84 58 78 -1 73 53 15 -1 52 78 79 -1 35 79 41 -1 85 74 86 -1 87 88 89 -1 87 5 6 -1 88 90 85 -1 91 92 93 -1 94 95 14 -1 90 96 97 -1 19 18 98 -1 20 22 99 -1 100 24 23 -1 101 102 96 -1 103 5 87 -1 104 105 106 -1 107 108 109 -1 97 96 34 -1 110 13 54 -1 95 23 37 -1 98 18 111 -1 108 112 109 -1 98 111 113 -1 100 114 24 -1 95 37 14 -1 114 115 24 -1 111 45 44 -1 116 111 44 -1 117 20 99 -1 118 48 117 -1 105 119 88 -1 116 92 120 -1 92 91 120 -1 121 100 122 -1 97 34 53 -1 110 94 13 -1 122 123 124 -1 123 100 23 -1 95 123 23 -1 100 123 122 -1 113 120 125 -1 99 113 117 -1 93 100 121 -1 108 91 126 -1 22 19 99 -1 18 45 111 -1 117 48 20 -1 113 118 117 -1 99 19 98 -1 98 113 99 -1 113 125 127 -1 106 59 48 -1 87 6 59 -1 118 127 104 -1 123 95 124 -1 94 14 13 -1 114 82 115 -1 111 116 113 -1 93 128 114 -1 106 105 87 -1 105 88 87 -1 125 129 130 -1 131 119 105 -1 130 131 105 -1 130 104 132 -1 130 105 104 -1 132 125 130 -1 104 127 133 -1 133 127 125 -1 130 129 131 -1 113 127 118 -1 120 91 108 -1 125 109 129 -1 101 134 135 -1 112 124 136 -1 124 110 101 -1 96 137 34 -1 138 139 70 -1 134 69 135 -1 109 140 119 -1 87 89 103 -1 85 73 74 -1 88 86 89 -1 141 91 93 -1 126 91 142 -1 143 121 122 -1 112 108 144 -1 91 141 142 -1 135 81 80 -1 101 96 90 -1 73 90 97 -1 85 90 73 -1 116 44 128 -1 116 128 92 -1 113 116 120 -1 120 108 107 -1 136 124 101 -1 140 90 88 -1 119 140 88 -1 109 145 140 -1 145 90 140 -1 142 141 146 -1 126 142 146 -1 73 97 53 -1 112 144 124 -1 144 122 124 -1 106 87 59 -1 59 29 48 -1 60 29 30 -1 59 3 29 -1 118 104 106 -1 118 106 48 -1 135 69 81 -1 81 69 28 -1 147 70 139 -1 71 26 28 -1 110 54 148 -1 101 110 148 -1 147 139 67 -1 148 54 139 -1 101 148 138 -1 138 148 139 -1 139 54 67 -1 26 147 67 -1 69 71 28 -1 134 70 69 -1 138 70 134 -1 101 138 134 -1 26 71 147 -1 147 71 70 -1 135 80 102 -1 80 28 27 -1 144 126 149 -1 108 126 144 -1 144 149 122 -1 52 79 35 -1 79 33 41 -1 128 82 114 -1 93 114 100 -1 115 82 43 -1 24 115 43 -1 128 44 82 -1 92 128 93 -1 61 46 10 -1 82 61 43 -1 101 135 102 -1 137 150 27 -1 27 150 80 -1 137 27 16 -1 27 26 16 -1 150 102 80 -1 102 150 137 -1 96 102 137 -1 34 137 16 -1 129 119 131 -1 129 109 119 -1 64 63 62 -1 57 62 40 -1 88 85 86 -1 74 7 2 -1 126 146 149 -1 149 143 122 -1 84 76 58 -1 151 75 84 -1 133 125 132 -1 132 104 133 -1 65 64 57 -1 60 64 65 -1 141 121 152 -1 121 141 93 -1 75 76 84 -1 75 11 76 -1 146 141 152 -1 149 146 143 -1 51 75 151 -1 51 77 52 -1 146 152 143 -1 143 152 121 -1 51 151 77 -1 151 84 77 -1 120 107 125 -1 125 107 109 -1 57 40 32 -1 31 57 32 -1 112 136 145 -1 109 112 145 -1 145 136 90 -1 136 101 90 -1 83 72 8 -1 40 72 83 -1 41 83 68 -1 35 41 68 -1 95 94 124 -1 124 94 110 -1 12 14 38 -1 13 12 36 -1' creaseAngle='2.094' texCoordIndex='0 1 2 -1 3 4 5 -1 6 3 7 -1 0 8 9 -1 10 11 12 -1 13 14 15 -1 9 16 17 -1 18 19 20 -1 21 22 23 -1 24 25 26 -1 27 28 29 -1 6 4 3 -1 30 3 31 -1 32 33 34 -1 16 35 17 -1 13 36 37 -1 38 24 39 -1 18 40 19 -1 34 41 42 -1 18 43 40 -1 44 10 26 -1 15 38 39 -1 25 44 26 -1 45 46 40 -1 45 40 47 -1 21 48 22 -1 49 50 48 -1 31 51 52 -1 47 32 11 -1 11 32 12 -1 53 54 26 -1 16 55 35 -1 56 14 37 -1 54 36 57 -1 24 26 57 -1 24 57 39 -1 26 54 57 -1 58 59 60 -1 22 48 58 -1 10 53 26 -1 61 12 34 -1 22 18 20 -1 19 40 46 -1 49 48 21 -1 58 48 50 -1 23 22 20 -1 18 22 58 -1 43 62 32 -1 49 30 50 -1 7 3 63 -1 50 64 59 -1 57 36 39 -1 39 36 13 -1 44 65 10 -1 40 43 47 -1 65 11 10 -1 50 30 64 -1 31 3 51 -1 66 67 68 -1 69 31 52 -1 31 69 70 -1 71 72 64 -1 31 70 64 -1 73 74 75 -1 72 59 64 -1 72 60 59 -1 75 76 66 -1 58 50 59 -1 32 34 12 -1 33 41 34 -1 77 37 27 -1 36 27 37 -1 36 78 27 -1 79 80 81 -1 56 37 77 -1 41 82 83 -1 3 5 51 -1 84 8 85 -1 0 2 8 -1 53 10 86 -1 61 87 12 -1 54 88 89 -1 61 34 90 -1 86 10 12 -1 89 61 90 -1 91 92 29 -1 27 9 17 -1 84 16 9 -1 8 84 9 -1 93 45 65 -1 45 47 65 -1 43 32 47 -1 94 82 41 -1 41 95 42 -1 83 0 9 -1 52 51 96 -1 78 9 27 -1 95 9 78 -1 88 97 89 -1 97 61 89 -1 84 55 16 -1 54 89 90 -1 36 90 42 -1 98 85 99 -1 100 101 102 -1 100 6 7 -1 103 104 98 -1 105 106 107 -1 108 109 15 -1 104 110 111 -1 20 19 112 -1 21 23 113 -1 114 25 24 -1 115 116 110 -1 117 6 100 -1 118 119 120 -1 121 122 123 -1 111 110 35 -1 124 14 56 -1 109 24 38 -1 112 19 125 -1 122 126 123 -1 112 125 127 -1 114 128 25 -1 109 38 15 -1 128 129 25 -1 125 46 45 -1 130 125 45 -1 131 21 113 -1 132 49 131 -1 119 133 101 -1 130 106 134 -1 106 105 134 -1 135 114 136 -1 111 35 55 -1 124 108 14 -1 136 137 138 -1 137 114 24 -1 109 137 24 -1 114 137 136 -1 127 134 139 -1 113 140 131 -1 107 114 135 -1 122 105 141 -1 23 20 113 -1 19 46 125 -1 131 49 21 -1 140 132 131 -1 113 20 112 -1 112 140 113 -1 140 142 143 -1 120 63 49 -1 100 7 63 -1 132 143 118 -1 137 109 138 -1 108 15 14 -1 128 93 129 -1 125 130 127 -1 107 144 128 -1 120 119 100 -1 119 101 100 -1 145 146 147 -1 148 133 119 -1 149 148 119 -1 149 118 150 -1 149 119 118 -1 151 145 147 -1 118 143 152 -1 152 143 142 -1 147 146 153 -1 140 143 132 -1 134 105 122 -1 139 123 154 -1 115 155 156 -1 126 138 157 -1 138 124 115 -1 110 158 35 -1 159 160 80 -1 155 79 156 -1 123 161 162 -1 100 102 117 -1 98 84 85 -1 103 99 163 -1 164 105 107 -1 141 105 165 -1 166 135 136 -1 126 122 167 -1 105 164 165 -1 156 92 91 -1 115 110 104 -1 84 104 111 -1 98 104 84 -1 130 45 144 -1 130 144 106 -1 127 130 134 -1 134 122 121 -1 157 138 115 -1 161 104 103 -1 133 168 101 -1 123 169 161 -1 169 104 161 -1 165 164 170 -1 141 165 170 -1 84 111 55 -1 126 167 138 -1 167 136 138 -1 120 100 63 -1 63 30 49 -1 64 30 31 -1 63 3 30 -1 132 118 120 -1 132 120 49 -1 156 79 92 -1 92 79 29 -1 171 80 160 -1 81 27 29 -1 124 56 172 -1 115 124 172 -1 171 160 77 -1 172 56 160 -1 115 172 159 -1 159 172 160 -1 160 56 77 -1 27 171 77 -1 79 81 29 -1 155 80 79 -1 159 80 155 -1 115 159 155 -1 27 81 171 -1 171 81 80 -1 156 91 116 -1 91 29 28 -1 167 141 173 -1 122 141 167 -1 167 173 136 -1 54 90 36 -1 90 34 42 -1 144 93 128 -1 107 128 114 -1 129 93 44 -1 25 129 44 -1 144 45 93 -1 106 144 107 -1 65 47 11 -1 93 65 44 -1 115 156 116 -1 158 174 28 -1 28 174 91 -1 158 28 17 -1 28 27 17 -1 174 116 91 -1 116 174 158 -1 110 116 158 -1 35 158 17 -1 146 175 153 -1 154 123 162 -1 76 67 66 -1 62 94 41 -1 103 98 99 -1 85 8 2 -1 141 170 173 -1 173 166 136 -1 97 87 61 -1 176 86 97 -1 177 145 151 -1 150 118 152 -1 74 76 75 -1 64 70 71 -1 164 135 178 -1 135 164 107 -1 86 87 97 -1 86 12 87 -1 170 164 178 -1 173 170 166 -1 53 86 176 -1 53 88 54 -1 170 178 166 -1 166 178 135 -1 53 176 88 -1 176 97 88 -1 134 121 139 -1 139 121 123 -1 62 41 33 -1 32 62 33 -1 126 157 169 -1 123 126 169 -1 169 157 104 -1 157 115 104 -1 95 83 9 -1 41 83 95 -1 42 95 78 -1 36 42 78 -1 109 108 138 -1 138 108 124 -1 13 15 39 -1 14 13 37 -1";
        String delimiter = "-1";
        getLength(temp, delimiter);        
        //testColorDescriptor();
        //testIndexer(new String[]{"."});
        //testExtrusion();        
        //testURIResolver();
        //testIFSExtraction();
    }

    private static void testIndexer(String[] args) throws IOException{
    // Checking if arg[0] is there and if it is a directory.
        boolean passed = false;
        if (args.length > 0) {
            File f = new File(args[0]);
            System.out.println("Indexing images in " + args[0]);
            if (f.exists() && f.isDirectory()) passed = true;
        }
        if (!passed) {
            System.out.println("No directory given as first argument.");
            System.out.println("Run \"Indexer <directory>\" to index files of a directory.");
            System.exit(1);
        }
        // Getting all images from a directory and its sub directories.
        ArrayList<String> images = FileUtils.getAllImages(new File(args[0]), true);
 
        // Creating a CEDD document builder and indexing al files.
        DocumentBuilder builder = DocumentBuilderFactory.getCEDDDocumentBuilder();
        // Creating an Lucene IndexWriter
        IndexWriterConfig conf = new IndexWriterConfig(LuceneUtils.LUCENE_VERSION,
                new WhitespaceAnalyzer(LuceneUtils.LUCENE_VERSION));
        IndexWriter iw = new IndexWriter(FSDirectory.open(new File("index")), conf);
        // Iterating through images building the low level features
        for (Iterator<String> it = images.iterator(); it.hasNext(); ) {
            String imageFilePath = it.next();
            System.out.println("Indexing " + imageFilePath);
            try {
                BufferedImage img = ImageIO.read(new FileInputStream(imageFilePath));
                Document document = builder.createDocument(img, imageFilePath);
                iw.addDocument(document);
            } catch (Exception e) {
                System.err.println("Error reading image or indexing it.");
                e.printStackTrace();
            }
        }
        // closing the IndexWriter
        iw.close();
        System.out.println("Finished indexing.");
    }
    private static void testColorDescriptor() throws FileNotFoundException, IOException{
        String imageFilePath = "image2.jpg";
        BufferedImage img = ImageIO.read(new FileInputStream(imageFilePath));
        //EHD
        EdgeHistogramImplementation ehdi = new EdgeHistogramImplementation(img);
        String ehdiOut = ehdi.getStringRepresentation();
        System.out.println("EHD: " + ehdiOut);
        String[] ehdiBitsCount = ehdiOut.split(" ");
        System.out.println("numOfBits: " +ehdiBitsCount.length);
        //SCD
//        int[] pixels = {2, 4, 3};
//        ScalableColorImpl scdi = new ScalableColorImpl(pixels);
//        scdi.extract(img);
        ScalableColorImpl scdi = new ScalableColorImpl(img);
        String scdiOut = scdi.getStringRepresentation();
        System.out.println("SCD: " + scdiOut);
        String[] output = scdiOut.split(";")[3].split(" ");
        for (int i=0;i<output.length;i++){
            System.out.println(output[i]);
        }
        System.out.println(scdiOut.substring(scdiOut.indexOf(";") + 1, scdiOut.length()));
        String[] scdiOutBits = scdiOut.split(" ");
        System.out.println("numOfBits: " +scdiOutBits.length);
        
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

    private static void testExtrusion() {
        String command[] = new String[1];
        command[0] = "Extrusion5.txt";
        try {
            ArrayList<String> resultedExtrExtractionList = new ArrayList<String>();
            ArrayList<String> resultedExtrBBoxList = new ArrayList<String>();
            StringBuilder ExtrShapeStringBuilder = new StringBuilder();
            StringBuilder ExtrBBoxStringBuilder = new StringBuilder();
            String resultedExtraction = new ExtrusionToIFSFilter(command).filterGeometry();
            String ExtrBBox = resultedExtraction.substring(0, resultedExtraction.indexOf("&"));
            String ExtrShape = resultedExtraction.substring(resultedExtraction.indexOf("&") + 1);

            resultedExtrBBoxList.add(ExtrBBox);
            resultedExtrExtractionList.add(ExtrShape);

            for (int i = 0; i < resultedExtrExtractionList.size(); i++) {
                ExtrShapeStringBuilder.append(resultedExtrExtractionList.get(i));
                ExtrShapeStringBuilder.append("#");

                ExtrBBoxStringBuilder.append(resultedExtrBBoxList.get(i));
                ExtrBBoxStringBuilder.append("#");

            }
//            System.out.println("ExtrShape:" + ExtrShape);
//
//            System.out.println("ExtrShapeStringBuilder: " + ExtrShapeStringBuilder.toString());
//            System.out.println("ExtrBBox: " + ExtrBBox);
//            System.out.println("ExtrBBoxStringBuilder:" + ExtrBBoxStringBuilder.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private static void testURIResolver() {
        String pt = "../HelloWorld.x3d";
        String bp = "/db/3dData/x3d/X3DForWebAuthors/Chapter13-Grouping";
        System.out.println(resolveExistUri(bp, pt));
    }

    private static void testIFSExtraction() {
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

    private static void getLength(String temp, String delim) {       
        System.out.println(temp.split(delim).length);
    }
}
