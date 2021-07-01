			//Collects total ROIs from Cell Pose mask
			roiManager("reset");
			getMinAndMax(min, max);
				for (i = 1; i <=max; i++) {
					setThreshold(i, i);
					run("Create Selection");
					roiManager("add");
					resetThreshold();
				  }
				resetThreshold();
