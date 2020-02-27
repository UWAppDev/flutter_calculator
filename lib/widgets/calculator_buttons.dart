import 'package:flutter/material.dart';

class CalculatorButtonsWidget extends StatelessWidget {
  CalculatorButtonsWidget({
    Key key, this.buttons, this.onButtonPress
  }) : super(key : key);

  final List<String> buttons;
  final Function onButtonPress;

  @override
  Widget build(BuildContext context) {
    final double aspect = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    final bool thinScreen = aspect < 1.0;
    final int countPerRow = thinScreen ? 4 : 8;
    final int buttonsPerRow = thinScreen ? 1 : 4;
    final int numbersPerRow = countPerRow - buttonsPerRow;
    final int rows = 10 ~/ (numbersPerRow - 1);
    final int numItems = rows * countPerRow;

    return GridView.builder(
      itemCount: numItems,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: countPerRow),
  
      
      itemBuilder: (BuildContext context, int index) {
        final int col = index % countPerRow;
        final int row = index ~/ countPerRow;

        int buttonIndex = row * buttonsPerRow + col;
        int numberDisplay = row * numbersPerRow + col - buttonsPerRow;

        String text = '';

        if (buttonIndex < buttons.length && col < buttonsPerRow) {
          text = buttons[buttonIndex];
        } else if (numberDisplay < 10 && col >= buttonsPerRow) {
          text = ((numberDisplay + 1) % 10).toString();
        } else if (buttonIndex < buttons.length && row >= rows - 1) { // Any remaining buttons?
          text = buttons[buttonIndex];
        }

        return MaterialButton(
          child: Text(text),
          onPressed: () => onButtonPress(text),
        );
      },
    );
  }
}