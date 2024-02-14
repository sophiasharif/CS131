import java.io.IOException;
import java.util.zip.CRC32;
import java.util.zip.Deflater;
import java.nio.ByteBuffer;


public class Pigzj {
    public static void main(String[] args) {
        try {
            CRC32 crc32 = new CRC32();

            byte[] byteBuffer = System.in.readAllBytes();
            crc32.update(byteBuffer);

            Deflater deflater = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
            deflater.setInput(byteBuffer);
            deflater.finish();

            byte[] output = new byte[byteBuffer.length];
            int compressedSize = deflater.deflate(output);
            deflater.end();
            

            byte[] gzipHeader = {31, -117, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, -1};
            byte[] gzipTrailer = new byte[8];
            byte[] checksum = ByteBuffer.allocate(4).putInt((int) crc32.getValue()).array();
            byte[] dataSize = ByteBuffer.allocate(4).putInt(byteBuffer.length).array(); // Use compressedSize instead of byteBuffer.length
            System.arraycopy(checksum, 0, gzipTrailer, 0, 4);
            System.arraycopy(dataSize, 0, gzipTrailer, 4, 4);
            System.out.write(gzipHeader);
            System.out.write(output, 0, compressedSize);
            System.out.write(gzipTrailer);
        } catch (IOException e) {
            System.out.println("IO Error in reading bytes: " + e.getMessage());
        }
        
    }
}