import java.io.ByteArrayOutputStream;
import java.util.zip.Deflater;

public class CompressionThread extends Thread {
    private byte[] data; 
    private int compressedSize;
    private byte[] output;
    
    CompressionThread(byte[] data) {
        this.data = data;
    }
    
    public void run() {
        Deflater deflater = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
        deflater.setInput(data);
        output = new byte[data.length+10];
        compressedSize = deflater.deflate(output, 0, data.length+10, Deflater.SYNC_FLUSH);
        deflater.end();
    }

    public void write(ByteArrayOutputStream baos) {
        baos.write(output, 0, compressedSize);
    }
}
