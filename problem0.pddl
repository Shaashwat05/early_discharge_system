(define (problem soko-ichii-pallette)
  (:domain earlyDischarge)
  (:objects
    patient1 - patient
    heartRate1 - heartRate
    bloodPressure1 bloodPressure2 - bloodPressure
    SPO21 - SpO2
    respirationRate1 - respirationRate
    CIED1 - CIED
    ablation1 - ablation
    rassScore1 - rassScore
    ; wlkDist1 - wlkDist
    Hardik - doctor
    ; tc - tCount

    )
  (:init
    ; (= (testingCount tc) 0)
    (operationPerformed patient1)
    (procedureType patient1 CIED1)
    ; (not (procedureType patient1 CIED1))
    (= (reading heartRate1) 80)
    (= (reading SPO21) 60)
    (= (reading respirationRate1) 15)
    (= (reading bloodPressure1) 100)
    (= (reading bloodPressure2) 80)
    (= (reading rassScore1) 0)
    ; (= (reading wlkDist1) 450)
    ; (deviceCheckNormal patient1)
    ; (callMD Hardik)



    )
  (:goal (and (considerSDD patient1)))
)
