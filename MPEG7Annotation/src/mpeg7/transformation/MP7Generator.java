package mpeg7.transformation;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.exist.storage.serializers.EXistOutputKeys;
import org.xmldb.api.DatabaseManager;
import org.xmldb.api.base.Collection;
import org.xmldb.api.modules.XMLResource;
import storage.database.ExistDB;
import storage.helpers.X3DResourceDetail;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class MP7Generator extends ExistDB {

    protected X3DResourceDetail x3dResource;
    protected HashMap<String, String> paramDictMap;
    protected Transformer transformer;
    protected TransformerFactory factory;
    protected StreamSource xslStream;

    public MP7Generator(X3DResourceDetail x3dResource, HashMap<String, String> paramDictMap) {
        this.x3dResource = x3dResource;
        this.paramDictMap = paramDictMap;
        this.factory = TransformerFactory.newInstance();
        this.xslStream = new StreamSource(getClass().getResourceAsStream("x3d_to_mpeg7_transform.xsl"));
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

    public StreamSource getXslStream() {
        return xslStream;
    }

    public void setFactory(TransformerFactory factory) {
        this.factory = factory;
    }

    public void setTransformer(Transformer transformer) {
        this.transformer = transformer;
    }

    public void setXslStream(StreamSource xslStream) {
        this.xslStream = xslStream;
    }

    public void generateDescription() {
        try {

            ExistDB db = new ExistDB();
            db.registerInstance();
            String x3dSource = db.retrieveDocument(x3dResource).toString();

            //StreamSource x3dInput = new StreamSource(new File(x3dResource.parentPath + "/" + x3dResource.resourceFileName));
            StreamSource x3dInput = new StreamSource(new ByteArrayInputStream(x3dSource.getBytes()));
            File mp7File = new File(x3dResource.parentPath + "/" + x3dResource.resourceName + ".mp7");
            String mp7Output = mp7File.toURI().toString();

            this.transformer = this.factory.newTransformer(this.xslStream);
            this.transformer.setErrorListener(new TransformationErrorListener());
            setTranformerParameters();

            transformer.transform(x3dInput, new StreamResult(mp7Output));
            db.storeResource(x3dResource,mp7File);

        } catch (TransformerConfigurationException | IllegalArgumentException e) {
            Logger.getLogger(MP7Generator.class.getName()).log(Level.SEVERE, null, e);
        } catch (TransformerException e) {
            Logger.getLogger(MP7Generator.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(MP7Generator.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    private void setTranformerParameters() {

        this.transformer.setParameter("filename", this.x3dResource.parentPath + "/" + this.x3dResource.resourceName);
        Set set = this.paramDictMap.entrySet();
        Iterator i = set.iterator();
        while (i.hasNext()) {
            Map.Entry me = (Map.Entry) i.next();
            this.transformer.setParameter(me.getKey().toString(), me.getValue().toString());
        }
//        this.transformer.setParameter("filename", partialFilePath);
//        this.transformer.setParameter("pointsExtraction", IFSStringBuilder.toString());
//        this.transformer.setParameter("extrusionPointsExtraction", ExtrShapeStringBuilder.toString());
//        this.transformer.setParameter("extrusionBBoxParams", ExtrBBoxStringBuilder.toString());

    }
}
