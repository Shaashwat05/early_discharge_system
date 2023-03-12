# Early Discharge System
## Streamlining decisions regarding safety and efficacy of same day inpatients’ discharge after cardiac electrophysiology procedures

In this project, we have built a planning-based system utilizing [PDDL](https://planning.wiki/guide/whatis/pddl#:~:text=Planning%20Domain%20Definition%20Language%20(PDDL)%20is%20a%20family%20of%20languages,with%20different%20levels%20of%20expressivity), [NextKB](https://www.qrg.northwestern.edu/nextkb/index.html),  and [Companions Cognitive Architecture](https://www.qrg.northwestern.edu/papers/Files/FS104KForbus.pdf) to generate pathways for determining safe discharge of post-operative patients. Specific criteria used for making such decisions include the type of procedure, immediate surgical outcome, presence/absence of any complications, any unexpected surgical findings, post-operative vital signs, results of planned postoperative imaging, and lab work or other studies, among other things.

The system resolves to one (or more) of the following 4 goal states and generates a planning graph that can be used as a step-by-step action guide by physicians:
1. considerDischarge - patient can be safely discharged.
2. callMD - further inspection is required by a physician.
3. checkMeds - patient's medicine doses are to be updated immediately, primarily due to high/low heart rate
4. startO2 - patient's O2 level is low. They need to be immediately put on a ventilator. 

## Project Architecture
![Architecture](https://github.com/Shaashwat05/early_discharge_system/blob/main/images/project_architecture.png?raw=true)

## Reasoning
![Reasoning_Graph_1](https://github.com/Shaashwat05/early_discharge_system/blob/main/images/reasoning_1.png?raw=true)
![Reasoning_Graph_2](https://github.com/Shaashwat05/early_discharge_system/blob/main/images/reasoning_2.png?raw=true)

## To run the code:

### Devices:

Tested on MacBook Pro (14-inch, 2021) - Apple M1 Pro (Monterey 12.5)


### Dependencies:
```
1. Python 3.x
2. Preferred IDE: Visual Studio Code -  https://code.visualstudio.com/download
3. Install the PDDL extension in visual studio code (developed by Jan Dolejsi) to view the planner outputs as graphs.
Installation and Usage Guide - https://github.com/jan-dolejsi/vscode-pddl
```


### To test the code, run the following command:

```
python test.py
```

### To get the planner graph outputs:

```
1. Open one of the problem.pddl files
2. Open the Visual Studio Code command pallete (Mac Shortcut - Cmd+Shift+P)
3. Run the command: PDDL: Run the planner and display the plan
4. Press Enter when prompted for selecting planner. i.e., choose No Options (use defaults)
```

### To test new inputs:

For testing a new scenario, you can either create a new problem.pddl file, or update one of the existing problem.pddl files. If you are defining a new problem, please note that the domain of our pddl system is: **earlyDischarge** and your initial state must contain these two predicates: 
(operationPerformed <patient_var>) & (procedureType <patient_var> <proc_type_var>) where <patient_var> must be of type patient, and <proc_type_var> must be either of type CIED or ablation. 
You can define one of the following 4 goal states:
```
1. (considerDischarge <patient_var>) - where <patient_var> must be of type patient
2. (callMD <doctor_var>) - where <doctor_var> must be of type doctor
3. (checkMeds <patient_var>) - where <patient_var> must be of type patient
4. (startO2 <patient_var>) - where <patient_var> must be of type patient
```

You can refer to the existing problem.pddl and domain.pddl files to understand the existing "types". Please refer to the reasoning graphs provided above to understand how the different goal states are triggered. Please note that the patients can only be discharged (goal state: considerDischarge), if their vital signs are normal. For normal vital ranges, refer to the following values:
```
1. Heart Rate: (50-120)
2. BP1 (Systolic Blood Pressure): [90-130]
3. BP2 (Diastolic Blood Pressure): [60-90]
4. Respiration Rate: [12-20]
5. SPO2: [90 or above]
6. Walking Distance: [400 or above]
7. RASS Score: [-1, 0]
```
** Note: "()" signifies exclusive ranges, and "[]" signifies inclusive ranges.
Additionally, CIED-operated patients can only be discharged if their device check came normal, i.e., their init state has the following predicate: 
(deviceCheckNormal <patient_var>) - where <patient_var> must be of type patient

### Adding New Patients and Generating Actions to be Performed
A new patient can be added to the Knowledge Base directly by writing a KRF flat file. The structure of this file would be similar to the ones provided as examples (*Doe.krf). This file includes medical information corresponding to the patient and other identifiable information. You can add this patient to the Knowledge Base by uploading the KRF file to the interaction manager on Companions. Once the patient is in the database, you can directly run all the possible outcomes for the patient (or any other patient in the Knowledge base) wrapped in get_outcomes function in the main.py file. The resolution (“ok”/”error”) of the patient can be obtained from get_outcomes(“<patientname>”) as a dictionary. If the patient does not exist in the Knowledge base, a NameError is raised.


## References:
1. This implementation is done as an assignment for the following MSAI course (Winter 2023): [Northwestern University - MSAI 371: Knowledge Representation and Reasoning](https://www.mccormick.northwestern.edu/artificial-intelligence/curriculum/descriptions/msai-371.html). The instructor for this course is: [Prof. Mohammed Alam](https://www.mccormick.northwestern.edu/research-faculty/directory/profiles/alam-mohammed.html).
