package png_2_list;

import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.imageio.ImageIO;

/**
 *
 * @author skytthe
 */
public class PNG_2_LIST {

    final static Charset ENCODING = StandardCharsets.UTF_8;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("ERROR:  Exactly one argument must be given: "
                    + "a image which will be converted to list form.");
            System.exit(1);
        }

        System.out.println("PNG_2_LIST:");
        System.out.println("Image path: " + args[0]);

        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(args[0]));
        } catch (IOException e) {
            System.err.println("ERROR: Image could not be read from file.");
            System.exit(1);
        }

        Path path = Paths.get("ROM.list");
        try (BufferedWriter writer = Files.newBufferedWriter(path, ENCODING)) {
            int i = 0;
            int pixel, a, r, g, b;
            for (int y = 0; y < img.getHeight(); y++) {
                for (int x = 0; x < img.getWidth(); x++) {
                    i++;
                    pixel = img.getRGB(x, y);
                    a = (pixel >> 24) & 0xff;
                    r = (pixel >> 16) & 0xff;
                    g = (pixel >> 8) & 0xff;
                    b = (pixel) & 0xff;
                    String p = ((r + b + g) == 0) ? "0" : "1";

                    if ((y == 0) && (x == 0)) {
                    } else {
                        writer.newLine();
                    }
                    writer.write(p);
                }
            }
            
            System.out.println("pixels: " + i);

        } catch (IOException e) {
            System.err.println("ERROR: could not create text file.");
            System.exit(1);
        }

    }

}
