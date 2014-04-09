package org.exist.xquery.modules.mpeg7.x3d.geometries;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class IFSDetector extends GeometryDetector {

    private static final Logger logger = Logger.getLogger("app.annotation");

    public IFSDetector(Document doc) {
        super(doc);
        
    }
    
    @Override
    public void processShapes() {
        String[] tokenizedCoord = null;
        String[] tokenizedPoint = null;
        
        List totalPointParts = null;
        ArrayList<String> resultedIFSExtractionList = new ArrayList<String>();
        StringBuilder IFSStringBuilder = new StringBuilder();
        try {
            //getDoc().getDocumentElement().normalize();
            XPath xPath = XPathFactory.newInstance().newXPath();
            NodeList ifsSet = (NodeList) xPath.evaluate("//Shape/IndexedFaceSet", getDoc().getDocumentElement(), XPathConstants.NODESET);
            for (int p = 0; p < ifsSet.getLength(); p++) {
                Element elem = (Element) ifsSet.item(p);
                HashMap<String, String[]> coordDictParams = new HashMap<String, String[]>();
                HashMap<String, String[]> pointDictParams = new HashMap<String, String[]>();
                
                String coordIndexAttrib = elem.getAttribute("coordIndex");
                
                int lastMinusOnePosition = coordIndexAttrib.lastIndexOf("-1");
                String stringWithoutLastMinusOne = coordIndexAttrib.substring(0, lastMinusOnePosition);
                tokenizedCoord = stringWithoutLastMinusOne.split(" -1 ");
                
                Element coordElem = (Element) elem.getElementsByTagName("Coordinate").item(0);
                String pointAttrib = coordElem.getAttribute("point");
                tokenizedPoint = pointAttrib.split(" ");
                totalPointParts = new ArrayList();
                
                if (tokenizedPoint.length > 2) {
                    
                    for (int i = 0; i < tokenizedPoint.length; i = i + 3) {
                        String pointPart = tokenizedPoint[i].concat(" " + tokenizedPoint[i + 1] + " " + tokenizedPoint[i + 2]);
                        totalPointParts.add(pointPart);
                    }
                    
                } else {
                    //Unique case: an IndexedFaceSet without points (authoring error!)
                    totalPointParts.add("0 0 0");
                    totalPointParts.add("0.0000001 0 0");
                    totalPointParts.add("0 0.0000001 0");
                    tokenizedCoord = new String[1];
                    tokenizedCoord[0] = "0 1 2";
                }
                coordDictParams.put("coordIndex", tokenizedCoord);
                pointDictParams.put("points", (String[]) totalPointParts.toArray(new String[0]));
                //String coordTempFile = writeCoordIndexToFile(tokenizedCoord, file, bw);
                //String pointTempFile = writePointToFile(totalPointParts, file, bw);
                String coordTempFile = writeParamsToFile(coordDictParams, new File("coordIndex.txt"), getWriter());
                String pointTempFile = writeParamsToFile(pointDictParams, new File("point.txt"), getWriter());
                String[] tempFiles = {coordTempFile, pointTempFile};
                String resultedExtraction = ShapeIndexExtraction.shapeIndexEctraction(tempFiles);
                resultedIFSExtractionList.add(resultedExtraction);
            }
            for (int i = 0; i < resultedIFSExtractionList.size(); i++) {
                IFSStringBuilder.append(resultedIFSExtractionList.get(i));
                IFSStringBuilder.append("#");
            }
            getParamMap().put("pointsExtraction", IFSStringBuilder.toString());
        } catch (IOException e) {
            logger.error(e);
        } catch (XPathExpressionException e) {
            logger.error(e);
        }
    }
    
    @Override
    public String writeParamsToFile(HashMap<String, String[]> dictMap, File file, BufferedWriter writer) {
        try {
            // if file doesnt exists, then create it
            if (file.exists()) {
                file.delete();
            }
            file.createNewFile();
            setWriter(new BufferedWriter(new FileWriter(file)));
            
            Set set = dictMap.entrySet();
            Iterator i = set.iterator();
            while (i.hasNext()) {
                Map.Entry me = (Map.Entry) i.next();
                for (String data : (String[]) me.getValue()) {
                    getWriter().write(data);
                    getWriter().newLine();
                }                
            }
            getWriter().close();
        } catch (IOException e) {
            logger.error(e);
        }
        return file.getAbsolutePath();
    }
    
}
