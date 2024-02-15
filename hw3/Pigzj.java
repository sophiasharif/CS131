public class Pigzj {
    public static void main(String[] args) {
        Utils.checkForInput();
        int numThreads = Utils.getNumThreads(args);
        System.err.println("Number of threads: " + numThreads);
        Compressor compressor = new Compressor();
        compressor.init();
        compressor.compress();
        compressor.finish();
    }
}