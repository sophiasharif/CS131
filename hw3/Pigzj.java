import java.io.IOException;

public class Pigzj {
    public static void main(String[] args) {

        try {
            if (System.in.available() == 0) {
                // No input was passed to standard input
                System.out.println("No input was passed to standard input.");
                System.exit(1);
            }
        } catch (IOException e) {
            System.err.println("I/O Error: " + e.getMessage());
        }
        
        
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