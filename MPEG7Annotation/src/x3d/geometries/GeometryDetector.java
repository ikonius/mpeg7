/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package x3d.geometries;

import java.io.BufferedWriter;
import java.io.File;
import java.util.HashMap;
import org.w3c.dom.Document;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public abstract class GeometryDetector {
    private File file;
    private BufferedWriter writer;
    private String resultExtraction;
    private Document doc;
    private final HashMap<String, String> paramMap;
    
    public GeometryDetector(Document doc){
        this.doc = doc;
        this.paramMap = new HashMap<String, String>();
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public BufferedWriter getWriter() {
        return writer;
    }

    public void setWriter(BufferedWriter writer) {
        this.writer = writer;
    }

    public String getResultExtraction() {
        return resultExtraction;
    }

    public void setResultExtraction(String resultExtraction) {
        this.resultExtraction = resultExtraction;
    }

    public Document getDoc() {
        return doc;
    }

    public void setDoc(Document doc) {
        this.doc = doc;        
    }

    public HashMap<String, String> getParamMap() {
        return paramMap;
    }
    
    
    public abstract void processShapes();
    public abstract String writeParamsToFile(HashMap<String, String[]> dictMap, File file, BufferedWriter writer);
}
