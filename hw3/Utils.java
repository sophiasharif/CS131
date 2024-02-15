import java.io.IOException;

public class Utils {
    
    public static void writeInt(int i, byte[] byteArray, int dest) throws IOException {
        writeShort(i & '\uffff', byteArray, dest);
        writeShort(i >> 16 & '\uffff', byteArray, dest+2);
    }

    public static void writeShort(int s, byte[] byteArray, int dest) throws IOException {
        byteArray[dest] = (byte)(s & 255);
        byteArray[dest + 1] = (byte) (s >> 8 & 255);
    }

    public static int getNumThreads(String[] args) {

        if (args.length > 0)  {
            if (args.length != 2 || !("-p".equals(args[0]))) {
                System.err.println("Usage: java Pigzj -p <int>");
                System.exit(1);
            }
            try {
                int pValue = Integer.parseInt(args[1]);

                // non negative, not 0, greater than number of cores

                return pValue;
            } catch (NumberFormatException e) {
                System.err.println("Error: -p must be followed by an integer.");
                System.exit(1);
            }
        }
        return Runtime.getRuntime().availableProcessors();
    }
}
