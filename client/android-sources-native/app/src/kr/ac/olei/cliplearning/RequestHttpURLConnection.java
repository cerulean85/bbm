package com.codymonster.ibeobom;

import android.content.ContentValues;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;
import java.util.Collection;
import java.util.Iterator;
import javax.net.ssl.X509TrustManager;
import javax.net.ssl.HttpsURLConnection;
import android.util.Log;
import java.io.FileInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.nio.file.Files;
import java.io.InputStream;
import java.io.FileInputStream;
import java.util.Iterator;

public class RequestHttpURLConnection {

    private String mCookie = "";
    public void setCookie(String m) { mCookie = m; }
    public String cookie() { return mCookie; }

    private boolean requestedCookieValue = false;
    public void requestCookieValue(boolean m) { requestedCookieValue = m; }
    private void getCookie(Map m)
    {
        if(m.containsKey("Set-Cookie")) {
            Collection c =(Collection)m.get("Set-Cookie");
            for(Iterator i = c.iterator(); i.hasNext(); ) {
                mCookie += (String)i.next() + ", ";
            }
        }
    }

    public String request(String _url, ContentValues _params){

        HttpURLConnection urlConn = null;
        StringBuffer sbParams = new StringBuffer();

        if (_params == null) sbParams.append("");
        else {

            boolean isAnd = false;
            String key;
            String value;

            for(Map.Entry<String, Object> parameter : _params.valueSet()){
                key = parameter.getKey();
                if(parameter.getValue() == null) value = "";
                else value = parameter.getValue().toString();

                if (isAnd) sbParams.append("&");
                sbParams.append(key).append("=").append(value);

                if (!isAnd)
                {
                    if (_params.size() >= 2)
                        isAnd = true;
                }
            }
        }

        String result = "";
        try{
            URL url = new URL(_url);
            urlConn = (HttpURLConnection) url.openConnection();
            urlConn.setRequestMethod("POST");
            urlConn.setRequestProperty("Accept-Charset", "UTF-8");
            urlConn.setRequestProperty("Content_Type", "application/x-www-form-urlencoded;cahrset=UTF-8");
            urlConn.setDoOutput(true);
            urlConn.setDoInput(true);

            if(!requestedCookieValue)
                urlConn.setRequestProperty("cookie", mCookie);

            String strParams = sbParams.toString();
            OutputStream os = urlConn.getOutputStream();
            os.write(strParams.getBytes("UTF-8"));
            os.flush();
            os.close();

            if (urlConn.getResponseCode() != HttpURLConnection.HTTP_OK)
                return null;

            if(requestedCookieValue)
                getCookie(urlConn.getHeaderFields());

            String line;
            BufferedReader reader = new BufferedReader(new InputStreamReader(urlConn.getInputStream(), "UTF-8"));
            while ((line = reader.readLine()) != null) result += line;

        } catch (MalformedURLException e) { // for URL.
            System.out.println("An error has occured.");
            result = "Can't connect the network. Please confirm the URL. (1)";
        } catch (IOException e) { // for openConnection().
            System.out.println("An error has occured.");
            result = "Can't connect the network. Please confirm the URL. (2)";
        } finally {
            if (urlConn != null)
                urlConn.disconnect();
        }

        return result;
    }

