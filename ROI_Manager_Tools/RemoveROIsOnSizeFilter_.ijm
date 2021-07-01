ROIArea = 100;
n = roiManager("count");
  for (i=n-1; i>=0; i--) {
		roiManager("select", i);
		run("Clear Results");
		run("Measure");
		if (getResult("Area",0)<ROIArea)
		  roiManager("delete");
		}
