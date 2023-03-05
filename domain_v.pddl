(define (domain earlyDischarge)
  (:requirements :typing :fluents :durative-actions)

  ;#################################### types ##########################################
  (:types
    patient
    number
    ablation
    implant 
    procedure
    test
  )
  ;#################################### Functions ##########################################
  (:functions
  (reading ?testResult - number)
  )
  ;#################################### Predicates ##########################################
  (:predicates  
  (operationPerformed ?p - patient)
  (performTests ?t - test)
  (checkHeartRate ?hr - number) 
  (checkBloopPressure ?bp - number) 
  (checkRespirationRate ?rr - number) 
  (checkSPO2 ?sp - number) 
  (heartRateNormal ?p - patient)
  (bloodPressureNormal ?p - patient)
  (respirationRateNormal ?p - patient)
  (SPNormal ?p - patient)
  (Abnormal ?p - patient)
  (durativeVitals ?p - patient)
  (isAssessedRassScore ?p - patient)
  (normalRassScore ?p - patient)
  (considerSDD ?p - patient)
  )
  ;#################################### Actions ##########################################
  (:action CheckProcedure     ; Checking procedure and enabling testing
  :parameters (?p - patient ?pt - procedure)
  :precondition (and (operationPerformed ?p))
  :effect (and (performTests ?t)) 
  )

  (:action Testing     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
  :precondition (and (performTests ?t) (<= (reading ?c) 8))
  :effect (and (increase (reading c) 1) (durativeVitals ?p))
  )

  (:action DoneTesting     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?pt - procedure ?t - test ?hr - number ?bp - number ?sp - number ?c - number)
  :precondition (and (> (reading ?c) 8))
  :effect (and (not (performTests ?t)) (not (durativeVitals ?p)))
  )
  (:action Abnormality     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?hrn - number ?bpn - number ?spn - number ?c - number)
  :precondition (or (not (respirationRateNormal ?p)) (not (heartRateNormal ?p)) (not (bloodPressureNormal ?p)) (not ((SPNormal ?p))))
  :effect (and )(Abnormal ?p)
  )

  ;########################### Tests #################################
  (:action HRNormality     
  :parameters (?p - patient ?hr - number ?hrv - number ?hrn - normality of heart rate)
  :precondition (and (checkHeartRate ?p) (> (reading ?hrv) 50) (< (reading ?hrv) 120))
  :effect (and (heartRateNormal ?p) (not (checkHeartRate ?p))) 
  )
  (:action BPNormality     
  :parameters (?p - patient ?bp - number ?bpv1 - number  ?bpv2 - number ?bpn - number)
  :precondition (and (checkBloodPressure ?p) (>= (reading ?bpv1) 90) (<= (reading ?bpv1) 130) (>= (reading ?bpv2) 60) (<= (reading ?bpv1) 90))
  :effect (and (bloodPressureNormal ?p) (not (checkBloopPressure ?p))) 
  )
  (:action RRNormality     
  :parameters (?p - patient ?rr - number)
  :precondition ((checkRespirationRate ?p) (>= (reading ?rr) 12) (<= (reading ?rr) 20))
  :effect (and (respirationRateNormal ?p) (not (checkRespiration ?p))) 
  )
  (:action SPNormality    
  :parameters (?p - patient ?sp - number)
  :precondition (and (checkSPO2 ?p) (<= (reading ?sp) 90))
  :effect (and (SPNormal ?p) (not (checkSPO2 ?p))) 
  )

  (:durative-action Vitals15
    :parameters (?p patient)
    :duration (= ?duration 15)
    :condition (and (durativeVitals ?p) (not (checkHeartRate ?p)) (not (checkBloopPressure ?p)) (not (checkSPO2 ?p)) (not (checkRespirationrate ?p)))
    :effect (and (at start (checkHeartRate ?p)) (at start (checkBloopPressure ?p)) (at start  (checkSPO2 ?p)) (at start (checkRespirationrate ?p)))
  )

    (:durative-action Vitals30
    :parameters (?p patient)
    :duration (= ?duration 30)
    :condition (and (durativeVitals ?p) (not (checkHeartRate ?p)) (not (checkBloopPressure ?p)) (not (checkSPO2 ?p)) (not (checkRespirationrate ?p)))
    :effect (and (at start (checkHeartRate ?p)) (at start (checkBloopPressure ?p)) (at start  (checkSPO2 ?p)) (at start (checkRespirationrate ?p)))
  )






;############################ Begin: Common flow for both the procedure types ##################################
  (:action AssessRassScore     ; Assess Rass Score
  :parameters (?p - patient ?testResult - number)
  :precondition (and (isAssessedRassScore ?p) (>= (reading ?testResult) -1) (<= (reading ?testResult) 0))
  :effect (and (normalRassScore ?p)) 
  )

  (:action ConsiderSDD     ; Tests are normal, final checks for SDD
  :parameters (?p - patient)
  :precondition (and (normalRassScore ?p))
  :effect (and (considerSDD ?p)) 
  )
;############################ End: Common flow for both the procedure types #################################
)
