package org.exist.xquery.modules.mpeg7;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.StringWriter;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPathExpressionException;
import static org.apache.commons.io.FilenameUtils.removeExtension;
import org.exist.xquery.modules.mpeg7.transformation.MP7Generator;
import org.apache.log4j.Logger;
import org.exist.dom.QName;
import org.exist.xquery.BasicFunction;
import org.exist.xquery.Cardinality;
import org.exist.xquery.FunctionSignature;
import org.exist.xquery.XPathException;
import org.exist.xquery.XQueryContext;
import org.exist.xquery.value.BooleanValue;
import org.exist.xquery.value.FunctionParameterSequenceType;
import org.exist.xquery.value.FunctionReturnSequenceType;
import org.exist.xquery.value.Sequence;
import org.exist.xquery.value.SequenceType;
import org.exist.xquery.value.Type;
import org.exist.xquery.value.ValueSequence;
import org.w3c.dom.Document;
import org.exist.xquery.modules.mpeg7.storage.database.ExistDB;
import org.exist.xquery.modules.mpeg7.storage.helpers.X3DResourceDetail;
import org.exist.xquery.modules.mpeg7.x3d.geometries.ExtrusionDetector;
import org.exist.xquery.modules.mpeg7.x3d.geometries.IFSDetector;
import org.exist.xquery.modules.mpeg7.x3d.geometries.ILSDetector;
import org.exist.xquery.modules.mpeg7.x3d.geometries.InlineDetector;
import org.xml.sax.SAXException;
import org.xmldb.api.base.XMLDBException;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class SingleTransform extends BasicFunction {

    private static final Logger logger = Logger.getLogger(SingleTransform.class);

    public final static FunctionSignature signature = new FunctionSignature(
            new QName("singleTransform", MPEG7Module.NAMESPACE_URI, MPEG7Module.PREFIX),
            "MPEG7 Transformer for a single X3D resource in a Collection",
            new SequenceType[]{
                new FunctionParameterSequenceType("collectionPath", Type.ITEM, Cardinality.EXACTLY_ONE, "The full path URI of the Resource to transform"),
                new FunctionParameterSequenceType("fileName", Type.ITEM, Cardinality.EXACTLY_ONE, "The X3D Resource file name to transform")
            },
            new FunctionReturnSequenceType(Type.BOOLEAN, Cardinality.EXACTLY_ONE, "true if successful, false otherwise"));

    public SingleTransform(XQueryContext context, FunctionSignature signature) {
        super(context, signature);
    }

    @Override
    public Sequence eval(Sequence[] args, Sequence sqnc) throws XPathException {
        // is argument the empty sequence?
        ValueSequence result = new ValueSequence();
        if (args.length == 0) {
            return Sequence.EMPTY_SEQUENCE;
        }

        try {           
            String resourcePath = args[0].getStringValue();
            String fileName = args[1].getStringValue();
            X3DResourceDetail resource = new X3DResourceDetail(removeExtension(fileName), fileName, resourcePath);
            int mpeg7counter = 0; //debugging
            ExistDB db = new ExistDB();
            db.registerInstance();
            String xslSource = db.retrieveModule("x3d_to_mpeg7_transform.xsl").toString();
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            DocumentBuilder builder = factory.newDocumentBuilder();

            logger.debug("Processing file: " + resource.resourceFileName); //debugging
            String x3dSource = db.retrieveDocument(resource).toString();
            Document doc = builder.parse(new ByteArrayInputStream(x3dSource.getBytes()));
            InlineDetector inlDetector = new InlineDetector(doc, resource.parentPath);
            doc = inlDetector.retrieveInlineNodes();

            //debugging
            StringWriter sw = new StringWriter();
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
            transformer.setOutputProperty(OutputKeys.METHOD, "xml");
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            transformer.transform(new DOMSource(doc), new StreamResult(sw));
            logger.info(sw.toString());
            //end debugging
            IFSDetector ifsDetector = new IFSDetector(doc);
            ifsDetector.processShapes();
            ILSDetector ilsDetector = new ILSDetector(doc);
            ilsDetector.processShapes();
            ExtrusionDetector extrusionDetector = new ExtrusionDetector(doc);
            extrusionDetector.processShapes();

            MP7Generator mp7Generator = new MP7Generator(resource, extrusionDetector.getParamMap(), xslSource);
            mpeg7counter = mp7Generator.generateDescription(mpeg7counter);

            logger.debug("No of MPEG-7 files: " + mpeg7counter); //debugging
            result.add(new BooleanValue(true)); //todo cases

        } catch (InstantiationException ex) {
            logger.error("InstantiationException: ", ex);
            result.add(new BooleanValue(false));
        } catch (ParserConfigurationException ex) {
            logger.error("ParserConfigurationException: ", ex);
            result.add(new BooleanValue(false));
        } catch (XMLDBException ex) {
            logger.error("XMLDBException: ", ex);
            result.add(new BooleanValue(false));
        } catch (IllegalAccessException ex) {
            logger.error("IllegalAccessException: ", ex);
            result.add(new BooleanValue(false));
        } catch (ClassNotFoundException ex) {
            logger.error("ClassNotFoundException: ", ex);
            result.add(new BooleanValue(false));
        } catch (SAXException ex) {
            logger.error("SAXException: ", ex);
            result.add(new BooleanValue(false));
        } catch (IOException ex) {
            logger.error("IOException: ", ex);
            result.add(new BooleanValue(false));
        } catch (XPathExpressionException ex) {
            logger.error("XPathExpressionException: ", ex);
            result.add(new BooleanValue(false));
        } catch (Exception ex) {
            logger.error("Exception: ", ex);
            result.add(new BooleanValue(false));
        }
        return result;
    }

}
