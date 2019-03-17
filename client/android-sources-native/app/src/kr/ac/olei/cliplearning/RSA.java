package com.codymonster.ibeobom;

import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.PrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
import javax.crypto.Cipher;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.UnsupportedEncodingException;
import android.util.Base64;
import android.util.Log;
import java.lang.NullPointerException;
import java.lang.IllegalArgumentException;
import java.lang.UnsupportedOperationException;

public class RSA {

    private Cipher mEcipher;
    private Cipher mDcipher;

    private String mPublicKey = "";
    private String mPrivateKey = "";
    public void setPublicKey(String key) { mPublicKey = key; }
    public void setPrivateKey(String key) { mPrivateKey = key; }

    public String encrypted(String str) {
        String result = "untitled";
        try {
            if(mPublicKey==null || mPublicKey.isEmpty()) return result;
            X509EncodedKeySpec mPublicKeySpec = new X509EncodedKeySpec(Base64.decode(getKeyPublicOnly(mPublicKey), Base64.DEFAULT));
            PublicKey pbKey = KeyFactory.getInstance("RSA").generatePublic(mPublicKeySpec);
            mEcipher = Cipher.getInstance("RSA");
            if(mEcipher != null)
            {
                mEcipher.init(Cipher.ENCRYPT_MODE, pbKey);
                byte[] utf8 = str.getBytes("UTF8");
                byte[] enc = mEcipher.doFinal(utf8);
                result = Base64.encodeToString(enc, Base64.URL_SAFE|Base64.NO_WRAP);
            }
        } catch (NullPointerException e) { //X509EncodedKeySpec
            System.out.println("An error has occured.");
        } catch (IllegalArgumentException e) { //Base64.decode
            System.out.println("An error has occured.");
        } catch (InvalidKeySpecException e) { //generatePublic
            System.out.println("An error has occured.");
        } catch (InvalidKeyException e) { //generatePublic
            System.out.println("An error has occured.");
        } catch (UnsupportedOperationException e) { //generatePublic
            System.out.println("An error has occured.");
        } catch (NoSuchAlgorithmException e) { //Cipher
            System.out.println("An error has occured.");
        } catch (NoSuchPaddingException	e) { //Cipher
            System.out.println("An error has occured.");
        } catch (IllegalBlockSizeException e) { //Cipher
            System.out.println("An error has occured.");
        } catch (UnsupportedEncodingException e) {
            System.out.println("An error has occured.");
        } catch (BadPaddingException e) {
            System.out.println("An error has occured.");
        }

        return result;
    }

    public String decrypted(String str) {
        String result = "untitled";
        try {
            if(mPrivateKey==null || mPrivateKey.isEmpty()) return result;
            PKCS8EncodedKeySpec mPrivateKeySpec = new PKCS8EncodedKeySpec(Base64.decode(getPrivateKeyOnly(mPrivateKey), Base64.DEFAULT));
            PrivateKey pvKey = KeyFactory.getInstance("RSA").generatePrivate(mPrivateKeySpec);
            mDcipher = Cipher.getInstance("RSA");
            if(mDcipher != null)
            {
                mDcipher.init(Cipher.DECRYPT_MODE, pvKey);
                byte[] dec = Base64.decode(str, Base64.URL_SAFE|Base64.NO_WRAP);
                byte[] utf8 = mDcipher.doFinal(dec);
                result = new String(utf8, "UTF8");
            }
        } catch (NullPointerException e) { //X509EncodedKeySpec
            System.out.println("An error has occured.");
        } catch (IllegalArgumentException e) { //Base64.decode
            System.out.println("An error has occured.");
        } catch (InvalidKeySpecException e) { //generatePublic
            System.out.println("An error has occured.");
        } catch (InvalidKeyException e) { //generatePublic
            System.out.println("An error has occured.");
        } catch (UnsupportedOperationException e) { //generatePublic
            System.out.println("An error has occured.");
        } catch (NoSuchAlgorithmException e) { //Cipher
            System.out.println("An error has occured.");
        } catch (NoSuchPaddingException e) { //Cipher
            System.out.println("An error has occured.");
        } catch (IllegalBlockSizeException e) { //Cipher
            System.out.println("An error has occured.");
        } catch (UnsupportedEncodingException e) {
            System.out.println("An error has occured.");
        } catch (BadPaddingException e) {
            System.out.println("An error has occured.");
        }

        return result;
    }

    public String getKeyPublicOnly(String key){
        key = key.replaceAll("-----BEGIN PUBLIC KEY-----", "")
                 .replaceAll("-----END PUBLIC KEY-----", "")
                 .replaceAll("\n","")
                 .trim();
        return key;
    }

    public String getPrivateKeyOnly(String key){
        key = key.replaceAll("-----BEGIN PRIVATE KEY-----", "")
                 .replaceAll("-----END PRIVATE KEY-----", "")
                 .replaceAll("\n","")
                 .trim();
        return key;
    }
}
