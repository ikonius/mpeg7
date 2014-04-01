package x3d.geometries;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class ExtrusionDetector extends GeometryDetector {

    public ExtrusionDetector(Document doc) {
        super(doc);
    }

    @Override
    public void processShapes() {
        String crossSectionAttrib, spineAttrib, scaleAttrib, orientAttrib;
        ArrayList<String> resultedExtrExtractionList = new ArrayList<>();
        ArrayList<String> resultedExtrBBoxList = new ArrayList<>();
        StringBuilder ExtrShapeStringBuilder = new StringBuilder();
        StringBuilder ExtrBBoxStringBuilder = new StringBuilder();

        try {
            getDoc().getDocumentElement().normalize();
            XPath xPath = XPathFactory.newInstance().newXPath();
            // NodeList shpList = getDoc().getElementsByTagName("Shape");
            NodeList extrSet = (NodeList) xPath.evaluate("//Shape/Extrusion", getDoc().getDocumentElement(), XPathConstants.NODESET);

            for (int i = 0; i < extrSet.getLength(); i++) {
                Element elem = (Element) extrSet.item(i);
                HashMap<String, String[]> dictParams = new HashMap<>();
                scaleAttrib = null;
                orientAttrib = null;

                crossSectionAttrib = elem.getAttribute("crossSection");
                spineAttrib = elem.getAttribute("spine");
                dictParams.put("crossSection", new String[]{crossSectionAttrib});
                dictParams.put("spine", new String[]{spineAttrib});
                if (elem.getAttribute("scale") != null) {
                    scaleAttrib = elem.getAttribute("scale");
                    dictParams.put("scale", new String[]{scaleAttrib});
                }
                if (elem.getAttribute("spine") != null) {
                    orientAttrib = elem.getAttribute("orientation");
                    dictParams.put("orientation", new String[]{orientAttrib});
                }
                setFile(new File("Extrusion.txt"));

                String coordTempFile = writeParamsToFile(dictParams,getFile(), getWriter());
                //String coordTempFile = writeExtrusionParamsToFile(crossSectionAttrib, spineAttrib, scaleAttrib, orientAttrib, file, bw);

                String[] ExtrTempFile = {coordTempFile};
                String resultedExtraction = ExtrusionDescription.ExtrusionDescription(ExtrTempFile);
                getFile().delete();

                String ExtrBBox = resultedExtraction.substring(0, resultedExtraction.indexOf("&") - 1);
                String ExtrShape = resultedExtraction.substring(resultedExtraction.indexOf("&") + 1);

                resultedExtrBBoxList.add(ExtrBBox);
                resultedExtrExtractionList.add(ExtrShape);

            }
            for (int i = 0; i < resultedExtrExtractionList.size(); i++) {
                ExtrShapeStringBuilder.append(resultedExtrExtractionList.get(i));
                ExtrShapeStringBuilder.append("#");

                ExtrBBoxStringBuilder.append(resultedExtrBBoxList.get(i));
                ExtrBBoxStringBuilder.append("#");

            }
        } catch (IOException | XPathExpressionException e) {
            Logger.getLogger(ExtrusionDetector.class.getName()).log(Level.SEVERE, null, e);
        }

    }

    @Override
    public String writeParamsToFile(HashMap<String, String[]> dictMap, File file, BufferedWriter get) {
        try {
            // if file doesnt exists, then create it
            if (file.exists()) {
                file.delete();
            }
            file.createNewFile();
            setWriter(new BufferedWriter(new FileWriter(file)));
            
            Set set = dictMap.entrySet();
            Iterator i = set.iterator();
            while(i.hasNext()){
                Map.Entry me = (Map.Entry)i.next();
                getWriter().write(me.getKey().toString());
                getWriter().newLine();
                getWriter().write(me.getValue().toString());
                getWriter().newLine();
            }            
            getWriter().close();
        } catch (IOException e) {
            Logger.getLogger(ExtrusionDetector.class.getName()).log(Level.SEVERE, null, e);
        }
        return file.getAbsolutePath();
    }


}
