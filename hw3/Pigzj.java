public class Pigzj {
    public static void main(String[] args) {
        Utils.checkForInput();
        int numThreads = Utils.getNumThreads(args);
        Compressor compressor = new Compressor(numThreads);
        compressor.init();
        compressor.compress();
        compressor.finish();
    }
}