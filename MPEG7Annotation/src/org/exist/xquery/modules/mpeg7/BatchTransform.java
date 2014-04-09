package org.exist.xquery.modules.mpeg7;

import java.io.ByteArrayInputStream;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
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

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class BatchTransform extends BasicFunction {

    private static final Logger logger = Logger.getLogger("app.annotation");
    public final static FunctionSignature signature = new FunctionSignature(
            new QName("batchTransform", MPEG7Module.NAMESPACE_URI, MPEG7Module.PREFIX),
            "Batch MPEG7 Transformer for .zip extracted Collection stored X3D resources.",
            new SequenceType[]{
                new FunctionParameterSequenceType("path", Type.ITEM, Cardinality.EXACTLY_ONE, "The full path URI of the Collection to transform")
            },
            new FunctionReturnSequenceType(Type.BOOLEAN, Cardinality.EXACTLY_ONE, "true if successful, false otherwise"));

    public BatchTransform(XQueryContext context, FunctionSignature signature) {
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
            String collectionPath = args[0].getStringValue();
            ExistDB db = new ExistDB();
            db.registerInstance();
            String xslSource = db.retrieveModule("x3d_to_mpeg7_transform.xsl").toString();
            List<X3DResourceDetail> x3dResources = db.getX3DResources(collectionPath);
            if (!x3dResources.isEmpty()) {
                for (X3DResourceDetail detail : x3dResources) {

                    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                    factory.setNamespaceAware(true);
                    DocumentBuilder builder = factory.newDocumentBuilder();

                    String docSource = db.retrieveDocument(detail).toString();

                    Document doc = builder.parse(new ByteArrayInputStream(docSource.getBytes()));
                    //doc.getDocumentElement().normalize();

                    IFSDetector ifsDetector = new IFSDetector(doc);
                    ifsDetector.processShapes();
                    ExtrusionDetector extrusionDetector = new ExtrusionDetector(doc);
                    extrusionDetector.processShapes();                    
                    
                    MP7Generator mp7Generator = new MP7Generator(detail, extrusionDetector.getParamMap(), xslSource);
                    mp7Generator.generateDescription(); 

                }
            }
            result.add(new BooleanValue(true)); //todo cases

        } catch (XPathException e) {
            logger.error(e);
            result.add(new BooleanValue(false));
        } catch (Exception ex) {
            logger.error(ex);
            result.add(new BooleanValue(false));
        }
        return result;
    }

}
