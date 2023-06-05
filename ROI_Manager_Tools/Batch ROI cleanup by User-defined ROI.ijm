print("\\Clear")

//	MIT License

//	Copyright (c) 2019 Nicholas Condon n.condon@uq.edu.au

//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:

//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.

//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.


//IMB Macro Splash screen (Do not remove this acknowledgement)
scripttitle="Batch ROI cleanup by User-defined ROI";
version="1.0";
versiondate="05/06/2023";
description="This is a tool to delete already saved ROIs by a single ROI defined by the user"
+"First, point at the directory of saved ROIs ending in .zip.<br><br> "
+"Second, choose a representative image from which these ROIs were generated (same dimensions). <br><br> "
+"Lastly, draw a ROI (square shaped) around the area you want to keep. Saved ROIs will be a COPY with the suffix   _sanitiedbyROI.zip"
    
    showMessage("Institute for Molecular Biosciences ImageJ Script", "<html>" 
    +"<h1><font size=6 color=Teal>ACRF: Cancer Biology Imaging Facility</h1>
    +"<h1><font size=5 color=Purple><i>The Institute for Molecular Bioscience <br> The University of Queensland</i></h1>
    +"<h4><a href=http://imb.uq.edu.au/Microscopy/>ACRF: Cancer Biology Imaging Facility</a><\h4>"
    +"<h1><font color=black>ImageJ Script Macro: "+scripttitle+"</h1> "
    +"<p1>Version: "+version+" ("+versiondate+")</p1>"
    +"<H2><font size=3>Created by Nicholas Condon</H2>"	
    +"<p1><font size=2> contact n.condon@uq.edu.au \n </p1>" 
    +"<P4><font size=2> Available for use/modification/sharing under the "+"<p4><a href=https://opensource.org/licenses/MIT/>MIT License</a><\h4> </P4>"
    +"<h3>   <\h3>"    
    +"<p1><font size=3 \b i>"+description+".</p1>"
   	+"<h1><font size=2> </h1>"  
	+"<h0><font size=5> </h0>"
    +"");


//Log Window Title and Acknowledgement
print("");
print("FIJI Macro: "+scripttitle);
print("Version: "+version+" ("+versiondate+")");
print("ACRF: Cancer Biology Imaging Facility");
print("By Nicholas Condon (2023) n.condon@uq.edu.au")
print("");
getDateAndTime(year, month, week, day, hour, min, sec, msec);
print("Script Run Date: "+day+"/"+(month+1)+"/"+year+"  Time: " +hour+":"+min+":"+sec);
print("");
    

roiManager("reset");



roiDir = getDir("Choose you ROI folder location");
roiList = getFileList(roiDir);


testIMG =File.openDialog("Choose a test image");
open(testIMG);

waitForUser("Make a selection of the area you want to KEEP");
	
	getSelectionBounds(Sx, Sy, Sw, Sh);
	xMin = Sx;
	xMax = Sx+Sw;
	yMin = Sy;
	yMax = Sy+Sh;



for (r = 0; r < roiList.length; r++) {
	if (endsWith(roiList[r],"zip")){
		roiManager("open", roiDir+roiList[r]);
		roiManager("show all with labels");

		roiFilename = roiList[r];
		roiFilenamenoext = replace(roiFilename, ".zip", "");


		n = roiManager("count");
		for (i=n-1; i>=0; i--) {
			roiManager("select", i);
			getSelectionBounds(x, y, w, h);
			COMx = x+(w/2);
			COMy = y+(h/2);
				if (x < xMin || x + w > xMax || y < yMin || y + h > yMax) {
		
				//if (COMx<=Sx||COMy<=Sy||x+w>=Sx+Sw||y+h>=Sy+Sh){
				roiManager("delete");
			}	
		}	
		
		
		
		if(roiManager("count")>0){roiManager("save", roiDir+roiFilenamenoext+"_sanitisedbyROI.zip");}

	print("Updated ROI "+r+" of "+roiList.length+"   #ROIs after sanitising = "+roiManager("count"));
	roiManager("reset");
	}
				     			     			     
}


//Saving Log File
selectWindow("Log");
saveAs("Text", roiDir+"Log_"+scripttitle+".txt");

waitForUser("fin");		