import java.io.IOException;
import java.util.zip.CRC32;


public class Pigzj {
    public static void main(String[] args) {
        
        try {

            // read all bytes from stdin
            byte[] byteBuffer = System.in.readAllBytes();

            // calculate crc32 of input data
            CRC32 crc32 = new CRC32();
            crc32.update(byteBuffer);

            // create threads
            CompressionThread t1 = new CompressionThread(byteBuffer);
            Thread thread = new Thread(t1);
            thread.start();

            // wait for compression data
            thread.join();
            
            // prepare crc32 and size of compressed data for gzip trailer
            byte[] gzipHeader = {31, -117, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, -1};
            byte[] gzipTrailer = new byte[8];
            writeInt((int) crc32.getValue(), gzipTrailer, 0);
            writeInt((int) byteBuffer.length, gzipTrailer, 4);
            
            // write header, compressed data, and trailer to stdout
            System.out.write(gzipHeader);
            System.out.write(t1.output, 0, t1.compressedSize);
            System.out.write(gzipTrailer);


        } catch (IOException | InterruptedException e) {
            System.out.println("Error: " + e.getMessage());
        }
        
    }

    public static void writeInt(int i, byte[] byteArray, int dest) throws IOException {
        writeShort(i & '\uffff', byteArray, dest);
        writeShort(i >> 16 & '\uffff', byteArray, dest+2);
    }

    public static void writeShort(int s, byte[] byteArray, int dest) throws IOException {
        byteArray[dest] = (byte)(s & 255);
        byteArray[dest + 1] = (byte) (s >> 8 & 255);
    }

}