import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.zip.CRC32;

public class Compressor {

    private CRC32 crc32 = new CRC32();
    private int bytesRead = 0;
    private ByteArrayOutputStream baos = new ByteArrayOutputStream();

    public void init() {

        // write header
        byte[] gzipHeader = {31, -117, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, -1};
        try { 
            baos.write(gzipHeader); 
        } catch (IOException e) {
            System.err.println("Error in writing header: " + e);
        }
    }
    
    public void compress() {
        
        try {
            // read all bytes from stdin
            // byte[] byteBuffer = System.in.readNBytes(128 * 1024);
            byte[] byteBuffer = System.in.readAllBytes();
            bytesRead += byteBuffer.length;

            // calculate crc32 of input data
            crc32.update(byteBuffer);

            // create thread
            CompressionThread t1 = new CompressionThread(byteBuffer);
            Thread thread = new Thread(t1);
            thread.start();
            thread.join();
            t1.write(baos);


        } catch (IOException | InterruptedException e) {
            System.err.println("Error: " + e.getMessage());
        }
     
    }

    public void finish() {

        try {
            
            // prepare crc32 and size of compressed data for gzip trailer
            byte[] gzipTrailer = new byte[8];
            Utils.writeInt((int) crc32.getValue(), gzipTrailer, 0);
            Utils.writeInt((int) bytesRead, gzipTrailer, 4);
            
            // write header, compressed data, and trailer to stdout
            baos.write(gzipTrailer);
            System.out.write(baos.toByteArray());

        } catch (IOException e) {
            System.err.println("Error in writing trailer: " + e.getMessage());
        }
    }
}
