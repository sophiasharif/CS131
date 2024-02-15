// import java.io.IOException;
// import java.util.zip.CRC32;

import java.util.zip.Deflater;

public class Pigzj {
    public static void main(String[] args) {

        
        int numThreads = Utils.getNumThreads(args);
        System.err.println("Number of threads: " + numThreads);
        Compressor compressor = new Compressor();
        compressor.init();
        compressor.compress();
        compressor.finish();
        
        // byte[] data = {};
        // Deflater deflater = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
        // deflater.setInput(data);
        // deflater.finish();
        // byte[] output = new byte[8];
        // int compressedSize = deflater.deflate(output, 0, 8, Deflater.FULL_FLUSH);
        // deflater.end();

        // System.err.println("Compressed size: " + compressedSize);
        // for (int i=0; i<output.length; i++) {
        //     System.err.println(output[i]);
        // }
    }


}