//This script provides an example of the Dialog window options in FIJI
//Created by Nicholas Condon, ACRF Cancer Biology Imaging Facility, UQ

print("\\Clear");																				//clears the log window

colourArray = newArray("red" , "green" , "blue");												//creates array of different colours
examplestring = ".tif";																			//creates 'default' string for dialogbox

Dialog.create("Parameters");																	//Creates the dialog box
	Dialog.addMessage("You can add custom text as a message")									//Message command (no input)
	Dialog.addChoice("Custom drop downs", newArray("Option 1", "Option 2", "Option 3"));		//Drop down box with options made as an array.
	Dialog.addString("Add input strings", examplestring);										//Text input with example text from above
 	Dialog.addNumber("or a number", random);													//Number input, with a random number generated as input
	Dialog.addCheckbox("Ticked on by default checkbox", true);									//Checkbox turned on
	Dialog.addCheckbox("Ticked off by default checkbox", false);								//Checkbox turned off
	Dialog.addRadioButtonGroup("Colours with red as default", colourArray, 1, 3, "red");		//Radio buttons using the array above, with red as default
	Dialog.addSlider("An example slider: How much I like FIJI", 0, 100, random*100);			//Slider from 0-100 with a random number as default position
Dialog.show();																					//Displays the dialog box

optionAnswer = Dialog.getChoice();																//Gets answer from dropdown box
textInput = Dialog.getString();																	//Gets answer from text input
NumberInput = Dialog.getNumber();																//Gets answer from number input
TrueCheckbox = Dialog.getCheckbox();															//Gets answer from checked box
FalseCheckbox = Dialog.getCheckbox();															//Gets answer from non-checked box
ButtonChoice = Dialog.getRadioButton();															//Gets answer from radio button
SliderChoice = Dialog.getNumber();																//Gets answer from slider
roundedSliderChoice = round(SliderChoice); 														//Rounds slider answer to whole number

print("optionAnswer = "+optionAnswer);															//Prints Drop down answer to log window
print("textInput = "+textInput);																//Prints text input answer to log window
print("NumberInput = "+NumberInput);															//Prints number input to log window
print("TrueCheckbox = "+TrueCheckbox);															//Prints checkbox Boolean value to log window
print("FalseCheckbox = "+FalseCheckbox);														//Prints checkbox Boolean value to log window
print("ButtonChoice = "+ButtonChoice);															//Prints radio button choice to log window
print("SliderChoice = "+SliderChoice);															//Prints slider output to log window
print("roundedSliderChoice = "+roundedSliderChoice);											//Prints rounded slider value to log window

print("");																						//Prints a line space
print("OR as an alternative to printing the Boolean values from the checkboxes");				//Prints the message as written
print("");																						//Prints a line space
if (TrueCheckbox == 1){print("True Checkbox is checked");}										//Sets up Boolean to say if the box is equal to 1 (ticked) print this,
	else {print("True Checkbox is not checked");}												//if box isnt infact checked, prints the alternative text
if (FalseCheckbox == 0){print("False Checkbox is not checked");}								//Sets up Boolean to say if the box is equal to 0 (unchecked) print this,
	else{print("False Checkbox is checked");}													//if the box is infact checked, prints the alternative text