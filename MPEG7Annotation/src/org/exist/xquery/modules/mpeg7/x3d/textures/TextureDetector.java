package org.exist.xquery.modules.mpeg7.x3d.textures;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.imageio.ImageIO;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import static org.apache.commons.io.FilenameUtils.removeExtension;
import org.apache.commons.validator.UrlValidator;
import org.apache.log4j.Logger;
import org.exist.xquery.modules.mpeg7.x3d.colors.ScalableColorImpl;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class TextureDetector {

    private Document doc;
    String basePath;
    private HashMap<String, ArrayList<String>> textureList;
    private HashMap<String, String> histograms;
    private HashMap<String, String> scalableColors;
    private static final Logger logger = Logger.getLogger(TextureDetector.class);

    public TextureDetector(Document doc, String basePath) throws XPathExpressionException, ParserConfigurationException, MalformedURLException, IOException {
        this.doc = doc;
        this.basePath = basePath;
        retrieveImageList();
        extractFeatures();

    }

    public Document getDoc() {
        return doc;
    }

    public void setDoc(Document doc) {
        this.doc = doc;
    }

    public String getBasePath() {
        return basePath;
    }

    public void setBasePath(String basePath) {
        this.basePath = basePath;
    }

    public HashMap<String, String> getHistograms() {
        return histograms;
    }

    public HashMap<String, String> getScalableColors() {
        return scalableColors;
    }

    protected void retrieveImageList() throws XPathExpressionException, ParserConfigurationException, MalformedURLException {
        textureList = new HashMap<String, ArrayList<String>>();
        XPath xPath = XPathFactory.newInstance().newXPath();
        this.getDoc().getDocumentElement().normalize();
        String xPathInline = "//ImageTexture";
        NodeList textureSet = (NodeList) xPath.compile(xPathInline).evaluate(this.getDoc().getDocumentElement(), XPathConstants.NODESET);
        for (int p = 0; p < textureSet.getLength(); p++) {
            Element textureNode = (Element) textureSet.item(p);
            boolean hasUse = textureNode.hasAttribute("USE");
            if (hasUse) {
                String def = textureNode.getAttribute("USE");
                textureNode = (Element) xPath.compile("//ImageTexture[@DEF='" + def + "']").evaluate(this.getDoc().getDocumentElement(), XPathConstants.NODE);
            }
            boolean hasUrl = textureNode.hasAttribute("url");
            if (hasUrl) {
                String urlParams[] = textureNode.getAttribute("url").replaceAll("\"", "").split(" ");
                ArrayList<String> textureUrls = new ArrayList<String>();
                for (String urlParam : urlParams) {
                    textureUrls.clear();
                    UrlValidator urlValidator = new UrlValidator();                   
                    if (!urlValidator.isValid(urlParam)) {
                        textureUrls.add(basePath.replace("/db/", "http://54.72.206.163/exist/") + "/" + urlParam);
                    } else {
                        URL url = new URL(urlParam);
                        textureUrls.add(url.toString());
                    }
                }
                String def = textureNode.hasAttribute("DEF") ? textureNode.getAttribute("DEF") +"_"+p : removeExtension(textureUrls.get(0).substring(textureUrls.get(0).lastIndexOf('/') + 1));
                textureList.put(def, textureUrls);
            }            
        }        
    }

    protected void extractFeatures() {
        histograms = new HashMap<String, String>();
        StringBuilder textureHistogramsBuilder = new StringBuilder();
        scalableColors = new HashMap<String, String>();
        StringBuilder textureScalableColorsBuilder = new StringBuilder();
        Iterator it = textureList.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry) it.next();
            ArrayList textureUrls = (ArrayList) pairs.getValue();
            for (Object textureUrl : textureUrls) {
                try {
                    BufferedImage img = ImageIO.read(new URL(textureUrl.toString()));
                    //EHD
                    EdgeHistogramImplementation ehdi = new EdgeHistogramImplementation(img);
                    String bins = ehdi.getStringRepresentation().split(";")[1];
                    textureHistogramsBuilder.append(pairs.getKey().toString());
                    textureHistogramsBuilder.append(':');
                    textureHistogramsBuilder.append(bins);
                    if (it.hasNext()) {
                        textureHistogramsBuilder.append('#');
                    }
                    //SCD
                    ScalableColorImpl scdi = new ScalableColorImpl(img);
                    String scdiBits = scdi.getStringRepresentation();
                    String scalableColorParts = scdiBits.substring(scdiBits.indexOf(";") + 1, scdiBits.length());
                    textureScalableColorsBuilder.append(pairs.getKey().toString());
                    textureScalableColorsBuilder.append(":");
                    textureScalableColorsBuilder.append(scalableColorParts);
                    if (it.hasNext()) {
                        textureScalableColorsBuilder.append("#");
                    }
                    break;
                } catch (IOException ex) {
                    //logger.warn(ex);
                }
            }
            it.remove(); // avoids a ConcurrentModificationException
        }
        logger.info(textureScalableColorsBuilder.toString());
        histograms.put("EHDs", textureHistogramsBuilder.toString());
        scalableColors.put("SCDs", textureScalableColorsBuilder.toString());
        //CommonUtils.printMap(histograms);        

    }

}
