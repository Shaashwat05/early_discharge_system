# Early Discharge System: Streamlining decisions regarding safety and efficacy of same day inpatients’ discharge after cardiac electrophysiology procedures

In this project, we have built a planning-based system utilizing PDDL to generate pathways for determining safe discharge of post-operative patients. Specific criteria used for making such decisions include the type of procedure, immediate surgical outcome, presence/absence of any complications, any unexpected surgical findings, post-operative vital signs, results of planned postoperative imaging, and lab-work or other studies, among other things.

The system resolves to one (or more) of the following 4 goal-states and generates a planning graph that can be used as a step-by-step action guide by physicians:
1. considerDischarge - patient can be safely discharged.
2. callMD - further inspection is required by a physician.
3. checkMeds - patient's medicine doses are to be updates immediately, primarily due to high/low heart rate
4. startO2 - patient's O2 level is low. They need to be immediately put on a ventilator. 

## To run the code:

### Devices:

Tested on MacBook Pro (14-inch, 2021) - Apple M1 Pro (Monterey 12.5)


### Dependencies:
```
#### 1. Python 3.x
#### 2. referred IDE - [Visual Studio Code](https://code.visualstudio.com/download)
#### 3. (Optional) Install the PDDL extension in visual studio code (developed by **Jan Dolejsi**) to view the planner outputs as graphs
[Installation and Usage Guide](https://github.com/jan-dolejsi/vscode-pddl)
```

### To test the code, run the following command:

```
python test.py
```

### To get the planner graph outputs:

```
1. Open one of the **problem.pddl** files
2. Open the Visual Studio Code command pallete (Mac Shortcut - Cmd+Shift+P)
3. Run the command: **PDDL: Run the planner and display the plan**
4. Press Enter when prompted for selecting planner. i.e., choose **No Options (use defaults)**
```




## References:
1. This implementation is done as an assignment for the following MSAI course (Winter 2023): [Northwestern University - MSAI 371: Knowledge Representation and Reasoning](https://www.mccormick.northwestern.edu/artificial-intelligence/curriculum/descriptions/msai-371.html). The instructor for this course is: [Prof. Mohammed Alam](https://www.mccormick.northwestern.edu/research-faculty/directory/profiles/alam-mohammed.html).
