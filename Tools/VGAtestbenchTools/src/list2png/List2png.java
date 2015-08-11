package list2png;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
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
public class List2png {

    final static Charset ENCODING = StandardCharsets.UTF_8;
    final static int c_image_width = 800;
    final static int c_image_height = 600;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

        int image_width = c_image_width;
        int image_height = c_image_height;
        
        System.out.println(args.length);
        
        if (args.length != 1 && args.length != 3) {
            System.err.println("ERROR:  Exactly one or three argument must be given: "
                    + "a txt file which will be converted to a png image, image width, image height");
            System.exit(1);
        }
        if (args.length == 3) {
            image_width = Integer.parseInt(args[1]);
            image_height = Integer.parseInt(args[2]);
        }
        
        System.out.println("List2png:");
        System.out.println("ROM list path: " + args[0]);

        BufferedImage img = new BufferedImage(image_width, image_height, BufferedImage.TYPE_INT_ARGB);

        Path path = Paths.get(args[0]);
        try (BufferedReader reader = Files.newBufferedReader(path, ENCODING)) {
            String line;
            int argb, a, r, g, b;
            for (int y = 0; y < image_height; y++) {
                for (int x = 0; x < image_width; x++) {
                    try {
                        line = reader.readLine();
                        try {
                            r = Integer.parseInt(line.substring(0, 3), 2);
                            g = Integer.parseInt(line.substring(3, 6), 2);
                            b = Integer.parseInt(line.substring(6, 9), 2);

                            a = 255;
                            r = (int) ((r / 7.0) * 255.0);
                            g = (int) ((g / 7.0) * 255.0);
                            b = (int) ((b / 7.0) * 255.0);
                            argb = (a << 24) | (r << 16) | (g << 8) | b;
                            img.setRGB(x, y, argb);
                        } catch (java.lang.StringIndexOutOfBoundsException e) {
                            System.err.println("StringIndexOutOfBoundsException: the string must be 9 char long");
                            System.exit(1);
                        }
                    } catch (NullPointerException e) {
                        System.err.println("NullPointerException: not enogth lines for a "
                                + image_width + "x" + image_height + " image");
                        System.exit(1);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("ERROR: data could not be read from file.");
            System.exit(1);
        }

        try {
            File outputImageFile = new File("screen.png");
            ImageIO.write(img, "png", outputImageFile);
        } catch (IOException ex) {
            System.err.println("ERROR: could not create image file.");
            System.exit(1);
        }

    }

}
