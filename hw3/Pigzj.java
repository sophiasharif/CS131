// import java.io.IOException;
// import java.util.zip.CRC32;


public class Pigzj {
    public static void main(String[] args) {
        
        Compressor compressor = new Compressor(1);
        compressor.init();
        compressor.compress();
        compressor.finish();
        
    }

}