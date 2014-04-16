package org.exist.xquery.modules.mpeg7.x3d.geometries;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
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
    public void processShapes() throws XPathExpressionException, IOException {
        String crossSectionAttrib, spineAttrib, scaleAttrib, orientAttrib;
        ArrayList<String> resultedExtrExtractionList = new ArrayList<String>();
        ArrayList<String> resultedExtrBBoxList = new ArrayList<String>();
        StringBuilder ExtrShapeStringBuilder = new StringBuilder();
        StringBuilder ExtrBBoxStringBuilder = new StringBuilder();

        this.getDoc().getDocumentElement().normalize();
        XPath xPath = XPathFactory.newInstance().newXPath();        
        NodeList extrSet = (NodeList) xPath.evaluate("//Shape/Extrusion", this.getDoc().getDocumentElement(), XPathConstants.NODESET);

        for (int i = 0; i < extrSet.getLength(); i++) {
            Element elem = (Element) extrSet.item(i);
            HashMap<String, String[]> dictParams = new HashMap<String, String[]>();
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
            this.setFile(new File("Extrusion.txt"));

            String coordTempFile = writeParamsToFile(dictParams, this.getFile(), this.getWriter());
            //String coordTempFile = writeExtrusionParamsToFile(crossSectionAttrib, spineAttrib, scaleAttrib, orientAttrib, file, bw);

            String[] ExtrTempFile = {coordTempFile};
            String resultedExtraction = ExtrusionDescription.ExtrusionDescription(ExtrTempFile);            

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
        this.getParamMap().put("extrusionPointsExtraction", ExtrShapeStringBuilder.toString());
        this.getParamMap().put("extrusionBBoxParams", ExtrBBoxStringBuilder.toString());

    }

    @Override
    public String writeParamsToFile(HashMap<String, String[]> dictMap, File file, BufferedWriter get) throws IOException {

        // if file doesnt exists, then create it
        if (file.exists()) {
            file.delete();
        }
        file.createNewFile();
        this.setWriter(new BufferedWriter(new FileWriter(file)));

        Set set = dictMap.entrySet();
        Iterator i = set.iterator();
        while (i.hasNext()) {
            Map.Entry me = (Map.Entry) i.next();
            this.getWriter().write(me.getKey().toString());
            this.getWriter().newLine();
            this.getWriter().write(me.getValue().toString());
            this.getWriter().newLine();
        }
        this.getWriter().close();

        return file.getAbsolutePath();
    }

}
