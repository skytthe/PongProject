/*
 * The MIT License
 *
 * Copyright 2015 skytthe.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package model;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

/**
 *
 * @author skytthe
 */
public class PongModel {

    //constants
    private static final int batWidth = 19;
    private static final int batHeight = 99;
    private static final int ballWidth = 19;
    private static final int ballHeight = 19;

    private static final int bat1Offset = 21;
    private static final int bat2Offset = 761;
    private static final int ballOffset = 41;

    private int width;
    private int height;

    private int[][] noiseModel;
    private int noiseModelWidth;
    private int noiseModelHeight;
    private int[][] objectModel;
    private int objectModelWidth;
    private int objectModelHeight;

    private int[][] model;
    private int[][] goal;
    private int bat1Position;
    private int bat2Position;
    private int ballXposition;
    private int ballYposition;

    public PongModel(int width, int height, int bat1Position, int bat2Position,
            int ballXposition, int ballYposition) {
        this.width = width;
        this.height = height;

        try {
            String fgPath = "/resources/fg.png";
            String bgPath = "/resources/bg.png";

            InputStream fgPathStream =  PongModel.class.getResourceAsStream(fgPath);
            InputStream bgPathStream =  PongModel.class.getResourceAsStream(bgPath);
            
            BufferedImage fg = ImageIO.read(fgPathStream);
            BufferedImage bg = ImageIO.read(bgPathStream);

            int pixel, r, b, g, a;
            //create background noise model
            noiseModelWidth = bg.getWidth();
            noiseModelHeight = bg.getHeight();
            noiseModel = new int[noiseModelHeight][noiseModelWidth];
            for (int y = 0; y < noiseModelHeight; y++) {
                for (int x = 0; x < noiseModelWidth; x++) {
                    pixel = bg.getRGB(x, y);
                    a = (pixel >> 24) & 0xff;
                    r = (pixel >> 16) & 0xff;
                    g = (pixel >> 8) & 0xff;
                    b = (pixel) & 0xff;
                    noiseModel[y][x] = ((r + b + g) == 0) ? 0 : 1;
                }
            }
            //create bat and ball model
            objectModelWidth = fg.getWidth();
            objectModelHeight = fg.getHeight();
            objectModel = new int[objectModelHeight][objectModelWidth];
            for (int y = 0; y < objectModelHeight; y++) {
                for (int x = 0; x < objectModelWidth; x++) {
                    pixel = fg.getRGB(x, y);
                    a = (pixel >> 24) & 0xff;
                    r = (pixel >> 16) & 0xff;
                    g = (pixel >> 8) & 0xff;
                    b = (pixel) & 0xff;
                    objectModel[y][x] = ((r + b + g) == 0) ? 0 : 1;
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(PongModel.class.getName()).log(Level.SEVERE, null, ex);
        }

        generatePongModel(bat1Position, bat2Position,
                ballXposition, ballYposition);
    }

    public void generateRandomConfig() {
        //TODO: add randomness
        generatePongModel(250, 250, 390, 290);
    }

    public final void generatePongModel(int bat1Position, int bat2Position,
            int ballXposition, int ballYposition) {
        this.bat1Position = bat1Position;
        this.bat2Position = bat2Position;
        this.ballXposition = ballXposition;
        this.ballYposition = ballYposition;

        model = new int[height][width];
        goal = new int[height][width];

        //generate background
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                model[y][x] = noiseModel[y % noiseModelHeight][x % noiseModelWidth];
            }
        }
//        //generate bat1 & bat2
//        for (int y = 0; y < batHeight; y++) {
//            for (int x = 0; x < batWidth; x++) {
//                //bat1
//                model[this.bat1Position + y][bat1Offset + x] = objectModel[y % objectModelHeight][x % objectModelWidth];
//                goal[this.bat1Position + y][bat1Offset + x] = 1;
//                //bat2
//                model[this.bat2Position + y][bat2Offset + x] = objectModel[y % objectModelHeight][x % objectModelWidth];
//                goal[this.bat2Position + y][bat2Offset + x] = 1;
//            }
//        }
//        //generate ball
//        for (int y = 0; y < ballHeight; y++) {
//            for (int x = 0; x < ballWidth; x++) {
//                //ball
//                model[this.ballYposition + y][this.ballXposition + ballOffset + x] = objectModel[y % objectModelHeight][x % objectModelWidth];
//                goal[this.ballYposition + y][this.ballXposition + ballOffset + x] = 1;
//            }
//        }
    }

    public BufferedImage getImageOfModel() {
        BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        int argb, a, r, g, b;
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                a = 255;
                r = model[y][x] * 255;
                g = model[y][x] * 255;
                b = model[y][x] * 255;
                argb = (a << 24) | (r << 16) | (g << 8) | b;
                img.setRGB(x, y, argb);
            }
        }
        return img;
    }

    public BufferedImage getImageOfGoal() {
        BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        int argb, a, r, g, b;
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                a = goal[y][x] * 255;
                r = 0;
                g = 0;
                b = goal[y][x] * 255;
                argb = (a << 24) | (r << 16) | (g << 8) | b;
                img.setRGB(x, y, argb);
            }
        }
        return img;
    }

}
