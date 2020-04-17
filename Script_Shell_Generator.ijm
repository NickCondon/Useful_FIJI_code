print("\\Clear");
print("print(\"\\\\Clear\");");
Dialog.create("Details Box");
Dialog.addString("Script Title: ", "Title");
Dialog.addString("Version", "0.0");
Dialog.addString("Description", "Description");
Dialog.addMessage("Note: you can use <br> for a line break");
Dialog.addString("File Extension: ", ".tif");
Dialog.addCheckbox("Generate Summary File?" , 1);
Dialog.show();
printedTitle = Dialog.getString();
printedVersion = Dialog.getString();
printedDescription = Dialog.getString();
ext = Dialog.getString();
summary = Dialog.getCheckbox();
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
if (dayOfMonth<10) {dayOfMonth = "0" + toString(dayOfMonth);}
month = month+1;
if (month<10) {month = "0" + month;}
printedDate = toString(dayOfMonth) + "-" + month + "-" + year;
print("//	MIT License");
print("//	Copyright (c) "+year+" Nicholas Condon n.condon@uq.edu.au");
print("//	Permission is hereby granted, free of charge, to any person obtaining a copy");
print("//	of this software and associated documentation files (the \"Software\"), to deal");
print("//	in the Software without restriction, including without limitation the rights");
print("//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell");
print("//	copies of the Software, and to permit persons to whom the Software is");
print("//	furnished to do so, subject to the following conditions:");
print("//	The above copyright notice and this permission notice shall be included in all");
print("//	copies or substantial portions of the Software.");
print("//	THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR");
print("//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,");
print("//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE");
print("//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER");
print("//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,");
print("//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE");
print("//	SOFTWARE.");
print("scripttitle= "+"\""+printedTitle+"\";");
print("version= "+"\""+printedVersion+"\";");
print("date= "+"\""+printedDate+"\";");
print("description= "+"\""+printedDescription+"\";");
print("showMessage(\"Institute for Molecular Biosciences ImageJ Script\", \"<html>"); 
print("    +\"<h1><font size=6 color=Teal>ACRF: Cancer Biology Imaging Facility</h1>");
print("    +\"<h1><font size=5 color=Purple><i>The University of Queensland</i></h1>");
print("    +\"<h4><a href=http://imb.uq.edu.au/Microscopy/>ACRF: Cancer Biology Imaging Facility</a><\h4>");
print("    +\"<h1><font color=black>ImageJ Script Macro: \"+scripttitle+\"</h1> ");
print("    +\"<p1>Version: \"+version+\" (\"+date+\")</p1>\"");
print("    +\"<H2><font size=3>Created by Nicholas Condon</H2>\"	");
print("    +\"<p1><font size=2> contact n.condon@uq.edu.au \\n </p1>\" ");
print("    +\"<P4><font size=2> Available for use/modification/sharing under the \"+\"<p4><a href=https://opensource.org/licenses/MIT/>MIT License</a><\h4> </P4>\"");
print("    +\"<h3>   <\h3>\"    ");
print("    +\"<p1><font size=3 \b i>\"+description+\"</p1>");
print("    +\"<h1><font size=2> </h1>\"  ");
print("	   +\"<h0><font size=5> </h0>\"");
print("    +\"\");");

	
print("print(\"\");");
print("print(\"FIJI Macro: \"+scripttitle);");
print("print(\"Version: \"+version+\" Version Date: \"+date);");
print("print(\"ACRF: Cancer Biology Imaging Facility\");");
print("print(\"By Nicholas Condon ("+year+") n.condon@uq.edu.au\")");
print("print(\"\");");
print("getDateAndTime(year, month, week, day, hour, min, sec, msec);");
print("print(\"Script Run Date: \"+day+\"/\"+(month+1)+\"/\"+year+\"  Time: \" +hour+\":\"+min+\":\"+sec);");
print("print(\"\");");
print("");

print("//Directory Warning and Instruction panel     ");
print("Dialog.create(\"Choosing your working directory.\");");
print(" 	Dialog.addMessage(\"Use the next window to navigate to the directory of your images.\");");
print("  	Dialog.addMessage(\"(Note a sub-directory will be made within this folder for output files) \");");
print("  	Dialog.addMessage(\"Take note of your file extension (eg .tif, .czi)\");");
print("Dialog.show(); ");

print("");

print("//Directory Location");
print("path = getDirectory(\"Choose Source Directory \");");
print("list = getFileList(path);");
print("getDateAndTime(year, month, week, day, hour, min, sec, msec);");

print("");

print("ext = \""+ext+"\";");
print("Dialog.create(\"Settings\");");
print("Dialog.addString(\"File Extension: \", ext);");
print("Dialog.addMessage(\"(For example .czi  .lsm  .nd2  .lif  .ims)\");");
print("Dialog.show();");
print("ext = Dialog.getString();");
print("");
print("start = getTime();");
print("");
print("//Creates Directory for output images/logs/results table");
print("resultsDir = path+\"_Results_\"+\"_\"+year+\"-\"+month+\"-\"+day+\"_at_\"+hour+\".\"+min+\"/\"; ");
print("File.makeDirectory(resultsDir);");
print("print(\"Working Directory Location: \"+path);");

if (summary ==1){
print("summaryFile = File.open(resultsDir+\"Results_\"+\"_\"+year+\"-\"+month+\"-\"+day+\"_at_\"+hour+\".\"+min+\".xls\");");
print("print(summaryFile,\"Image Name \\t Image Number \\t Number of Objects Found \\t Object ID\");");
}
print("");print("");
print("for (z=0; z<list.length; z++) {");
print("if (endsWith(list[z],ext)){");
print("");
print("		run(\"Bio-Formats Importer\", \"open=[\"+path+list[z]+\"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT\");");
print("		run(\"Clear Results\");");
print("		roiManager(\"reset\");");

print("		windowtitle = getTitle();");
print("		windowtitlenoext = replace(windowtitle, ext, \"\");");
print("		print(\"Opening File: \"+(z+1)+\" of \"+list.length+\"  Filename: \"+windowtitle);");
print("");print("");print("");print("");
print("//########## INSERT SCRIPT HERE");
print("");print("");print("");print("");
print("		}}");
print("		selectWindow(\"Log\");");								
print("		saveAs(\"Text\", \"Log.txt\");");
print("//exit message to notify user that the script has finished.");
print("title = \"Batch Completed\";");
print("msg = \"Put down that coffee! Your analysis is finished\";");
print("waitForUser(title, msg);");
