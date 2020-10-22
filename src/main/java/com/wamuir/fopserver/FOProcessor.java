package com.wamuir.simplefopserver;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;


public class FOProcessor {

    private FopFactory fopFactory;

    {
        try {
            fopFactory = FopFactory.newInstance(new File("/usr/local/etc/fop.xconf"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public ByteArrayOutputStream toPDF(InputStream request) {
        ByteArrayOutputStream pdf = new ByteArrayOutputStream();

        try {

            FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
            foUserAgent.getEventBroadcaster().addEventListener(new SysOutEventListener());
            Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, pdf);

            StreamSource src = new StreamSource(request);          
            Result res = new SAXResult(fop.getDefaultHandler());
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            transformer.transform(src, res);

        } catch (Exception e) {
            pdf.reset();
            System.out.println("No xsl:fo output for you: " + e.getMessage());
        } finally {
            return pdf;
        }

    }
}
