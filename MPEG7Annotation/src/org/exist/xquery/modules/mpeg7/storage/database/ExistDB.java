/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.exist.xquery.modules.mpeg7.storage.database;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import javax.xml.transform.OutputKeys;
import static org.apache.commons.io.FilenameUtils.removeExtension;
import org.apache.log4j.Logger;
import org.exist.storage.serializers.EXistOutputKeys;
import org.xmldb.api.DatabaseManager;
import org.xmldb.api.base.Collection;
import org.xmldb.api.base.Database;
import org.xmldb.api.base.ResourceIterator;
import org.xmldb.api.base.ResourceSet;
import org.xmldb.api.base.XMLDBException;
import org.xmldb.api.modules.XMLResource;
import org.xmldb.api.modules.XPathQueryService;
import org.exist.xquery.modules.mpeg7.storage.helpers.CollectionDetail;
import org.exist.xquery.modules.mpeg7.storage.helpers.X3DResourceDetail;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class ExistDB {

    private static final Logger logger = Logger.getLogger(ExistDB.class);
    protected String driver;
    protected String URI;
    protected Database database;

    public ExistDB() {
    }

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getURI() {
        return URI;
    }

    public void setURI(String URI) {
        this.URI = URI;
    }

    /**
     * Create the main connection instance to the eXist XML Database. All
     * configuration variables are loaded from the "connection.properties" file
     * in the same package.
     *
     * @throws Exception
     */
    public void registerInstance() throws Exception {
        this.URI = "xmldb:exist://localhost:8899/exist/xmlrpc";
        this.driver = "org.exist.xmldb.DatabaseImpl";
        Class<?> cl = Class.forName(this.driver);
        this.database = (Database) cl.newInstance();
        this.database.setProperty("ssl-enable", "false");
        DatabaseManager.registerDatabase(this.database);
    }

    /**
     * This method returns a list of Collection details where X3D resources are
     * stored, in the BASE directory. Use the same method with parameters to
     * search for specific X3D child Collections
     *
     * @return List<CollectionDetail> with each Collection name and location
     * path in directory
     * @throws Exception
     */
    public List<CollectionDetail> listX3DCollections() throws Exception {

        String baseCollection;
        Collection baseCol;
        List<CollectionDetail> childCols = new ArrayList<CollectionDetail>();
        baseCollection = "/db/apps/annotation/data/Examples/";
        baseCol = DatabaseManager.getCollection(URI + baseCollection);
        baseCol.setProperty(OutputKeys.INDENT, "yes");
        baseCol.setProperty(EXistOutputKeys.EXPAND_XINCLUDES, "no");
        baseCol.setProperty(EXistOutputKeys.PROCESS_XSL_PI, "yes");
        if (baseCol.getChildCollectionCount() > 0) {
            //childCols = baseCol.listChildCollections();
            for (String child : baseCol.listChildCollections()) {
                childCols.add(new CollectionDetail(child, baseCol.getName()));
            }
        }
        if (baseCol.isOpen()) {
            baseCol.close();
        }
        return childCols;
    }

    /**
     * This method returns a list of Collection details where X3D resources are
     * stored, based on child directory path given.
     *
     * @param childPath
     * @return List<CollectionDetail> with each Collection name and location
     * path in directory
     * @throws Exception
     */
    public List<CollectionDetail> listX3DCollections(String childPath) throws Exception {

        // baseCollection can be null when we want to get the base repository -  the url is then defined in 
        String baseCollection;
        Collection baseCol;
        List<CollectionDetail> childCols = new ArrayList<CollectionDetail>();
        baseCollection = "/db/apps/annotation/data/Examples/";
        baseCol = DatabaseManager.getCollection(URI + baseCollection + childPath);
        baseCol.setProperty(OutputKeys.INDENT, "yes");
        baseCol.setProperty(EXistOutputKeys.EXPAND_XINCLUDES, "no");
        baseCol.setProperty(EXistOutputKeys.PROCESS_XSL_PI, "yes");
        if (baseCol.getChildCollectionCount() > 0) {
            for (String child : baseCol.listChildCollections()) {
                childCols.add(new CollectionDetail(child, baseCol.getName()));
            }
        }
        if (baseCol.isOpen()) {
            baseCol.close();
        }
        return childCols;
    }

    /**
     * This method returns a list of X3D Resource details, based on child
     * directory path given.
     *
     * @param collectionPath
     * @return List<CollectionDetail> with each Collection name and location
     * path in directory
     * @throws Exception
     */
    public List<X3DResourceDetail> getX3DResources(String collectionPath) throws Exception {
        Collection col = DatabaseManager.getCollection(URI + collectionPath);
        col.setProperty(OutputKeys.INDENT, "yes");
        col.setProperty(EXistOutputKeys.EXPAND_XINCLUDES, "no");
        col.setProperty(EXistOutputKeys.PROCESS_XSL_PI, "yes");
        List<X3DResourceDetail> childRes = new ArrayList<X3DResourceDetail>();

        XPathQueryService service = (XPathQueryService) col.getService("XPathQueryService", "1.0");
        ResourceSet resultSet = service.query("//X3D");

        ResourceIterator results = resultSet.getIterator();
        while (results.hasMoreResources()) {
            XMLResource res = (XMLResource) results.nextResource();
            childRes.add(new X3DResourceDetail(
                    removeExtension((String) res.getDocumentId()),
                    (String) res.getDocumentId(),
                    res.getParentCollection().getName())
            );
        }
        col.close();
        return childRes;
    }

    public Object retrieveDocument(X3DResourceDetail detail) throws Exception {
        Collection col = DatabaseManager.getCollection(URI + detail.parentPath);
        col.setProperty(OutputKeys.INDENT, "yes");
        col.setProperty(EXistOutputKeys.EXPAND_XINCLUDES, "no");
        col.setProperty(EXistOutputKeys.PROCESS_XSL_PI, "yes");
        XMLResource resource = (XMLResource) col.getResource(detail.resourceFileName);
        Object resContent = resource.getContent();
        if (col.isOpen()) {
            col.close();
        }
        return resContent;

    }
    
    public Object retrieveModule(String moduleName) throws Exception{
        String modulePath = "/db/apps/annotation/modules/";
        Collection col = DatabaseManager.getCollection(URI + modulePath);
        col.setProperty(OutputKeys.INDENT, "yes");
        col.setProperty(EXistOutputKeys.EXPAND_XINCLUDES, "no");
        col.setProperty(EXistOutputKeys.PROCESS_XSL_PI, "yes");
        XMLResource resource = (XMLResource) col.getResource(moduleName);
        Object resContent = resource.getContent();
        if (col.isOpen()) {
            col.close();
        }
        return resContent;

    }

    public boolean storeResource(X3DResourceDetail x3dResource, File localFile) {
        try {
            Collection col = DatabaseManager.getCollection(URI + x3dResource.parentPath, "admin", "admin");
            col.setProperty(OutputKeys.INDENT, "yes");
            col.setProperty(EXistOutputKeys.EXPAND_XINCLUDES, "no");
            col.setProperty(EXistOutputKeys.PROCESS_XSL_PI, "yes");

            XMLResource resource = (XMLResource) col.createResource(localFile.getName(), "XMLResource");
            resource.setContent(localFile);
            col.storeResource(resource);
            return true;
        } catch (XMLDBException e) {
            logger.error(e);
            return false;
        }

    }
}
