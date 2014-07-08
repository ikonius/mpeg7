package org.exist.xquery.modules.mpeg7.x3d.textures.SURFManager;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import net.sf.javaml.clustering.Clusterer;
import net.sf.javaml.clustering.KMeans;
import net.sf.javaml.core.Dataset;
import net.sf.javaml.core.DefaultDataset;
import net.sf.javaml.core.DenseInstance;
import net.sf.javaml.core.Instance;
import net.sf.javaml.distance.DistanceMeasure;
import net.sf.javaml.distance.EuclideanDistance;
import net.sf.javaml.tools.data.FileHandler;
import org.apache.log4j.Logger;

/**
 *
 * @author Markos | Patti Spala <pd.spala@gmail.com>
 */
public class BuildSURFVocabularies {

    private static final Logger logger = Logger.getLogger(BuildSURFVocabularies.class);

    public static void main(String args[]) {
        int VocabSize = 128;

        DirectoryStream<Path> FileList = PlainFileListing("D:\\SymformFromOffice\\Research\\iPromotion-X3D\\MPEG-7 2.0\\SURFDatabase\\Data\\ImageCollection");
        Dataset EntireDataset = new DefaultDataset();
        Dataset ImageSURF;
        SURFOperations Extractor = new SURFOperations();

        
        File ForSizeEval;
        Double[] tmpVals = new Double[64];
        double[] tmpVals2 = new double[64];

        for (Path file : FileList) {
            try {
                System.out.println(file.toString());
                ForSizeEval = new File(file.toString());
                // Skip files larger than 5MB for memory considerations
                if (ForSizeEval.length() <= 5 * Math.pow(2, 20)) {
                    ImageSURF = Extractor.extractFromFile(file.toString());
                    for (int kkk = 0; kkk < ImageSURF.size(); kkk++) {
                        tmpVals = ImageSURF.get(kkk).values().toArray(tmpVals);
                        for (int lll = 0; lll < tmpVals.length; lll++) {
                            tmpVals2[lll] = tmpVals[lll];
                        }
                        ImageSURF.set(kkk, new DenseInstance(tmpVals2));
                    }
                    EntireDataset.addAll(ImageSURF);
                } else {
                    System.out.println("Too big");
                }
            } catch (Exception e) {
                System.out.println("***************************************************************");
            }
        }

        try {
            FileHandler.exportDataset(EntireDataset, new File("D:\\EntireDataset.iData"));
        } catch (Exception e) {
            System.out.println("FailedToStore");
            System.out.println(e.toString());
        }
        
        try {
            EntireDataset = FileHandler.loadDataset(new File("D:\\EntireDataset.iData"));
        } catch (IOException ex) {
            logger.error(ex);
        }

        Instance[] Vocabulary = OrganizeVocab(EntireDataset, VocabSize);

        Dataset VocabToStore = new DefaultDataset();
        for (Instance Vocabulary1 : Vocabulary) {
            VocabToStore.add(Vocabulary1);
        }
        try {
            FileHandler.exportDataset(VocabToStore, new File("http://54.72.206.163/exist/3dData/Vocabularies/SURF/Vocab" + String.valueOf(VocabSize) + ".iVocab"));
        } catch (IOException ex) {
          logger.error(ex);
        }

    }

    public static DirectoryStream<Path> PlainFileListing(String PathStr) {
        DirectoryStream<Path> stream = null;
        Path dir = Paths.get(PathStr);
        try {
            stream = Files.newDirectoryStream(dir);
            return (stream);
        } catch (IOException ex) {
            // IOException can never be thrown by the iteration.
            // In this snippet, it can only be thrown by newDirectoryStream.
            logger.error(ex);
            return stream;
        }
    }

    public static Instance[] OrganizeVocab(Dataset data, int numberOfClusters) {

        int subSampleSize = 200000;
        int numberOfIterations = 500;
        DistanceMeasure dm = new EuclideanDistance();
        int FeatureLength = data.get(0).values().size();

        //System.out.println("Total " + String.valueOf(data.size()) + " points of length " + String.valueOf(FeatureLength));
        Integer[] IndexesArray = new Integer[data.size()];
        for (int ii = 0; ii < data.size(); ii++) {
            IndexesArray[ii] = ii;
        }
        ArrayList<Integer> IndexesList = new ArrayList<Integer>(Arrays.asList(IndexesArray));
        java.util.Collections.shuffle(IndexesList);

        Dataset subData = new DefaultDataset();

        for (int ii = 0; ii < subSampleSize; ii++) {
            subData.add(data.get(IndexesList.get(ii)));
            //subData.add(data.get(ii));
        }
        //System.out.println("Kept " + String.valueOf(subData.size()) + " points of length " + String.valueOf(FeatureLength));

        try {
            FileHandler.exportDataset(subData, new File("D:\\subDataset.iData"));
        } catch (IOException ex) {
            logger.error(ex);
        }

        Clusterer km = new KMeans(numberOfClusters, numberOfIterations, dm);
        Dataset[] clusters = km.cluster(subData);        

        //Calculate cluster centroids
        Instance[] centroids = new Instance[numberOfClusters];

        double[][] sumPosition = new double[numberOfClusters][FeatureLength];
        int[] countPosition = new int[numberOfClusters];
       // System.out.println(String.valueOf(clusters.length) + " clusters. Membership count:");
        for (int ClusterID = 0; ClusterID < numberOfClusters; ClusterID++) {
            //System.out.println(clusters[ClusterID].size());
            for (int i = 0; i < clusters[ClusterID].size(); i++) {
                Instance in = clusters[ClusterID].instance(i);
                for (int j = 0; j < FeatureLength; j++) {
                    sumPosition[ClusterID][j] += in.value(j);
                }
                countPosition[ClusterID]++;
            }
            if (countPosition[ClusterID] > 0) {
                double[] tmp = new double[FeatureLength];
                for (int j = 0; j < FeatureLength; j++) {
                    tmp[j] = (float) sumPosition[ClusterID][j] / countPosition[ClusterID];
                }
                centroids[ClusterID] = new DenseInstance(tmp);
            }
        }
        return centroids;
    }
}
