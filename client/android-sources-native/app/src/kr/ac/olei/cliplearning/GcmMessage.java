package com.codymonster.ibeobom;

import java.io.*;
public class GcmMessage implements Serializable
{

    public int no1;
    public int no2;
    public int type;
    public String message;
    public boolean isRead;
//    public boolean running;

    public GcmMessage() { }
    public GcmMessage(int type, String message, int no1, int no2)
    {
        this.no1 = no1;
        this.no2 = no2;
        this.type = type;
        this.message = message;
        this.isRead = true;
     }
}
