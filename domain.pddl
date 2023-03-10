(define (domain earlyDischarge)
  (:requirements :typing :fluents)

  ;#################################### types ##########################################
  (:types
    patient
    heartRate bloodPressure1 bloodPressure2 respirationRate SPO2 rassScore wlkDist - number
    ablation CIED - procedure
    doctor
  )
  ;#################################### Functions ##########################################
  (:functions
  (reading ?testResult - number)
  )
  ;#################################### Predicates ##########################################
  (:predicates  
  (operationPerformed ?p - patient)
  (performTests ?p - patient)
  (checkHeartRate ?hr - patient) 
  (checkBloodPressure ?bp - patient) 
  (checkRespirationRate ?rr - patient) 
  (checkSPO2 ?sp - patient) 
  (checkedHeartRate ?hr - patient) 
  (checkedBloodPressure ?bp - patient) 
  (checkedRespirationRate ?rr - patient) 
  (checkedSPO2 ?sp - patient) 
  (heartRateNormal ?p - patient)
  (bloodPressureNormal ?p - patient)
  (respirationRateNormal ?p - patient)
  (SPNormal ?p - patient)
  (Abnormal ?p - patient)
  (normalRassScore ?p - patient)
  (considerSDD ?p - patient)
  (procedureType ?p - patient ?pt - procedure)
  (assessSymptoms ?p - patient)
  (IVFluids ?p - patient)
  (callMD ?d - doctor)
  (checkDevice ?p - patient)
  (startO2 ?p - patient)
  (sedationRevarsal ?p - patient)
  (OSA ?p - patient)
  (CXR ?p - patient)
  (checkMeds ?p - patient)
  (checkRythm ?p - patient)
  (considerDischarge ?p - patient)
  (doWalkTest ?p - patient)
  (deviceCheckNormal ?p - patient)
  (walkTestSuccessful ?p - patient)
  )
  ;#################################### Actions ##########################################
  (:action CheckProcedure     ; Checking procedure and enabling testing
  :parameters (?p - patient)
  :precondition (and (operationPerformed ?p))
  :effect (and (performTests ?p)) 
  )

  (:action Testing     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient)
  :precondition (and  (performTests ?p) (not (checkHeartRate ?p)) (not (checkBloodPressure ?p)) (not (checkSPO2 ?p)) (not (checkRespirationrate ?p))) ; (<= (reading ?c) 2)
  :effect (and (checkHeartRate ?p) (checkBloodPressure ?p) (checkSPO2 ?p) (checkRespirationrate ?p)) ; (increase (reading c) 1) ; (durativeVitals15 ?p) 
  )

  (:action Abnormality     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient)
  :precondition (or (not (respirationRateNormal ?p)) (not (heartRateNormal ?p)) (not (bloodPressureNormal ?p)) (not (SPNormal ?p)))
  :effect (and (Abnormal ?p))
  )

;   ;########################### Tests #################################
  (:action HRNormality     
  :parameters (?p - patient  ?hrv - heartRate)
  :precondition (and (checkHeartRate ?p) (> (reading ?hrv) 50) (< (reading ?hrv) 120))
  :effect (and (heartRateNormal ?p) (not (checkHeartRate ?p)) (checkedHeartRate ?p)) 
  )
  (:action BPNormality     
  :parameters (?p - patient ?bpv1 - bloodPressure1  ?bpv2 - bloodPressure2)
  :precondition (and (checkBloodPressure ?p) (>= (reading ?bpv1) 90) (<= (reading ?bpv1) 130) (>= (reading ?bpv2) 60) (<= (reading ?bpv2) 90))
  :effect (and (bloodPressureNormal ?p) (not (checkBloodPressure ?p)) (checkedBloodPressure ?p)) 
  )
  (:action RRNormality     
  :parameters (?p - patient ?rr - respirationRate )
  :precondition (and (checkRespirationRate ?p) (>= (reading ?rr) 12) (<= (reading ?rr) 20))
  :effect (and (respirationRateNormal ?p) (not (checkRespirationRate ?p)) (checkedRespirationRate ?p)) 
  )
  (:action SPNormality    
  :parameters (?p - patient ?sp - SPO2 )
  :precondition (and (checkSPO2 ?p) (>= (reading ?sp) 90))
  :effect (and (SPNormal ?p) (not (checkSPO2 ?p)) (checkedSPO2 ?p)) 
  )

