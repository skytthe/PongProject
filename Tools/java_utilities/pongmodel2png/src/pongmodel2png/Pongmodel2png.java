/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pongmodel2png;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import model.PongModel;

/**
 *
 * @author skytthe
 */
public class Pongmodel2png {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

        int width = 800;
        int height = 600;
        int bat1Pos = 251;
        int bat2Pos = 251;
        int ballPosX = 350;
        int ballPosY = 291;

        String output_path = "";

        if (args.length != 0 && args.length != 7) {
            System.err.println("ERROR:  Exactly zero or six argument must be given: "
                    + "width,height, bat1Pos, bat2Pos, ballPosX, ballPosY, output_path");
            System.exit(1);
        }

        if (args.length == 7) {
            width = Integer.parseInt(args[0]);
            height = Integer.parseInt(args[1]);
            bat1Pos = Integer.parseInt(args[2]);
            bat2Pos = Integer.parseInt(args[3]);
            ballPosX = Integer.parseInt(args[4]);
            ballPosY = Integer.parseInt(args[5]);
            output_path = args[6];
        }

        System.out.println("generating pong model:");
        System.out.println("- width    = " + width);
        System.out.println("- height   = " + height);
        System.out.println("- bat1Pos  = " + bat1Pos);
        System.out.println("- bat2Pos  = " + bat2Pos);
        System.out.println("- ballPosX = " + ballPosX);
        System.out.println("- ballPosY = " + ballPosY);
        
        PongModel model = new PongModel(width, height, bat1Pos, bat2Pos, ballPosX, ballPosY);

        System.out.println("writing image file to: " + output_path + "pongmodel.png");
        
        try {
            File outputModelFile = new File(output_path + "pongmodel.png");
            BufferedImage imgModel = model.getImageOfModel();
            ImageIO.write(imgModel, "png", outputModelFile);
        } catch (IOException ex) {
            Logger.getLogger(PongModel.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        System.out.println("done!");
    }

}
