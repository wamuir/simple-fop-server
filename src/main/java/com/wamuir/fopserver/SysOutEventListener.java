package com.github.wamuir.simplefopserver;

import org.apache.fop.events.Event;
import org.apache.fop.events.EventFormatter;
import org.apache.fop.events.EventListener;
import org.apache.fop.events.model.EventSeverity;

/** A simple event listener that writes the events to stdout and stderr. */
public class SysOutEventListener implements EventListener {

    /** {@inheritDoc} */
    public void processEvent(Event event) {
        String msg = EventFormatter.format(event);
        EventSeverity severity = event.getSeverity();
        if (severity == EventSeverity.INFO) {
            System.out.println("[INFO ] " + msg);
        } else if (severity == EventSeverity.WARN) {
            System.out.println("[WARN ] " + msg);
        } else if (severity == EventSeverity.ERROR) {
            System.err.println("[ERROR] " + msg);
        } else if (severity == EventSeverity.FATAL) {
            System.err.println("[FATAL] " + msg);
        } else {
            assert false;
        }
    }

}
