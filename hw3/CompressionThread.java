import java.util.zip.Deflater;

public class CompressionThread extends Thread {
    private byte[] data; // Declare the data variable
    public int compressedSize;
    public byte[] output;
    
    public void setData(byte[] data) {
        this.data = data;
    }
    
    public void run() {
        this.compress();
    }

    public void write() {
        System.out.write(output, 0, compressedSize);
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
