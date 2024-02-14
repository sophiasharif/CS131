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
}
