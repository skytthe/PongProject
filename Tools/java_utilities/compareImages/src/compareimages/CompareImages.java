/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package compareimages;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

/**
 *
 * @author skytthe
 */
public class CompareImages {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("ERROR:  Exactly two argument must be given: "
                    + "the two images which will be compared.");
            System.exit(1);
        }

        System.out.println("reading input images from: ");
        System.out.println("   args[0]");
        System.out.println("   args[1]");
        
        BufferedImage img1 = null;
        BufferedImage img2 = null;
        try {
            img1 = ImageIO.read(new File(args[0]));
            img2 = ImageIO.read(new File(args[1]));
        } catch (IOException e) {
            System.err.println("ERROR: Image could not be read from file.");
            System.exit(1);
        }

        if (img1.getWidth() == img2.getWidth() && img1.getHeight() == img2.getHeight()) {
            for (int y = 0; y < img1.getHeight(); y++) {
                for (int x = 0; x < img1.getWidth(); x++) {
                    if (img1.getRGB(x, y) != img2.getRGB(x, y)) {
                        System.err.println("ERROR: pixel x=" + x + " y=" + y + " do not have same color");
                        System.exit(1);
                    }
                }
            }
        } else {
            System.err.println("ERROR: the images do not have the same dimensions.");
            System.exit(1);
        }
        
        System.out.println("SUCCESS: the two images are identical");
    }

}
