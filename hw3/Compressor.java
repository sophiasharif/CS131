import java.io.IOException;
import java.util.zip.CRC32;
import java.util.zip.Deflater;

public class Compressor {

    CRC32 crc32 = new CRC32();
    int bytesRead = 0;
    CompressionThread[] threads;

    Compressor(int num_threads) {
        // initialize threads
        threads = new CompressionThread[num_threads];
    }

    public void writeHeader() {

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
            byte[] byteBuffer = {0}; // initialize to non-empty array so loop starts
            
            while (byteBuffer.length != 0) {
                System.err.println("iteration!");
                int i;

                for (i=0; i < threads.length; i++) {


                    // NEXT STEPS:
                    // 0) debug large file
                    // 1) separate the join and write steps into other for loops
                    // 2) make sure you can create multiple threads

                    // read a block
                    byteBuffer = System.in.readNBytes(128 * 1024);
                    if (byteBuffer.length == 0) {
                        break; 
                    }

                    // CREATE THREAD
                    // threads[i] = new CompressionThread();

                    // update metadata
                    bytesRead += byteBuffer.length;
                    System.err.println("Bytes read: " + bytesRead);
                    crc32.update(byteBuffer);

                    // no thread test
                    Deflater deflater = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
                    deflater.setInput(byteBuffer);
                    deflater.finish();
                    byte[] output = new byte[byteBuffer.length+100];
                    int compressedSize = deflater.deflate(output);
                    deflater.end();
                    System.out.write(output, 0, compressedSize);

                    // COMPRESS DATA
                    // threads[i].setData(byteBuffer);
                    // threads[i].start();
                    // threads[i].join();
                    // threads[i].write();
                }

            }

        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
        }
     
    }

    public void writeTrailer() {

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
