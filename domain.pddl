(define (domain sokorobotto)
  (:requirements :typing :fluents)
  (:types
   pallette robot  - object
   location saleitem order shipment
   ablation implant
  )
  (:predicates  
  (operationPerformed ?p - patient)
  (performTests ?t - tests)
  (checkHeartRate ?hr - heart rate) 
  (checkBloopPressure ?bp - bloop pressure) 
  (checkRespirationRate ?rr - respiration rate) 
  (checkSPO2 ?sp - SPO2 test) 
  (heartRateNormal ?hrn - normality of heart rate)
  (bloodPressureNormal ?bpn - normality of blood pressure)
  (respirationRateNormal ?hrn - normality of respiration rate)
  (SPNormal ?spn - normality of SPO2 test)
  (Abnormal ?v)
  (durativeVitals ?dtv - checking vitals in durations)
  
  )
  (:functions
        (amount ?a - value)
  )

  (:action checkProcedure     ; Checking procedure and enabling testing
  :parameters (?p - patient ?pt - procedure)
  :precondition (and (operationPerformed ?p))
  :effect (and (performTests ?t)) 
  )
  (:action Testing     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?pt - procedure ?t - tests ?hr - heart rate ?bp - blood pressure ?sp - spo2 ?v - vitals ?c - count of vitals check)
  :precondition (and (performTests ?t) (<= (amount ?c) 8))
  :effect (and (increase (amount c) 1) (durativeVitals ?dtv))
  )
  (:action doneTesting     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?pt - procedure ?t - tests ?hr - heart rate ?bp - blood pressure ?sp - spo2 ?v - vitals ?c - count of vitals check)
  :precondition (and (> (amount ?c) 8))
  :effect (and (not (performTests ?t)) (not (durativeVitals ?dtv)))
  )
  (:action Abnormality     ; Enabling all tests to be performed for procedure
  :parameters (?p - patient ?hrn - heart rate normality ?bpn - blood pressure normality ?spn - spo2 normality ?v - vitals ?c - count of vitals check)
  :precondition (or (not (respirationRateNormal ?hrn)) (not (heartRateNormal ?hrn)) (not (bloodPressureNormal ?bpn)) (not ((SPNormal ?spn))))
  :effect (and )(Abnormal ?v)
  )

  ;########################### Tests #################################
  (:action HRNormality     ; Robot Picking up pallette
  :parameters (?p - patient ?hr - heart rate test ?hrv - heart rate value ?hrn - normality of heart rate)
  :precondition (and (checkHeartRate ?hr) (> (amount ?hrv) 50) (< (amount ?hrv) 120))
  :effect (and (heartRateNormal ?hrn) (not (checkHeartRate ?hr))) 
  )
  (:action BPNormality     ; Robot Picking up pallette
  :parameters (?p - patient ?bp - Blood Pressure test ?bpv1 - blood Pressure value 1 ?bpv2 - blood Pressure value 2 ?bpn - normality of Blood Pressure)
  :precondition (and (checkBloodPressure ?bp) (>= (amount ?bpv1) 90) (<= (amount ?bpv1) 130) (>= (amount ?bpv2) 60) (<= (amount ?bpv1) 90))
  :effect (and (bloodPressureNormal ?bpn) (not (checkBloopPressure ?bp))) 
  )
  (:action RRNormality     ; Robot Picking up pallette
  :parameters (?p - patient ?rr - Respiration Rate test ?rrv - respiration Rate value ?rrn - normality of Respiration Rate)
  :precondition ((checkRespirationRate ?rr) (>= (amount ?rrv) 12) (<= (amount ?rrv) 20))
  :effect (and (respirationRateNormal ?hrn) (not (checkRespiration ?rr))) 
  )
  (:action SPNormality     ; Robot Picking up pallette
  :parameters (?p - patient ?sp - SPO2 test ?spv - Sp02 value ?spn - normality of SPO2)
  :precondition (and (checkSPO2 ?sp) (<= (amount ?spv) 90))
  :effect (and (SPNormal ?spn) (not (checkSPO2 ?sp))) 
  )
  (:durative-action Vitals15
    :parameters (?p patient ?v - vitals ?)
    :duration (= ?duration 15)
    :condition (and (durativeVitals ?dtv) (not (checkHeartRate ?hr)) (not (checkBloopPressure ?bp)) (not (checkSPO2 ?sp)) (not (checkRespirationrate ?rr)))
    :effect (and (at start (checkHeartRate ?hr)) (at start (checkBloopPressure ?bp)) (at start  (checkSPO2 ?sp)) (at start (checkRespirationrate ?rr)))
  )

  ;##################################################################
  
