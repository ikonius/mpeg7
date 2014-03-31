/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package storage;

import java.util.List;
import storage.database.ExistDB;
import storage.helpers.CollectionDetail;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class Storage {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        ExistDB db = new ExistDB();
     
        try {  
            PoolingExample example = new PoolingExample();
                int[] anArray = {32,44,34};
                    example.printExample(anArray);
            db.registerInstance();
            List<CollectionDetail> x3dCols = db.listX3DCollections();
            if (!x3dCols.isEmpty()) {
                for (CollectionDetail item : x3dCols) {
                    System.out.println("Collection--> " + item.name + " LOCATED @: " + item.locationPath);
                    List<CollectionDetail> innerChildrenCols = db.listX3DCollections(item.name);
                    if (!innerChildrenCols.isEmpty()) {
                        for (CollectionDetail child : innerChildrenCols) {
                            System.out.println("---CHILD--> " + child.name + " LOCATED @: " + child.locationPath);

                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