; ;############################ Begin: Common flow for both the procedure types ##################################
  (:action AssessRassScore     ; Assess Rass Score
  :parameters (?p - patient ?rsc - rassScore)
  :precondition (and (checkedBloodPressure ?p) (checkedHeartRate ?p) (checkedRespirationRate ?p) (checkedSPO2 ?p) (>= (reading ?rsc) -1) (<= (reading ?rsc) 0))
  :effect (and (normalRassScore ?p)) 
  )

  (:action ConsiderSDD     ; Tests are normal, final checks for SDD
  :parameters (?p - patient)
  :precondition (and (normalRassScore ?p))
  :effect (and (considerSDD ?p)) 
  )

  (:action AbnormalWalkTest     ; Walk test - abnormal
  :parameters (?p - patient ?wlk - wlkDist ?d - doctor)
  :precondition (and (doWalkTest ?p) (< (reading ?wlk) 400))
  :effect (and (abnormal ?p) (callMD ?d)) 
  )

  (:action NormalWalkTestAblation     ; Walk test - normal ablation
  :parameters (?p - patient ?wlk - wlkDist ?pt - ablation)
  :precondition (and (doWalkTest ?p) (>= (reading ?wlk) 400) (procedureType ?p ?pt))
  :effect (and (considerDischarge ?p) (walkTestSuccessful ?p)) 
  )


  (:action NormalWalkTestCIED    ; Walk test - normal CIED
  :parameters (?p - patient ?wlk - wlkDist ?pt - CIED)
  :precondition (and (doWalkTest ?p) (>= (reading ?wlk) 400) (deviceCheckNormal ?p) (procedureType ?p ?pt))
  :effect (and (considerDischarge ?p) (walkTestSuccessful ?p)) 
  )
; ;############################ End: Common flow for both the procedure types #################################

 (:action ConsiderSDDFollowUpablation     ; Follow-up tests for discharge consideration (ablation)
  :parameters (?p - patient ?pt - ablation)
  :precondition (and (considerSDD ?p) (procedureType ?p ?pt))
  :effect (and (doWalkTest ?p)) 
  )

  (:action ConsiderSDDFollowUpCIED     ; Follow-up tests for discharge consideration (CIED)
  :parameters (?p - patient ?pt - CIED)
  :precondition (and (considerSDD ?p) (procedureType ?p ?pt))
  :effect (and (doWalkTest ?p) (checkDevice ?p)) 
  )

  (:action DeviceCheckNormal     ; device check - normal
  :parameters (?p - patient ?pt - CIED)
  :precondition (and (checkDevice ?p) (walkTestSuccessful ?p) (deviceCheckNormal ?p) (procedureType ?p ?pt))
  :effect (and (considerDischarge ?p)) 
  )

   (:action DeviceCheckAbnormal     ; device check - abnormal
  :parameters (?p - patient  ?d - doctor)
  :precondition (and (checkDevice ?p) (not (deviceCheckNormal ?p)))
  :effect (and (abnormal ?p) (callMD ?d)) 
  )

; ;########################### Abnormality Procedure #################################

(:action ABNBPAblation     ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - ablation ?d - doctor ?bpv1 - bloodPressure1 ?bpv2 - bloodPressure2)
:precondition (and (not (bloodPressureNormal ?p)) (or(< (reading ?bpv1) 90) (> (reading ?bpv1) 130)) (or(< (reading ?bpv2) 60) (> (reading ?bpv2) 90)) (procedureType ?p ?pt))
:effect (and (assessSymptoms ?p) (IVFluids ?p) (callMD ?d))
)

(:action ABNBPCIED     ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - CIED ?d - doctor ?bpv1 - bloodPressure1  ?bpv2 - bloodPressure2)
:precondition (and (not (bloodPressureNormal ?p)) (or(< (reading ?bpv1) 90) (> (reading ?bpv1) 130)) (or(< (reading ?bpv2) 60) (> (reading ?bpv2) 90)) (procedureType ?p ?pt))
:effect (and (checkDevice ?p) (callMD ?d))
)

(:action ABNSPO2Ablation    ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - ablation ?d - doctor ?sp - SPO2)
:precondition (and (not (SPNormal ?p)) (< (reading ?sp) 90) (procedureType ?p ?pt))
:effect (and (startO2 ?p) (sedationRevarsal ?p) (callMD ?d) (OSA ?p))
)

(:action ABNBSPO2CIED     ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - CIED ?d - doctor ?sp - SPO2)
:precondition (and (not (SPNormal ?p)) (< (reading ?sp) 90) (procedureType ?p ?pt))
:effect (and (startO2 ?p) (CXR ?p) (callMD ?d))
)

(:action ABNHRAblation    ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - ablation ?d - doctor ?hrv - heartRate)
:precondition (and (not (heartRateNormal ?p)) (or(<= (reading ?hrv) 50) (>= (reading ?hrv) 120)) (procedureType ?p ?pt))
:effect (and (checkMeds ?p) (assessSymptoms ?p) (checkHeartRate ?p) (checkRythm ?p) (callMD ?d)) 
)

(:action ABNHRCIED    ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - CIED ?d - doctor ?hrv - heartRate)
:precondition (and (not (heartRateNormal ?p)) (or(<= (reading ?hrv) 50) (>= (reading ?hrv) 120)) (procedureType ?p ?pt))
:effect (and (checkMeds ?p) (checkHeartRate ?p) (checkDevice ?p) (callMD ?d))   
)
)

  