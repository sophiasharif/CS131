import java.io.IOException;
import java.util.zip.CRC32;

public class Compressor {
    public void compress() {
        try {

            // write header
            byte[] gzipHeader = {31, -117, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, -1};
            System.out.write(gzipHeader);

            // read all bytes from stdin
            byte[] byteBuffer = System.in.readNBytes(128 * 1024);

            // calculate crc32 of input data
            CRC32 crc32 = new CRC32();
            crc32.update(byteBuffer);

            // create thread
            CompressionThread t1 = new CompressionThread(byteBuffer);
            Thread thread = new Thread(t1);
            thread.start();
            thread.join();
            t1.write();
            
            // prepare crc32 and size of compressed data for gzip trailer
            byte[] gzipTrailer = new byte[8];
            Utils.writeInt((int) crc32.getValue(), gzipTrailer, 0);
            Utils.writeInt((int) byteBuffer.length, gzipTrailer, 4);
            
            // write header, compressed data, and trailer to stdout
            System.out.write(gzipTrailer);


        } catch (IOException | InterruptedException e) {
            System.out.println("Error: " + e.getMessage());
        }
     
    }
}
