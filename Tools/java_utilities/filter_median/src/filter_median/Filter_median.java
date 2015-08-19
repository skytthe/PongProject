/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filter_median;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import javax.imageio.ImageIO;

/**
 *
 * @author skytthe
 */
public class Filter_median {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        int radiusX = 1;
        int radiusY = 1;
        String output_path = "";

        if (args.length != 4) {
            System.err.println("ERROR:  Exactly one argument must be given: "
                    + "input_image, radiusX, radiusY, output_path");
            System.exit(1);
        }

        System.out.println("reading input image from: " + args[0]);

        BufferedImage img = null;
        try {
            img = ImageIO.read(new File(args[0]));
            radiusX = Integer.parseInt(args[1]);
            radiusY = Integer.parseInt(args[2]);
            output_path = args[3];
        } catch (IOException e) {
            System.err.println("ERROR: Image could not be read from file.");
            System.exit(1);
        }

        System.out.println("running median filter:");
        for (int y = -radiusY; y <= radiusY; y++) {
            System.out.print("  ");
            for (int x = -radiusX; x <= radiusX; x++) {
                if (x == 0 && y == 0) {
                    System.out.print("o");
                } else {
                    System.out.print("x");
                }
            }
            System.out.println("");
        }

        BufferedImage img_filter = new BufferedImage(img.getWidth(), img.getHeight(), BufferedImage.TYPE_INT_ARGB);

        int a, r, g, b, argb;
        for (int y = 0; y < img.getHeight(); y++) {
            for (int x = 0; x < img.getWidth(); x++) {
                //generate array with pixels from box
                int[][] pixels = new int[4][(2 * radiusX + 1) * (2 * radiusY + 1)];

                int startX = x - radiusX;
                int endX = x + radiusX;
                int startY = y - radiusY;
                int endY = y + radiusY;

                int i = 0;
                for (int boxY = startY; boxY <= endY; boxY++) {
                    for (int boxX = startX; boxX <= endX; boxX++) {
                        try {
                            int pixel = img.getRGB(boxX, boxY);
                            pixels[0][i] = (pixel >> 24) & 0xff;
                            pixels[1][i] = (pixel >> 16) & 0xff;
                            pixels[2][i] = (pixel >> 8) & 0xff;
                            pixels[3][i] = (pixel) & 0xff;
                        } catch (ArrayIndexOutOfBoundsException e) {
                            pixels[0][i] = 255;
                            pixels[1][i] = 0;
                            pixels[2][i] = 0;
                            pixels[3][i] = 0;
                        }
                        i++;
                    }
                }

                for (int[] pixelChannel : pixels) {
                    Arrays.sort(pixelChannel);
                }

                a = pixels[0][pixels[0].length / 2];
                r = pixels[1][pixels[1].length / 2];
                g = pixels[2][pixels[2].length / 2];
                b = pixels[3][pixels[3].length / 2];

                argb = (a << 24) | (r << 16) | (g << 8) | b;
                img_filter.setRGB(x, y, argb);
            }
        }

        System.out.println("writing image file to: " + output_path + "filter_median.png");

        try {
            File outputImageFile = new File(output_path + "filter_median.png");
            ImageIO.write(img_filter, "png", outputImageFile);
        } catch (IOException ex) {
            System.err.println("ERROR: could not create image file.");
            System.exit(1);
        }

        System.out.println("done!");
    }

}
