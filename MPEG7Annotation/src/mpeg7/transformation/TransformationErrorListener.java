package mpeg7.transformation;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;
import org.apache.log4j.Logger;
import org.apache.log4j.Priority;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class TransformationErrorListener implements ErrorListener{
      private static final Logger logger = Logger.getLogger(TransformationErrorListener.class);

    @Override
    public void warning(TransformerException e) throws TransformerException {
        logger.log(Priority.WARN, null, e);
        //show("Warning", e);
        //throw (e);
    }

    @Override
    public void error(TransformerException e) throws TransformerException {
        logger.log(Priority.ERROR, null, e);
        //show("Error", e);
        //throw (e);
    }

    @Override
    public void fatalError(TransformerException e) throws TransformerException {
        logger.log(Priority.FATAL, null, e);
        //show("Fatal Error", e);
        //throw (e);
    }

    private void show(String type, TransformerException e) {
        System.out.println(type + ": " + e.getMessage());
        if (e.getLocationAsString() != null) {
            System.out.println(e.getLocationAsString());

        }
    }
}
