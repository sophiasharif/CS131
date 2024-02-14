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

    private void compress() {
        Deflater deflater = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
        deflater.setInput(data);
        deflater.finish();
        output = new byte[data.length+100];
        compressedSize = deflater.deflate(output);
        deflater.end();
    }
}
