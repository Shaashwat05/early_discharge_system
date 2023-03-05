(define (domain earlyDischarge)
  (:requirements :typing :fluents)

  ;#################################### types ##########################################
  (:types
    patient
    rassScore wlkDist heartRate bloodPressure1 bloodPressure2 count SPO2 respirationRate tCount - number
    ablation
    implant 
    Ablation CIED - procedure
    test
    doctor
    device
  )
  ;#################################### Functions ##########################################
  (:functions
  (reading ?testResult - number)
  (testingCount ?tc - tCount)
  )
  ;#################################### Predicates ##########################################
  (:predicates  
  (operationPerformed ?p - patient)
  (performTests ?p - patient)
  (checkHeartRate ?hr - number) 
  (checkBloodPressure ?bp - number) 
  (checkRespirationRate ?rr - number) 
  (checkSPO2 ?sp - number) 
  (heartRateNormal ?p - patient)
  (bloodPressureNormal ?p - patient)
  (respirationRateNormal ?p - patient)
  (SPNormal ?p - patient)
  (Abnormal ?p - patient)
  (durativeVitals15 ?p - patient)
  (durativeVitals30 ?p - patient)
  (isAssessedRassScore ?p - patient)
  (normalRassScore ?p - patient)
  (considerSDD ?p - patient)
  (procedureType ?p - patient ?pt - procedure)
  (assessSymptoms ?p - patient)
  (IVFluids ?p - patient)
  (callMD ?d - doctor)
  (checkDevice ?p - patient)
  ;(getECG ? - patient)
  (startO2 ?p - patient)
  (sedationRevarsal ?p - patient)
  (OSA ?p - patient)
  (CXR ?p - patient)
  (checkMeds ?p - patient)
  (checkRythm ?p - patient)
  (considerDischarge ?p - patient)
  (doWalkTest ?p - patient)
  (deviceCheckNormal ?p)
  )
  ;#################################### Actions ##########################################
  (:action CheckProcedure     ; Checking procedure and enabling testing
  :parameters (?p - patient ?pt - procedure)
  :precondition (and (operationPerformed ?p))
  :effect (and (performTests ?p)) 
  )

  (:action Testing     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - count)
  :precondition (and (performTests ?p) (not (checkHeartRate ?p)) (not (checkBloodPressure ?p)) (not (checkSPO2 ?p)) (not (checkRespirationrate ?p))) ; (<= (reading ?c) 2)
  :effect (and (checkHeartRate ?p) (checkBloodPressure ?p) (checkSPO2 ?p) (checkRespirationrate ?p)) ; (increase (reading c) 1) ; (durativeVitals15 ?p) 
  )

  (:action DoneTesting     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number ?tc - tCount)
  :precondition (and (durativeVitals15 ?p) (> (testingCount tc) 3))
  :effect (and (not (performTests ?t)))   ;  (not (durativeVitals15 ?p))
  )
  (:action Abnormality     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?hrn - number ?bpn - number ?spn - number ?c - number)
  :precondition (or (not (respirationRateNormal ?p)) (not (heartRateNormal ?p)) (not (bloodPressureNormal ?p)) (not (SPNormal ?p)))
  :effect (and (Abnormal ?p))
  )

  ;########################### Tests #################################
  (:action HRNormality     
  :parameters (?p - patient ?hr - number ?hrv - heartRate ?tc - tCount)
  :precondition (and (checkHeartRate ?p) (> (reading ?hrv) 50) (< (reading ?hrv) 120))
  :effect (and (heartRateNormal ?p) (not (checkHeartRate ?p)) (increase (testingCount tc) 1)) 
  )
  (:action BPNormality     
  :parameters (?p - patient ?bp - number ?bpv1 - number  ?bpv2 - number ?bpn - number ?tc - tCount)
  :precondition (and (checkBloodPressure ?p) (>= (reading ?bpv1) 90) (<= (reading ?bpv1) 130) (>= (reading ?bpv2) 60) (<= (reading ?bpv1) 90))
  :effect (and (bloodPressureNormal ?p) (not (checkBloodPressure ?p)) (increase (testingCount tc) 1)) 
  )
  (:action RRNormality     
  :parameters (?p - patient ?rr - number ?tc - tCount)
  :precondition (and (checkRespirationRate ?p) (>= (reading ?rr) 12) (<= (reading ?rr) 20))
  :effect (and (respirationRateNormal ?p) (not (checkRespiration ?p)) (increase (testingCount tc) 1)) 
  )
  (:action SPNormality    
  :parameters (?p - patient ?sp - number ?tc - tCount)
  :precondition (and (checkSPO2 ?p) (<= (reading ?sp) 90))
  :effect (and (SPNormal ?p) (not (checkSPO2 ?p)) (increase (testingCount tc) 1)) 
  )

  ;(:durative-action Vitals15
  ;  :parameters (?p patient)
  ;  :duration (= ?duration 15)
  ;  :condition (and (durativeVitals15 ?p) (not (checkHeartRate ?p)) (not (checkBloodPressure ?p)) (not (checkSPO2 ?p)) (not (checkRespirationrate ?p)))
  ;  :effect (and (at start (checkHeartRate ?p)) (at start (checkBloodPressure ?p)) (at start  (checkSPO2 ?p)) (at start (checkRespirationrate ?p)))
  ;)

    (:durative-action Vitals30
    :parameters (?p patient)
    :duration (= ?duration 30)
    :condition (and (durativeVital30 ?p) (not (checkHeartRate ?p)) (not (checkBloodPressure ?p)) (not (checkSPO2 ?p)) (not (checkRespirationrate ?p)))
    :effect (and (at start (checkHeartRate ?p)) (at start (checkBloodPressure ?p)) (at start  (checkSPO2 ?p)) (at start (checkRespirationrate ?p)))
  )






