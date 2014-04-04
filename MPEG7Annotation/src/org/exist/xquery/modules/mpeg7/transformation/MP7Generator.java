package org.exist.xquery.modules.mpeg7.transformation;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.exist.xquery.modules.mpeg7.validation.Validator;
import org.apache.log4j.Logger;
import org.apache.log4j.Priority;
import org.exist.xquery.modules.mpeg7.storage.database.ExistDB;
import org.exist.xquery.modules.mpeg7.storage.helpers.X3DResourceDetail;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class MP7Generator extends ExistDB {
   
    protected X3DResourceDetail x3dResource;
    protected HashMap<String, String> paramDictMap;
    protected Transformer transformer;
    protected TransformerFactory factory;
    protected Source xslStream;


    public MP7Generator(X3DResourceDetail x3dResource, HashMap<String, String> paramDictMap, String xslSource) {
        this.x3dResource = x3dResource;
        this.paramDictMap = paramDictMap;
        this.factory = TransformerFactory.newInstance();
        this.xslStream = new StreamSource(new ByteArrayInputStream(xslSource.getBytes()));          
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

    public Source getXslStream() {
        return xslStream;
    }

    public void setXslStream(Source xslStream) {
        this.xslStream = xslStream;
    }
       

    public Boolean generateDescription() throws Exception {

        //Get X3D source
        ExistDB db = new ExistDB();
        db.registerInstance();
        String x3dSource = db.retrieveDocument(x3dResource).toString();
        StreamSource x3dInput = new StreamSource(new ByteArrayInputStream(x3dSource.getBytes()));

     
        //Where to write MPEG-7 file
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
        //} 
        return isValid;
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

class TransformationErrorListener implements ErrorListener{
      private static final Logger logger = Logger.getLogger("mpeg7");

    @Override
    public void warning(TransformerException e) throws TransformerException {
        logger.log(Priority.WARN, null, e);
    }

    @Override
    public void error(TransformerException e) throws TransformerException {
        logger.log(Priority.ERROR, null, e);
    }

    @Override
    public void fatalError(TransformerException e) throws TransformerException {
        logger.log(Priority.FATAL, null, e);
    }

}