/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.exist.xquery.modules.mpeg7.x3d.helpers;

import java.util.Iterator;
import java.util.Map;
import org.apache.log4j.Logger;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class CommonUtils {

    private static final Logger logger = Logger.getLogger(CommonUtils.class);

    public static void printMap(Map mp) {
        Iterator it = mp.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry) it.next();
            logger.info(pairs.getKey() + " : " + pairs.getValue());
            it.remove(); // avoids a ConcurrentModificationException
        }
    }
}
