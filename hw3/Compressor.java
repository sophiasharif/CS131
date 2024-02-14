import java.io.IOException;
import java.util.zip.CRC32;

public class Compressor {

    CRC32 crc32 = new CRC32();
    int bytesRead = 0;
    CompressionThread[] threads;

    Compressor(int num_threads) {
        threads = new CompressionThread[num_threads];
        for (int i=0; i < threads.length; i++) {
            threads[i] = new CompressionThread();
        }
    }

    public void init() {

        // write header
        byte[] gzipHeader = {31, -117, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, -1};
        try { 
            System.out.write(gzipHeader); 
        } catch (IOException e) {
            System.err.println("Error in writing header: " + e);
        }
    }
    
    public void compress() {
        
        try {
            // read all bytes from stdin
            byte[] byteBuffer = System.in.readNBytes(128 * 1024);
            bytesRead += byteBuffer.length;

            // calculate crc32 of input data
            crc32.update(byteBuffer);

            // create thread
            threads[0].setData(byteBuffer);
            threads[0].start();
            threads[0].join();
            threads[0].write();


        } catch (IOException | InterruptedException e) {
            System.out.println("Error: " + e.getMessage());
        }
     
    }

    public void finish() {

        try {
            
            // prepare crc32 and size of compressed data for gzip trailer
            byte[] gzipTrailer = new byte[8];
            Utils.writeInt((int) crc32.getValue(), gzipTrailer, 0);
            Utils.writeInt((int) bytesRead, gzipTrailer, 4);
            
            // write header, compressed data, and trailer to stdout
            System.out.write(gzipTrailer);

        } catch (IOException e) {
            System.out.println("Error in writing trailer: " + e.getMessage());
        }
    }
}
