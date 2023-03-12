(define (problem callMD-heartRate-BP)
  (:domain earlyDischarge)
  (:objects
    patient1 - patient
    heartRate1 - heartRate
    bp1 - bloodPressure1
    bp2 - bloodPressure2
    SPO21 - SpO2
    respirationRate1 - respirationRate
    CIED1 - CIED
    ablation1 - ablation
    rassScore1 - rassScore
    wlkDist1 - wlkDist
    Hardik - doctor
  )
  (:init
    (operationPerformed patient1)
    (procedureType patient1 CIED1)
    (= (reading heartRate1) 125)
    (= (reading SPO21) 20)
    (= (reading respirationRate1) 35)
    (= (reading bp1) 170)
    (= (reading bp2) 30)
    (= (reading rassScore1) 0)
    (= (reading wlkDist1) 450)
    (deviceCheckNormal patient1)
    )
  (:goal (and (callMD Hardik)))
)