;############################ Begin: Common flow for both the procedure types ##################################
  (:action AssessRassScore     ; Assess Rass Score
  :parameters (?p - patient ?rsc - rassScore)
  :precondition (and (isAssessedRassScore ?p) (>= (reading ?rsc) -1) (<= (reading ?rsc) 0))
  :effect (and (normalRassScore ?p)) 
  )

  (:action ConsiderSDD     ; Tests are normal, final checks for SDD
  :parameters (?p - patient)
  :precondition (and (normalRassScore ?p))
  :effect (and (considerSDD ?p)) 
  )

  (:action AbnormalRassFollowUp     ; Actions to be taken when Rass socre is abnormal
  :parameters (?p - patient, ?rsc - rassScore)
  :precondition (and (not (normalRassScore ?p)) (>= (reading ?rsc) 2) (<= (reading ?rsc) -2))
  :effect (and (durativeVitals15 ?p)) 
  )

  (:action AbnormalWalkTest     ; Walk test - abnornal
  :parameters (?p - patient ?wlkDist - number)
  :precondition (and (doWalkTest ?p) (< (reading ?wlkDist) 400))
  :effect (and (abnormal ?p) (callMD ?p)) 
  )

  (:action NormalWalkTest     ; Walk test - normal
  :parameters (?p - patient ?wlkDist - number)
  :precondition (and (doWalkTest ?p) (<= (reading ?wlkDist) 400))
  :effect (and (considerDischarge ?p)) 
  )
;############################ End: Common flow for both the procedure types #################################

 (:action ConsiderSDDFollowUpablation     ; Follow-up tests for discharge consideration (ablation)
  :parameters (?p - patient ?pt - procedure)
  :precondition (and (considerSDD ?p) (procedureType ?p ablation))
  :effect (and (doWalkTest ?p)) 
  )

  (:action ConsiderSDDFollowUpCIED     ; Follow-up tests for discharge consideration (CIED)
  :parameters (?p - patient ?pt - procedure)
  :precondition (and (considerSDD ?p) (procedureType ?p CIED))
  :effect (and (doWalkTest ?p) (checkDevice ?p)) 
  )

  (:action DeviceCheckNormal     ; device check - normal
  :parameters (?p - patient ?dv - device)
  :precondition (and (checkDevice ?p) (deviceCheckNormal ?p))
  :effect (and (considerDischarge ?p)) 
  )

   (:action DeviceCheckAbnormal     ; device check - abnormal
  :parameters (?p - patient ?dv - device)
  :precondition (and (checkDevice ?p) (not ((deviceCheckNormal ?p))))
  :effect (and (abnormal ?p) (callMD ?p)) 
  )

;########################### Abnormality Procedure #################################

(:action ABNBPAblation     ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
:precondition (and (not (bloodPressureNormal ?p)) (procedureType ?p Ablation))
:effect (and (assessSymptoms ?p) (IVFluids ?p) (callMD ?d))
)

(:action ABNBPCIED     ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
:precondition (and (not (bloodPressureNormal ?p)) (procedureType ?p CIED))
:effect (and (checkDevice ?p) (getECG ?p) (callMD ?d))
)

(:action ABNSPO2Ablation    ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
:precondition (and (not (SPNormal ?p)) (procedureType ?p Ablation))
:effect (and (startO2 ?p) (sedationRevarsal ?p) (callMD ?d) (OSA ?p))
)

(:action ABNBSPO2CIED     ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
:precondition (and (not (bloodPressureNormal ?p)) (procedureType ?p CIED))
:effect (and (startO2 ?p) (CXR ?p) (callMD ?d))
)

(:action ABNHRAblation    ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
:precondition (and (not (heartRateNormal ?p)) (procedureType ?p Ablation))
:effect (and (checkMeds ?p) (assessSymptoms ?p) (checkHeartRate ?p) (checkRythm ?p) (callMD ?d))  ; (getECG ?p)
)

(:action ABNHRAblation    ; Enabling all tests to be performed for procedure
:parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
:precondition (and (not (heartRateNormal ?p)) (procedureType ?p CIED))
:effect (and (checkMeds ?p) (checkHeartRate ?p) (checkDevice ?p) (callMD ?d))    ; (getECG ?p)
)
)

