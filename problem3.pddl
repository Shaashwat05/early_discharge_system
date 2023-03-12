(define (problem startO2)
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
    (procedureType patient1 ablation1)
    (= (reading heartRate1) 80)
    (= (reading SPO21) 70)
    (= (reading respirationRate1) 15)
    (= (reading bp1) 100)
    (= (reading bp2) 80)
    (= (reading rassScore1) 0)
    (= (reading wlkDist1) 450)
    (deviceCheckNormal patient1)
    )
  (:goal (and (startO2 patient1)))
)
