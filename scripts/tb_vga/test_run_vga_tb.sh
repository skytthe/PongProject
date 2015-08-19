#generel settings
WIDTH="800"
HEIGHT="600"
BAT1="251"
BAT2="251"
BALL_X="350"
BALL_Y="291"
OUTPUT_PATH="res/"

#Test type
TEST_TYPE="FILTER"
#TEST_TYPE="GRAPHICS"

#Pongmodel2png settings
PONG_IMAGE_NAME="pongmodel.png"

#Filter settings
FILTER_MED_RADIUS_X="1"
FILTER_MED_RADIUS_Y="1"
FILTER_IMAGE_NAME="filter_median.png"


echo "############################################################"
echo "##                                                        ##"
echo "## Run automated VGA testbench                            ##"
echo "##                                                        ##"
echo "############################################################"
echo "## test type: "$TEST_TYPE
echo "## screen resolution: "$WIDTH"x"$HEIGHT
echo "## Bat1 position: "$BAT1
echo "## Bat2 position: "$BAT2
echo "## Ball position: "$BALL_X","$BALL_Y

#clean up
rm -rf build
rm -rf res

#create build and res folders
mkdir build
mkdir res

#replace running ISIM simulation
cp data_output.txt res/.

echo "############################################################"
echo "## Generate Pong game image                               ##"
echo "############################################################"

#args: width, height, bat1Pos, bat2Pos, ballPosX, ballPosY, output_path
java -jar "../../Tools/java_utilities/pongmodel2png/dist/pongmodel2png.jar" $WIDTH $HEIGHT $BAT1 $BAT2 $BALL_X $BALL_Y $OUTPUT_PATH

echo "############################################################"
echo "## Generate Goal image                                    ##"
echo "############################################################"

#args: input_image, radiusX, radiusY, output_path
java -jar "../../Tools/java_utilities/filter_median/dist/filter_median.jar" $OUTPUT_PATH$PONG_IMAGE_NAME $FILTER_MED_RADIUS_X $FILTER_MED_RADIUS_Y $OUTPUT_PATH


echo "############################################################"
echo "## Generate rom list from pong game image                 ##"
echo "############################################################"

#args: input_image, output_path
java -jar "../../Tools/java_utilities/png2list/dist/png2list.jar" $OUTPUT_PATH$PONG_IMAGE_NAME $OUTPUT_PATH


echo "############################################################"
echo "## Generate output image from ISIM result                 ##"
echo "############################################################"

#args: input_list, width, height, output_path
java -jar "../../Tools/java_utilities/list2png/dist/list2png.jar" $OUTPUT_PATH"data_output.txt" $WIDTH $HEIGHT $OUTPUT_PATH


echo "############################################################"
echo "## Compare goal image with output image from ISIM result  ##"
echo "############################################################"

#args: image1, image2
java -jar "../../Tools/java_utilities/compareImages/dist/compareImages.jar" $OUTPUT_PATH$FILTER_IMAGE_NAME $OUTPUT_PATH"screen.png"

echo "############################################################"
echo "## open image(s) for visual inspection                    ##"
echo "############################################################"

open res/screen.png
