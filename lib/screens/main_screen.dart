import 'dart:typed_data';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:pak_text/widgets/custom_button_widget.dart';
import 'package:pak_text/widgets/pak_text_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController textController = TextEditingController();
  final List<double> textSizes = [16.0, 24.0, 32.0];
  final List<Color> backgroundColors = [
    const Color(0xFF264653),
    const Color(0xFF606c38),
    const Color(0xFFf4a261),
    const Color(0xFFe63946),
    const Color(0xFF9381ff),
  ];
  final List<TextAlign> textAlignments = [
    TextAlign.right,
    TextAlign.center,
    TextAlign.left
  ];
  final List<IconData> textAlignmentIcons = [
    Icons.format_align_right,
    Icons.format_align_center,
    Icons.format_align_left
  ];
  List<String> fonts = [
    'Jameel Nastaleeq',
    'Jameel Kasheeda',
    'Faiz Nastaliq',
    'Nafees Naskh'
  ];

  int currentSizeIndex = 0;
  int currentFontIndex = 0;
  int currentColorIndex = 0;
  int currentAlignmentIndex = 0;

  // Create custom swatches from backgroundColors
  Map<ColorSwatch<Object>, String> get customSwatches {
    Map<ColorSwatch<Object>, String> swatches = {};
    for (Color color in backgroundColors) {
      swatches[ColorTools.createPrimarySwatch(color)] = color.toString();
    }
    return swatches;
  }

  Future<void> captureAndSaveScreenshot() async {
    // final Uint8List? screenshot = await screenshotController.capture();
    // final result = await ImageGallerySaver.saveImage(screenshot!);

    // Get the device height
    final deviceHeight = MediaQuery.of(context).size.height;
    // Create the non-editable mirror widget
    Widget mirrorWidget = Container(
      width: MediaQuery.of(context).size.width,
      color: backgroundColors[currentColorIndex],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: deviceHeight),
          child: Center(
            child: Text(
              textController.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: textSizes[currentSizeIndex],
                  fontFamily: fonts[currentFontIndex]),
              textAlign: textAlignments[currentAlignmentIndex],
            ),
          ),
        ),
      ),
    );

    // Capture the screenshot
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    Uint8List screenshot = await screenshotController
        .captureFromLongWidget(mirrorWidget, pixelRatio: pixelRatio);

    // Save the screenshot to the gallery
    final result = await ImageGallerySaver.saveImage(screenshot);

    final logger = Logger();

    logger.d("File Saved to Gallery: $result");
    logger.d("Pixel Ratio: $pixelRatio");
  }

  void changeTextSize() {
    setState(() {
      currentSizeIndex = (currentSizeIndex + 1) % textSizes.length;
    });
  }

  void showTextSizeSlider(
      BuildContext context, Function(double) onTextSizeChanged) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                      'Text Size: ${textSizes[currentSizeIndex].toStringAsFixed(2)}'),
                  Slider(
                    value: textSizes[currentSizeIndex],
                    min: 8.0,
                    max: 72.0,
                    onChanged: (double newValue) {
                      setState(() {
                        textSizes[currentSizeIndex] = newValue;
                      });
                      onTextSizeChanged(newValue);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void changeBackgroundColor() {
    setState(() {
      currentColorIndex = (currentColorIndex + 1) % backgroundColors.length;
    });
  }

  void showColorPicker(BuildContext context, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: backgroundColors[currentColorIndex],
              onColorChanged: onColorChanged,
              width: 44,
              height: 44,
              borderRadius: 22,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 165,
              enableShadesSelection: true,
              showRecentColors: true,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.wheel: true,
                ColorPickerType.custom: true,
                ColorPickerType.accent: false,
              },
              customColorSwatchesAndNames: customSwatches,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changeTextAlignment() {
    setState(() {
      currentAlignmentIndex =
          (currentAlignmentIndex + 1) % textAlignments.length;
    });
  }

  void changeFont() {
    setState(() {
      currentFontIndex = (currentFontIndex + 1) % fonts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors[currentColorIndex],
      body: Column(
        children: <Widget>[
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: backgroundColors[currentColorIndex],
                child: PakTextWidget(
                  fontSize: textSizes[currentSizeIndex],
                  fontFamily: fonts[currentFontIndex],
                  controller: textController,
                  textAlign: textAlignments[currentAlignmentIndex],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // this will justify the buttons
            children: [
              CustomButtonWidget(
                onPressed: () {
                  changeBackgroundColor();
                },
                onLongPress: () {
                  showColorPicker(context, (Color newColor) {
                    setState(() {
                      backgroundColors[currentColorIndex] = newColor;
                    });
                  });
                },
                icon: Icons.format_paint,
                tooltip: 'Change Background Color',
              ),
              CustomButtonWidget(
                onPressed: () {
                  changeTextSize();
                },
                onLongPress: () {
                  showTextSizeSlider(context, (double newSize) {
                    setState(() {
                      textSizes[currentSizeIndex] = newSize;
                    });
                  });
                },
                icon: Icons.format_size,
                tooltip: 'Change Text Size',
              ),
              CustomButtonWidget(
                onPressed: () {
                  changeTextAlignment();
                },
                icon: textAlignmentIcons[currentAlignmentIndex],
                tooltip: 'Change Text Alignment',
              ),
              CustomButtonWidget(
                onPressed: () {
                  changeFont();
                },
                icon: Icons.font_download_outlined,
                tooltip: 'Change Font',
              ),
              CustomButtonWidget(
                onPressed: () {
                  captureAndSaveScreenshot();
                },
                icon: Icons.camera_alt_rounded,
                tooltip: 'Take Screenshot',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
