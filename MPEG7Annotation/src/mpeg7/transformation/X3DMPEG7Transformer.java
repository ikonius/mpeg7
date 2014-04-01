/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mpeg7.transformation;

import java.io.File;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.log4j.Logger;
import org.apache.log4j.Priority;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class X3DMPEG7Transformer {
    
      private static Logger logger = Logger.getLogger(X3DMPEG7Transformer.class);

    public void generateDescription(File inXml) {

        StringBuilder IFSStringBuilder = new StringBuilder();
        StringBuilder ExtrShapeStringBuilder = new StringBuilder();
        StringBuilder ExtrBBoxStringBuilder = new StringBuilder();
        // 1. Instantiate a TransformerFactory.
        TransformerFactory factory = TransformerFactory.newInstance();
        StreamSource xslStream = new StreamSource(getClass().getResourceAsStream("x3d_to_mpeg7_transform.xsl"));
        // 2. Use the TransformerFactory to process the stylesheet Source and generate a Transformer.
        Transformer transformer = null;
        try {
            transformer = factory.newTransformer(xslStream);
        } catch (TransformerConfigurationException exXSL) {
            //System.out.println(getServletContext().getRealPath("/"));
            //System.setProperty("resultFolder", getServletContext().getRealPath("/"));
            //System.out.println(System.getProperty("resultFolder"));
            //logger.log(Priority.FATAL, null, exXSL);
            exXSL.printStackTrace();
            //Logger.getLogger(MP7Transformation.class.getName()).log(Level.SEVERE, null, exXSL);
        }
        transformer.setErrorListener(new TransformationErrorListener());
        StreamSource in = new StreamSource(inXml);
        // 3. Use the Transformer to transform an XML Source and send the output to a Result object.
        //xmlSystemId is used to pass the full path of the xml file currently being transformed through the xsl
        //String xmlSystemId = inXml.toURI().toString();
        //transformer.setParameter("filename", xmlSystemId);
        String partialFilePath = org.apache.commons.io.FilenameUtils.getName(inXml.getParent().toString()) + "/" + "someting.x3d";
        //System.out.println("X3D-MP7 partialFilePath: " + partialFilePath);
        transformer.setParameter("filename", partialFilePath);
        transformer.setParameter("pointsExtraction", IFSStringBuilder.toString());
        transformer.setParameter("extrusionPointsExtraction", ExtrShapeStringBuilder.toString());
        transformer.setParameter("extrusionBBoxParams", ExtrBBoxStringBuilder.toString());
        String fileNameOnly = org.apache.commons.io.FilenameUtils.removeExtension(inXml.getName());
        String outputXML = new File(System.getProperty("java.io.tmpdir") + "/" + fileNameOnly + ".mp7").toURI().toString();
        //System.out.println("Output MP7 location: " + outputXML);
        try {
            transformer.transform(in, new StreamResult(outputXML));
            System.out.println("MP7 File Generated Successfully!");
        } catch (TransformerException exTransform) {
            System.out.println("MP7 Transformation Error! The full stack trace of the root cause is available in the logs of Apache Tomcat.");
            logger.log(Priority.ERROR, null, exTransform);
            //Logger.getLogger(MP7Transformation.class.getName()).log(Level.SEVERE, null, exTransform);
        }

    }
}
