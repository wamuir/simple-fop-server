package com.wamuir.simplefopserver;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;


public class Responder {
    
    public void respond(FOProcessor processor, HttpExchange exchange) throws Exception {
               
        ByteArrayOutputStream pdf = processor.toPDF(exchange.getRequestBody());
        Integer pdfSize = pdf.size();

        if (pdfSize > 0) {
            Headers headers = exchange.getResponseHeaders();
            headers.set("Content-Type", "application/pdf");
            exchange.sendResponseHeaders(200, pdfSize);
            pdf.writeTo(exchange.getResponseBody());
        } else {
            exchange.sendResponseHeaders(400, -1);

        }
        return;

    }
}