    public String requestFile(String _url, ContentValues _params, String filePath)
    {
        Log.d("Request File > ", "" + _url + "/" + filePath);
        String fileName = "";
        String boardNo = "";
        String boardArticleNo = "";
        StringBuffer sbParams = new StringBuffer();
        if (_params == null) sbParams.append("");
        else
        {
            boolean isAnd = false;
            String key;
            String value;

            for(Map.Entry<String, Object> parameter : _params.valueSet()){
                key = parameter.getKey();

                if(parameter.getValue() == null) value = "";
                else value = parameter.getValue().toString();

                if(key.equals("file_name")) fileName = value;
                else if(key.equals("board_no")) boardNo = value;
                else if(key.equals("board_article_no")) boardArticleNo = value;

                if (isAnd) sbParams.append("&");
                sbParams.append(key).append("=").append(value);

                Log.d("Check Params >", key + ": " + value);

                if (!isAnd)
                {
                    if (_params.size() >= 2)
                        isAnd = true;
                }
            }
        }


        String result = "";
        String lineEnd = "\r\n";
        String boundary = "*****" + Long.toString(System.currentTimeMillis()) + "*****";
        File file = null;
        FileInputStream fs = null;
        if(!filePath.isEmpty())
        {
            file = new File(filePath);
            if(!file.exists())
            {
                result = "has no file.";
                return result;
            }
        }

        HttpURLConnection urlConn = null;
        try {

            URL url = new URL(_url);
            urlConn = (HttpURLConnection) url.openConnection();
            urlConn.setDoOutput(true);
            urlConn.setDoInput(true);
            urlConn.setUseCaches(false);
            urlConn.setRequestMethod("POST");
            urlConn.setRequestProperty("Connection", "Keep-Alive");
            urlConn.setRequestProperty("User-Agent", "Android Multipart HTTP Client 1.0");
            urlConn.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);

            if(!requestedCookieValue)
                urlConn.setRequestProperty("cookie", mCookie);

            DataOutputStream ds = new DataOutputStream(urlConn.getOutputStream());
            ds.writeBytes("--" + boundary + lineEnd);
            ds.writeBytes("Content-Disposition: form-data; name=\"file"  + "\";filename=\"" + fileName + "\"" + lineEnd);
            ds.writeBytes("Content-Type: image/jpeg" + lineEnd);
            ds.writeBytes("Content-Transfer-Encoding: binary" + lineEnd);
            ds.writeBytes(lineEnd);

            int maxBufferSize = 5 * 1024 * 1024;
            fs = new FileInputStream(file);
            int bytesAvailable = fs.available();
            int bufferSize = Math.min(bytesAvailable, maxBufferSize);
            byte[] buffer = new byte[bufferSize];

            int bytesRead = fs.read(buffer, 0, bufferSize);
            while (bytesRead > 0)
            {
                ds.write(buffer, 0, bufferSize);
                bytesAvailable = fs.available();
                bufferSize = Math.min(bytesAvailable, maxBufferSize);
                bytesRead = fs.read(buffer, 0, bufferSize);
            }
            ds.writeBytes(lineEnd);

            Iterator<String> keys = _params.keySet().iterator();
            while (keys.hasNext()) {
                String key = keys.next();
                String value = _params.getAsString(key);

                ds.writeBytes("--" + boundary + lineEnd);
                ds.writeBytes("Content-Disposition: form-data; name=\"" + key + "\"" + lineEnd);
                ds.writeBytes("Content-Type: text/plain" + lineEnd);
                ds.writeBytes(lineEnd);
                ds.writeBytes(value);
                ds.writeBytes(lineEnd);
            }

            ds.writeBytes("--" + boundary + "--" + lineEnd);

            if (urlConn.getResponseCode() != HttpURLConnection.HTTP_OK) {
                Log.d("Failed to upload the file.", "Failed to upload code:" + urlConn.getResponseCode() + " " + urlConn.getResponseMessage());
                return null;
            }

            InputStream is = urlConn.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is));
            String line = null;
            while((line = br.readLine())!=null) result += line;

            if(is != null) is.close();
            if(ds != null) {
                ds.flush();
                ds.close();
            }

        } catch (MalformedURLException e1) { // for URL.
            System.out.println("An error has occured.");
            result = "Can't connect the network. Please confirm the URL.";
        } catch (IOException e2) {
            System.out.println("An error has occured.");
            result = "Can't connect the network. Please confirm the URL.";
        } finally {
            if (urlConn != null)
                urlConn.disconnect();

                try {

                    if(fs != null) fs.close();
                } catch (IOException e) {
                    System.out.println("An error has occured.");
                }
        }

        return result;
    }
}
