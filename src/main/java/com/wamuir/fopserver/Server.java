package com.wamuir.simplefopserver;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;
import java.io.InputStream;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;


public class Server {
    private static final int PORT = 8080;
    private static final int NUM_THREADS = Runtime.getRuntime().availableProcessors();
    private static final FOProcessor processor = new FOProcessor();
    
    public static void main(String[] args) throws Exception {
        
        HttpServer server = HttpServer.create(new InetSocketAddress(PORT), 0);
        server.setExecutor(Executors.newFixedThreadPool(NUM_THREADS));
        server.createContext("/", new HttpHandler() {
            @Override
            public void handle(HttpExchange exchange) throws IOException {
                try {
                    new Responder().respond(processor, exchange);
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    exchange.close();
                }
            }
        }); 
        server.createContext("/health", new HttpHandler() {
            @Override
            public void handle(HttpExchange exchange) throws IOException {
                try {
                    exchange.sendResponseHeaders(200, -1);
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    exchange.close();
                }
            }
        }); 
        server.start();
    }
}
