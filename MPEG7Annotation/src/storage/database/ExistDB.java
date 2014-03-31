/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package storage.database;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.xml.transform.OutputKeys;
import org.exist.storage.serializers.EXistOutputKeys;
import org.xmldb.api.DatabaseManager;
import org.xmldb.api.base.Collection;
import org.xmldb.api.base.Database;
import org.xmldb.api.base.ResourceIterator;
import org.xmldb.api.base.ResourceSet;
import org.xmldb.api.modules.XMLResource;
import org.xmldb.api.modules.XPathQueryService;
import storage.helpers.CollectionDetail;
import storage.helpers.X3DResourceDetail;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class ExistDB {

    protected static String driver;
    protected static String URI;
    protected static Database database;

    public ExistDB() {
    }

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        ExistDB.driver = driver;
    }

    public String getURI() {
        return URI;
    }

    public void setURI(String URI) {
        ExistDB.URI = URI;
    }

    /**
     * Create the main connection instance to the eXist XML Database. All
     * configuration variables are loaded from the "connection.properties" file
     * in the same package.
     *
     * @throws Exception
     */
    public void registerInstance() throws Exception {
        Properties prop = new Properties();
        InputStream config = null;
        try {
            config = getClass().getResourceAsStream("connection.properties");
            prop.load(config);
            URI = prop.getProperty("exist.URI");
            driver = prop.getProperty("exist.driver");
            Class<?> cl = Class.forName(driver);
            database = (Database) cl.newInstance();
            database.setProperty("ssl-enable", prop.getProperty("exist.sslOn"));
            DatabaseManager.registerDatabase(database);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (config != null) {
                try {
                    config.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
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
        Properties prop = new Properties();
        InputStream config = null;
        Collection baseCol;
        List<CollectionDetail> childCols = new ArrayList<>();
        try {
            config = getClass().getResourceAsStream("connection.properties");
            prop.load(config);
            baseCollection = prop.getProperty("exist.baseX3DCollection");
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

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (config != null) {
                try {
                    config.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
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
        Properties prop = new Properties();
        InputStream config = null;
        Collection baseCol;
        List<CollectionDetail> childCols = new ArrayList<>();
        try {
            config = getClass().getResourceAsStream("connection.properties");
            prop.load(config);
            baseCollection = prop.getProperty("exist.baseX3DCollection");
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

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (config != null) {
                try {
                    config.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
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
        List<X3DResourceDetail> childRes = new ArrayList<>();

        XPathQueryService service = (XPathQueryService) col.getService("XPathQueryService", "1.0");
        ResourceSet resultSet = service.query("//X3D");

        ResourceIterator results = resultSet.getIterator();
        while (results.hasMoreResources()) {
            XMLResource res = (XMLResource) results.nextResource();
            childRes.add(new X3DResourceDetail(
                    (String) res.getDocumentId(),
                    res.getParentCollection().getName())
            );
        }
        col.close();
        return childRes;
    }
}
