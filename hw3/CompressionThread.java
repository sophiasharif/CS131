import java.io.ByteArrayOutputStream;
import java.util.zip.Deflater;

public class CompressionThread implements Runnable{
    private byte[] data; // Declare the data variable
    public int compressedSize;
    public byte[] output;
    
    CompressionThread(byte[] data) {
        this.data = data;
    }
    
    public void run() {
        this.compress();
    }

    public void write(ByteArrayOutputStream baos) {
        baos.write(output, 0, compressedSize);
    }

    private void compress() {
        Deflater deflater = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
        deflater.setInput(data);
        // deflater.finish();
        output = new byte[data.length+10];
        compressedSize = deflater.deflate(output, 0, data.length+10, Deflater.SYNC_FLUSH);
        deflater.end();
    }
}
