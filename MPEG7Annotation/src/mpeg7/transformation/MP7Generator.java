package mpeg7.transformation;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import mpeg7.validation.Validator;
import org.apache.log4j.Logger;
import org.exist.xmldb.XmldbURI;
import org.exist.xquery.XQueryContext;
import storage.database.ExistDB;
import storage.helpers.X3DResourceDetail;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class MP7Generator extends ExistDB {

    private static final Logger logger = Logger.getLogger(MP7Generator.class);
    protected X3DResourceDetail x3dResource;
    protected HashMap<String, String> paramDictMap;
    protected Transformer transformer;
    protected TransformerFactory factory;
    protected Source xslStream;
//    protected File xslFile;
//    protected Templates xsl;

    public MP7Generator(X3DResourceDetail x3dResource, HashMap<String, String> paramDictMap, String xslSource) {
        this.x3dResource = x3dResource;
        this.paramDictMap = paramDictMap;
        this.factory = TransformerFactory.newInstance();
        this.xslStream = new StreamSource(new ByteArrayInputStream(xslSource.getBytes()));
        //this.xslFile = new File(XmldbURI.XMLDB_URI_PREFIX + context.getBroker().getBrokerPool().getId()  + "/x3d_to_mpeg7_transform.xsl");
        //this.xslStream = new StreamSource(context.getClass().getResourceAsStream(context.getModuleLoadPath() + File.separatorChar + "x3d_to_mpeg7_transform.xsl"));       
    }

    public HashMap<String, String> getParamDictMap() {
        return paramDictMap;
    }

    public X3DResourceDetail getX3dResource() {
        return x3dResource;
    }

    public void setParamDictMap(HashMap<String, String> paramDictMap) {
        this.paramDictMap = paramDictMap;
    }

    public void setX3dResource(X3DResourceDetail x3dResource) {
        this.x3dResource = x3dResource;
    }

    public TransformerFactory getFactory() {
        return factory;
    }

    public Transformer getTransformer() {
        return transformer;
    }

    public void setFactory(TransformerFactory factory) {
        this.factory = factory;
    }

    public void setTransformer(Transformer transformer) {
        this.transformer = transformer;
    }

    public void generateDescription() throws Exception {

        //Get X3D source
        ExistDB db = new ExistDB();
        db.registerInstance();
        String x3dSource = db.retrieveDocument(x3dResource).toString();
        StreamSource x3dInput = new StreamSource(new ByteArrayInputStream(x3dSource.getBytes()));

        //Get and setup XSLT
        //this.xsl = this.factory.newTemplates(new StreamSource(this.xslFile));

        //Where to write to
        File mp7File = new File(x3dResource.parentPath + "/" + x3dResource.resourceName + ".mp7");
        String mp7Output = mp7File.toURI().toString();

        //Setup transformer options
        this.transformer = this.factory.newTransformer(this.xslStream);
        this.transformer.setErrorListener(new TransformationErrorListener());
        setTranformerParameters();
        this.transformer.transform(x3dInput, new StreamResult(mp7Output));

        Validator mpeg7Validator = new Validator(mp7File);
        Boolean isValid = mpeg7Validator.isValid();
        // if (isValid) {
        db.storeResource(x3dResource, mp7File);
        //} else {
        //System.out.println("MPEG7 Document: " + mp7File.getName() + " validation result: " + isValid);
        logger.info("MPEG7 Document: " + mp7File.getName() + " validation result: " + isValid);
        //}      

    }

    private void setTranformerParameters() {

        this.transformer.setParameter("filename", this.x3dResource.parentPath + "/" + this.x3dResource.resourceName);
        Set set = this.paramDictMap.entrySet();
        Iterator i = set.iterator();
        while (i.hasNext()) {
            Map.Entry me = (Map.Entry) i.next();
            this.transformer.setParameter(me.getKey().toString(), me.getValue().toString());
        }

    }
}
